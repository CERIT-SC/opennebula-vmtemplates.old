packages:
- mysql-server

runcmd:
- openssl rand -base64 32 >/root/mysql.pswd
- mysql -u root -e 'drop database if exists LQ()`lost+found'LQ()'
- mysql -u root -e \"delete from mysql.user where User='root' and Host not in ('localhost','127.0.0.1')\"
- mysql -u root -e \"grant all on *.* to '$UNAME' identified by 'LQ()`cat /root/mysql.pswd'LQ()'\"
- mysql -u root -e 'flush privileges'

write_files:
- path: /etc/motd
  content: |2
    
       ___ ___ ___  _ _____    ___  ___
      / __| __| _ \| |_   _|__/ __|/ __|'s application template
     | (__| _||   /| | | ||___\__ \ (__      for MySQL 5.5
      \___|___|_|_\|_| |_|    |___/\___|
      
     Database credentials:
      - hostname: $NIC[IP] 
      - db. user: $UNAME 
      - password: see /root/mysql.pswd
      
     Remote connect:
     # mysql -h $NIC[IP] -u $UNAME -p
      
- path: /etc/mysql/conf.d/cerit.cnf
  content: |2
    [mysqld]
    bind-address                   = 0.0.0.0
    tmpdir                         = /var/lib/mysql/
    max_connect_errors             = 500
    innodb                         = FORCE
    key_buffer_size                = 32M
    
    # CACHES AND LIMITS #
    tmp_table_size                 = 32M
    max_heap_table_size            = 32M
    query_cache_type               = 0
    query_cache_size               = 0
    max_connections                = 128
    thread_cache_size              = 20
    open_files_limit               = 65535
    table_definition_cache         = 2048
    table_open_cache               = 2048
    
    # INNODB #
    innodb_flush_method            = O_DIRECT
    innodb_log_file_size           = 128M
    innodb_flush_log_at_trx_commit = 2 
    innodb_file_per_table          = 1
    innodb_buffer_pool_size        = 2G
