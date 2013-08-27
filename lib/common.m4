divert(`-1')
define(`forloop', `pushdef(`$1', `$2')_forloop($@)popdef(`$1')')
define(`_forloop', `$4`'ifelse($1, `$3', `', `define(`$1', incr($1))$0($@)')')
divert`'dnl
dnl
dnl http://mbreen.com/m4.html#quotemacro
define(`LQ',`changequote(<,>)`dnl'
changequote`'')
define(`RQ',`changequote(<,>)dnl`
'changequote`'')
define(XML_WATCHDOG,		<watchdog model='i6300esb' action='reset'/>)dnl
define(XML_CONSOLE,			<serial type='pty'><target port='0'/></serial><console type='pty'><target type='serial' port='0'/></console>)dnl
define(XML_D_SCRATCH,		<disk type='block' device='disk'><driver name='qemu' type='raw' cache='none' io='native'/><source dev='__SCRATCH_DEV__'/><target dev='vde' bus='virtio'/></disk>)dnl
define(XML_HOSTDEV_IB,		<hostdev mode='subsystem' type='pci' managed='yes'><source><address domain='__IB_PCI_DOMAIN__' bus='__IB_PCI_BUS__' slot='__IB_PCI_SLOT__' function='__IB_PCI_FN__'/></source></hostdev>)dnl
define(XML_NUMATUNE,		<numatune><memory mode='preferred' nodeset='0'/></numatune>)
define(XML_CPU_TOPOLOGY,	<topology sockets='__SOCKETS__' cores='eval(__VCPU__/__SOCKETS__/__THREADS__)' threads='__THREADS__'/>)
define(XML_CPU_MODE_SIMPLE, <cpu mode='host-model'></cpu>)dnl
define(XML_CPU_MODE_2NUMA,  <cpu mode='__CPU_MODE__'>XML_CPU_TOPOLOGY<numa><cell cpus='0-eval((__VCPU__/2)-1)' memory='eval(__MEMORY__*512)' /><cell cpus='eval(__VCPU__/2)-eval(__VCPU__-1)' memory='eval(__MEMORY__*512)' /></numa></cpu>)dnl
define(XML_CPUTUNE,			<cputune>forloop(VCPUID,0,eval(__VCPU__-1),`<vcpupin vcpu=RQ()VCPUID()RQ() cpuset=RQ()VCPUID()RQ() />')</cputune>)dnl
define(PSWD_64,`esyscmd(`dd if=/dev/urandom bs=1 count=64 2>/dev/null | base64 | awk "{printf \$$0}"')')dnl
