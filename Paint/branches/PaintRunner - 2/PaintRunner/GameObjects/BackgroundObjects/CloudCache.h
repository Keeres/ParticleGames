//
//  CloudCache.h
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Cloud.h"
#import "Constants.h"

@interface CloudCache : CCNode {
    //Variables
    CGSize winSize;
    CCArray *totalClouds;
    NSMutableArray *visibleClouds;
}

@property (nonatomic, retain) CCArray *totalClouds;
@property (nonatomic, retain) NSMutableArray *visibleClouds;

-(void) updateCloudsWithTime:(ccTime)dt andSpeed:(float)speed;
-(void) addCloud;
-(void) cleanCloud;
-(void) resetClouds;

@end
