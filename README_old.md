# Scoob

### No caso de php puro o Scoob já contém um nginx, php-fpm, supervisor instalados em um Debian GNU/Linux 12 (bookworm).

### No caso de Laravel puro o Scoob já contém um nginx, php-fpm, supervisor, redis, mysql instalados em um Debian GNU/Linux 12 (bookworm).

---

### Requisitos obrigatórios:
- Shell bash
- Docker


### Vá para pasta do usuário:
```
cd ~/
```
---

### Clone o scoob:
```
git clone https://github.com/Shieldforce/scoob.git
```
---

### Acesse a pasta dele:
```
cd scoob
```
---

### Rode o comando para criar um alias para o scoob:
```
echo "alias scoob='bash $(pwd)/scoob'" >> ~/.bashrc; source ~/.bashrc
```
---

### Existem dois jeitos de chamar a ajuda do scoob:
```
scoob
scoob --help
```
---

### Para remover uma implementação de container:
```
scoob --type docker-remove {nome do container}
```
---

### Os tipos de implementação são:
```
scoob --type docker-php-nginx
scoob --type docker-laravel
```
---

### Limpar tudo que não está sendo usado no docker (CUIDADO, IRÁ EXCLUIR TUDO QUE NÃO ESTÁ SENDO USADO!):
```
scoob --docker-prune
```
---

### Exemplos de container para php/nginx e laravel:
- --type                (obrigatório) : Tipo do container para php sempre será (docker-php-nginx)
- --version             (obrigatório) : Versão do PHP Versões disponíveis (7.3, 7.4, 8.1, 8.2, 8.3)
- --port                (obrigatório) : Porta de Exposição do container
- --composer-update        (opcional) : Atualiza a lista de pacotes da vendor!
- --migrate-seed           (opcional) : Roda as migrations se for um laravel!
- --migrate-fresh          (opcional) : Reseta as migrations se for um laravel!
- --migrate                (opcional) : Roda as migrations e seeds!

---

Este comando vai instalar um container com php/nginx, atualizar a vendor e rodar as migrations e seeds (Caso muito útil e, laravel),
é possível implementar ao invés de --type docker-php-nginx, assim: --type docker-laravel, a diferença é que no container para laravel,
subimos o nginx, mariadb, redis, cron, horizon. use portas entre 10 e 99, pois essa porta será concatenada com as portas de banco e redis.
```
scoob --type docker-php-nginx --version 8.1 --port 81 --composer-update --migrate-seed
```

#### Este comando vai instalar um container com php e nginx:
```
scoob --type docker-laravel --version 8.3 --port 8811
```

#### Este comando vai instalar um container com nginx, php-fpm, supervisor, redis, mysql e atualizar a vendor e resetar as migrations e seeds (Laravel Framework):
```
scoob --type docker-laravel --version 8.3 --port 8073 --redis-port 6386 --mysql-port 3386 --composer-update --migrate-fresh
```

#### Este comando vai instalar um container com nginx, php-fpm, supervisor, redis, mysql e atualizar a vendor (Laravel Framework):
```
scoob --type docker-laravel --version 8.3 --port 8073 --redis-port 6386 --mysql-port 3386 --composer-update
```

#### Este comando vai instalar um container nginx, php-fpm, supervisor, redis, mysql (Laravel Framework):
```
scoob --type docker-laravel --version 8.3 --port 8073 --redis-port 6386 --mysql-port 3386
```

#### Este comando vai instalar um container com php/nginx, atualizar a vendor:
```
scoob --type docker-php-nginx --version 8.3 --port 8073 --composer-update
```

#### Este comando vai instalar um container com php/nginx:
```
scoob --type docker-php-nginx --version 8.3 --port 8073
```

#### Listar containers Exemplo:  --type + --port [php-fpm-8.3-8073] :
```
docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                                                       NAMES
b96c8b3e9947   php-fpm-8.3-8073   "docker-php-entrypoi…"   3 minutes ago   Up 3 minutes   8073/tcp, 9000/tcp, 0.0.0.0:8073->80/tcp, :::8073->80/tcp   php-fpm-8.3-8073
```

#### Subir Container depois dele já configurado:
```
docker start {container-name}
```
#### O index aponta para:
```
public/index.php
```
#### Para entrar no container:
```
docker exec -it {container-id} bash
```

#### Ver os processos do supervisor:
```
docker exec -it {container-id} supervisorctl status
```

#### Sistema Operacional:
```
docker exec -it {container-id} cat /etc/os-release
    PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
    NAME="Debian GNU/Linux"
    VERSION_ID="12"
    VERSION="12 (bookworm)"
    VERSION_CODENAME=bookworm
    ID=debian
    HOME_URL="https://www.debian.org/"
    SUPPORT_URL="https://www.debian.org/support"
    BUG_REPORT_URL="https://bugs.debian.org/"
```

---
---
---

# Containers Node (Somente para desenvolvimento)

#Requisitos: Docker

#Container (Node 14) + (Yarn 1.22.22) + (Express ^4.17.1) + (Nodemon)
#Container PORTA: 3014 (Node 14) + (Yarn 1.22.22) + (Express ^4.17.1) + (Nodemon)
```
docker-compose -f ./node14/docker-compose.yml up -d --build
```

#Container (Node 16) + (Yarn 1.22.22) + (Express ^4.18.2) + (Nodemon)
#Container PORTA: 3016 (Node 16) + (Yarn 1.22.22) + (Express ^4.18.2) + (Nodemon)
```
docker-compose -f ./node16/docker-compose.yml up -d --build
```

#Container (Node 18) + (Yarn 1.22.22) + (Express ^4.17.1) + (Nodemon)
#Container PORTA: 3018 (Node 18) + (Yarn 1.22.22) + (Express ^4.17.1) + (Nodemon)
```
docker-compose -f ./node18/docker-compose.yml up -d --build
```

#Container (Node 20) + (Yarn *) + (Express *) + (Nodemon)
#Container PORTA: 3020 (Node 20) + (Yarn *) + (Express *) + (Nodemon)
```
docker-compose -f ./node20/docker-compose.yml up -d --build
```

#Container (Node 21) + (Yarn *) + (Express *) + (Nodemon)
#Container PORTA: 3021 (Node 21) + (Yarn *) + (Express *) + (Nodemon)
```
docker-compose -f ./node21/docker-compose.yml up -d --build
```

#Container (Node 22) + (Yarn *) + (Express *) + (Nodemon)
#Container PORTA: 3022 (Node 22) + (Yarn *) + (Express *) + (Nodemon)
```
docker-compose -f ./node22/docker-compose.yml up -d --build
```

#Container (Node 23) + (Yarn *) + (Express *) + (Nodemon)
#Container PORTA: 3023 (Node 23) + (Yarn *) + (Express *) + (Nodemon)
```
docker-compose -f ./node23/docker-compose.yml up -d --build
```

