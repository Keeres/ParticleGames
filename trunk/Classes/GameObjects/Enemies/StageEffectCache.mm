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
                VolcanicRock *volcanicRock = [[[VolcanicRock alloc] initWithWorld:theWorld] autorelease];
                [stageEffectOfType addObject:volcanicRock];      
            }
        }
    }
}

-(void) chooseVolcanoEffect {
    CCArray *stageEffectOfType = [totalStageEffectType objectAtIndex:kVolcanoType];
    CCLOG(@"spawn");
    for (int i = 0; i < [stageEffectOfType capacity]; i++) {
        VolcanicRock *tempVolcanicRock = [stageEffectOfType objectAtIndex:i];
        
        if (tempVolcanicRock.visible == NO) {
            CGPoint location;
            location = ccp(offset, winSize.height);
            [[stageEffectOfType objectAtIndex:i] spawn:location];
            [visibleStageObjects addObject:tempVolcanicRock];
            return;
        }
    }
}


-(void) spawnStageEffectForBackgroundState:(int)Type atTime:(ccTime)dt atOffset:(float)newOffset andScale:(float)scale{
    randomOffset = (arc4random()%5)*50;
    self.scale = scale;
    offset = newOffset + 300 + randomOffset;
    if (Type == kVolcanoErupt) {
        float randomTime = arc4random() % 5 + 2;
        if (stageEffectTiming > randomTime) {
            CCLOG(@"spawn");
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


-(id) initWithWorld:(b2World*)theWorld withStageEffectType:(int) backgroundType {
	if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
       // backgroundLayer = gameBackgroundLayer;
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
