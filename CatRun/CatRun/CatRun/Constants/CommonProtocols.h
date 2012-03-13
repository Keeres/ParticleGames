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


