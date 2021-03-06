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
    kVolcanoType,
    kSnowType,
  //  kStormType,
    //kBonusType,
    kMaxStageEffectType,
    kNormalType,
    kRandomType,
}StageEffectType;

#pragma mark -
#pragma mark volcano constants
typedef enum {
    kNormal,
    kVolcanoDormant,
    kVolcanoSmoke,
    kVolcanoLava,
    kVolcanoErupt,
    kSnowFall,
}BackgroundState;


