packages:
- mysql-server

runcmd:
- rmdir /var/lib/mysql/lost+found/
- openssl rand -base64 32 >/root/mysql.pswd
- mysql -u root -e 'delete from mysql.user where User='\''root'\'' and Host not in ('\''localhost'\'','\''127.0.0.1'\'')'
- mysql -u root -e 'grant all on *.* to '\''cerit'\'' identified by '\'\LQ()cat /root/mysql.pswd\LQ()\'
- mysql -u root -e 'flush privileges'
- echo 'Instance is ready to use.' | wall

write_files:
- path: /etc/motd
  content: |2
    
       ___ ___ ___  _ _____    ___  ___
      / __| __| _ \| |_   _|__/ __|/ __|'s application template with MySQL 5.1
     | (__| _||   /| | | ||___\__ \ (__    * db. user: cerit
      \___|___|_|_\|_| |_|    |___/\___|   * passwd see /root/mysql.pswd
     
- path: /etc/mysql/my.cnf
  content: |2
    [mysql]
    
    # CLIENT #
    port                           = 3306
    socket                         = /var/lib/mysql/mysql.sock
    
    [mysqld]
    
    # GENERAL #
    user                           = mysql
    default-storage-engine         = InnoDB
    socket                         = /var/lib/mysql/mysql.sock
    pid-file                       = /var/lib/mysql/mysql.pid
    
    # MyISAM #
    key-buffer-size                = 32M
    myisam-recover                 = FORCE,BACKUP
    
    # SAFETY #
    max-allowed-packet             = 16M
    max-connect-errors             = 1000000
    innodb                         = FORCE
    
    # DATA STORAGE #
    datadir                        = /var/lib/mysql/
    tmpdir                         = /var/lib/mysql/
    
    # CACHES AND LIMITS #
    tmp-table-size                 = 32M
    max-heap-table-size            = 32M
    query-cache-type               = 0
    query-cache-size               = 0
    max-connections                = 500
    thread-cache-size              = 50
    open-files-limit               = 65535
    table-definition-cache         = 4096
    table-open-cache               = 4096
    
    # INNODB #
    innodb-flush-method            = O_DIRECT
    innodb-log-files-in-group      = 2
    innodb-log-file-size           = 128M
    innodb-flush-log-at-trx-commit = 2
    innodb-file-per-table          = 1
    innodb-buffer-pool-size        = 2G
    
    # LOGGING #
    log-error                      = /var/lib/mysql/mysql-error.log
    log-queries-not-using-indexes  = 1
    slow-query-log                 = 1
    slow-query-log-file            = /var/lib/mysql/mysql-slow.log
