define GetOpkgBuildDir
${shell pwd}/build/opkg/$(1)
endef

define GetOpkgControlDir
$(call GetOpkgBuildDir,$(1))/control
endef

define GetOpkgRootDir
$(call GetOpkgBuildDir,$(1))/root
endef

define GetOpkgOuterDir
$(call GetOpkgBuildDir,$(1))/outer
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

convert_to_shell_name = $(shell echo "$(1)" | tr 'A-Z' 'a-z' | tr -c 'a-z' '_')

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

define BuildPackageOpkg
$(eval $(call Package/$(1)))

PKGFILE:=$(call convert_to_shell_name,Package_$(1)_ControlFile)
define $$(PKGFILE)_CONTROL
$(call PackageControlFile,$(1))
endef
define $$(PKGFILE)_CONFFILES
$$(call Package/$(1)/conffiles)
endef
define $$(PKGFILE)_POSTINST
$(if Package/$(1)/postinst,$$(call Package/$(1)/postinst),$$(call Package/default/postinst))
endef
define $$(PKGFILE)_PRERM
$(if Package/$(1)/prerm,$$(call Package/$(1)/prerm),$$(call Package/default/prerm))
endef
$(PKGFILE)_TMP := $$(shell echo /tmp/$(1))
export $$(PKGFILE)_CONTROL
export $$(PKGFILE)_CONFFILES
export $$(PKGFILE)_POSTINST
export $$(PKGFILE)_PRERM
export $$(PKGFILE)_TMP

$$(PKGFILE)_IPK := $(1).ipk

all:: package/$(1)/compile
package/$(1)/compile:: $${$$(PKGFILE)_IPK}

$${$$(PKGFILE)_IPK}:
	@echo "Building package: luci-app-radius"
	mkdir -p $(call GetOpkgControlDir,$(1))
	mkdir -p $(call GetOpkgRootDir,$(1))

	echo $$$$$$(PKGFILE)_TMP
	echo "$$$$$$(PKGFILE)_CONTROL" > $$$$$$(PKGFILE)_TMP
	install -m 644 $$$$$$(PKGFILE)_TMP $(call GetOpkgControlDir,$(1))/control
	echo "$$$$$$(PKGFILE)_CONFFILES" > $$$$$$(PKGFILE)_TMP
	install -m 644 $$$$$$(PKGFILE)_TMP $(call GetOpkgControlDir,$(1))/conffiles
	echo "$$$$$$(PKGFILE)_POSTINST" > $$$$$$(PKGFILE)_TMP
	install -m 755 $$$$$$(PKGFILE)_TMP $(call GetOpkgControlDir,$(1))/postinst
	echo "$$$$$$(PKGFILE)_PRERM" > $$$$$$(PKGFILE)_TMP
	install -m 755 $$$$$$(PKGFILE)_TMP $(call GetOpkgControlDir,$(1))/prerm
	rm -f $$$$$$(PKGFILE)_TMP


	@mkdir -p $(call GetOpkgRootDir,$(1))
	$(call Package/$(1)/install,$(call GetOpkgRootDir,$(1)))

	mkdir -p $(call GetOpkgOuterDir,$(1))
	$$(file >$(call GetOpkgOuterDir,$(1))/debian-binary,"2.0")
	tar -cvf $(call GetOpkgOuterDir,$(1))/control.tar -C $(call GetOpkgControlDir,$(1)) --owner=0 --group=0 control conffiles
	tar -uvf $(call GetOpkgOuterDir,$(1))/control.tar -C $(call GetOpkgControlDir,$(1)) --owner=0 --group=0 --mode=755 postinst prerm
	gzip -f $(call GetOpkgOuterDir,$(1))/control.tar > $(call GetOpkgOuterDir,$(1))/control.tar.gz
	cd $(call GetOpkgRootDir,$(1)) && tar -cvf $(call GetOpkgOuterDir,$(1))/data.tar --owner=0 --group=0 .
	cd $(call GetOpkgRootDir,$(1)) && tar -uvf $(call GetOpkgOuterDir,$(1))/data.tar --owner=0 --group=0 --mode=755 ./etc/init.d/*
	gzip -f $(call GetOpkgOuterDir,$(1))/data.tar > $(call GetOpkgOuterDir,$(1))/data.tar.gz
	tar -czvf $${$$(PKGFILE)_IPK} -C $(call GetOpkgOuterDir,$(1)) --owner=0 --group=0 --mode=644 ./data.tar.gz ./control.tar.gz ./debian-binary

clean:: package/$(1)/clean
package/$(1)/clean::
	@echo $(1) Cleaning
	@rm -rf $(call GetOpkgBuildDir,$1) $(1).ipk
	@mkdir -p $(call GetOpkgBuildDir,$1)
	@mkdir -p $(call GetOpkgControlDir,$1)
	@mkdir -p $(call GetOpkgRootDir,$1)
	@mkdir -p $(call GetOpkgOuterDir,$1)
endef
