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
    background.anchorPoint = ccp(0,0);
    background.position = ccp(0.0, 0.0);
    [self addChild:background z:0];
    
    /*city = [CCSprite spriteWithFile:@"city.png"];
    city.anchorPoint = ccp(0,0);
    city.position = ccp(0.0, 0.0);
    [self addChild:city z:5];
    
    mountain = [CCSprite spriteWithFile:@"mountain.png"];
    mountain.anchorPoint = ccp(0,0);
    mountain.position = ccp(0.0, 50.0);
    [self addChild:mountain z:4];
    
    sky = [CCSprite spriteWithFile:@"sky.png"];
    sky.anchorPoint = ccp(0,0);
    sky.position = ccp(0.0, 100.0);
    [self addChild:sky z:3];*/
    
    leafEmitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM
                   particleWithFile:@"leafEmitter.plist"];
    leafEmitter.position = ccp(winSize.width, winSize.height/2);
    leafEmitter.scale = 0.5;
    [self addChild:leafEmitter z:100];
}

#pragma mark Reset GameBackgroundLayer2

-(void) resetBackground {
    CCLOG(@"BackgroundLayer2: Reset");

    cloudTimePassed = 0.0;
    cloudSpawnTime = 5.0;
    [cloudCache resetClouds];
    
    self.position = ccp(0.0, 0.0);
    background.position = ccp(0.0, 0.0);

    //city.position = ccp(0.0, 0.0);
    //mountain.position = ccp(0.0, 50.0);
    //sky.position = ccp(0.0, 100.0);
}

#pragma mark Initialize GameBackgroundLayer2

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
        cloudTimePassed = 0;
        cloudSpawnTime = arc4random() % 5 + 5;
        [cloudCache addCloud];
    }
}

-(void) updateBackgroundWithTime:(ccTime)dt andSpeed:(float)speed andScreenOffsetY:(float)screenOffsetY {
    float yPos = self.position.y + screenOffsetY;
    self.position = ccp(self.position.x, yPos);
    
    //float yPosEmitter = leafEmitter.position.y + screenOffsetY;
    //leafEmitter.position = ccp(leafEmitter.position.x, yPosEmitter);
    
    background.position = ccp(background.position.x - speed*dt*0.05, background.position.y);
    //city.position = ccp(city.position.x - speed*dt*0.25, city.position.y);
    //mountain.position = ccp(mountain.position.x - speed*dt*0.1, mountain.position.y);
    //sky.position = ccp(sky.position.x - speed*dt*0.05   , sky.position.y);

    [self cloudControl:dt];
    [cloudCache updateCloudsWithTime:dt andSpeed:speed];
}

@end
