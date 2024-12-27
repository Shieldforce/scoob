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
---
Este comando vai instalar um container com laravel/mysql/redis/supervisor.
```
scoob --type docker-laravel --version 8.4 --port 8094 --redis-port 6394 --mysql-port 3394
```
---
## Supervisor  (No caso de containers: --type docker-laravel)

### Acessar bash do container:
```
docker exec -it {container-name} bash
```

### Listar serviços pendurados no supervisor:
```
docker exec -it {container-name} supervisorctl status

A saída tem que ser parecdia com isso:
horizon                          RUNNING   pid 61, uptime 0:00:44
mariadb                          RUNNING   pid 62, uptime 0:00:44
nginx                            RUNNING   pid 63, uptime 0:00:44
php-fpm                          RUNNING   pid 64, uptime 0:00:44
redis                            RUNNING   pid 65, uptime 0:00:44
```
### Resetar serviços pendurados no supervisor:
```
docker exec -it {container-name} supervisorctl restart all
```

### Cada serviço está explicado a baixo caso falhar!

---
### Acessar redis do container:
Se não passou porta, ela será no caso de 
- php7.3: 6373
- php7.4: 6374
- php8.1: 6381
- php8.2: 6382
- php8.3: 6383
- php8.4: 6384
Se passou --redis-port será o valor passado:
```
docker exec -it {container-name} redis-cli -p {port}
```

### Env Redis:
```
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT={porta_configurada}
```
### Se precisar colocar senha no redis só passar o parâmetro no arquivo de configuração do redis:
### /etc/redis/redis.conf
### requirepass myStrongPassword123!

---
### Acessar mysql do container:
Se não passou porta, ela será no caso de
- php7.3: 3373
- php7.4: 3374
- php8.1: 3381
- php8.2: 3382
- php8.3: 3383
- php8.4: 3384
  Se passou --mysql-port será o valor passado:
```
docker exec -it {container-name} mysql
MariaDB [(none)]> create database {db_name};
O resultado tem que ser: (Query OK, 1 row affected (0.000 sec))
```

### Acesso root:
```
docker exec -it {container-name} mysql
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '{senha_desejada}' WITH GRANT OPTION;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%.%.%.%' IDENTIFIED BY 'senha_desejada' WITH GRANT OPTION;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'0.0.0.0' IDENTIFIED BY 'senha_desejada' WITH GRANT OPTION;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'senha_desejada' WITH GRANT OPTION;
```

### Env Mysql:
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT={porta que configurou}
DB_DATABASE={db_name}
DB_USERNAME=root
DB_PASSWORD={senha_desejada}
```

### Rodar Migrate (Se pedir para criar banco cujo o nome está na variável DB_DATABASE, aceite):
```
docker exec -it {container-name} php artisan migrate
```


### Rodar Horizon (Se não estiver instalado rode o primeiro comando):
```
docker exec -it {container-name} composer require laravel/horizon
docker exec -it {container-name} php artisan horizon:install
```