//
//  PlaformCache.mm
//  PaintRunner
//
//  Created by Kelvin on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlatformCache.h"

@implementation PlatformCache

@synthesize totalPlatforms;
@synthesize visiblePlatforms;
@synthesize initialPlatformsCreated;

-(void) initPlatforms {
    totalPlatforms = [[CCArray alloc] initWithCapacity:platform_Max];
    
    for (int i = 0; i < platform_Max; i++) {
        int capacity;
        switch (i) {
            case platformA:
                capacity = 10;
                break;
            case platformB:
                capacity = 10;
                break;
            case platformC:
                capacity = 10;
                break;
                
            default:
                [NSException exceptionWithName:@"PlatformCache Exception" reason:@"unhandled platform type" userInfo:nil];
                break;
        }
        CCArray *platformOfType = [CCArray arrayWithCapacity:capacity];
        [totalPlatforms addObject:platformOfType];
    }
    
    for (int i = 0; i < platform_Max; i++) {
        CCArray *platformOfType = [totalPlatforms objectAtIndex:i];
        
        int numberPlatformOfType = [platformOfType capacity];
        
        for (int j = 0; j < numberPlatformOfType; j++) {
            
            Platform *platform = [[[Platform alloc] initWithWorld:world andPlatformType:(PlatformTypes)i] autorelease];
            [platformOfType addObject:platform];
        }
    }
    
    initialPlatform = [[Platform alloc] initInitialGroundPlatformWithWorld:world];
}

-(id) initWithWorld:(b2World*)theWorld {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        self.position = ccp(-100,0);
        world = theWorld;

        visiblePlatforms = [[NSMutableArray alloc] init];
        initialPlatformsCreated = NO;

        [self initPlatforms];
            
    }
    return self;
}

-(void) addInitialPlatforms {
    for (int i = 0; i < 3; i++) {
        int randomPlatform = arc4random() % 3;
        CCArray *platformOfType = [totalPlatforms objectAtIndex:randomPlatform];
        for (int j = 0; j < [platformOfType count]; j++) {
            
            Platform *tempPlat;
            if (j == 0) {
                tempPlat = initialPlatform;
            } else {
                tempPlat = [platformOfType objectAtIndex:j];
            }
            
            if (tempPlat.visible == NO) {
                CGPoint location;
                if (j == 0) {
                    location = ccp(winSize.width/4, winSize.height/4);
                    tempPlat.finalHeight = winSize.height/4;
                    tempPlat.visible = YES;
                    tempPlat.platformNumber = platformCounter;
                    tempPlat.body->SetActive(YES);
                    tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                    [visiblePlatforms addObject:tempPlat];
                    platformCounter++;

                } else {
                    location = ccp(winSize.width/4 + tempPlat.contentSize.width/2 + (2*i*tempPlat.contentSize.width), -tempPlat.contentSize.height/2);
                    tempPlat.position = location;
                    tempPlat.finalHeight = arc4random() % 50 + 20;
                    tempPlat.visible = YES;
                    tempPlat.platformNumber = platformCounter;
                    tempPlat.body->SetActive(YES);
                    tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                    [visiblePlatforms addObject:tempPlat];
                    platformCounter++;
                }
                break;
            }
        }
    }
    initialPlatformsCreated = YES;
}

-(void) addPlatform {
    int randomPlatform = arc4random() % 3;
    CCArray *platformOfType = [totalPlatforms objectAtIndex:randomPlatform];
    
    for (int i = 0; i < [platformOfType count]; i++) {        
        Platform *tempPlat = [platformOfType objectAtIndex:i];
        
        if (tempPlat.visible == NO) {
            float differentX = arc4random() % 5 + 2;
            differentX = differentX * 8;
            CGPoint location = ccp(winSize.width - tempPlat.contentSize.width/2 - differentX, -tempPlat.contentSize.height/2);
            
            tempPlat.position = location;
            tempPlat.finalHeight = arc4random() % 50 + 20;
            tempPlat.visible = YES;
            tempPlat.platformNumber = platformCounter;
            tempPlat.body->SetActive(YES);
            tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
            
            [visiblePlatforms addObject:tempPlat];
            
            platformCounter++;
            break;
        }
    }
}

-(void) updatePlatformsWithTime:(ccTime)dt andSpeed:(float)speed {
    for (int i = 0; i < [visiblePlatforms count]; i++) {
        Platform *tempPlat = [visiblePlatforms objectAtIndex:i];
        
        if (tempPlat.readyToMove) {
            b2Vec2 bodyPos = tempPlat.body->GetPosition();
            tempPlat.body->SetTransform(b2Vec2(bodyPos.x - (speed*dt/PTM_RATIO), bodyPos.y), 0.0);
            
        } //else {
            
            if (tempPlat.position.y < tempPlat.finalHeight) {
                b2Vec2 bodyPos = tempPlat.body->GetPosition();
                tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*3.5*dt/PTM_RATIO)), 0.0);
                tempPlat.readyToMove = YES;

            } else {
                tempPlat.readyToMove = YES;
            }
       // }
    }
    
    [self cleanPlatforms];
}

-(void) cleanPlatforms {
    for (int i = 0; i < [visiblePlatforms count]; i++) {
        
        Platform *tempPlat = [visiblePlatforms objectAtIndex:i];
        
        if (tempPlat.visible == NO || tempPlat.position.x < -winSize.width/4) {
            [tempPlat despawn];
            [visiblePlatforms removeObject:tempPlat];
        }
    }
}

-(void) resetPlatforms {
    initialPlatformsCreated = NO;
    for (int i = 0; i < [visiblePlatforms count]; i++) {
        Platform *tempPlat = [visiblePlatforms objectAtIndex:i];
        [tempPlat despawn];
    }
    [visiblePlatforms removeAllObjects];
    
    platformCounter = 0;
    
}

@end
