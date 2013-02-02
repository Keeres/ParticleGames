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
@synthesize themeEdges;

/*-(void) createThemeCache {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    theme = [[NSMutableArray alloc] init];
    themeEdges = [[NSMutableArray alloc] init];
    
    switch (difficultySelected) {
        case kEasyDifficulty:
            break;
            
        case kNormalDifficulty:
            for (int i = 0; i < 4; i++) {
                CCSprite *m = [CCSprite spriteWithSpriteFrameName:@"TrainMid.png"];
                m.position = ccp(winSize.width/2, winSize.height/2);
                
                if (i % 2) {
                    CCSprite *a = [CCSprite spriteWithSpriteFrameName:@"TrainA.png"];
                    a.position = ccp(-a.contentSize.width/2, m.contentSize.height/2);
                    //a.visible = NO;
                    [m addChild:a];
                } else {
                    CCSprite *b = [CCSprite spriteWithSpriteFrameName:@"TrainB.png"];
                    b.position = ccp(-b.contentSize.width/2, m.contentSize.height/2);
                    //b.visible = NO;
                    [m addChild:b];
                }

                m.visible = NO;
                [theme addObject:m];
            }
            break;
            
        case kExtremeDifficuly:
            break;
            
        default:
            break;
    }
}*/

-(void) createThemeCache {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    theme = [[NSMutableArray alloc] init];
    themeEdges = [[NSMutableArray alloc] init];
    
    if (gameThemeSelected == kMetalTheme) {
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
        
        switch (difficultySelected) {
            case kEasyDifficulty:
                for (int i = 0; i < 4; i++) {
                    //int edgeNum = i % 2;
                    int edgeNum = 0;
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected andEdge:edgeNum] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            case kNormalDifficulty:
                for (int i = 0; i < 4; i++) {
                    //int edgeNum = i % 2;
                    int edgeNum = 0;
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected andEdge:edgeNum] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            case kExtremeDifficuly:
                for (int i = 0; i < 4; i++) {
                    //int edgeNum = i % 2;
                    int edgeNum = 0;
                    GameTheme *gt = [[[GameTheme alloc] initWithTheme:gameThemeSelected andEdge:edgeNum] autorelease];
                    gt.position = ccp(winSize.width/2, winSize.height/2);
                    gt.visible = NO;
                    [theme addObject:gt];
                }
                break;
                
            default:
                break;
        }
    }
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
