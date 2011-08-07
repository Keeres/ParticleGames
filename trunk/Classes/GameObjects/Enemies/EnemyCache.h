//
//  TurtleCache.h
//  mushroom
//
//  Created by Kelvin on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Mushroom.h"
#import "Enemy.h"
#import "Turtle.h"
#import "Bee.h"
#import "Jumper.h"
#import "CommonProtocols.h"
#import "GameActionLayer.h"

@class GameActionLayer;

@interface EnemyCache : CCNode {
    CCArray *totalEnemies;
    
    NSMutableArray *visibleEnemies;
    NSMutableArray *garbageEnemies;
    
    b2World *world;
    GameActionLayer *actionLayer;
    CGSize winSize;
    
    float timePassed;
    float offset;
}

@property (nonatomic, retain) CCArray *totalEnemies;
@property (nonatomic, retain) NSMutableArray *visibleEnemies;
@property (nonatomic, retain) NSMutableArray *garbageEnemies;

-(id) initWithWorld:(b2World*)theWorld withActionLayer:(GameActionLayer*)gameActionLayer;
-(void) randomlySpawnEnemy:(ccTime)dt atOffset:(float)newOffset andScale:(float)scale;
-(void) detectMushroomCheck;
-(void) cleanEnemies;

@end
