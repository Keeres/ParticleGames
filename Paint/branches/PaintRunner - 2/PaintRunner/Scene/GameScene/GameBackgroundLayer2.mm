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
    background.anchorPoint = ccp(0.0, 0.5);
    background.position = ccp(0.0, winSize.height/2);
    [self addChild:background z:0];
    
    background2 = [CCSprite spriteWithFile:@"background.png"];
    background2.anchorPoint = ccp(0.0, 0.5);
    background2.position = ccp(0.0, winSize.height/2);
    [self addChild:background2 z:0];
    background2.visible = NO;
    
    
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
    background.position = ccp(0.0, winSize.height/2);
    background2.position = ccp(0.0, winSize.height/2);
    background2.visible = NO;

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
    
    if (background.position.x < -background.contentSize.width) {
        background.visible = NO;
    }
    
    if (background2.position.x < -background2.contentSize.width) {
        background2.visible = NO;
    }
    
    if (background2.position.x < 0.0 && background.visible == NO) {
        background.position = ccp(background2.position.x + background2.contentSize.width, background2.position.y);
        background.visible = YES;
    }
    
    if (background.position.x < 0.0 && background2.visible == NO) {
        background2.position = ccp(background.position.x + background.contentSize.width, background.position.y);
        background2.visible = YES;
    }
    
    if (background.visible == YES) {
        background.position = ccp(background.position.x - speed*dt*0.05, background.position.y);
    }
    
    if (background2.visible == YES) {
        background2.position = ccp(background2.position.x - speed*dt*0.05, background2.position.y);

    }
    
    [self cloudControl:dt];
    [cloudCache updateCloudsWithTime:dt andSpeed:speed];
}

@end
