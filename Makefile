include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-radius-manager
PKG_VERSION:=0.1
PKG_RELEASE:=1-11
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
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/controller/radius_manager.lua $(1)/usr/lib/lua/luci/controller/radius_manager.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/radius_manager
	$(INSTALL_DATA) ./files/cbi/clients.lua $(1)/usr/lib/lua/luci/model/cbi/radius_manager/clients.lua
	$(INSTALL_DATA) ./files/cbi/users.lua $(1)/usr/lib/lua/luci/model/cbi/radius_manager/users.lua
	$(INSTALL_DATA) ./files/cbi/realms.lua $(1)/usr/lib/lua/luci/model/cbi/radius_manager/realms.lua
	$(INSTALL_DATA) ./files/cbi/servers.lua $(1)/usr/lib/lua/luci/model/cbi/radius_manager/servers.lua
	$(INSTALL_DATA) ./files/cbi/settings.lua $(1)/usr/lib/lua/luci/model/cbi/radius_manager/settings.lua
endef

define Package/luci-app-radius-manager/postinst
#!/bin/sh	
[ ! -z "$${IPKG_INSTROOT}" ] && exit 0
# check if freeradius authorize file includes our $$INCLUDE already

endef

define Build/Compile
endef

$(eval $(call BuildPackage,luci-app-radius-manager))


