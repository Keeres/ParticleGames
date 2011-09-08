//
//  PlatformCache.h
//  mushroom
//
//  Created by Kelvin on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Platform.h"
#import "Box2D.h"
#import "Constants.h"
#import "CommonProtocols.h"
#import "GLES-Render.h"

#define kMaxPlatformPoints 1000

@interface PlatformCache : CCNode {
    CGSize winSize;
    b2World *world;
    b2Body *platformBody;
    b2Body *platformSideBody;
    GLESDebugDraw *debugDraw;
    
    CCSpriteBatchNode *batch;
    CCArray *platforms;
    NSMutableArray *platformsVisible;
    CCArray *platformsFront;
    CCArray *platformsMiddle;
    CCArray *platformsEnd;
    
    CGPoint platformKeyPoints[kMaxPlatformPoints];
    int fromKeyPointI;
    int toKeyPointI;
    float offset;
    float previousXLocation;
}

@property (nonatomic, retain) CCArray *platforms;
@property (nonatomic, retain) NSMutableArray *platformsVisible;
@property (nonatomic, retain) CCArray *platformsFront;
@property (nonatomic, retain) CCArray *platformsMiddle;
@property (nonatomic, retain) CCArray *platformsEnd;
@property b2Body *platformBody;
@property b2Body *platformSideBody;

@property int fromKeyPointI;
@property int toKeyPointI;
@property float previousXLocation;

-(id) initWithWorld:(b2World*)theWorld andScale:(float)scale;
-(void) updatePlatforms:(float)newOffset withScale:(float)newScale;
-(void) generatePlatforms;

@end
