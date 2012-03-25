//
//  PerksMenuLayer.h
//  CatRun
//
//  Created by Steven Chen on 3/14/12.
//  Copyright 2012 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "CommonProtocols.h"
#import "LevelHelperLoader.h"
#import "SpriteHelperLoader.h"

@class MainMenuLayer;

@interface PerksMenuLayer : CCLayer {
    CGSize winSize;
    MainMenuLayer *mainMenuLayer;
    LevelHelperLoader *lHelper;
    SpriteHelperLoader *sHelper;
    
    CCMenu *backButtonMenu;
    CCMenu *perksMenu;
}

-(id) initWithpriteHelper:(SpriteHelperLoader*)sHelperLoader;
-(void) setMainMenuLayer:(MainMenuLayer*) mainLayer;

@end
