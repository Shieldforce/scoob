# Scoob

## Requisitos obrigatórios:
- Docker

---
## Instalando Scoob globalmente:
```
cd ~/ && git clone https://github.com/Shieldforce/scoob.git && cd scoob
```
### Criando alias para rodar o scoob em qualquer projeto:
```
echo "alias scoob='bash $(pwd)/scoob'" >> ~/.bashrc; source ~/.bashrc
```
---

---
## Instalando Scoob localmente:
```
composer require shieldforce/scoob
```
### Comando para rodar local:
```
bash ./vendor/shieldforce/scoob/scoob {comandos scoob}
```
### Exemplo (Vai criar um container com php8.3 na porta 9000):
```
bash ./vendor/shieldforce/scoob/scoob --type docker-php-nginx --version 8.3 --port 9000
```
---

## Tipos de implementação:

### Remover totalmente um container:
```
scoob --type docker-remove {container-name}
```

### Implementar um container PHP Puro:
```
scoob --type docker-php-nginx {parametros obrigatórios}
```

### Implementar um container Laravel:
```
scoob --type docker-laravel {parametros obrigatórios}
```

### Limpar tudo que não está sendo usado no docker (CUIDADO, IRÁ EXCLUIR TUDO QUE NÃO ESTÁ SENDO USADO!):
```
scoob --docker-prune
```
---

## Exemplos de container para php/nginx e laravel:
- --type                   (obrigatório) : Tipo do container para php sempre será (docker-php-nginx)
- --version                (obrigatório) : Versão do PHP Versões disponíveis (7.3, 7.4, 8.1, 8.2, 8.3,84)
- --port                   (obrigatório) : Porta de Exposição do container
- --redis-port             (opcional) : Seta porta do redis!
- --mysql-port             (opcional) : Seta porta do mysql!
---

Este comando vai instalar um container com php/nginx.
```
scoob --type docker-php-nginx --version 8.4 --port 8084
```

#### Listar containers Exemplo:  --type + --port [php-fpm-8.4-8084] :
```
docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                                                       NAMES
f6d5sf6f56f5   php-fpm-8.4-8084   "docker-php-entrypoi…"   1 minutes ago   Up 1 minutes   8073/tcp, 9000/tcp, 0.0.0.0:8084->80/tcp, :::8084->80/tcp   php-fpm-8.4-8084
```