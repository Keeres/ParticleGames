//  CommonProtocols.h

typedef enum {
    kStateNone,
    kStateIdle,
    kStateSpawning,
    kStateRunning,
    kStateJumping,
    kStateIsHit,
    kStateDead,
} CharacterStates;

typedef enum {
    kPlayerType,
    kPaintChipType,
    kPlatformType,
    kSidePlatformType,
    kCloudType,
    kTreeType,
    kGameObjectMaxType,
} GameObjectType;

typedef enum {
    kGroundPlatform,
    kSidePlatform,
    kMaxPlatform,
} PlatformType;

typedef enum {
    kMainMenuType,
    kCharacterMenuType,
    kCustomizeMenuType,
    kPerkMenuType,
} MenuType;

typedef enum{
    kAlignRowFirst,
    kAlignColFirst
}AlignStyle;

typedef enum {
    kDefaultSkin,
    kRedSkin,
    kBlueSkin,
    kGreenSkin,
    kPinkSkin,
    kPurpleSkin,
    kRainbowSkin = 7,
}kSkinType;
