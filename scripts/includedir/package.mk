define GetBuildDir
build/$(1)
endef

define GetControlDir
$(call GetBuildDir,$(1))/control
endef

define GetRootDir
$(call GetBuildDir,$(1))/root
endef

define GetOuterDir
$(call GetBuildDir,$(1))/outer
endef

define Package/default/postinst
#!/bin/sh
[ "$${IPKG_NO_SCRIPT}" = "1" ] && exit 0
[ -s $${IPKG_INSTROOT}/lib/functions.sh ] || exit 0
. $${IPKG_INSTROOT}/lib/functions.sh
default_postinst $$0 $$@
endef

_EMPTY :=
_SPACE := $(_EMPTY) $(_EMPTY)
_COMMA := ,

define Package/default/prerm
#!/bin/sh
[ -s $${IPKG_INSTROOT}/lib/functions.sh ] || exit 0
. $${IPKG_INSTROOT}/lib/functions.sh
default_prerm $$0 $$@
endef

convert_to_shell_name = $$(shell echo "$(1)" | tr 'A-Z' 'a-z' | tr -c 'a-z' '_')

define PackageControlFile
Package: ${PKG_NAME}
Version: ${PKG_VERSION}-${PKG_RELEASE}
Depends: $(patsubst +%,%${_COMMA},${DEPENDS})
SourceName: ${PKG_NAME}
Section: ${SECTION}
Licence: ${PKG_LICENSE}
Architecture: ${PKGARCH}
Description: $(call Package/$(1)/description)
endef

define BuildPackage
$(eval $(call Package/$(1)))

PKGFILE:=$(call convert_to_shell_name,Package_$(1)_ControlFile)
define $$(PKGFILE)_CONTROL
$(call PackageControlFile,$(1))
endef
define $$(PKGFILE)_CONFFILES
$(call Package/$(1)/conffiles)
endef
define $$(PKGFILE)_POSTINST
$(call Package/default/postinst)
endef
define $$(PKGFILE)_PRERM
$(call Package/default/prerm)
endef
$$(PKGFILE)_TMP := $$(shell echo /tmp/$(1))
export $$(PKGFILE)_CONTROL
export $$(PKGFILE)_CONFFILES
export $$(PKGFILE)_POSTINST
export $$(PKGFILE)_PRERM
export $$(PKGFILE)_TMP

package/$(1)/compile:
	@echo "Building package: luci-app-radius"
	mkdir -p $(call GetControlDir,$(1))
	mkdir -p $(call GetRootDir,$(1))

	echo $$$$$$(PKGFILE)_TMP
	echo "$$$$$$(PKGFILE)_CONTROL" > $$$$$$(PKGFILE)_TMP
	install -m 644 $$$$$$(PKGFILE)_TMP $(call GetControlDir,$(1))/control
	echo "$$$$$$(PKGFILE)_CONFFILES" > $$$$$$(PKGFILE)_TMP
	install -m 644 $$$$$$(PKGFILE)_TMP $(call GetControlDir,$(1))/conffiles
	echo "$$$$$$(PKGFILE)_POSTINST" > $$$$$$(PKGFILE)_TMP
	install -m 755 $$$$$$(PKGFILE)_TMP $(call GetControlDir,$(1))/postinst
	echo "$$$$$$(PKGFILE)_PRERM" > $$$$$$(PKGFILE)_TMP
	install -m 755 $$$$$$(PKGFILE)_TMP $(call GetControlDir,$(1))/prerm
	rm -f $$$$$$(PKGFILE)_TMP


	@mkdir -p $(call GetRootDir,$(1))
	$(call Package/$(1)/install,$(call GetRootDir,$(1)))

	mkdir -p $(call GetOuterDir,$(1))
	$$(file >$(call GetOuterDir,$(1))/debian-binary,"2.0")
	tar -cvf $(call GetOuterDir,$(1))/control.tar -C $(call GetControlDir,$(1)) --owner=0 --group=0 control conffiles
	tar -uvf $(call GetOuterDir,$(1))/control.tar -C $(call GetControlDir,$(1)) --owner=0 --group=0 --mode=755 postinst prerm
	gzip -f $(call GetOuterDir,$(1))/control.tar > $(call GetOuterDir,$(1))/control.tar.gz
	tar -cvf $(call GetOuterDir,$(1))/data.tar  -C $(call GetRootDir,$(1)) --owner=0 --group=0 .
	gzip -f $(call GetOuterDir,$(1))/data.tar > $(call GetOuterDir,$(1))/data.tar.gz
	tar -czvf $(1).ipk -C $(call GetOuterDir,$(1)) --owner=0 --group=0 --mode=644 ./data.tar.gz ./control.tar.gz ./debian-binary

package/$(1)/clean:
	@echo $(1) Cleaning
	@rm -rf $(call GetBuildDir,$1) $(1).ipk
	@mkdir -p $(call GetBuildDir,$1)
	@mkdir -p $(call GetControlDir,$1)
	@mkdir -p $(call GetRootDir,$1)
	@mkdir -p $(call GetOuterDir,$1)
endef
