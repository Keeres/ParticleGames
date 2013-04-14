//
//  CCMenuAdvancedPlus.h
//  GeoQuest
//
//  Created by Kelvin on 10/24/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMenuAdvanced.h"
#import "ChallengerMenuItemSprite.h"

@interface CCMenuAdvancedPlus : CCMenuAdvanced {
    CGPoint     originalPos;
    CGPoint     startTouchPos;
    BOOL        bounceEffectLeft;
    BOOL        bounceEffectRight;
    BOOL        bounceEffectUp;
    BOOL        bounceEffectDown;
    BOOL        isRefreshed;
    BOOL        touchedItem;
    BOOL        disableScroll;
    
    int         extraTouchPriority;
    float       bounceDistance;
    
    ChallengerMenuItemSprite *challenger;
}

@property (assign) CGPoint originalPos;
@property (assign) BOOL bounceEffectLeft;
@property (assign) BOOL bounceEffectRight;
@property (assign) BOOL bounceEffectUp;
@property (assign) BOOL bounceEffectDown;
@property (assign) BOOL isRefreshed;
@property (assign) BOOL disableScroll;
@property (readwrite) int extraTouchPriority;
@property (assign) float bounceDistance;

-(void) fixPosition;

@end
