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

@interface CCMenuAdvancedPlus : CCMenuAdvanced {
    CGPoint     originalPos;
    BOOL        bounceEffectLeft;
    BOOL        bounceEffectRight;
    BOOL        bounceEffectUp;
    BOOL        bounceEffectDown;
    BOOL        isRefreshed;
    
    int         extraTouchPriority;
    float       bounceDistance;
}

@property (assign) CGPoint originalPos;
@property (assign) BOOL bounceEffectLeft;
@property (assign) BOOL bounceEffectRight;
@property (assign) BOOL bounceEffectUp;
@property (assign) BOOL bounceEffectDown;
@property (assign) BOOL isRefreshed;
@property (readwrite) int extraTouchPriority;
@property (assign) float bounceDistance;

-(void) fixPosition;

@end
