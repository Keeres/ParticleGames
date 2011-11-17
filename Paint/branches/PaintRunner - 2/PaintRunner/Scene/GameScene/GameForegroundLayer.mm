//
//  GameForegroundLayer.m
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameForegroundLayer.h"

@implementation GameForegroundLayer

-(void) createTrees {
    treeCache = [[TreeCache alloc] init];
    CCArray *totalTrees = [treeCache totalTrees];
    
    for (int i = 0; i < [totalTrees count]; i++) {
        CCArray *treeOfType = [totalTrees objectAtIndex:i];
        for (int j = 0; j < [treeOfType count]; j++) {
            Tree *tempTree = [treeOfType objectAtIndex:j];
            [sceneSpriteBatchNode addChild:tempTree z:1000];
        }
    }
}

#pragma mark Reset Foreground

-(void) resetForeground; {
    CCLOG(@"ForegroundLayer: Reset");
    treeTimePassed = 0.0;
    treeSpawnTime = 10.0;
    [treeCache resetTrees];
}

#pragma mark Initialize GameForegroundLayer

-(id) init {
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        CCTexture2D *gameArtTexture = [[CCTextureCache sharedTextureCache] addImage:@"game1atlas.png"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithTexture:gameArtTexture capacity:100];
        
        [self addChild:sceneSpriteBatchNode z:1000];
        treeTimePassed = 0.0;
        treeSpawnTime = 8.0;
    }
    return self;
}

-(void) setGameActionLayer:(GameActionLayer *)gameActionLayer {
    actionLayer = gameActionLayer;
    [self createTrees];
}

-(void) treeControl:(ccTime) dt {
    treeTimePassed += dt;
    if (treeTimePassed > treeSpawnTime && [[treeCache visibleTrees] count] < 4) {
        treeTimePassed = 0;
        treeSpawnTime = arc4random() % 5 + 8.0;
        [treeCache addTree];
    }
}


-(void) updateForegroundWithTime:(ccTime)dt andSpeed:(float)speed {
    [self treeControl:dt];
    [treeCache updateTreesWithTime:dt andSpeed:speed];
}


@end
