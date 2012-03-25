//
//  MainMenuScene.h
//  PaintRunner
//
//  Created by Kelvin Chan on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "CharacterMenuLayer.h"
#import "CustomizeMenuLayer.h"
#import "PerksMenuLayer.h"
#import "SpriteHelperLoader.h"

@interface MainMenuScene : CCScene {
    SpriteHelperLoader *sHelper;
    
    MainMenuLayer *mainMenuLayer;
    CharacterMenuLayer *characterMenuLayer;
    CustomizeMenuLayer *customizeMenuLayer;
    PerksMenuLayer *perksMenuLayer;
}

@end
