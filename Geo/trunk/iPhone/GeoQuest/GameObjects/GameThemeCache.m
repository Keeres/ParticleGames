//
//  GameThemeCache.m
//  GeoQuest
//
//  Created by Kelvin on 11/22/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "GameThemeCache.h"
#import "Constants.h"


@implementation GameThemeCache

@synthesize theme;

-(void) createThemeCache {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    theme = [[NSMutableArray alloc] init];
    
    if (gameThemeSelected == kNoTheme) {
        switch (difficultySelected) {
            case kEasyDifficulty:
                for (int i = 0; i < 4; i++) {
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            case kNormalDifficulty:
                for (int i = 0; i < 4; i++) {
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            case kExtremeDifficuly:
                for (int i = 0; i < 4; i++) {
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            default:
                break;
        }
    } else {
        
    }
    
    /*if (gameThemeSelected == kMetalTheme) {
        switch (difficultySelected) {
            case kEasyDifficulty:
                for (int i = 0; i < 4; i++) {
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            case kNormalDifficulty:
                for (int i = 0; i < 4; i++) {
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            case kExtremeDifficuly:
                for (int i = 0; i < 4; i++) {
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            default:
                break;
        }
    } else {
        
    }*/
}



-(id) initWithDifficulty:(int)diff andThemeName:(int)themeName {
    if ((self = [super init])) {
        difficultySelected = diff;
        gameThemeSelected = themeName;
        
        [self createThemeCache];
        
    }
    
    return self;
}

-(void) dealloc {
    [super dealloc];
}

@end
