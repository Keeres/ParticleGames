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
    BOOL        bounceEffect;
    BOOL        isRefreshed;
    
    int         extraTouchPriority;
}

@property CGPoint originalPos;
@property BOOL bounceEffect;
@property BOOL isRefreshed;
@property (readwrite) int extraTouchPriority;

-(void) fixPosition;

@end
