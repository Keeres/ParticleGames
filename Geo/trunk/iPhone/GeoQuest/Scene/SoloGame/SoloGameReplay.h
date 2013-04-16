//
//  SoloGameReplay.h
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "cocos2d.h"
#import "SoloGameUI.h"
#import "CCMenuAdvanced.h"
#import "CCRenderTexturePlus.h"

#define Z_ORDER_TOP 100
#define Z_ORDER_MIDDLE 50
#define Z_ORDER_BACK 10

@class SoloGameUI;

@interface SoloGameReplay : CCLayer {
    CGSize              winSize;
    
    //CCSpriteBatchNode   *usaStatesSheet;
    //CCSpriteBatchNode   *usaCapitalsSheet;
    
    // Layers
    SoloGameUI          *soloGameUI;
    
    // Arrays
    NSMutableArray      *playerRaceDataArray; //array to store raceData objects
    NSMutableArray      *playerReverseRaceDataArray;
    NSMutableArray      *challengerRaceDataArray;
    NSMutableArray      *challengerReverseRaceDataArray;
    
    // CCNodes
    CCRenderTexturePlus *renderTexture;
    CCSprite            *playerVehicle;
    CCSprite            *challengerVehicle;
    CCSprite            *theme;
    CCLabelTTF          *playerName;
    CCLabelTTF          *challengerName;
    CCLabelTTF          *playerScore;
    CCLabelTTF          *challengerScore;
    CCParticleSystemQuad *moveVehicle1Particle;
    CCParticleSystemQuad *moveVehicle2Particle;
    
    //CCMenu
    CCMenuAdvanced      *nextMenu;

    
    // Variables
    CGPoint             currentPoint;
    CGPoint             previousPoint;
    CGPoint             renderTextureOrigPos;
    float               raceStartHeight;
    float               raceLineWidth;
    float               startingPoint;
    float               finishingPoint;
}

-(id) initWithSoloGameUILayer:(SoloGameUI*)soloUI;
//-(void) setRaceData:(NSMutableArray*)r;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;
-(void) loadReplayLayer;

@end
