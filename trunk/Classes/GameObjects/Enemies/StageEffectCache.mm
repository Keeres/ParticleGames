//
//  StageEffectCache.m
//  mushroom
//
//  Created by Steven Chen on 8/10/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "StageEffectCache.h"


@implementation StageEffectCache
 
@synthesize totalStageEffectType;
@synthesize visibleStageObjects;
@synthesize garbageStageObjects;

#pragma mark -
#pragma mark load stage effects into cache


-(void) initStageEffectsInWorld:(b2World*)theWorld {
    totalStageEffectType = [[CCArray alloc] initWithCapacity:kMaxStageEffectType];
    visibleStageObjects = [[NSMutableArray alloc] init];
    for (int i = 0; i < kMaxStageEffectType; i++) {
        int capacity;
        switch (i) {
            case kVolcanoType:
                capacity = 8;
                break;
            default:
                [NSException exceptionWithName:@"StageEffectCache Exception" reason:@"unhandled stage effect" userInfo:nil];
                break;
        }
        CCArray *effectOfType = [CCArray arrayWithCapacity:capacity];
        [totalStageEffectType addObject:effectOfType];
    }
    
    for (int i = 0; i<kMaxStageEffectType; i++) {
        CCArray *stageEffectOfType = [totalStageEffectType objectAtIndex:i];
        int numberStageEffectType = [stageEffectOfType capacity];
        
        if (i == kVolcanoType) {
            for (int j = 0; j < numberStageEffectType; j++) {
                VolcanoFireball *volcanoFireball = [[[VolcanoFireball alloc] initWithWorld:theWorld] autorelease];
                [stageEffectOfType addObject:volcanoFireball];      
            }
        }
    }
}

-(void) chooseVolcanoEffect {
    CCArray *stageEffectOfType = [totalStageEffectType objectAtIndex:kVolcanoType];
    for (int i = 0; i < [stageEffectOfType capacity]; i++) {
        VolcanoFireball *tempVolcanoFireball = [stageEffectOfType objectAtIndex:i];
        
        if (tempVolcanoFireball.visible == NO) {
            CGPoint location;
            location = ccp(offset, winSize.height);
            [[stageEffectOfType objectAtIndex:i] spawn:location];
            [visibleStageObjects addObject:tempVolcanoFireball];
            return;
        }
    }
}

//Called by update method in gameActionLayer to spawn stage effect objects corresponding to backgroundState
-(void) spawnStageEffectForBackgroundState:(int)Type atTime:(ccTime)dt atOffset:(float)newOffset andScale:(float)scale{
    randomOffset = (arc4random()%5)*50;
    self.scale = scale;
   
    offset = newOffset + 300 + randomOffset;
    if (Type == kVolcanoErupt) {
        float randomTime = arc4random() % 5 + 2;
        if (stageEffectTiming > randomTime) {
            stageEffectTiming = 0.0;
            if ([visibleStageObjects count] < 4) {
                int randomStageEffect = arc4random() % 2;
                if (randomStageEffect == 0) {
                    [self chooseVolcanoEffect];
                }
            }
        }   
        stageEffectTiming += dt;
    }
}

-(void) cleanStageEffectUsingMushroomPosition:(float)cleanOffset {
    for (int i=0; i < [visibleStageObjects count]; i++) {
        StageEffect *tempStageEffect = [visibleStageObjects objectAtIndex:i];
        b2Vec2 tempPosition = tempStageEffect.body->GetPosition();
        if (tempPosition.x < (cleanOffset-400)/PTM_RATIO) {
            [tempStageEffect changeState:kStateDead];
            [visibleStageObjects removeObjectAtIndex:i];
        }
    }
}


-(id) initWithWorld:(b2World*)theWorld{
	if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
		[self initStageEffectsInWorld:world];
        garbageStageObjects = [[NSMutableArray alloc] init];
        stageEffectTiming = 0.0;
	}
	return self;
}


- (void)dealloc {
    [totalStageEffectType release];
    [visibleStageObjects release];
    [garbageStageObjects release];
    [super dealloc];
}

@end
