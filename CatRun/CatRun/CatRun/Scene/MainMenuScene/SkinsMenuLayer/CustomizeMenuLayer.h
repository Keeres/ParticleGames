//
//  CustomizeMenuLayer .h
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
//#import "SkinsMenu.h"
#import "MyScrollLayer.h"

@class MainMenuLayer;

@interface CustomizeMenuLayer : CCLayer {
    CGSize winSize;
    MainMenuLayer *mainMenuLayer;
    LevelHelperLoader *lHelper;
    SpriteHelperLoader *sHelper;
  //  SkinsPurchaseMenuLayer *skinsPurchaseMenuLayer;
    MyScrollLayer *skinsPurchaseMenuLayer;
    
    CCMenu *titleBarMenu;
    CCMenu *customizeMenu;
    CCMenu *skinsPurchaseMenu;
  //  SkinsMenu *skinsMenu;
    
    
}

-(id) initWithSpriteHelper:(SpriteHelperLoader *)sHelperLoader;
-(void) setMainMenuLayer:(MainMenuLayer*) mainLayer;

@end
