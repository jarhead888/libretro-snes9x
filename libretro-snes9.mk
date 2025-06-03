################################################################################
#
# LIBRETRO_SNES9X
#
################################################################################
LIBRETRO_SNES9X_DEPENDENCIES = retroarch
LIBRETRO_SNES9X_DIR=$(BUILD_DIR)/libretro-snes9x

$(LIBRETRO_SNES9X_DIR)/.source:
	mkdir -pv $(LIBRETRO_SNES9X_DIR)
	cp -raf package/libretro-snes9x/src/* $(LIBRETRO_SNES9X_DIR)
	touch $@

$(LIBRETRO_SNES9X_DIR)/.configured : $(LIBRETRO_SNES9X_DIR)/.source
	touch $@

libretro-snes9x-binary: $(LIBRETRO_SNES9X_DIR)/.configured $(LIBRETRO_SNES9X_DEPENDENCIES)
	BASE_DIR="$(BASE_DIR)" CFLAGS="$(TARGET_CFLAGS) -I${STAGING_DIR}/usr/include/ -I$(LIBRETRO_SNES9X_DIR)/" CXXFLAGS="$(TARGET_CXXFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" $(MAKE) -C $(LIBRETRO_SNES9X_DIR)/libretro/ -f Makefile platform="unix-armv-rpi3"

libretro-snes9x: libretro-snes9x-binary
	mkdir -p $(TARGET_DIR)/usr/lib/libretro
	cp -raf $(LIBRETRO_SNES9X_DIR)/libretro/snes9x_libretro.so $(TARGET_DIR)/usr/lib/libretro/
	$(TARGET_STRIP) $(TARGET_DIR)/usr/lib/libretro/snes9x_libretro.so

ifeq ($(BR2_PACKAGE_LIBRETRO_SNES9X), y)
TARGETS += libretro-snes9x
endif
