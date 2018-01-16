#!/bin/bash -x
#
# run as root!

LOC=$(hostname | cut -d- -f1)
ZONE_NAME="${LOC}.uh-iaas.no"

if [ "$LOC" = "vagrant" ]; then
    . /root/openrc
    export OS_USERNAME=admin
    export OS_PROJECT_NAME=openstack
    export OS_PASSWORD=admin_pass
    export PS1='[\u@\h \W(keystone_vagrant_admin)]$ '
else
    [ -f /root/openrc_admin ] || exit 1
    . /root/openrc_admin
fi

# update pools config (FIXME: should be done by puppet)
designate-manage pool update --file /etc/designate/pools.yaml

# Tenant ID to own all managed resources - like auto-created records etc.
OPENSTACK_TENANT_ID=$(openstack project show openstack -c id -f value)
openstack-config --set /etc/designate/designate.conf service:central managed_resource_tenant_id $OPENSTACK_TENANT_ID

# Create a server
designate server-create --name $(hostname).

# Create our zone
designate domain-create --name ${ZONE_NAME}. --email root@${ZONE_NAME}

# Get the zone ID
ZONE_ID=$(designate domain-list | grep $ZONE_NAME | awk '{print $2}')

# Register an A record within the zone
designate record-create --name dummy1.${ZONE_NAME}. --type A --data 1.1.1.1 $ZONE_ID

# Configure [handler:nova_fixed] in designate.conf
openstack-config --set /etc/designate/designate.conf handler:nova_fixed zone_id $ZONE_ID

# Restart services
systemctl restart designate-api
systemctl restart designate-central
systemctl restart designate-mdns
systemctl restart designate-pool-manager
systemctl restart designate-sink
