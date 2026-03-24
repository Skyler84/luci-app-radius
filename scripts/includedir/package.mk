include ${INCLUDE_DIR}/opkg.mk
include ${INCLUDE_DIR}/apk.mk

define BuildPackage
$(call BuildPackageOpkg,$(1))
$(call BuildPackageApk,$(1))
endef