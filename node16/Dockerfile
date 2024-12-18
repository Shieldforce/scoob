FROM node:16

# Mude para o usuário "node"
#USER node

# Define o diretório de trabalho dentro do container
WORKDIR /home/node/app

# Copia os arquivos do projeto para o container
COPY . .

# Instala o Yarn globalmente
RUN corepack enable \
&& yarn install \
&& yarn add express \
&& yarn global add nodemon

# Expõe a porta
EXPOSE 3016

# Comando para iniciar o container
CMD ["yarn", "start"]
