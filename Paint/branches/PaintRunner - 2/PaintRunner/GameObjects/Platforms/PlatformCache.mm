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
@synthesize visibleSidePlatforms;
@synthesize initialPlatformsCreated;

-(void) initPlatforms {
    totalPlatforms = [[CCArray alloc] initWithCapacity:totalPlatformTypes];
    
    for (int i = 0; i < totalPlatformTypes; i++) {
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
    
    for (int i = 0; i < totalPlatformTypes; i++) {
        CCArray *platformOfType = [totalPlatforms objectAtIndex:i];
        
        int numberPlatformOfType = [platformOfType capacity];
        
        for (int j = 0; j < numberPlatformOfType; j++) {
            
            Platform *platform = [[[Platform alloc] initWithWorld:world andPlatformType:(PlatformTypes)i] autorelease];
            [platformOfType addObject:platform];
        }
    }
    
    initialPlatform = [[Platform alloc] initInitialGroundPlatformWithWorld:world];
}

-(void) initSidePlatforms {
    totalSidePlatforms = [[CCArray alloc] initWithCapacity:5];
    
    for (int i = 0; i < [totalSidePlatforms capacity]; i++) {
        Platform *platform = [[[Platform alloc] initSideWithWorld:world] autorelease];
        [totalSidePlatforms addObject:platform];
    }
}

-(id) initWithWorld:(b2World*)theWorld {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;

        visiblePlatforms = [[NSMutableArray alloc] init];
        visibleSidePlatforms = [[NSMutableArray alloc] init];
        initialPlatformsCreated = NO;
        previousPlatformFinalHeight = winSize.height*0.2;

        [self initPlatforms];
        [self initSidePlatforms];
            
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

-(void) addPlatformBasedOffPlayerHeight:(float)playerHeight {
    //int randomPlatform = arc4random() % 3;
    
    int randomPlatform = 0;
    CCArray *platformOfType = [totalPlatforms objectAtIndex:randomPlatform];
    
    float randomHeight = arc4random() % 30 + 20;
    BOOL isTopPlatformNext = arc4random() % 2;
    if ((isTopPlatformNext || previousPlatformFinalHeight < winSize.height*0.2) && (previousPlatformFinalHeight < winSize.height*1.1)) {
        randomHeight = previousPlatformFinalHeight + randomHeight;
    } else {
        randomHeight = previousPlatformFinalHeight - randomHeight;
    }
    
    //float differentX = arc4random() % 5 + 5;
    //differentX = differentX * 8;
    float differentX = 0;
    for (int i = 0; i < platformLength; i++) {
        
        //Add side body
        if (i == 0) {
            for (int j = 0; j < [totalSidePlatforms count]; j++) {
                Platform *tempSide = [totalSidePlatforms objectAtIndex:j];
                
                if (!tempSide.body->IsActive()) {
                    
                    //CGPoint location = ccp(0.8*winSize.width - tempSide.contentSize.width/2 + ((tempSide.contentSize.width - 1)*i) + differentX, -tempSide.contentSize.height/2 - (tempSide.contentSize.width*i));
                    CGPoint location = ccp(0.8*winSize.width - tempSide.contentSize.width/2 + ((tempSide.contentSize.width - 1)*i) + differentX, playerHeight - winSize.height/2 - (tempSide.contentSize.width*i));
                    
                    tempSide.position = location;
                    tempSide.finalHeight = randomHeight;
                    tempSide.body->SetActive(YES);
                    tempSide.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                    
                    [visibleSidePlatforms addObject:tempSide];
                    break;
                }
            }
        }
        
        //Add top body
        for (int j = 0; j < [platformOfType count]; j++) {        
            Platform *tempPlat = [platformOfType objectAtIndex:j];
            
            if (tempPlat.visible == NO) {

                //CGPoint location = ccp(0.8*winSize.width - tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i) + differentX, -tempPlat.contentSize.height/2 - (tempPlat.contentSize.width*i));
                CGPoint location = ccp(0.8*winSize.width - tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i) + differentX, 
                                       playerHeight - winSize.height/2 - (tempPlat.contentSize.width*i));
                
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
    previousPlatformFinalHeight = randomHeight;
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
        
        b2Vec2 bodyPos = tempPlat.body->GetPosition();
        tempPlat.body->SetTransform(b2Vec2(bodyPos.x - (speed*dt/PTM_RATIO), bodyPos.y), 0.0);
        
        float distanceRemaining = tempPlat.finalHeight - tempPlat.position.y;
        
        if ((tempPlat.position.y < tempPlat.finalHeight) && tempPlat.readyToMove == NO) {
            b2Vec2 bodyPos = tempPlat.body->GetPosition();
            //tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*2*dt/PTM_RATIO)), 0.0);
            tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed/25.0*distanceRemaining*dt/PTM_RATIO)), 0.0);
        } else {
            tempPlat.position = ccp(tempPlat.position.x, tempPlat.finalHeight);
            b2Vec2 bodyPos = tempPlat.body->GetPosition();
            
            tempPlat.body->SetTransform(b2Vec2(bodyPos.x, tempPlat.finalHeight/PTM_RATIO), 0.0);
            tempPlat.readyToMove = YES;
        }
    }
    
    for (int i = 0; i < [visibleSidePlatforms count]; i++) {
        Platform *tempSide = [visibleSidePlatforms objectAtIndex:i];
        
        b2Vec2 bodyPos = tempSide.body->GetPosition();
        tempSide.body->SetTransform(b2Vec2(bodyPos.x - (speed*dt/PTM_RATIO), bodyPos.y), 0.0);
        
        float distanceRemaining = tempSide.finalHeight - tempSide.position.y;
        
        if ((tempSide.position.y < tempSide.finalHeight) && tempSide.readyToMove == NO) {
            b2Vec2 bodyPos = tempSide.body->GetPosition();
            //tempSide.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*2*dt/PTM_RATIO)), 0.0);
            tempSide.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed/25.0*distanceRemaining*dt/PTM_RATIO)), 0.0);
        } else {
            tempSide.position = ccp(tempSide.position.x, tempSide.finalHeight);
            b2Vec2 bodyPos = tempSide.body->GetPosition();
            
            tempSide.body->SetTransform(b2Vec2(bodyPos.x, tempSide.finalHeight/PTM_RATIO), 0.0);
            tempSide.readyToMove = YES;
        }
    }
    
    [self cleanPlatforms];
}

-(void) cleanPlatforms {
    for (int i = 0; i < [visiblePlatforms count]; i++) {
        Platform *tempPlat = [visiblePlatforms objectAtIndex:i];
        if (!tempPlat.body->IsActive() || tempPlat.position.x < -winSize.width/4) {
            [tempPlat despawn];
            [visiblePlatforms removeObject:tempPlat];
        }
    }
    
    for (int i = 0; i < [visibleSidePlatforms count]; i++) {
        Platform *tempSide = [visibleSidePlatforms objectAtIndex:i];
        if (!tempSide.body->IsActive() || tempSide.position.x < -winSize.width/4) {
            [tempSide despawn];
            [visibleSidePlatforms removeObject:tempSide];
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
    
    for (int i = 0; i < [visibleSidePlatforms count]; i++) {
        Platform *tempSide = [visibleSidePlatforms objectAtIndex:i];
        [tempSide despawn];
    }
    [visibleSidePlatforms removeAllObjects];
    
    previousPlatformFinalHeight = winSize.height*0.2;
    
    //platformCounter = 0;
    
}

@end
