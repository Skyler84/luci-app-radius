define GetApkBuildDir
${shell pwd}/build/apk/$(1)
endef

define GetApkRootDir
$(call GetApkBuildDir,$(1))/root
endef

define GetApkScriptDir
$(call GetApkBuildDir,$(1))/scripts
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


define BuildPackageApk
$(eval $(call Package/$(1)))

PKGFILE:=$(call convert_to_shell_name,Package_$(1)_ControlFile)
define $(PKGFILE)_POSTINST
$(if Package/$(1)/postinst,$$(call Package/$(1)/postinst),$$(call Package/default/postinst))
endef
define $(PKGFILE)_PRERM
$(if Package/$(1)/prerm,$$(call Package/$(1)/prerm),$$(call Package/default/prerm))
endef
$$(PKGFILE)_TMP := $$(shell echo /tmp/$(1))
export $(PKGFILE)_POSTINST
export $(PKGFILE)_PRERM
export $(PKGFILE)_TMP

$$(PKGFILE)_APK := $(1).apk

package/$(1)/install-files:
	@echo "Installing package files"
	@mkdir -p $(call GetApkRootDir,$(1))

	$(call Package/$(1)/install,$(call GetApkRootDir,$(1)))

$(call GetApkRootDir,$(1))/lib/apk/packages/$(1).list: package/$(1)/install-files
	rm -f $$@
	mkdir -p $${@D}
	find $(call GetApkRootDir,$(1)) -type f | sed 's#$$@##g' | sed 's#$(call GetApkRootDir,$(1))/#/#g' > $$@

package/$(1)/scripts:
	@echo "Generating package scripts"
	@mkdir -p $(call GetApkScriptDir,$(1))

	echo $$$$$$(PKGFILE)_TMP
	echo "$$$$$$(PKGFILE)_POSTINST" > $$$$$$(PKGFILE)_TMP
	install -m 755 $$$$$$(PKGFILE)_TMP $(call GetApkScriptDir,$(1))/postinst
	echo "$$$$$$(PKGFILE)_PRERM" > $$$$$$(PKGFILE)_TMP
	install -m 755 $$$$$$(PKGFILE)_TMP $(call GetApkScriptDir,$(1))/prerm
	rm -f $$$$$$(PKGFILE)_TMP

all:: package/$(1)/compile
package/$(1)/compile:: $${$$(PKGFILE)_APK}

$${$$(PKGFILE)_APK}: package/$(1)/install-files $(call GetApkRootDir,$(1))/lib/apk/packages/$(1).list
	@echo "Building package: luci-app-radius"
	${APK} mkpkg -I name:$(1) -I version:${PKG_VERSION}.${PKG_RELEASE} -I arch:noarch -F $(call GetApkRootDir,$(1)) -o $(1).apk

clean:: package/$(1)/clean
package/$(1)/clean::
	@echo $(1) Cleaning
	@rm -rf $(call GetApkBuildDir,$1) $(1).ipk
	@mkdir -p $(call GetApkBuildDir,$1)
	@mkdir -p $(call GetApkRootDir,$1)
endef
