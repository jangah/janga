Installation

1. Checkout janga from git
2. Checkout the assets from git git clone git@gitlab.com:jangah/www.git
3. Create link : ln -s ../www www 
4. Create a configuration file app.config based on the app.config.template
5. If you want to use apns, you have to copy your certs into priv/certs directory
6. dev.sh or prod.sh