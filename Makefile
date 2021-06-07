FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = SpringBoard

export ARCHS = arm64 arm64e
export TARGET = iphone:clang::14

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLibraryController

$(TWEAK_NAME)_FILES = $(TWEAK_NAME).xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += AppLibraryControllerSettings
SUBPROJECTS += ActivatorListenersForAppLibrary
include $(THEOS_MAKE_PATH)/aggregate.mk
