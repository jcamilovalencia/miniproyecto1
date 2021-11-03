#APROVISIONAMIENTO DEL BALANCEADOR DE CARGA

echo "Creación de contenedores web"
lxc launch ubuntu:18.04 HAProxy --target virutalMachine1
lxc launch ubuntu:18.04 Web01 --target vitualMachine2
lxc launch ubuntu:18.04 Web02 --target virtualMachine3

echo "Ingresamos al modo superusuario del contenedor Web01 para instalar el apache2"
lxc exec Web01 /bin/bash
apt update && apt upgrade
apt install apache2
systemclt enable apache2
vim /var/www/html/index.html

echo "Modificando el archivo index.html"
sed -i '
<!DOCTYPE html>
<html>
<body>
<h1>CONTENEDOR WEB1 VIRTUALMACHINE2</h1>
<p>Bienvenidos al contenedor LXD WEB1</p>
</body>
</html>
' /var/www/html/index.html
lxc file push index.html Web01/var/www/html/index.html
systemctl start apache2
exit


echo "Ingresamos al modo superusuario del contenedor Web01 para instalar el apache2"
lxc exec Web02 /bin/bash
apt update && apt upgrade
apt install apache2
systemctl enable apache2
vim /var/www/html/index.html

echo "Modificando el archivo index.html"
sed -i '
<!DOCTYPE html>
<html>
<body>
<h1>CONTENEDOR WEB2 VIRTUALMACHINE3</h1>
<p>Bienvenidos al contenedor LXD WEB2</p>
</body>
</html>
' /var/www/html/index.html
lxc file push index.html Web02/var/www/html/index.html
systemctl start apache2
exit



echo "Ingresamos al modo superusuario del contenedor HAProxy para instalar el haproxy"
lxc exec HAProxy /bin/bash
apt update && apt upgrade
apt install haproxy
systemctl enable haproxy

echo "Modificamos el archivos haproxy.cfg"
vim /etc/haproxy/haproxy.cfg
sed -i '
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats

   server web1 240.101.0.172:80 check
   server web2 240.102.0.58:80 check

frontend http
  bind *:80
  default_backend web-backend
' /etc/haproxy/haproxy.cfg
systemctl start haproxy
exit

echo "Configuración de reenvio de puertos para probar el balanceador de carga"
lxc config device add haproxy http proxy listen=tcp:0.0.0.0:2080 connect=tcp:127.0.0.1:80

