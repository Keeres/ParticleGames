//
//  GameScene.mm
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

+(id) scene {
    CCScene *scene = [CCScene node];
    
    GameUILayer *uiLayer = [GameUILayer node];
    [scene addChild:uiLayer z:2];
    
    //GameBackgroundLayer *backgroundLayer = [GameBackgroundLayer node];
    //[scene addChild:backgroundLayer z:0];
    
    GameBackgroundLayer2 *backgroundLayer2 = [GameBackgroundLayer2 node];
    [scene addChild:backgroundLayer2 z:0];
    
    GameActionLayer *actionLayer = [[[GameActionLayer alloc] initWithGameUILayer:uiLayer andBackgroundLayer:backgroundLayer2] autorelease];
    
    [scene addChild:actionLayer z:1];
    
    return scene;
}

@end
