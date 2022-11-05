#!/bin/bash -e

install -d "${ROOTFS_DIR}/etc/unbound/unbound.conf.d/"
install -d "${ROOTFS_DIR}/etc/dnsmasq.d/"
install -m 644 files/unbound-pi-hole.conf "${ROOTFS_DIR}/etc/unbound/unbound.conf.d/pi-hole.conf"
install -m 644 files/99-edns.conf "${ROOTFS_DIR}/etc/dnsmasq.d/99-edns.conf"