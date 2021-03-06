//
//  AsyncGameUI.h
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AsyncGameBG.h"
#import "AsyncGameTerritory.h"
#import "AsyncGameGameOver.h"
#import "AsyncGameReplay.h"
#import "GeoQuestDB.h"
#import "PlayerDB.h"
//#import "GeoQuestQuestion.h"
#import "Question.h"
#import "GeoQuestAnswer.h"
#import "CCMenuAdvancedPlus.h"
#import "CCMenu+Layout.h"
#import "CCRenderTexturePlus.h"
#import "GameTheme.h"
#import "GameThemeCache.h"
#import "RaceData.h"

#define ASYNC_GRID_SPACING 20 //points between menu items
#define ASYNC_GAME_TIMER 60 
#define ASYNC_GAME_QUICKDRAW_TIMER 1.5
#define ASYNC_GAME_SCORE_TO_WIN 100
#define Z_ORDER_TOP 100
#define Z_ORDER_MIDDLE 50
#define Z_ORDER_BACK 10

@class AsyncGameReplay;
@class AsyncGameGameOver;
@class AsyncGameTerritory;
@class AsyncGameBG;

@interface AsyncGameUI : CCLayer {
    CGSize              winSize;
    
    //CCSpriteBatchNode   *usaStatesSheet;
    //CCSpriteBatchNode   *usaCapitalsSheet;
    //CCSpriteBatchNode   *questionThemesSheet;
    
    //Layers
    AsyncGameTerritory   *asyncGameTerritory;
    AsyncGameReplay      *asyncGameReplay;
    AsyncGameGameOver    *asyncGameGameOver;
    AsyncGameBG          *asyncGameBG;

    Question            *currentQuestion;
    GameThemeCache      *theme;
    NSArray             *themeArray;

    NSMutableArray      *questionArray;
    NSMutableArray      *answerArray;
    NSMutableArray      *currentAnswerChoices;
    NSMutableArray      *themeTotal;
    NSMutableArray      *themeVisible;
    NSMutableArray      *territoriesChosen; //array of all the territories usable by player
    NSMutableArray      *playerRaceDataArray; //array to store raceData objects
    NSMutableArray      *challengerRaceDataArray; //array to store CHALLENGERNEXTRACEDATA to move challengerVehicle
    
    CCSprite            *clock;
    CCSprite            *question;
    CCSprite            *correctMark;
    CCSprite            *wrongMark;
    CCSprite            *playerVehicle;
    CCSprite            *challengerVehicle;
    CCSprite            *asyncGameTheme;
    CCMenuAdvancedPlus  *answerChoicesMenu;
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
    CCParticleSystemQuad *moveVehicle1Particle;
    CCParticleSystemQuad *moveVehicle2Particle;


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

-(void) setAsyncGameBGLayer:(AsyncGameBG*)asyncBG;
-(void) setAsyncGameTerritoryLayer:(AsyncGameTerritory*)asyncTerritory;
-(void) setAsyncGameGameOverLayer:(AsyncGameGameOver*)asyncGameOver;
-(void) setAsyncReplayLayer:(AsyncGameReplay*)asyncReplay;
-(void) setupGame;
-(void) setTerritoriesChosen:(NSMutableArray*)tChosen;
-(AsyncGameReplay*) getAsyncGameReplay;
-(void) showTerritoryLayer;

@end
