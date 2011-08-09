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
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kMushroomType,
    kGroundType    
} GameObjectType;

typedef enum {
    kColorMushroomType,
    kMaxMushroomType,
} MushroomType;

typedef enum {
    kTurtleType,
    kBeeType,
    kJumperType,
    kMaxEnemyType,
} EnemyType;

typedef enum {
    kGroundPlatform,
    kSidePlatform,
    kMaxPlatform,
} PlatformType;
