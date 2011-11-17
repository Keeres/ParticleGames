//
//  GameBackgroundLayer2.mm
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBackgroundLayer2.h"

@implementation GameBackgroundLayer2

-(void) createClouds {
    cloudCache = [[CloudCache alloc] init];
    CCArray *totalClouds = [cloudCache totalClouds];
    
    for (int i = 0; i < [totalClouds count]; i++) {
        CCArray *cloudOfType = [totalClouds objectAtIndex:i];
        for (int j = 0; j < [cloudOfType count]; j++) {
            Cloud *tempCloud = [cloudOfType objectAtIndex:j];
            [sceneSpriteBatchNode addChild:tempCloud z:1000];
        }
    }
}

-(void) setupBackground {
    background = [CCSprite spriteWithFile:@"background.png"];
    background.position = ccp(background.contentSize.width/2,winSize.height/2);
    [self addChild:background z:0];
    
    leafEmitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM
                   particleWithFile:@"leafEmitter.plist"];
    leafEmitter.position = ccp(winSize.width, winSize.height/2);
    leafEmitter.scale = 0.5;
    [self addChild:leafEmitter z:100];
}

-(void) resetBackground {
    CCLOG(@"BackgroundLayer2: Reset");

    cloudTimePassed = 0.0;
    cloudSpawnTime = 5.0;
    [cloudCache resetClouds];
    background.position = ccp(background.contentSize.width/2, winSize.height/2);
}

-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        CCTexture2D *gameArtTexture = [[CCTextureCache sharedTextureCache] addImage:@"game1atlas.png"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithTexture:gameArtTexture capacity:100];
        
        [self setupBackground];
        [self addChild:sceneSpriteBatchNode z:1000];
        cloudTimePassed = 0.0;
        cloudSpawnTime = 5.0;
        
    }
    return self;
}

-(void) setGameActionLayer:(GameActionLayer *)gameActionLayer {
    actionLayer = gameActionLayer;
    [self createClouds];
}

-(void) cloudControl:(ccTime) dt {
    cloudTimePassed += dt;
    if (cloudTimePassed > cloudSpawnTime && [[cloudCache visibleClouds] count] < 9) {
        CCLOG(@"clouds added");
        cloudTimePassed = 0;
        cloudSpawnTime = arc4random() % 5 + 5;
        [cloudCache addCloud];
    }
}


-(void) updateBackgroundWithTime:(ccTime)dt andSpeed:(float)speed {
    background.position = ccp(background.position.x - speed*dt*0.05, background.position.y);
    [self cloudControl:dt];
    [cloudCache updateCloudsWithTime:dt andSpeed:speed];
}

@end
