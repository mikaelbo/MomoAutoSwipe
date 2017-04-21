include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MomoAutoSwipe
ADDITIONAL_OBJCFLAGS = -fobjc-arc
MomoAutoSwipe_FILES = $(wildcard *.m *.mm *.x *.xm)

include $(THEOS_MAKE_PATH)/tweak.mk
