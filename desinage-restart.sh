#!/bin/bash -x
#
# run as root!


# Restart services
systemctl restart designate-api
systemctl restart designate-central
systemctl restart designate-mdns
systemctl restart designate-worker
systemctl restart designate-producer
systemctl restart designate-sink
