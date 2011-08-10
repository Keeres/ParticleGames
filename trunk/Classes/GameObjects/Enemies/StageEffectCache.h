//
//  StageEffectCache.h
//  mushroom
//
//  Created by Steven Chen on 8/10/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Enemy.h"
#import "CommonProtocols.h"
#import "VolcanicRock.h"
 
//@class GameActionLayer;
@interface StageEffectCache : CCNode {
     CCArray *totalStageEffectType;
    NSMutableArray *visibleStageObjects;
    NSMutableArray *garbageStageObjects;
    
    b2World *world;
    CGSize winSize;
    
    float stageEffectTiming;
    float offset;
    float randomOffset;
}

@property (nonatomic, retain) CCArray *totalStageEffectType;
@property (nonatomic, retain) NSMutableArray *visibleStageObjects;
@property (nonatomic, retain) NSMutableArray *garbageStageObjects;

-(id) initWithWorld:(b2World*)theWorld withStageEffectType:(int) backgroundType;

-(void) spawnStageEffectForBackgroundState:(int)Type atTime:(ccTime)dt atOffset:(float)newOffset andScale:(float)scale;

@end
