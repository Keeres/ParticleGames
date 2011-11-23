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
    
    //Variables
    CGSize winSize;
    CCArray *totalPlatforms;
    CCArray *totalSidePlatforms;
    NSMutableArray *visiblePlatforms;
    NSMutableArray *visibleSidePlatforms;
    BOOL initialPlatformsCreated;
    BOOL topPlatformSpawned;
    Platform *initialPlatform;
    //int platformCounter;
    int platformLength;
    float previousPlatformFinalHeight;
}

@property (nonatomic, retain) CCArray *totalPlatforms;
@property (nonatomic, retain) NSMutableArray *visiblePlatforms;
@property (nonatomic, retain) NSMutableArray *visibleSidePlatforms;
@property (readwrite) BOOL initialPlatformsCreated;

-(id) initWithWorld:(b2World*)theWorld;
-(void) updatePlatformsWithTime:(ccTime)dt andSpeed:(float)speed;
-(void) addInitialPlatforms;
-(void) addPlatformBasedOffPlayerHeight:(float)playerHeight;

-(void) cleanPlatforms;
-(void) resetPlatforms;

@end
