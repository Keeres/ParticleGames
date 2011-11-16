//
//  Cloud.m
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Cloud.h"

@implementation Cloud

@synthesize speedPercentage;

-(id) initWithCloudType:(CloudTypes)cloudWithType {
    cloudType = cloudWithType;
    
    NSString *cloudName;
    
    switch (cloudType) {
        case cloud:
            cloudName = @"cloud.png";
            break;
            
        default:
            [NSException exceptionWithName:@"Cloud Exception" reason:@"unhandled cloud type" userInfo:nil];
            break;
    }
    
    if ((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:cloudName]];
        
        self.visible = NO;
        self.tag = kCloudType;
        speedPercentage = 1.0;
    }
    return self;
}

-(void) despawn {
    self.visible = NO;
    speedPercentage = 1.0;
}

-(void) dealloc {
    [super dealloc];
}

@end
