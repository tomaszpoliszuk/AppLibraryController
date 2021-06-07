FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = SpringBoard

export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4

export PREFIX=/Volumes/Xcode_11.7/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/

SYSROOT =$(THEOS)/sdks/iPhoneOS14.4.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLibraryController

$(TWEAK_NAME)_FILES = $(TWEAK_NAME).xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += AppLibraryControllerSettings
SUBPROJECTS += ActivatorListenersForAppLibrary
include $(THEOS_MAKE_PATH)/aggregate.mk
