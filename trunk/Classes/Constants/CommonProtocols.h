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

typedef enum{
    kNormalType,
    kVolcanoType,
 //   kSnowEffects,
 //   kLightningEffects,
    kBonusType,
    kMaxStageEffectType,
}StageEffectType;

#pragma mark -
#pragma mark volcano constants
typedef enum {
    kVolcanoDormant,
    kVolcanoSmoke,
    kVolcanoLava,
    kVolcanoErupt,
}BackgroundState;


