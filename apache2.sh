#!/bin/bash
#
#
# automaçao apache sem ip fixo
# Ruan Cesar

# variaveis
pasta="/etc/apache2/sites-available"
tudo="/var/www"

shopt -s -o nounset

echo "instalaçao do apache 2 com configuraçao automatica"

# verificando privilegios
if sudo -n true 2>/dev/null; then
    echo "O usuário tem privilégios sudo."
    sleep 2
else
    echo " pfv tenha permiçao sudo para executar esse script"
    echo "saindo..... "
    sleep 3
    exit 1
fi

# atualizando o sistema
echo "atualizando o sistema"
sleep 2
apt-get update -y && apt-get upgrade -y
sleep 4

# verificando a instalaçao do programa

if [ comand -v apache2 &>/dev/null ]; then
    echo " o programa ja esta instalado "
    echo "saindo...."
    exit 1
else
    echo " instalando o apache "
    sleep 2
fi

#instalando o programa
apt-get install apache2 -y
sleep 4

echo "iniciando configuraçao"

echo "qual é o seu dominio? (com www/.com/.local)"
read site
echo "qual é o nome do seu site? (sem www/.com/.local)"
read site1
echo "cabo as pergunta"

#inicio da config do virtual holst

mkdir $tudo/$site1

touch $pasta/$site1.conf

echo "<VirtualHost *:80>" >> $pasta/$site1.conf
echo "      " >> $pasta/$site1.conf
echo "  ServerAdmin $site1@$site" >> $pasta/$site1.conf
echo "  ServerName $site" >> $pasta/$site1.conf
echo "  DocumentRoot $tudo/$site1" >> $pasta/$site1.conf
echo '  ErrorLog ${APACHE_LOG_DIR}/error.log' >> $pasta/$site1.conf
echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined' >> $pasta/$site1.conf
echo "      " >> $pasta/$site1.conf
echo "</VirtualHost>" >> $pasta/$site1.conf

#ligando o servidor/desligando o servidor padrao

a2ensite $pasta/$site1.conf
a2dissite $pasta/000-default.conf
systemctl restart apache2

echo "deseja adicionar um git clone? (sim/nao)"
read res


if [[ $res == sim ]]; then
    
    echo "instalando o git"
    apt-get install git -y
    sleep 2
    
    echo " pfv adicione o http do git clone "
    read git
    git clone $git $tudo/$site1
    echo "pronto"
else
    echo "ok, bye"
    sleep 2
    exit 1
fi
    
