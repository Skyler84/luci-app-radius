# luci-app-radius-manage
OpenWrt Radius Server Manager

Forked from https://github.com/jimbolaya/luci-app-radius

I have tried to upgrade this project to feature more significant radius management. You will want to go through the OpenWRT wiki on Freeradius3 at https://openwrt.org/docs/guide-user/network/wifi/freeradius to configure Freeradius 3 first.

You will also need to install luci-compat if you're running v21+ (maybe v19+)

When you're done with that and have sucessfully tested connecting a WiFi client, you will want to add 

`$INCLUDE clients.extra`

to the end of `/etc/freeradius3/clients.conf`

and 

`$INCLUDE /etc/freeradius3/authorize.extra`

to the top of `/etc/freeradius3/mods-config/files/authorize`

## Building

I cheated because i felt like it, you can build this separately from the OpenWRT build system using `make TOPDIR=scripts/topdir/ INCLUDE_DIR=scripts/includedir/`.