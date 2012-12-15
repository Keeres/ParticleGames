//
//  SoloGameBG.h
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoloGameUI.h"

@class SoloGameUI;

@interface SoloGameBG : CCLayer {
    CGSize              winSize;
    
    SoloGameUI          *soloGameUI;
    
    CCSprite            *backPanel;
    
}

-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI;

@end
