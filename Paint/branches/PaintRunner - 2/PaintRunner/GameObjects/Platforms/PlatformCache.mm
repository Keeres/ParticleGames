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
            /*case platformA:
                capacity = 10;
                break;
            case platformB:
                capacity = 10;
                break;
            case platformC:
                capacity = 10;
                break;*/
                
            case platformD:
                capacity = 50;
                
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
    for (int i = 0; i < 30; i++) {
        CCArray *platformOfType = [totalPlatforms objectAtIndex:0];
        for (int j = 0; j < [platformOfType count]; j++) {
            Platform *tempPlat;
            tempPlat = [platformOfType objectAtIndex:j];
            if (tempPlat.visible == NO) {
                CGPoint location;
                //location = ccp(tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i), 0.1*tempPlat.contentSize.height - (tempPlat.contentSize.width/2*i));
                location = ccp(tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i), 0.2*winSize.height);

                tempPlat.position = location;
                tempPlat.finalHeight = 0.2*winSize.height;
                tempPlat.visible = YES;
                //tempPlat.platformNumber = platformCounter;
                tempPlat.body->SetActive(YES);
                tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                [visiblePlatforms addObject:tempPlat];
                //platformCounter++;
                break;
            }
        }
    }
    initialPlatformsCreated = YES;
}

-(void) addPlatform {
    //int randomPlatform = arc4random() % 3;
    int randomPlatform = 0;
    CCArray *platformOfType = [totalPlatforms objectAtIndex:randomPlatform];
    
    float randomHeight = arc4random() % 80 + 30;
    //float differentX = arc4random() % 5 + 5;
    //differentX = differentX * 8;
    float differentX = 0;
    for (int i = 0; i < platformLength; i++) {
        for (int j = 0; j < [platformOfType count]; j++) {        
            Platform *tempPlat = [platformOfType objectAtIndex:j];
            
            if (tempPlat.visible == NO) {

                CGPoint location = ccp(0.8*winSize.width - tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i) + differentX, -tempPlat.contentSize.height/2 - (tempPlat.contentSize.width*i));
                
                tempPlat.position = location;
                tempPlat.finalHeight = randomHeight;
                tempPlat.visible = YES;
                tempPlat.body->SetActive(YES);
                tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                
                [visiblePlatforms addObject:tempPlat];
                if (i != 0 || i != (platformLength - 1)) {
                    //tempPlat.platformNumber = platformCounter;
                    //platformCounter++;
                }
                break;
            }
        }
    }
}

/*-(void) addInitialPlatforms {
    for (int i = 0; i < 3; i++) {
        //int randomPlatform = arc4random() % 3;
        int randomPlatform = 0;
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
}*/

/*-(void) addPlatform {
    //int randomPlatform = arc4random() % 3;
    int randomPlatform = 0;
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
}*/

-(void) updatePlatformsWithTime:(ccTime)dt andSpeed:(float)speed {
    if (speed > 100.0 && speed < 150.0) {
        platformLength = 6;
    } else if (speed > 150.0 && speed < 200.0) {
        platformLength = 5;
    } else if (speed > 200.0 && speed < 250.0) {
        platformLength = 4;
    } else if (speed > 250.0) {
        platformLength = 3;
    }
               
    for (int i = 0; i < [visiblePlatforms count]; i++) {
        Platform *tempPlat = [visiblePlatforms objectAtIndex:i];
        
        //if (tempPlat.readyToMove) {
            b2Vec2 bodyPos = tempPlat.body->GetPosition();
            tempPlat.body->SetTransform(b2Vec2(bodyPos.x - (speed*dt/PTM_RATIO), bodyPos.y), 0.0);
            
        //} //else {
            
            if ((tempPlat.position.y < tempPlat.finalHeight) && tempPlat.readyToMove == NO) {
                b2Vec2 bodyPos = tempPlat.body->GetPosition();
                tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*2*dt/PTM_RATIO)), 0.0);
                //tempPlat.readyToMove = YES;

            } else {
                tempPlat.position = ccp(tempPlat.position.x, tempPlat.finalHeight);
                b2Vec2 bodyPos = tempPlat.body->GetPosition();

                tempPlat.body->SetTransform(b2Vec2(bodyPos.x, tempPlat.finalHeight/PTM_RATIO), 0.0);
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
    
    //platformCounter = 0;
    
}

@end
