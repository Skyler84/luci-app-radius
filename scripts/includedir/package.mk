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
package/$(1)/compile:
	@echo "Building package: luci-app-radius"
	mkdir -p $(call GetControlDir,$(1))
	mkdir -p $(call GetRootDir,$(1))


	$$(file >$(call GetControlDir,$(1))/control,$$(call PackageControlFile,$(1)))
	$$(file >$(call GetControlDir,$(1))/conffiles,$$(call Package/$(1)/conffiles))
	$$(file >$(call GetControlDir,$(1))/postinst,$$(call Package/default/postinst))
	$$(file >$(call GetControlDir,$(1))/prerm,$$(call Package/default/prerm))


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
