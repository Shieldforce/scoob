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
scoob --type docker-php-nginx
```

### Implementar um container Laravel:
```
scoob --type docker-laravel
```

### Limpar tudo que não está sendo usado no docker (CUIDADO, IRÁ EXCLUIR TUDO QUE NÃO ESTÁ SENDO USADO!):
```
scoob --docker-prune
```