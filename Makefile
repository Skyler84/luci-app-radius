include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-radius-manager
PKG_VERSION:=0.5
PKG_RELEASE:=0
PKG_MAINTAINER:=Skyler Mansfield <skyler.mansfield.21@gmail.com>
PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-radius-manager
   SECTION:=luci
   CATEGORY:=LuCI
   DEPENDS:= +freeradius3-mod-files +luci-compat +python3-light
   TITLE:=Radius Server Management Tool
   MAINTAINER:=Skyler Mansfield <skyler.mansfield.21@gmail.com>
   PKGARCH:=all
endef

define Package/luci-app-radius-manager/description
Radius Server Management Tool
endef

define Package/luci-app-radius-manager/conffiles
/etc/config/radius_manager
endef

define Package/luci-app-radius-manager/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/config/radius_manager $(1)/etc/config/radius_manager
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/radius_manager $(1)/etc/init.d/radius_manager
	# New JavaScript-based views
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./files/usr/share/luci/menu.d/luci-app-radius-manager.json $(1)/usr/share/luci/menu.d/luci-app-radius-manager.json
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/radius_manager
	$(INSTALL_DATA) ./files/www/luci-static/resources/view/radius_manager/main.js $(1)/www/luci-static/resources/view/radius_manager/main.js
endef

define Package/luci-app-radius-manager/postinst
#!/bin/sh	
[ ! -z "$${IPKG_INSTROOT}" ] && exit 0
# check if freeradius authorize file includes our $$INCLUDE already
FR3_CONFIG_DIR=/etc/freeradius3
check_include()
{
	local filename incname
	filename=$$1
	incname=$$2
	if [ ! -z $$(grep "\$$INCLUDE $$incname" $$filename) ]; then
		echo "\$$INCLUDE $$incname" >> $$filename
	fi
}
check_include $$FR3_CONFIG_DIR/mods-config/files/authorize $$FR3_CONFIG_DIR/authorize.extra
check_include $$FR3_CONFIG_DIR/clients.conf $$FR3_CONFIG_DIR/clients.extra
endef

define Build/Compile
endef

$(eval $(call BuildPackage,luci-app-radius-manager))


