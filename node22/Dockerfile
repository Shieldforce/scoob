  FROM node:22
  
  # Define o diretório de trabalho dentro do container
  WORKDIR /home/node/app
  
  # Copia os arquivos do projeto para o container
  COPY . .
  
  # Instala o Yarn globalmente
  RUN corepack enable \
  && corepack prepare yarn@3.3.0 --activate \
  && npm install \
  && npm install express \
  && npm install -g nodemon -D
  
  # Expõe a porta
  EXPOSE 3022
  
  # Comando para iniciar o container
  CMD ["npm", "run", "start"]