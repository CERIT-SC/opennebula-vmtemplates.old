include(defaults.m4)dnl
include(common.m4)dnl
include(base.xml.m4)dnl
dnl
REQUIREMENTS="(HOSTNAME=\"__REQ_HOSTNAME__\")"
RAW=[
dnl DATA="<!-- RAW data follows: --> RAW_CPU_NUMA RAW_CPUTUNE <devices>RAW_D_SCRATCH RAW_HOSTDEV_IB RAW_CONSOLE RAW_WATCHDOG</devices>",
  DATA="<!-- RAW data follows: --> XML_NUMATUNE XML_CPU_MODE_2NUMA XML_CPUTUNE <devices>XML_D_SCRATCH XML_HOSTDEV_IB XML_CONSOLE XML_WATCHDOG</devices>",
  TYPE="kvm" ]

CONTEXT=[
  SSH_KEY="$USER[SSH_KEY]",
  PUBLIC_IP="$NIC[IP]",
  TARGET="vdb",
  USER_DATA="#cloud-config
# see https://help.ubuntu.com/community/CloudInit

mounts:
- [vdc,none,swap,sw,0,0]
- [vdd,/var/cache/openafs,ext2]
- [vde,/scratch,ext4,'noatime,nodiratime,nosuid,data=writeback,nobh,barrier=0,errors=remount-ro']

apt_sources:
- source: 'deb http://apt.puppetlabs.com/ wheezy main dependencies'
  keyid: 4BD6EC30
  filename: puppetlabs.list

puppet:
  conf:
    agent:
      server: dollbox.cerit-sc.cz
    ca_cert: |
      -----BEGIN CERTIFICATE-----
      MIICQTCCAaqgAwIBAgIBATANBgkqhkiG9w0BAQUFADApMScwJQYDVQQDDB5QdXBw
      ZXQgQ0E6IGRvbGxib3guY2VyaXQtc2MuY3owHhcNMTEwOTI1MTMyNTMzWhcNMTYw
      OTIzMTMyNTMzWjApMScwJQYDVQQDDB5QdXBwZXQgQ0E6IGRvbGxib3guY2VyaXQt
      c2MuY3owgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMizvRXQxXLIgD9M6/Gz
      rhacX0dVh22dhgPtzqhDIcmHZYpj4+K39kuA0lqC4qUT4Q3F9iuHXk/Sim+mIqCB
      Um76qudhb9RaRvUaAiDniNu5f+YoRuLrzsiGvaqpPuYnoDBWgTNhKG6ooJRR3+TR
      6ez/ja/hO/TkLn0e8k70/kbnAgMBAAGjeTB3MDgGCWCGSAGG+EIBDQQrFilQdXBw
      ZXQgUnVieS9PcGVuU1NMIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAPBgNVHRMBAf8E
      BTADAQH/MB0GA1UdDgQWBBSWE7RFkdVxbWSCS7pp3hhWqr1jjTALBgNVHQ8EBAMC
      AQYwDQYJKoZIhvcNAQEFBQADgYEALcurTg/OF0XNuV2YdLRmUnvaiMXb9rLkksMu
      k8k2M9a0MrOGpCZT27GzlqQyI4a5kB7eqLZQ/zlCFHj1GsfbGcdh8VOfrOSzZ01I
      Io3TY7LF5VJz7GzEMQkkYZFrBL87cTTH3oDjHzWJt/igOE9M43C7hLv0ebEhiUsO
      /KEOM4U=
      -----END CERTIFICATE-----
"]
