# Half Automatic nginx SSL Configuration with [Let's Encrypt]

With [Let's Encrypt] we can easily manage our certificates and build https sites.

This tool I offer will make integrating [Let's Encrypt] with [nginx] easier.

## What this tool can do

1. Apply certificates for all the domains pointing to the nginx on this server within one command.
2. Crontab task to auto renew the certificates.
3. Simple nginx config files that can redirect all your www domain to none www domain and get you an A+ score at [SSL Labs](https://www.ssllabs.com/)

## Install

[Let's Encrypt] is included in this tool as a submodule. You can just git clone this project and init submodules.

~~~
git clone https://github.com/songchenwen/nginx-ssl-config-with-letsencrypt.git
cd nginx-ssl-config-with-letsencrypt
git submodule init
git submodule update --remote
~~~

## Usage

### Apply Certificates

#### Edit `ssl/config` 

Fill in your domains, the first domain will be used as the common name, and your certificate will be stored in `/etc/letsencrypt/live/{your first domain in config file}/`

Choose a server. The `acme-v01` server is the product server, it has a strict rate limit. The `acme-staging` is a testing server, you'd better use this server first to test your configurations.

#### Configure nginx

[Let's Encrypt] use a little http server to verify your ownership to the domain. We need to configure nginx to serve that file for us.

Copy my configuration file `letsencrypt_challenge` to nginx config folder. This configuration file will redirect all http traffic to https exluding the url that [Let's Encrypt] needs to verify.

~~~
sudo cp nginx-config/letsencrypt_challenge /etc/nginx/sites-available/letsencrypt_challenge
sudo ln -s /etc/nginx/sites-available/letsencrypt_challenge /etc/nginx/sites-enabled/letsencrypt_challenge 
sudo nginx -s reload
~~~

#### Run the script

Execute `ssl/apply_all_certs.sh`, fill in your email and get your certificates.

~~~
bash ssl/apply_all_certs.sh
sudo nginx -s reload
~~~

### Sample nginx Config File

There's 3 usefull nginx config files under `nginx-config`. Remember to use them after you modify them, at least replace my domain with yours.

- `letsencrypt_challenge` redirects all your http traffic to https, but leaves the url that [Let's Encrypt] needs to apply or renew certificates as http.
- `www_to_none_www` redirects all your https traffic to www prefixed domain to its none www counterpart.
- `sample_config` is a simple server config that can get an A score at [SSL Labs](https://www.ssllabs.com/). Uncomment the last line before `}` will enable HSTS, which will give you a A+ score.

### Auto Renew Crontab Task

[Let's Encrypt] certificates only live for 90 days. We definitely need a way to auto renew our certificates. A crontab task which renews the certificates every month will be enough. This crontab should be run as root, since we'll need to reload our nginx's configuration after auto renewal.

~~~
sudo crontab -e
~~~

Crontab task goes below

~~~
0 2 1 1-12 * /path/to/ssl/renew_all_certs.sh
~~~

[Let's Encrypt]:https://letsencrypt.org/
[nginx]:https://www.nginx.com
