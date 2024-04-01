#!/bin/bash

# Verifique se o usuário é root (ou use sudo)
if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser executado como root ou com privilégios de superusuário."
    exit 1
fi

# Defina a versão do PostgreSQL que você deseja instalar
POSTGRES_VERSION="16.2"  # Substitua pela versão desejada

# Baixe o código fonte do PostgreSQL
wget https://ftp.postgresql.org/pub/source/v$POSTGRES_VERSION/postgresql-$POSTGRES_VERSION.tar.gz

# Extraia o arquivo tar.gz
tar -xvzf postgresql-$POSTGRES_VERSION.tar.gz

# Navegue para o diretório extraído
cd postgresql-$POSTGRES_VERSION

# Configure e compile o PostgreSQL
./configure --prefix=/usr/local/$POSTGRES_VERSION
make
make install

# Crie um link simbólico para /usr/local/pgsql
ln -s /usr/local/$POSTGRES_VERSION /usr/local/pgsql

# Crie um usuário para o PostgreSQL
useradd -m postgres

# Inicialize o banco de dados
su - postgres -c "initdb -D /usr/local/pgsql/data"

# Inicie o servidor PostgreSQL
su - postgres -c "pg_ctl -D /usr/local/pgsql/data -l logfile start"

# Adicione o PostgreSQL ao PATH
echo 'export PATH=$PATH:/usr/local/pgsql/bin' >> ~/.bashrc
source ~/.bashrc

# Verifique a versão instalada
psql --version

# Limpeza
cd ..
rm -rf postgresql-$POSTGRES_VERSION*
