//  CommonProtocols.h

typedef enum {
    kStateNone,
    kStateIdle,
    kStateSpawning,
    kStateWalking,
    kStateJumping,
    kStateLanding,
    kStateChange,
    kStateHitWall,
    kStateTakeHitByTurtle,
    kStateTakeHitByBee,
    kStateTakeHitByJumper,
    kStateCauseHit,
    kStateFlying,
    kStateRam,
    kStateDead,
    kStateEating,
    kStateCramping,
    kStateBurning,
    kStateRolling,
    kStateFrozen,
    kStateExplode,
} CharacterStates;

typedef enum {
    kPlayerType,
    kPaintChipType,
    kPlatformType,
    kCloudType,
    kGameObjectMaxType,
} GameObjectType;

typedef enum {
    kGroundPlatform,
    kSidePlatform,
    kMaxPlatform,
} PlatformType;


