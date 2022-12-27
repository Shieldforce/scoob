# Scoob

### Requisitos obrigatórios:
- shell bash
- docker
- docker-compose

### Rode o comando para criar um alias para o scoob: 
```
echo "alias scoob='bash $(pwd)/scoob'" >> ~/.bashrc; source ~/.bashrc
```

### Existem dois jeitos de chamar a ajuda do scoob:
```
scoob
scoob --help
```

### Para remover uma implementação de container:
```
scoob --type docker-remove {nome do container}
```

### Os tipos de implementação são:
```
scoob --type docker-php-nginx
```

### Limpar tudo que não está sendo usado no docker (CUIDADO, IRÁ EXCLUIR TUDO QUE NÃO ESTÁ SENDO USADO!):
```
scoob --docker-prune
```

### Exemplos de container para php/nginx:
- --type                : Tipo do container para php sempre será (docker-php-nginx)
- --version             : Versão do PHP Versões disponíveis (7.4, 8.1, 8.2)
- --port                : Porta de Exposição do container
- --composer-update     : Atualiza a lista de pacotes da vendor!
- --migrate-seed        : Roda as migrations se for um laravel! 
- --migrate-fresh       : Reseta as migrations se for um laravel! 
- --migrate             : Roda as migrations e seeds!
### Este comando vai instalar um container com php/nginx, atualizar a vendor e rodar as migrations e seeds (Caso muito útil e, laravel)
```
scoob --type docker-php-nginx --version 7.4 --port 8081 --composer-update --migrate-seed
```
