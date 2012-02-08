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
    b2Body *easySensor;
    b2Body *hardSensor;
    
    //Variables
    CGSize winSize;
    CCArray *totalPlatforms;
    CCArray *totalSidePlatforms;
    NSMutableArray *keyPlatforms;
    NSMutableArray *visiblePlatforms;
    NSMutableArray *visibleSidePlatforms;
    BOOL initialPlatformsCreated;
    BOOL topPlatformSpawned;
    Platform *initialPlatform;
    Platform *oldPlatform;
    Platform *nextPlatform;
    //int platformCounter;
    int longPlatformLength;
    int shortPlatformLength;
    int oldLongPlatformLength;
    int oldShortPlatformLength;
    float previousPlatformFinalHeight;
    
    NSUInteger previousPlatformEndIndex;
    NSUInteger currentPlatformIndex;
    NSUInteger currentPlatformEndIndex;
}

@property (nonatomic, retain) CCArray *totalPlatforms;
@property (nonatomic, retain) NSMutableArray *keyPlatforms;
@property (nonatomic, retain) NSMutableArray *visiblePlatforms;
@property (nonatomic, retain) NSMutableArray *visibleSidePlatforms;
@property (readwrite) BOOL initialPlatformsCreated;
@property (nonatomic, retain) Platform* oldPlatform;
@property (nonatomic, retain) Platform* nextPlatform;
@property (readonly) int oldLongPlatformLength;
@property (readonly) int oldShortPlatformLength;

-(id) initWithWorld:(b2World*)theWorld;
-(void) updatePlatformsWithTime:(ccTime)dt andSpeed:(float)speed;

-(void) addStartingPlatform;
-(void) addLongPlatform;
-(void) addShortPlatform;

-(void) cleanPlatforms;
-(void) resetPlatforms;

@end
