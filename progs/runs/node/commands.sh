#!/bin/bash
# Depois de criar o container: espera a aplicação subir e mostra o log inicial.
container=$1

sleep 5
echo ""
echo -e "\e[33;36m Últimas linhas do log (${container}): \e[0m"
docker logs --tail 30 ${container}
echo ""
echo -e "\e[33;36m Acompanhar: docker logs -f ${container} \e[0m"
echo -e "\e[33;36m Comandos no container: docker exec -it ${container} npm run <script> \e[0m"
