# Inherit some common Lineage stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Device
$(call inherit-product, device/motorola/lake/device.mk)

# Device identifiers
BUILD_FINGERPRINT := motorola/lake_retail/lake:10/QPWS30.61-21-18-7-12/b1002:user/release-keys
PRODUCT_BRAND := motorola
PRODUCT_DEVICE := lake
PRODUCT_MANUFACTURER := motorola
PRODUCT_MODEL := moto g(7) plus
PRODUCT_NAME := lineage_lake

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=lake \
    PRIVATE_BUILD_DESC="lake-user 10 QPWS30.61-21-18-7-12 b1002 release-keys"
