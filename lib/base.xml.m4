NAME="__NAME__"
VCPU="__VCPU__"
CPU="__CPU__"
MEMORY="__MEMORY__"
OS=[
  ARCH="x86_64",
  BOOT="hd" ]
FEATURES=[
  ACPI="yes",
  PAE="yes" ]
DISK=[
  IMAGE="__IMAGE__",
  IMAGE_UNAME="__IMAGE_UNAME__",
  DEV_PREFIX="__DEV_PREFIX__" ]
DISK=[
  DRIVER="raw",
  SIZE="__SWAP_SIZE__",
  TYPE="swap",
  DEV_PREFIX="__DEV_PREFIX__" ]
DISK=[
  DRIVER="raw",
  FORMAT="ext2",
  SIZE="512",
  TYPE="fs",
  DEV_PREFIX="__DEV_PREFIX__" ]
ifdef(`__DATADISK_SIZE__',
`DISK=[
  DRIVER="__DATADISK_DRIVER__",
  FORMAT="__DATADISK_FORMAT__",
  SIZE="__DATADISK_SIZE__",
  TYPE="fs",
  DEV_PREFIX="__DEV_PREFIX__" ]')
ifdef(`__NETWORK1__',
`NIC=[ifdef(`__IP1__',`
  IP="__IP1__",',`')
  MODEL="__NETWORK_MODEL__",
  NETWORK="__NETWORK1__",
  NETWORK_UNAME="__NETWORK1_UNAME__"]')
ifdef(`__NETWORK2__',
`NIC=[ifdef(`__IP2__',`
  IP="__IP2__",',`')
  MODEL="__NETWORK_MODEL__",
  NETWORK="__NETWORK2__",
  NETWORK_UNAME="__NETWORK2_UNAME__"]')
ifdef(`__VNC__',
`INPUT=[
  BUS="usb",
  TYPE="tablet" ]
GRAPHICS=[
  KEYMAP="en-us",
  LISTEN="0.0.0.0",
  PASSWD="PSWD_64",
  TYPE="vnc" ]
',`')dnl
