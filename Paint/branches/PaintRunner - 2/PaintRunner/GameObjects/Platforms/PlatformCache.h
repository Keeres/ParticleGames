//
//  PlaformCache.h
//  PaintRunner
//
//  Created by Kelvin on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"
#import "Platform.h"

@interface PlatformCache : CCNode {
    //Box2D
    b2World *world;
    b2Body *platformsTopAndBottomBody;
    b2Body *platformSideBody;
    
    //Variables
    CGSize winSize;
    CCArray *totalPlatforms;
    NSMutableArray *visiblePlatforms;
    BOOL initialPlatformsCreated;
    Platform *initialPlatform;
    int platformCounter;
    int platformLength;
}

@property (nonatomic, retain) CCArray *totalPlatforms;
@property (nonatomic, retain) NSMutableArray *visiblePlatforms;
@property (readwrite) BOOL initialPlatformsCreated;

-(id) initWithWorld:(b2World*)theWorld;
-(void) updatePlatformsWithTime:(ccTime)dt andSpeed:(float)speed;
-(void) addInitialPlatforms;
-(void) addPlatform;

-(void) cleanPlatforms;
-(void) resetPlatforms;

@end
