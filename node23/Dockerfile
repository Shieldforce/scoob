  FROM node:23
  
  # Define o diretório de trabalho dentro do container
  WORKDIR /home/node/app
  
  # Copia os arquivos do projeto para o container
  COPY . .
  
  # Instala o Yarn globalmente
  RUN corepack enable \
  && corepack prepare yarn@3.3.0 --activate \
  && yarn install \
  && yarn add express
  
  # Expõe a porta
  EXPOSE 3023
  
  # Comando para iniciar o container
  CMD ["yarn", "start"]