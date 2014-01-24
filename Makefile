# ON image name prefixes
IMAGE_D6=CERIT-SC-Debian-6.0-0031
IMAGE_D7=CERIT-SC-Debian-7-0004
IMAGE_C6=CERIT-SC-CentOS-6-0013

TMPL_GROUP=cerit-sc

# functions
HOST2IP=$(shell host $@ | grep ' has address ' | awk '{ print $$4 }')

all: cloud apps ha

apps: mysql51 zenoss4
	@echo 'Public application templates rebuilt'

cloud: debian7 centos6
	@echo 'Public cloud templates rebuilt'

ha: ha_brno ha_jihlava
	@echo 'HA templates rebuilt'

# ** onetemplate **
# desc: create and register VM template
# args: <name> <mode> <m4 file> <m4 args>
define onetemplate
	$(if $2,
		$(eval MODE := $2),
		$(eval MODE := 644))

	DEF=`mktemp`; \
	m4 -I lib -I templates -D__NAME__="$1" $4 $3 | tee $$DEF; \
	onetemplate delete "$1" ; \
	onetemplate create $$DEF ; \
	onetemplate chgrp "$1" $(TMPL_GROUP) ; \
	onetemplate chmod "$1" $(MODE) ; \
	unlink $$DEF
endef


#####################################################################
# (public) cloud templates
#

# ** onetemplate_cloud **
# desc: wrapper for creating ON cloud templates
# args: <ON name> <ON mode> <vcpus> <mem[GiB]> <swap[GiB]> <data[GiB]> <ON image> <m4 args>
define onetemplate_cloud
	$(if $6,
		$(eval NAME := CERIT-SC $1 ($3 VCPU - $(4)GiB RAM - $(6)GiB data)),
		$(eval NAME := CERIT-SC $1 ($3 VCPU - $(4)GiB RAM)))

	$(if $4, $(eval D_MEMORY := -D__MEMORY__=$(shell echo $(4)*1024 | bc)))
	$(if $5, $(eval D_SWAP_SIZE := -D__SWAP_SIZE__=$(shell echo $(5)*1024 | bc)))
	$(if $6, $(eval D_DATADISK_SIZE := -D__DATADISK_SIZE__=$(shell echo $(6)*1024 | bc)))

	$(call onetemplate,$(NAME),$2,cloud.xml.m4,$8 \
		-D__VCPU__="$3" \
		$(D_MEMORY) \
		$(D_SWAP_SIZE) \
		$(D_DATADISK_SIZE) \
		-D__IMAGE__="$7")
endef

# ** onetemplate_cloud_brno **
# desc: wrapper for creating ON cloud templates __in Brno__
# args: <ON name> <ON mode> <vcpus> <mem[GiB]> <swap[GiB]> <data[GiB]> <ON image> <m4 args>
define onetemplate_cloud_brno
	$(call onetemplate_cloud,$1,$2,$3,$4,$5,$6,$(7)@cerit-sc-cloud,$8 \
		-D__CLUSTER__='cerit-sc-cloud' \
		-D__NETWORK1__='cerit-sc-cloud-public' \
		-D__NETWORK2__='cerit-sc-cloud-private1')
endef

debian7:
	$(call onetemplate_cloud_brno,Debian 7 x86-64,,1,1,4,,$(IMAGE_D7))
	$(call onetemplate_cloud_brno,Debian 7 x86-64,,1,2,4,,$(IMAGE_D7))
	$(call onetemplate_cloud_brno,Debian 7 x86-64,,2,4,4,,$(IMAGE_D7))
	$(call onetemplate_cloud_brno,Debian 7 x86-64,,2,8,4,,$(IMAGE_D7))

centos6:
	$(call onetemplate_cloud_brno,CentOS 6 x86-64,,1,1,4,,$(IMAGE_C6))
	$(call onetemplate_cloud_brno,CentOS 6 x86-64,,1,2,4,,$(IMAGE_C6))
	$(call onetemplate_cloud_brno,CentOS 6 x86-64,,2,4,4,,$(IMAGE_C6))
	$(call onetemplate_cloud_brno,CentOS 6 x86-64,,2,8,4,,$(IMAGE_C6))

mysql51:
	$(call onetemplate_cloud_brno,application - MySQL 5.1,,2,4,8,50,$(IMAGE_D6),\
		-D__DATADISK_MOUNT__=/var/lib/mysql \
		-D__CLOUD_CONFIG__="include(mysql51.xml.m4)")

zenoss4:
	$(call onetemplate_cloud_brno,application - Zenoss Core 4,600,4,16,16,12,$(IMAGE_C6),\
		-D__DATADISK_MOUNT__=/opt \
		-D__CLOUD_CONFIG__="include(zenoss4.xml.m4)")


#####################################################################
# HPC node templates
#

# ** onetemplate_hpc **
# desc: wrapper for creating ON cloud templates
# args:
#   1: <ON name>
#   2: <vcpus>
#   3: <sockets>
#   4: <mem[MiB]>
#   5: <swap[MiB]>
#   6: <scratch_hostdev>
#   7: <IB PCI domain>
#   8: <IB PCI bus>
#   9: <IB PCI slot>
#  10: <IB PCI function>
#  11: <ON physical host>
#  12: <ON cluster>
#  13: <ON image>
#  14: <m4 args>
define onetemplate_hpc
	$(call onetemplate,$1,600,hpc.xml.m4,${14} \
		-D__CPU_MODE__=host-passthrough \
		-D__VCPU__=$2 -D__SOCKETS__=$3 \
		-D__MEMORY__=$4 \
		-D__SWAP_SIZE__=$5 \
		-D__SCRATCH_DEV__=$6 \
		-D__IB_PCI_DOMAIN__=$7 \
		-D__IB_PCI_BUS__=$8 \
		-D__IB_PCI_SLOT__=$9 \
		-D__IB_PCI_FN__=${10} \
		-D__REQ_HOSTNAME__=${11} \
		-D__IMAGE__="${13}@${12}" \
		-D__NETWORK1__="${12}" \
		-D__IP1__="$(HOST2IP)" )
endef

zegox%.cerit-sc.cz:
	$(call onetemplate_hpc,$@,12,2,93184,24576,/dev/md3,0x0,0x20,0x0,0x0,hda$*.cerit-sc.cz,cerit-sc-zegox,$(IMAGE_D6))

zigur%.cerit-sc.cz:
	$(call onetemplate_hpc,$@,8,2,124000,24576,/dev/md3,0x0,0x3,0x0,0x0,hdb$*.cerit-sc.cz,cerit-sc-zigur_zapat,$(IMAGE_D6))

zapat%.cerit-sc.cz:
	$(call onetemplate_hpc,$@,16,2,124000,24576,/dev/md3,0x0,0x3,0x0,0x0,hdc$*.cerit-sc.cz,cerit-sc-zigur_zapat,$(IMAGE_D6))

run-%: %
	onetemplate instantiate $* --name=$*


#####################################################################
# HA templates
#

# ** onetemplate_ha **
# desc: wrapper for creating ON HA templates
# args: <ON name> <ON mode> <vcpus> <mem[GiB]> <swap[GiB]> <data[GiB]> <ON cluster> <ON image> <m4 args>
define onetemplate_ha
	$(call onetemplate_cloud,$1,$2,$3,$4,$5,$6,$8@$7,$9 \
		-D__CLUSTER__=$7 \
		-D__NETWORK1__=$7 )
endef

ha_brno:
	$(call onetemplate_ha,HA Brno Debian 7 x86-64,600,1,2,4,,cerit-sc-ha-brno,$(IMAGE_D7))
	$(call onetemplate_ha,HA Brno CentOS 6 x86-64,600,1,2,4,,cerit-sc-ha-brno,$(IMAGE_C6))

ha_jihlava:
	$(call onetemplate_ha,HA Jihlava Debian 7 x86-64,600,1,2,4,,cerit-sc-ha-jihlava,$(IMAGE_D7))
	$(call onetemplate_ha,HA Jihlava CentOS 6 x86-64,600,1,2,4,,cerit-sc-ha-jihlava,$(IMAGE_C6))
