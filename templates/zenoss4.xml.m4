runcmd:
- rpm -e --nodeps mysql-libs
dnl - mkdir /opt/mysql && ln -s /opt/mysql /var/lib/
- wget --no-check-certificate https://github.com/zenoss/core-autodeploy/tarball/4.2.4 -O /tmp/auto.tar.gz
- tar xvf /tmp/auto.tar.gz -C /tmp
- cd /tmp/zenoss-core-autodeploy-*; sed -i -e 's/less /cat /' core-autodeploy.sh; yes | ./core-autodeploy.sh &>/root/zenoss.log

write_files:
- path: /etc/motd
  content: |2
    
       ___ ___ ___  _ _____    ___  ___
      / __| __| _ \| |_   _|__/ __|/ __|'s application template with Zenoss Core 4
     | (__| _||   /| | | ||___\__ \ (__    * please try http://localhost:8080
      \___|___|_|_\|_| |_|    |___/\___|
     
