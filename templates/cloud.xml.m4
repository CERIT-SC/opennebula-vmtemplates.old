include(defaults.m4)dnl
include(common.m4)dnl
include(base.xml.m4)dnl

REQUIREMENTS="(HYPERVISOR=\"kvm\") & (CLUSTER=\"__CLUSTER__\")"

RAW=[
  DATA="<!-- RAW data follows: -->XML_CPU_MODE_SIMPLE <devices>XML_CONSOLE</devices>",
  TYPE="kvm" ]

CONTEXT=[
  SSH_KEY="$USER[SSH_KEY]",
  PUBLIC_IP="$NIC[IP]",
  TARGET="vdb",
  USER_DATA="#cloud-config
# see https://help.ubuntu.com/community/CloudInit

bootcmd:
- test -L /etc/motd && unlink /etc/motd || /bin/true

mounts:
- [vdc,none,swap,sw,0,0]
- [vdd,/var/cache/openafs,ext2]ifdef(`__DATADISK_SIZE__',`
- [vde,__DATADISK_MOUNT__,__DATADISK_FORMAT__,format(`%s%s%s',RQ(),`__DATADISK_MOUNTOPTS__',RQ())]')

apt_sources:
- source: 'deb http://apt.puppetlabs.com/ squeeze main dependencies'
  keyid: 4BD6EC30
  filename: puppetlabs.list

dnl yum_repos:
dnl   puppetlabs-products:
dnl     name: Puppet Labs Products \$releasever - \$basearch
dnl     baseurl: http://yum.puppetlabs.com/el/\$releasever/products/\$basearch
dnl     enabled: true
dnl     gpgcheck: true
dnl     gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
dnl   puppetlabs-deps:
dnl     name: Puppet Labs Dependencies \$releasever - \$basearch
dnl     baseurl: http://yum.puppetlabs.com/el/\$releasever/dependencies/\$basearch
dnl     enabled: true
dnl     gpgcheck: true
dnl     gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs

packages: []

rsyslog:
- '*.*  @xenox.cerit-sc.cz'

write_files:
- path: /etc/motd
  content: |2
    
       ___ ___ ___  _ _____    ___  ___
      / __| __| _ \| |_   _|__/ __|/ __|'s cloud image with *cloud-init*
     | (__| _||   /| | | ||___\__ \ (__    http://www.cerit-sc.cz/
      \___|___|_|_\|_| |_|    |___/\___|   
     
    
runcmd:
- echo 'Instance is ready to use.' | wall
ifdef(`__CLOUD_CONFIG__',`
__CLOUD_CONFIG__')
"]
