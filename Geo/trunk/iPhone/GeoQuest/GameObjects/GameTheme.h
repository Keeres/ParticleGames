//
//  GameTheme.h
//  GeoQuest
//
//  Created by Kelvin on 11/24/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameTheme : CCSprite {
    CCSprite    *edgeSprite;
    
    NSString    *themeName;
    
    int         theme;
    
    CGRect      boundaryRect;
    
}

@property CGRect boundaryRect;

-(id) initWithTheme:(int)t;

@end
