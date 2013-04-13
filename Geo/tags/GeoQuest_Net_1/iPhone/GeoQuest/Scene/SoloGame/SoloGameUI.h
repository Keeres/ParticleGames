//
//  SoloGameUI.h
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoloGameBG.h"
#import "SoloGameTerritory.h"
#import "SoloGameGameOver.h"
#import "SoloGameReplay.h"
#import "GeoQuestDB.h"
#import "PlayerDB.h"
#import "GeoQuestQuestion.h"
#import "GeoQuestAnswer.h"
#import "CCMenuAdvanced.h"
#import "CCMenu+Layout.h"
#import "CCRenderTexturePlus.h"
#import "GameTheme.h"
#import "GameThemeCache.h"
#import "RaceData.h"
#import "PlayerDB.h"

#define SOLO_GRID_SPACING 5 //points between menu items
#define SOLO_GAME_TIMER 60 
#define SOLO_GAME_QUICKDRAW_TIMER 1.5
#define SOLO_GAME_SCORE_TO_WIN 200

@class SoloGameReplay;
@class SoloGameGameOver;
@class SoloGameTerritory;
@class SoloGameBG;

@interface SoloGameUI : CCLayer {
    CGSize              winSize;
    
    //Layers
    SoloGameTerritory   *soloGameTerritory;
    SoloGameReplay      *soloGameReplay;
    SoloGameGameOver    *soloGameGameOver;
    SoloGameBG          *soloGameBG;

    GeoQuestQuestion    *currentQuestion;
    //GameThemeCache      *theme;
    //NSArray             *themeArray;

    NSMutableArray      *questionArray;
    NSMutableArray      *questionLayerTotal;
    NSMutableArray      *questionLayerVisible;
    NSMutableArray      *answerArray;
    NSMutableArray      *currentAnswerChoices;
    //NSMutableArray      *themeTotal;
    //NSMutableArray      *themeVisible;
    NSMutableArray      *territoriesChosen; //array of all the territories usable by player
    NSMutableArray      *playerRaceDataArray; //array to store raceData objects
    NSMutableArray      *challengerRaceDataArray; //array to store CHALLENGERNEXTRACEDATA to move challengerVehicle
    
    CCSprite            *question;
    CCSprite            *correctMark;
    CCSprite            *wrongMark;
    CCSprite            *playerVehicle;
    CCSprite            *challengerVehicle;
    CCSprite            *soloGameTheme;
    CCMenuAdvanced      *answerChoicesMenu;
    CCLabelTTF          *prepTimerLabel;
    CCLabelTTF          *gameTimerLabel;
    CCLabelTTF          *questionTimerLabel;
    CCLabelTTF          *scoreLabel;
    CCLabelTTF          *pointsEarnedLabel;
    CCLabelTTF          *quickDrawLabel;
    CCLabelTTF          *inRowLabel;
    CCLabelTTF          *inRowQuickDrawLabel;
    
    //CCParticleSystemQuad *freezeTimePowerUpParticle;
    //CCParticleSystemQuad *doublePointsPowerUpParticle;
    //CCParticleSystemQuad *fiftyFiftyPowerUpParticle;
    //CCParticleSystemQuad *specialStagePowerUpParticle;

    BOOL                questionAnswered;
    BOOL                questionChecked;
    BOOL                previousAnswerCorrect;
    BOOL                previousAnswerQuickDrawCorrect;
    BOOL                freezeTimePowerUpActivated;
    BOOL                doublePointsPowerUpActivated;
    BOOL                fiftyFiftyPowerUpActivated;
    BOOL                specialStagePowerUpActivated;
    BOOL                touchedRenderTexture;
    float               prepTimer;
    float               gameTimer;
    float               questionTimer;
    float               quickDrawTimer;
    float               freezeTimePowerUpTimer;
    float               doublePointsPowerUpTimer;
    float               fiftyFiftyPowerUpTimer;
    float               specialStagePowerUpTimer;
    float               pointsEarned;
    float               score;
    float               startingPoint;
    float               finishingPoint;
    int                 questionsAsked;
    int                 questionsAnsweredCorrectly;
    int                 powerUpPercentageRequirement;
    int                 answerCorrectlyInRow;
    int                 answerQuickDrawCorrectlyInRow;
    int                 answerIncorrectlyInRow;
    int                 answerChoicesVisibleCount;
    

    
}

@property (nonatomic, retain) CCSprite *playerVehicle;
@property (nonatomic, retain) CCSprite *challengerVehicle;
@property (readonly) float startingPoint;
@property (readonly) float finishingPoint;

-(void) setSoloGameBGLayer:(SoloGameBG*)soloBG;
-(void) setSoloGameTerritoryLayer:(SoloGameTerritory*)soloTerritory;
-(void) setSoloGameGameOverLayer:(SoloGameGameOver*)soloGameOver;
-(void) setSoloReplayLayer:(SoloGameReplay*)soloReplay;
-(void) setupGame;
-(void) setTerritoriesChosen:(NSMutableArray*)tChosen;
-(SoloGameReplay*) getSoloGameReplay;
-(void) showTerritoryLayer;

@end
