#!/bin/bash

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

read -p "Enter domain name: " domain
if [ -z $domain ]; then
  echo "You don\`t write anything!" >&2
  exit 1
fi

rsa_key_size=4096
data_path="./certbot"
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

read -p "Enter your email (you will be notified when certificate expired): " email
if [ -z $email ]; then
  echo "Email is required!" >&2
  exit 1
fi

if [ -d "/etc/letsencrypt/live/$domain" ]; then
  read -p "Existing data found for $domain. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

echo "### Creating dummy certificate for $domain ..."
path="/etc/letsencrypt/live/$domain"

mkdir -p "$data_path/conf/live/$domain"

docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo

echo "### Starting apache ..."
docker-compose up --force-recreate -d apache
echo

echo "### Deleting dummy certificate for $domain ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domain && \
  rm -Rf /etc/letsencrypt/archive/$domain && \
  rm -Rf /etc/letsencrypt/renewal/$domain.conf" certbot
echo

echo "### Requesting Let's Encrypt certificate for $domain ..."
#Join $domain to -d args
domain_args="-d $domain"

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then
  staging_arg="--staging";
fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading apache ..."
docker-compose exec apache apachectl restart