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
@synthesize keyPlatforms;
@synthesize visiblePlatforms;
@synthesize visibleSidePlatforms;
@synthesize initialPlatformsCreated;
@synthesize oldPlatform;
@synthesize nextPlatform;
@synthesize oldLongPlatformLength;
@synthesize oldShortPlatformLength;

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

        keyPlatforms = [[NSMutableArray alloc] init];
        visiblePlatforms = [[NSMutableArray alloc] init];
        visibleSidePlatforms = [[NSMutableArray alloc] init];
        initialPlatformsCreated = NO;
        previousPlatformFinalHeight = winSize.height*0.2;
        
        previousPlatformEndIndex = 0;
        currentPlatformIndex = 0;
        currentPlatformEndIndex = 0;
        
        longPlatformLength = 15;
        shortPlatformLength = 5;
        
        [self initPlatforms];
        [self initSidePlatforms];            
    }
    return self;
}

-(void) addStartingPlatform {
    oldLongPlatformLength = 3;

    for (int i = 0; i < 10; i++) {
        CCArray *platformOfType = [totalPlatforms objectAtIndex:0];
        for (int j = 0; j < [platformOfType count]; j++) {
            Platform *tempPlat;
            tempPlat = [platformOfType objectAtIndex:j];
            if (tempPlat.visible == NO) {
                CGPoint location;

                location = ccp(tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i), 0.2*winSize.height);
                
                tempPlat.position = location;
                tempPlat.finalHeight = 0.2*winSize.height;
                tempPlat.visible = YES;
                //tempPlat.platformNumber = platformCounter;
                tempPlat.body->SetActive(YES);
                tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                [visiblePlatforms addObject:tempPlat];
                
                if (i == 8) {
                    [keyPlatforms addObject:tempPlat];
                }
                
                //platformCounter++;
                nextPlatform = tempPlat;
                oldPlatform = tempPlat;
                oldLongPlatformLength = longPlatformLength;
                break;
            }
        }
    }
    initialPlatformsCreated = YES;
}

-(void) addLongPlatform {
    oldPlatform = nextPlatform;
    oldLongPlatformLength = longPlatformLength;
    
    int randomPlatform = 0;
    CCArray *platformOfType = [totalPlatforms objectAtIndex:randomPlatform];
    
    float randomHeight = (arc4random() % 3) * 15 + 15;
    BOOL isTopPlatformNext = arc4random() % 2;
    if (isTopPlatformNext && ((oldPlatform.position.y + randomHeight) < winSize.height/2)) {
        randomHeight = oldPlatform.position.y + randomHeight;
    } else if (!isTopPlatformNext && ((oldPlatform.position.y - randomHeight) > winSize.height*0.2)) {
        randomHeight = oldPlatform.position.y - randomHeight;
    } else {
        randomHeight = oldPlatform.position.y;
    }
    
    float differentX = 0.0;
    for (int i = 0; i < longPlatformLength; i++) {
        
        //Add side body
        if (i == 0) {
            for (int j = 0; j < [totalSidePlatforms count]; j++) {
                Platform *tempSide = [totalSidePlatforms objectAtIndex:j];
                
                if (!tempSide.body->IsActive()) {

                    CGPoint location = ccp(0.9*winSize.width - tempSide.contentSize.width/2.0 + ((tempSide.contentSize.width - 1)*i) + differentX, oldPlatform.position.y - winSize.height/2.0 - (tempSide.contentSize.width*i));
                    
                    tempSide.position = location;
                    tempSide.finalHeight = randomHeight;
                    tempSide.easyPlatform = 0;
                    tempSide.platformFinalPosition = CGPointMake(tempSide.position.x, randomHeight);
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
                
                CGPoint location = ccp(0.9*winSize.width - tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i) + differentX, oldPlatform.position.y - winSize.height/2 - (tempPlat.contentSize.width*i));
                
                tempPlat.position = location;
                tempPlat.finalHeight = randomHeight;
                tempPlat.easyPlatform = 0;
                tempPlat.visible = YES;
                tempPlat.body->SetActive(YES);
                tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                
                [visiblePlatforms addObject:tempPlat];
                
                if (i == (longPlatformLength - 2)) {
                    [keyPlatforms addObject:tempPlat];
                }
                
                if (i != 0 || i != (longPlatformLength - 1)) {
                    //tempPlat.platformNumber = platformCounter;
                    //platformCounter++;
                }
                
                nextPlatform = tempPlat;
                break;
            }
        }
    }    
}

-(void) addShortPlatform {
    oldPlatform = nextPlatform;
    oldShortPlatformLength = shortPlatformLength;
    
    int randomPlatform = 0;
    CCArray *platformOfType = [totalPlatforms objectAtIndex:randomPlatform];
    
    float randomHeight = (arc4random() % 3) * 15 + 15;
    BOOL isTopPlatformNext = arc4random() % 2;
    
    if (isTopPlatformNext && ((oldPlatform.position.y + randomHeight) < winSize.height/2)) {
        randomHeight = oldPlatform.position.y + randomHeight;
    } else if (!isTopPlatformNext && ((oldPlatform.position.y - randomHeight) > winSize.height*0.2)) {
        randomHeight = oldPlatform.position.y - randomHeight;
    } else {
        randomHeight = oldPlatform.position.y;
    }
    
    float differentX = 0.0;
    for (int i = 0; i < shortPlatformLength; i++) {
        
        //Add side body
        if (i == 0) {
            for (int j = 0; j < [totalSidePlatforms count]; j++) {
                Platform *tempSide = [totalSidePlatforms objectAtIndex:j];
                
                if (!tempSide.body->IsActive()) {

                    CGPoint location = ccp(0.9*winSize.width - tempSide.contentSize.width/2.0 + ((tempSide.contentSize.width - 1)*i) + differentX, oldPlatform.position.y - winSize.height/2.0 - (tempSide.contentSize.width*i));
                    
                    tempSide.position = location;
                    tempSide.finalHeight = randomHeight;
                    tempSide.easyPlatform = 0;
                    tempSide.platformFinalPosition = CGPointMake(tempSide.position.x, randomHeight);
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

                CGPoint location = ccp(0.9*winSize.width - tempPlat.contentSize.width/2 + ((tempPlat.contentSize.width - 1)*i) + differentX, oldPlatform.position.y - winSize.height/2 - (tempPlat.contentSize.width*i));
                
                tempPlat.position = location;
                tempPlat.finalHeight = randomHeight;
                tempPlat.easyPlatform = 0;
                tempPlat.visible = YES;
                tempPlat.body->SetActive(YES);
                tempPlat.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                
                [visiblePlatforms addObject:tempPlat];
                
                if (i == (shortPlatformLength - 2)) {
                    [keyPlatforms addObject:tempPlat];
                }
                
                if (i != 0 || i != (shortPlatformLength - 1)) {
                    //tempPlat.platformNumber = platformCounter;
                    //platformCounter++;
                }
                
                nextPlatform = tempPlat;
                break;
            }
        }
    }
}

-(void) updatePlatformsWithTime:(ccTime)dt andSpeed:(float)speed {
    if (speed > 100.0 && speed < 150.0) {
        longPlatformLength = 15;
        shortPlatformLength = 5;
    } else if (speed > 150.0 && speed < 200.0) {
        longPlatformLength = 12;
        shortPlatformLength = 4;
    } else if (speed > 200.0 && speed < 250.0) {
        longPlatformLength = 9;
        shortPlatformLength = 3;
    } else if (speed > 250.0) {
        longPlatformLength = 6;
        shortPlatformLength = 2;
    }
    
    for (int i = 0; i < [visiblePlatforms count]; i++) {
        Platform *tempPlat = [visiblePlatforms objectAtIndex:i];
        
        b2Vec2 bodyPos = tempPlat.body->GetPosition();
        tempPlat.body->SetTransform(b2Vec2(bodyPos.x - (speed*dt/PTM_RATIO), bodyPos.y), 0.0);
        
        float distanceRemaining = tempPlat.finalHeight - tempPlat.position.y;
        float speedMultiplier = 3.0;
        if (distanceRemaining < 30.0) {
            speedMultiplier = 1.5;
        }
        
        if ((tempPlat.position.y < tempPlat.finalHeight) && tempPlat.readyToMove == NO) {
            b2Vec2 bodyPos = tempPlat.body->GetPosition();
            tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*speedMultiplier*dt/PTM_RATIO)), 0.0);
            //tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*3*dt/PTM_RATIO)), 0.0);
            //tempPlat.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed/25.0*distanceRemaining*dt/PTM_RATIO)), 0.0);
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
        float speedMultiplier = 3.0;
        if (distanceRemaining < 30.0) {
            speedMultiplier = 1.5;
        }
        
        if ((tempSide.position.y < tempSide.finalHeight) && tempSide.readyToMove == NO) {
            b2Vec2 bodyPos = tempSide.body->GetPosition();
            tempSide.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*speedMultiplier*dt/PTM_RATIO)), 0.0);
            //tempSide.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed*3*dt/PTM_RATIO)), 0.0);
            //tempSide.body->SetTransform(b2Vec2(bodyPos.x, bodyPos.y + (speed/25.0*distanceRemaining*dt/PTM_RATIO)), 0.0);
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
    [keyPlatforms removeAllObjects];
    previousPlatformFinalHeight = winSize.height*0.2;
    longPlatformLength = 20;
    shortPlatformLength = 6;

    //platformCounter = 0;
    
}

@end
