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

### Os tipos de implementação são:
```
scoob --type docker-php
```

### Exemplos:
```
scoob --type docker-php --version 7.4 --port 9001
```
