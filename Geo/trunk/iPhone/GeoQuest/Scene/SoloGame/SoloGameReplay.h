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

@class SoloGameUI;

@interface SoloGameReplay : CCLayer {
    CGSize              winSize;
    
    // Layers
    SoloGameUI          *soloGameUI;
    
    // Arrays
    NSMutableArray      *raceDataArray; //array to store raceData objects
    NSMutableArray      *reverseRaceDataArray;
    
    // CCNodes
    CCRenderTexturePlus *renderTexture;

    
    // Variables
    CGPoint             currentPoint;
    CGPoint             previousPoint;
    CGPoint             renderTextureOrigPos;
    float               raceStartHeight;
    float               raceLineWidth;
}

-(id) initWithSoloGameUILayer:(SoloGameUI*)soloUI;
-(void) setRaceData:(NSMutableArray*)r;
-(void) showLayerAndObjects;
-(void) hideLayerAndObjects;

@end
