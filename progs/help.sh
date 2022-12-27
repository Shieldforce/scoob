#!/bin/bash

echo -e "\e[33;36m |\e[33;31m --------------------------- HELP! ---------------------------- \e[0m\e[33;36m|\e[0m";
echo "";


echo -e "\e[33;36m - Argumentos para docker : \e[0m";
echo -e "\e[33;35m --type             : Recebe o tipo de execução do (SCOOB)   \e[0m";
echo -e "\e[33;35m --docker-remove    : Remove uma implementação de container  \e[0m";
echo -e "\e[33;35m --docker-prune     : REMOVE TUDO QUE NÃO ESTÁ SENDO USADO!  \e[0m";
echo -e "\e[33;35m --composer-update  : Atualiza a lista de pacotes da vendor! \e[0m";
echo -e "\e[33;35m --migrate          : Roda as migrations se for um laravel!  \e[0m";
echo -e "\e[33;35m --migrate-seed     : Roda as migrations e seeds!            \e[0m";
echo -e "\e[33;35m --migrate-fresh    : Reseta as migrations e seeds!          \e[0m";

