//
//  MushroomCache.m
//  mushroom
//
//  Created by Kelvin on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MushroomCache.h"

@implementation MushroomCache

@synthesize totalMushrooms;
@synthesize visibleMushrooms;
@synthesize garbageMushrooms;
@synthesize isMushroomJumping;
@synthesize jumpJustBegan;
@synthesize blueColor;
@synthesize jumpPercentage;
@synthesize currentSpeed;

-(void) initMuchroomsInWorld:(b2World*)theWorld {
    totalMushrooms = [[CCArray alloc] initWithCapacity:kMaxMushroomType];
    visibleMushrooms = [[NSMutableArray alloc] init];
    int capacity = 6;
    
    for (int i = 0; i < capacity; i++) {
        Mushroom *mushroom = [[[Mushroom alloc] initWithWorld:theWorld] autorelease];
        [totalMushrooms addObject:mushroom]; 
    }
}

-(id) initWithWorld:(b2World*)theWorld withActionLayer:(GameActionLayer *)gameActionLayer {
	if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
        actionLayer = gameActionLayer;

		[self initMuchroomsInWorld:world];
        garbageMushrooms = [[NSMutableArray alloc] init];
        
        isMushroomJumping = NO;
        jumpJustBegan = NO;
        blueColor = NO;
        
        jumpPercentage = 0.2;
        currentSpeed = 200.0;
	}
	return self;
}

-(float) calculateForceForMushroom:(b2Body*)mushroomBody atTime:(ccTime)dt{
    b2Vec2 velocityOfBody = mushroomBody->GetLinearVelocity();
    float massOfBody = mushroomBody->GetMass();
    float force;
    
    float currentYVector = velocityOfBody.y;
    float finalYVector = kMushroomJumpYVector;
    float differenceYVector = (finalYVector - currentYVector);
    force = (massOfBody * differenceYVector)/dt;
    return force;
}

-(void) mushroomJump:(int)number withYForce:(float)yVector {
    b2Vec2 force = b2Vec2(0.0, yVector);
    Mushroom *mushroomSprite = [visibleMushrooms objectAtIndex:number];
    b2Body *mushroomBody = mushroomSprite.body;
    //b2Vec2 mushroomVelocity = mushroomBody->GetLinearVelocity();
    mushroomBody->ApplyForce(force, mushroomBody->GetWorldCenter());
}

-(void) mushroomPush:(b2Body*)mushroomBody withXForce:(float)xVector {
    b2Vec2 force = b2Vec2(xVector, 0.0);
    mushroomBody->ApplyForce(force, mushroomBody->GetPosition());
}

-(void) jumpCheck:(ccTime)dt {
    ///////////////////////////////////////
    //Check for jumping mushrooms
    //Jumping is based on distance traveled
    ///////////////////////////////////////
    
    for (int i = 0; i < [visibleMushrooms count]; i++) {
        if (i == 0) {
            Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
            
            if (isMushroomJumping) {
                if (jumpJustBegan) {
                    jumpJustBegan = NO;
                    tempMushroom.mushroomStartHeight = tempMushroom.position.y;
                    tempMushroom.mushroomCurrentHeight = tempMushroom.position.y;
                    tempMushroom.mushroomMaxEndHeight = tempMushroom.mushroomStartHeight + kMushroomMaxJumpingHeight;
                    [tempMushroom changeState:kStateJumping];
                }
                
                if (tempMushroom.mushroomCurrentHeight < tempMushroom.mushroomMaxEndHeight) {
                    tempMushroom.isTouchingGround = NO;
                    
                    float force = [self calculateForceForMushroom:tempMushroom.body atTime:dt];
                    [self mushroomJump:i withYForce:force];
                    
                    tempMushroom.mushroomCurrentHeight = tempMushroom.position.y;
                    
                    float percentageOfJump = (tempMushroom.mushroomCurrentHeight - tempMushroom.mushroomStartHeight)/(tempMushroom.mushroomMaxEndHeight - tempMushroom.mushroomStartHeight);
                    
                    if (([visibleMushrooms count] > (i+1)) && percentageOfJump > jumpPercentage) {
                        tempMushroom.mushroomJumped = YES;
                    }
                } else {
                    if ([visibleMushrooms count] > (i+1)) {
                        tempMushroom.mushroomJumped = YES;
                        tempMushroom.mushroomMaxEndHeight = tempMushroom.mushroomCurrentHeight;
                    }
                    [tempMushroom changeState:kStateLanding];
                    isMushroomJumping = NO;
                }
            }
        } else {
            
            Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
            Mushroom *frontMushroom = [visibleMushrooms objectAtIndex:(i-1)];
            
            if ([visibleMushrooms count] > i && frontMushroom.mushroomJumped && tempMushroom.mushroomReady) {
                if (tempMushroom.isTouchingGround) {
                    tempMushroom.mushroomStartHeight = tempMushroom.position.y;
                    tempMushroom.mushroomCurrentHeight = tempMushroom.position.y;
                    tempMushroom.mushroomMaxEndHeight = frontMushroom.mushroomStartHeight + kMushroomMaxJumpingHeight;
                    tempMushroom.mushroomJumpStarted = YES;
                    [tempMushroom changeState:kStateJumping];
                }
                
                b2Vec2 mushroomVelocity = tempMushroom.body->GetLinearVelocity();
                
                if (tempMushroom.mushroomCurrentHeight < frontMushroom.mushroomMaxEndHeight && mushroomVelocity.y >= -0.1) {
                    tempMushroom.isTouchingGround = NO;
                    float force = [self calculateForceForMushroom:tempMushroom.body atTime:dt];
                    [self mushroomJump:i withYForce:force];
                    
                    tempMushroom.mushroomCurrentHeight = tempMushroom.position.y;
                    
                    float percentageOfJump = (tempMushroom.mushroomCurrentHeight - tempMushroom.mushroomStartHeight)/(tempMushroom.mushroomMaxEndHeight - tempMushroom.mushroomStartHeight);
                    
                    if (([visibleMushrooms count] > (i+1)) && percentageOfJump > jumpPercentage && (i+1) != [visibleMushrooms count]) {
                        tempMushroom.mushroomJumped = YES;
                    }
                } else {
                    if (tempMushroom.mushroomJumpStarted) {
                        if ([visibleMushrooms count] > (i+1) && (i+1) != [visibleMushrooms count]) {
                            tempMushroom.mushroomJumped = YES;
                            tempMushroom.mushroomMaxEndHeight = tempMushroom.mushroomCurrentHeight;
                        }
                        [tempMushroom changeState:kStateLanding];
                        frontMushroom.mushroomJumped = NO;
                        tempMushroom.mushroomJumpStarted = NO;
                    }
                }
            }
        }
    }
}

-(void) pushMushroomForward:(Mushroom*)body2 toFrontMushroom:(Mushroom*)body1 atTime:(ccTime) dt {
    float mushroomRemainingDistance;
    if (body1 != NULL) {
        mushroomRemainingDistance = body1.position.x - body2.position.x;
    } else {
        mushroomRemainingDistance = winSize.width/2 - body2.position.x;
    }
    
    b2Vec2 mushroomVelocity = body2.body->GetLinearVelocity();
    //if (mushroomRemainingDistance > body2.contentSize.width) {
    if (mushroomRemainingDistance > body2.contentSize.width) {
        body2.body->SetTransform(b2Vec2((body2.position.x+(100.0*dt))/PTM_RATIO, body2.position.y/PTM_RATIO), 0);
    } else if (mushroomRemainingDistance < body2.contentSize.width - 2.0) {
        body2.body->SetTransform(b2Vec2((body2.position.x-(100.0*dt))/PTM_RATIO, body2.position.y/PTM_RATIO), 0);
    } else {
        return;
        //mushroomBody->SetLinearVelocity(b2Vec2(0.0, mushroomVelocity.y));
    }
}

-(void) lineSpaceCheck:(ccTime)dt withOffset:(float)newOffset {    
    offset = newOffset;
    for (int i = 0; i < [visibleMushrooms count]; i++) {
        Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
        Mushroom *frontMushroom;
        
        if (i > 0) {
            frontMushroom = [visibleMushrooms objectAtIndex:(i-1)];
        } else {
            frontMushroom = NULL;
        }
        
        if (tempMushroom.hitPlatformSide == NO) {
            if (i > 0 && (tempMushroom.isTouchingGround || tempMushroom.hitEnemy) && tempMushroom.mushroomReady) {
                [self pushMushroomForward:tempMushroom toFrontMushroom:frontMushroom atTime:dt];
                b2Vec2 mushroomVelocity = tempMushroom.body->GetLinearVelocity();
            } else {
                if (frontMushroom != NULL) {
                    float mushroomRemainingDistance = frontMushroom.position.x - tempMushroom.position.x;
                    
                    if ((mushroomRemainingDistance > tempMushroom.contentSize.width) && tempMushroom.isTouchingGround) {
                        tempMushroom.mushroomReady = YES;
                    }
                } else if (tempMushroom.isTouchingGround) {
                    tempMushroom.mushroomReady = YES;
                }
            }
        }
        
        if (tempMushroom.hitPlatformSide|| tempMushroom.hitByTurtle || tempMushroom.hitByBee || tempMushroom.hitByJumper) {
            [garbageMushrooms addObject:tempMushroom];
            [visibleMushrooms removeObjectAtIndex:i];
        }
    }
}

-(void) cleanMushrooms{
    for (int i = 0; i < [garbageMushrooms count]; i++) {
        Mushroom *tempMushroom = [garbageMushrooms objectAtIndex:i];
        if (tempMushroom.position.x < -winSize.width || tempMushroom.position.y < -winSize.height/2) {
            
            [tempMushroom changeState:kStateDead];
            [garbageMushrooms removeObjectAtIndex:i];
        }
    }
    
    for (int j = 0; j < [visibleMushrooms count]; j++) {
        Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:j];
        if (tempMushroom.position.x < -winSize.width || tempMushroom.position.y < -winSize.height/2) {

            [tempMushroom changeState:kStateDead];
            [visibleMushrooms removeObjectAtIndex:j];
        }
    }
}

- (void)dealloc {
    [totalMushrooms release];
    [visibleMushrooms release];
    [garbageMushrooms release];
    [super dealloc];
}

@end
