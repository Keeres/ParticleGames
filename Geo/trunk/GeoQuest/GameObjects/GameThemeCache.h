//
//  GameThemeCache.h
//  GeoQuest
//
//  Created by Kelvin on 11/22/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameTheme.h"

@interface GameThemeCache : CCNode {
    int         difficultySelected;
    int         gameThemeSelected;
    
    //NSString            *themeName;
    
    NSMutableArray      *theme;
    NSMutableArray      *themeEdges;
}

-(id) initWithDifficulty:(int)diff andThemeName:(int)themeName;

@property (nonatomic, retain) NSMutableArray *theme;
@property (nonatomic, retain) NSMutableArray *themeEdges;

@end
