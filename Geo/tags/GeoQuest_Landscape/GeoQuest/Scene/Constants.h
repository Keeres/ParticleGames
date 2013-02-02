//
//  Constants.h
//  GeoQuest
//
//  Created by Kelvin on 10/5/12.
//  Copyright (c) 2012 Particle Games LLC. All rights reserved.
//

#ifndef GeoQuest_Constants_h
#define GeoQuest_Constants_h



#endif

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kSoloGameScene=100
} SceneTypes;

typedef enum {
    kLinkTypeCompanySite
} LinkTypes;

typedef enum {
    kEasyDifficulty,
    kNormalDifficulty,
    kExtremeDifficuly
} GameDifficulty;

typedef enum {
    kMetalTheme,
    kTrainTheme,
    kPlaneTheme,
    KTotalThemes
} GameThemeName;

typedef enum {
    kNullPowerUp,
    kFreezeTimePowerUp,
    kDoublePointsPowerUp,
    k5050PowerUp,
    kSpecialStagePowerUp,
    kTotalPowerUps
} GamePowerUp;

// Audio Items
#define AUDIO_MAX_WAITTIME 150

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;

// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]