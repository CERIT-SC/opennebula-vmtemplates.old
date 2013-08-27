# Rebuilding CERIT-SC's VM templates

## Public templates

All

    make cloud

or

    make debian6
    make debian7
    make centos6

## Application templates

All

    make apps

or

    make mysql51
	make zenoss4

## Private HA templates

All

    make ha

or

    make ha_brno
	make ha_jihlava

## Private HPC templates

Particular node, e.g.

    make zegox1.cerit-sc.cz
    make zigur1.cerit-sc.cz
    make zapat1.cerit-sc.cz

or build and instantiate, e.g.

    make run-zegox1.cerit-sc.cz

