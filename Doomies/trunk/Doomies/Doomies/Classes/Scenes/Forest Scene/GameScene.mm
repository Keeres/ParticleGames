//
//  GameScene.m
//  mushroom
//
//  Created by Kelvin on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (void) selectStage:(CCMenuItemFont*)itemPassedIn {
    if ([itemPassedIn tag] == 1) {
        initialStageType = kNormalType;
    }else if ([itemPassedIn tag] == 2) {
        initialStageType = kVolcanoType;
    }else if ([itemPassedIn tag] == 3) {
     //   CCLOG(@"snow selected");
        initialStageType = kSnowType;
        //    }else if ([itemPassedIn tag] == 4) {
        //     initialStageType = kStormType;
    }else if ([itemPassedIn tag] == 5) {
        initialStageType = kRandomType;
    }else {
        CCLOG(@"Unexpected item. Tag was: %d", [itemPassedIn tag]);
    }
    [tempMainMenu setIsTouchEnabled:FALSE];
    uiLayer = [GameUILayer node];
    [self addChild:uiLayer z:2];
    
    backgroundLayer = [[[GameBackgroundLayer alloc] initWithInitialStageType:initialStageType] autorelease];
     [self addChild:backgroundLayer z:0];
     
     GameActionLayer *actionLayer = [[[GameActionLayer alloc] initWithGameUILayer:uiLayer andBackgroundLayer:backgroundLayer] autorelease];
     [self addChild:actionLayer z:1];
    
}

- (void) stageSelectionMenu{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    
    CCLabelTTF *normalStageSelection = [CCLabelTTF labelWithString:@"Forest Stage" fontName:@"marker felt" fontSize:24];
    CCMenuItemLabel *normalButton = [CCMenuItemLabel itemWithLabel:normalStageSelection target:self selector:@selector(selectStage:)]; 
    [normalButton setTag:1];
    
    CCLabelTTF *volcanoStageSelection = [CCLabelTTF labelWithString:@"Volcano Stage" fontName:@"marker felt" fontSize:24];
    CCMenuItemLabel *volcanoButton = [CCMenuItemLabel itemWithLabel:volcanoStageSelection target:self selector:@selector(selectStage:)]; 
    [volcanoButton setTag:2];
    
    CCLabelTTF *snowStageSelection = [CCLabelTTF labelWithString:@"Snow Stage" fontName:@"marker felt" fontSize:24];
    CCMenuItemLabel *snowButton = [CCMenuItemLabel itemWithLabel:snowStageSelection target:self selector:@selector(selectStage:)]; 
    [snowButton setTag:3];
    
    CCLabelTTF *stormStageSelection = [CCLabelTTF labelWithString:@"Storm Stage" fontName:@"marker felt" fontSize:24];
   // [stormStageSelection setPosition:ccp(screenSize
    CCMenuItemLabel *stormButton = [CCMenuItemLabel itemWithLabel:stormStageSelection target:self selector:@selector(selectStage:)]; 
    [stormButton setTag:4];
    
    CCLabelTTF *randomStageSelection = [CCLabelTTF labelWithString:@"Random Stage" fontName:@"marker felt" fontSize:24];
    CCMenuItemLabel *randomButton = [CCMenuItemLabel itemWithLabel:randomStageSelection target:self selector:@selector(selectStage:)]; 
    [randomButton setTag:5];
    
    tempMainMenu = [CCMenu menuWithItems: normalButton,volcanoButton, snowButton, stormButton, randomButton, nil];
    [tempMainMenu alignItemsVerticallyWithPadding: 2]; 
    [tempMainMenu setPosition:ccp(screenSize.width/2, screenSize.height/1.5)];
   // [self addChild:stormStageSelection];
    [self addChild:tempMainMenu z:-1];
}

/*
- (void) resetToMenuSelectionScreen:(id) sender{
    CCLOG(@"button pressed");
   // [self removeChild:uiLayer cleanup:YES];
    [self removeChild:backgroundLayer cleanup:YES];
    
}*/

-(id) init {
    if ((self = [super init])) {
        
       /* CCLabelTTF *mainMenuSelection = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"marker felt" fontSize:24];
       // CCMenuItemLabel *mainMenuButton = [CCMenuItemLabel itemWithLabel:mainMenuSelection target:self selector:@selector(selectStage:)]; 
        CCMenuItemLabel *mainMenuButton = [CCMenuItemLabel itemWithLabel:mainMenuSelection target:self selector:@selector(resetToMenuSelectionScreen:)]; 
        CCMenu *menuButton = [CCMenu menuWithItems:mainMenuButton, nil];
        [menuButton setPosition:ccp(70, 10)];
        [self addChild:menuButton];*/
        
        
        [self stageSelectionMenu];
        
        
        
       // uiLayer = [GameUILayer node];
        //[self addChild:uiLayer z:2];
        
        //GameBackgroundLayer *backgroundLayer = [[[GameBackgroundLayer alloc] init] autorelease];
        
        /*
        backgroundLayer = [GameBackgroundLayer node];
        [self addChild:backgroundLayer z:0];

        GameActionLayer *actionLayer = [[[GameActionLayer alloc] initWithGameUILayer:uiLayer andBackgroundLayer:backgroundLayer] autorelease];
        [self addChild:actionLayer z:1];
        */
        
    }
    return self;
}

@end
