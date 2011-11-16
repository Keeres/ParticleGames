//
//  CloudCache.m
//  PaintRunner
//
//  Created by Kelvin on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CloudCache.h"

@implementation CloudCache

@synthesize totalClouds;
@synthesize visibleClouds;

-(void) initClouds {
    totalClouds = [[CCArray alloc] initWithCapacity:cloud_Max];
    
    for (int i = 0; i < cloud_Max; i++) {
        int capacity;
        switch (i) {
                /*case platformA:
                 capacity = 10;
                 break;
                 case platformB:
                 capacity = 10;
                 break;
                 case platformC:
                 capacity = 10;
                 break;*/
                
            case cloud:
                capacity = 10;
                
            default:
                [NSException exceptionWithName:@"CloudCache Exception" reason:@"unhandled cloud type" userInfo:nil];
                break;
        }
        CCArray *cloudOfType = [CCArray arrayWithCapacity:capacity];
        [totalClouds addObject:cloudOfType];
    }
    
    for (int i = 0; i < cloud_Max; i++) {
        CCArray *cloudOfType = [totalClouds objectAtIndex:i];
        
        int numberCloudOfType = [cloudOfType capacity];
        
        for (int j = 0; j < numberCloudOfType; j++) {
            
            Cloud *cloud = [[[Cloud alloc] initWithCloudType:(CloudTypes)i] autorelease];
            [cloudOfType addObject:cloud];
        }
    }
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        visibleClouds = [[NSMutableArray alloc] init];
        [self initClouds];
    }
    return self;
}

-(void) updateCloudsWithTime:(ccTime)dt andSpeed:(float)speed {
    for (int i = 0; i < [visibleClouds count]; i++) {
        Cloud *tempCloud = [visibleClouds objectAtIndex:i];
        tempCloud.position = ccp(tempCloud.position.x - speed*dt*tempCloud.speedPercentage, tempCloud.position.y);
    }
    [self cleanCloud];
}

-(void) addCloud {
    int randomNumOfClouds = arc4random() % 2 + 2;
    
    int randomCloud = 0; //Picks cloud type
    CCArray *cloudOfType = [totalClouds objectAtIndex:randomCloud];
    

    
    int speedSetter = arc4random()%4;
    float speedPercentage;
    
    switch (speedSetter) {
        case 0:
            speedPercentage = 0.3;
            break;
        case 1:
            speedPercentage = 0.35;
            break;
        case 2:
            speedPercentage = 0.4;
            break;
        case 3:
            speedPercentage = 0.5;
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < randomNumOfClouds; i++) {
        for (int j = 0; j < [cloudOfType count]; j++) {
            Cloud *tempCloud = [cloudOfType objectAtIndex:j];
            
            if (tempCloud.visible == NO) {
                float randomHeight = arc4random() % 60 + 50;
                randomHeight = winSize.height - randomHeight;
                float randomDistance = arc4random() % 40 + 30;
                int randomScaleSet = arc4random() % 3;
                switch (randomScaleSet) {
                    case 0:
                        tempCloud.scale = 0.8;
                        break;
                    case 1:
                        tempCloud.scale = 1.0;
                        break;
                    case 2:
                        tempCloud.scale = 1.2;
                        break;
                        
                    default:
                        break;
                }
                
                CGPoint location = ccp(winSize.width + randomDistance, randomHeight);
                
                tempCloud.position = location;
                tempCloud.visible = YES;
                tempCloud.speedPercentage = speedPercentage;
                [visibleClouds addObject:tempCloud];
                break;
            }
        }
    }
}

-(void) cleanCloud {
    for (int i = 0; i < [visibleClouds count]; i++) {
        Cloud *tempCloud = [visibleClouds objectAtIndex:i];
        
        if (tempCloud.visible == NO || tempCloud.position.x < -winSize.width/4) {
            [tempCloud despawn];
            [visibleClouds removeObject:tempCloud];
        }
    }
        
}

-(void) resetClouds {
    for (int i = 0; i < [visibleClouds count]; i++) {
        Cloud *tempCloud = [visibleClouds objectAtIndex:i];
        [tempCloud despawn];
    }
    
    [visibleClouds removeAllObjects];
}

-(void) dealloc {
    [super dealloc];
}


@end
