//
//  GameScene.h
//  mushroom
//
//  Created by Kelvin on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameUILayer.h"
#import "GameBackgroundLayer.h"
#import "GameActionLayer.h"

@interface GameScene : CCScene {
    GameUILayer *uiLayer;
    GameBackgroundLayer *backgroundLayer;
}

@end

