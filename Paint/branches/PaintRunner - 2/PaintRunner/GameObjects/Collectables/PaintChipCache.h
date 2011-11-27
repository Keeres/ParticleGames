//
//  PaintChipCache.h
//  PaintRunner
//
//  Created by Kelvin on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"
#import "PaintChip.h"

@interface PaintChipCache : CCNode {
    //Box2D
    b2World *world;
    
    //Variables
    CGSize winSize;
    CCArray *totalPaintChips;
    NSMutableArray *visiblePaintChips;
    float paintChipSpawnDelay;
}

@property (nonatomic, retain) CCArray *totalPaintChips;
@property (nonatomic, retain) NSMutableArray *visiblePaintChips;

-(id) initWithWorld:(b2World*)theWorld;
-(void) addPaintChips;
//-(void) addPaintChipsBetweenPlatformLocation:(CGPoint)position1 andLocation:(CGPoint)position2;
-(void) addPaintChipsPatternOneBetweenPlatformLocation:(CGPoint)position1 andLocation:(CGPoint)position2;
-(void) updatePaintChipsWithTime:(ccTime)dt andSpeed:(float)speed;
-(void) cleanPaintChips;
-(void) resetPaintChips;

@end
