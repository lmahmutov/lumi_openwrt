include $(TOPDIR)/rules.mk

PKG_NAME:=lumi-rtl8189es
PKG_RELEASE=2

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=

PKG_MAINTAINER:=Alexey Sadkov <alx.v.sadkov@gmail.com>
PKG_BUILD_PARALLEL:=1

STAMP_CONFIGURED_DEPENDS := $(STAGING_DIR)/usr/include/mac80211-backport/backport/autoconf.h

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/lumi-rtl8189es
  SUBMENU:=Lumi
  TITLE:=Wireless Drivers for Xiaomi Lumi Gw Realtek rtl8189es and ...
  DEPENDS:=+kmod-cfg80211 +@DRIVER_11N_SUPPORT
  FILES:=\
	$(PKG_BUILD_DIR)/rtl8189es.ko
  AUTOLOAD:=$(call AutoProbe,rtl8189es)
  PROVIDES:=kmod-rtl8189es
endef

NOSTDINC_FLAGS = \
	-I$(PKG_BUILD_DIR) \
	-I$(PKG_BUILD_DIR)/include \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-include backport/backport.h

NOSTDINC_FLAGS+=-DCONFIG_IOCTL_CFG80211 -DRTW_USE_CFG80211_STA_EVENT -DBUILD_OPENWRT

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
		modules
endef

$(eval $(call KernelPackage,lumi-rtl8189es))
