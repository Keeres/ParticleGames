//
//  GameState.h
//  PaintRunner
//
//  Created by Wayne on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GameState : NSObject <NSCoding> {
    //Game Achievements
    BOOL completedAchievement_Jumper;
    
    //Game Statistics
    int timesJumped;
    double highScore;
    
    //Game States
    int currentSkin;
    int currentActivePerk;
    int currentPassivePerk;
    int activeDoubleJump;   //active - 1
    int activeGlide;        //active - 2
    int activeFly;          //active - 3
    int passiveCoin;        //passive - 1
    int passiveMagnet;      //passive - 2
    int passiveSmash;       //passive - 3
    int passiveZoomOut;     //passive - 4
    
}

+ (GameState *) sharedInstance;
- (void)save;

//Game Achievements
@property (assign) BOOL completedAchievement_Jumper;

//Game Statistics
@property (assign) double highScore;

//Game States
@property (readwrite) int currentSkin;
@property (readwrite) int currentActivePerk;
@property (readwrite) int currentPassivePerk;
@property (readwrite) int activeDoubleJump;
@property (readwrite) int activeGlide;
@property (readwrite) int activeFly;
@property (readwrite) int passiveCoin;
@property (readwrite) int passiveMagnet;
@property (readwrite) int passiveSmash;
@property (readwrite) int passiveZoomOut;


@end