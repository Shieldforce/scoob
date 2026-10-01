#!/bin/bash
# Roda um comando dentro do container pelo Supervisor do host sem deixar processo órfão.
# O Supervisor só sinaliza o cliente "docker exec"; o processo lá dentro não recebe o TERM
# e segue vivo (duplicando workers/servidor no próximo start). Aqui o TERM é repassado.
# uso: supervisor-exec.sh <container> <padrão> <comando...>
container=$1; pattern=$2; shift 2

# Mata (TERM) os processos do container cuja linha de comando contém o padrão.
# As imagens não têm pkill, então varre /proc; ignora o próprio shell.
term_in_container() {
    docker exec "$container" sh -c 'for d in /proc/[0-9]*; do pid=${d#/proc/};
        [ "$pid" = "$$" ] && continue;
        tr "\0" " " < $d/cmdline 2>/dev/null | grep -q -- "$0" && kill -TERM $pid && echo "TERM $pid";
    done; true' "$pattern"
}

stop() {
    term_in_container
    wait "$child"
    exit 0
}
trap stop TERM INT

# Limpa sobra de execução anterior antes de subir
term_in_container | grep -q TERM && sleep 3

docker exec "$container" "$@" &
child=$!
wait "$child"
