# Imagem do scoob para projetos Node (--type docker-node).
# O projeto não é copiado para a imagem: a pasta é montada em /var/www no docker run, igual ao PHP.
ARG VERSION=22
FROM node:${VERSION}

# Usuário do host, para os arquivos criados (node_modules, build, uploads) ficarem com o dono certo.
ARG HOST_UID=1000
ARG HOST_GID=1000

ENV NODE_ENV=production \
    PORT=3000 \
    TZ=America/Sao_Paulo \
    HOME=/home/scoob \
    npm_config_cache=/home/scoob/.npm \
    npm_config_update_notifier=false

RUN mkdir -p /home/scoob /var/www \
    && chown -R ${HOST_UID}:${HOST_GID} /home/scoob /var/www

COPY entrypoint.sh /usr/local/bin/scoob-node-entrypoint
RUN chmod 755 /usr/local/bin/scoob-node-entrypoint

WORKDIR /var/www
EXPOSE 3000

ENTRYPOINT ["scoob-node-entrypoint"]
CMD ["npm", "run", "start"]
