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
#import "VolcanoBackgroundLayer.h"
#import "VolcanoActionLayer.h"

@interface VolcanoScene : CCScene {
    GameUILayer *uiLayer;
    GameBackgroundLayer *backgroundLayer;
}

@end

