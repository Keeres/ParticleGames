//
//  Mushroom.mm
//  mushroom
//
//  Created by Kelvin on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Mushroom.h"
#import "GameActionLayer.h"

@implementation Mushroom

@synthesize type;
@synthesize mushroomJumped;
@synthesize mushroomJumpStarted;
@synthesize mushroomReady;
@synthesize gameStarted;
@synthesize hitPlatformSide;
@synthesize hitByTurtle;
@synthesize hitByBee;
@synthesize hitByJumper;
@synthesize hitEnemy;
@synthesize eating;
@synthesize cramping;
@synthesize blueColor;
@synthesize mushroomStartPositionX;
@synthesize mushroomStartHeight;
@synthesize mushroomCurrentHeight;
@synthesize mushroomMaxEndHeight;
@synthesize speed;

@synthesize blueWalkAnim;
@synthesize blueJumpAnim;
@synthesize blueLandAnim;
@synthesize blueHitAnim;
@synthesize blueGetHitAnim;
@synthesize blueSpawnAnim;
@synthesize blueEatAnim;
@synthesize blueCrampAnim;
@synthesize redWalkAnim;
@synthesize redJumpAnim;
@synthesize redLandAnim;
@synthesize redHitAnim;
@synthesize redGetHitAnim;
@synthesize redSpawnAnim;
@synthesize redEatAnim;
@synthesize redCrampAnim;

-(void) createBodyWithWorld:(b2World*)world {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(0.0, 0.0);
    bodyDef.allowSleep = false;
    bodyDef.fixedRotation = true;
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2CircleShape shape;        
    shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.01;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    fixtureDef.filter.categoryBits = kCategoryMushroom;
    fixtureDef.filter.maskBits = kMaskMushroom;
    fixtureDef.filter.groupIndex = kGroupMushroom;
    
    mushroomFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
    
    
    //Create Sensor
    //b2PolygonShape sensorShape;
    //sensorShape.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/8/PTM_RATIO, b2Vec2(0, -self.contentSize.height/2/PTM_RATIO), 0);
    //sensorShape.SetAsBox(self.contentSize.width/6/PTM_RATIO, self.contentSize.height/2/PTM_RATIO, b2Vec2(self.contentSize.width/2/PTM_RATIO,0), 0);
    //sensorShape.SetAsBox(25.0/PTM_RATIO, 6.25/PTM_RATIO, b2Vec2(0, -50/2/PTM_RATIO),0);
    //sensorShape.SetAsBox(50/8/PTM_RATIO, 6.25/PTM_RATIO, b2Vec2(50.0/4/PTM_RATIO, -50/2/PTM_RATIO),0);
    //fixtureDef.shape = &sensorShape;
    //fixtureDef.density = 0.0;
    //fixtureDef.isSensor = true;
    //mushroomSensor = body->CreateFixture(&fixtureDef);
}

-(void) initAnimations {
    [self setBlueWalkAnim:[self loadPlistForAnimationWithName:@"blueWalkingAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueWalkAnim name:@"blueWalkingAnim"];
    
    [self setBlueJumpAnim:[self loadPlistForAnimationWithName:@"blueJumpAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueJumpAnim name:@"blueJumpAnim"];
    
    [self setBlueLandAnim:[self loadPlistForAnimationWithName:@"blueLandAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueLandAnim name:@"blueLandAnim"];
    
    [self setBlueHitAnim:[self loadPlistForAnimationWithName:@"blueHitAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueHitAnim name:@"blueHitAnim"];
    
    [self setBlueGetHitAnim:[self loadPlistForAnimationWithName:@"blueGetHitAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueGetHitAnim name:@"blueGetHitAnim"];
    
    [self setBlueSpawnAnim:[self loadPlistForAnimationWithName:@"blueSpawnAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueSpawnAnim name:@"blueSpawnAnim"];
    
    [self setBlueEatAnim:[self loadPlistForAnimationWithName:@"blueEatAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueEatAnim name:@"blueEatAnim"];
    
    [self setBlueCrampAnim:[self loadPlistForAnimationWithName:@"blueCrampAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueCrampAnim name:@"blueCrampAnim"];
    
    [self setRedWalkAnim:[self loadPlistForAnimationWithName:@"redWalkingAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redWalkAnim name:@"redWalkingAnim"];
    
    [self setRedJumpAnim:[self loadPlistForAnimationWithName:@"redJumpAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redJumpAnim name:@"redJumpAnim"];
    
    [self setRedLandAnim:[self loadPlistForAnimationWithName:@"redLandAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redLandAnim name:@"redLandAnim"];
    
    [self setRedHitAnim:[self loadPlistForAnimationWithName:@"redHitAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redHitAnim name:@"redHitAnim"];
    
    [self setRedGetHitAnim:[self loadPlistForAnimationWithName:@"redGetHitAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redGetHitAnim name:@"redGetHitAnim"];
    
    [self setRedSpawnAnim:[self loadPlistForAnimationWithName:@"redSpawnAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redSpawnAnim name:@"redSpawnAnim"];
    
    [self setRedEatAnim:[self loadPlistForAnimationWithName:@"redEatAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redEatAnim name:@"redEatAnim"];
    
    [self setRedCrampAnim:[self loadPlistForAnimationWithName:@"redCrampAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redCrampAnim name:@"redCrampAnim"];
}

-(id) initWithWorld:(b2World*)world {
    if ((self = [super init])) {
        
        NSString *mushroomFrameName = @"red_mushroom_run_1.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:mushroomFrameName]];
        [self createBodyWithWorld:world];
        self.visible = NO;
        
        type = kColorMushroomType;
        isTouchingGround = NO;
        mushroomJumped = NO;
        mushroomJumpStarted = NO;
        mushroomReady = NO;
        gameStarted = NO;
        hitPlatformSide = NO;
        hitByTurtle = NO;
        hitByBee = NO;
        hitByJumper = NO;
        hitEnemy = NO;
        eating = NO;
        cramping = NO;
        blueColor = NO;
        //self.scale = 0.75;
        self.scale = 1.0;
        self.flipX = NO;
        self.characterState = kStateNone;
        
        mushroomStartHeight = 0.0;
        mushroomCurrentHeight = 0.0;
        mushroomMaxEndHeight = 0.0;
        speed = 0.0;
        
        [self initAnimations];
    }
    return self;
}

-(void) spawn:(CGPoint)location withColor:(BOOL)color {
    body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
    body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    self.position = location;
    self.visible = YES;
    
    b2Filter tempFilter;
    for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()) {
        f->GetFilterData();
        tempFilter.categoryBits = kCategoryMushroom;
        tempFilter.maskBits = kMaskMushroom;
        tempFilter.groupIndex = kGroupMushroom;
        f->SetFilterData(tempFilter);
    }
    
    isTouchingGround = NO;
    mushroomJumped = NO;
    mushroomJumpStarted = NO;
    mushroomReady = NO;
    hitPlatformSide = NO;
    hitByTurtle = NO;
    hitByBee = NO;
    hitByJumper = NO;
    hitEnemy = NO;
    eating = NO;
    cramping = NO;
    blueColor = color;
    
    msTimeSpentIdle = 0.0;
    
    self.characterState = kStateNone;
    [self changeState:kStateSpawning];
    
    body->SetActive(YES);
}

-(void) despawn {
    body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    body->SetActive(NO);
    self.visible = NO;
}

-(void) changeState:(CharacterStates)newState {
    if (self.characterState == newState) {
        return;
    }
    
    [self stopAllActions];
    id action = nil;
    self.characterState = newState;
    
    switch (newState) {
        case kStateIdle:
            break;
            
        case kStateSpawning: {
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueSpawnAnim restoreOriginalFrame:NO];
            } else if (!blueColor) {
                action = [CCAnimate actionWithAnimation:redSpawnAnim restoreOriginalFrame:NO];
            }
            break;
        }
            
        case kStateWalking: {
            //mushroomReady = YES;
            CCAnimate *walking;
            
            if (blueColor) {
                walking = [CCAnimate actionWithAnimation:blueWalkAnim restoreOriginalFrame:NO];
            } else {
                walking = [CCAnimate actionWithAnimation:redWalkAnim restoreOriginalFrame:NO];
            }
            action = [CCRepeatForever actionWithAction:[CCSequence actions:walking, nil]];
            break;
        }
            
        case kStateJumping:{
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueJumpAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:redJumpAnim restoreOriginalFrame:NO];
            }
            break;
        }
            
        case kStateLanding: {
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueLandAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:redLandAnim restoreOriginalFrame:NO];
            }
            break;
        }
            
        case kStateChange: {
            if (blueColor) {
                blueColor = NO;
                //[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"red_mushroom_run_1.png"]];                
                action = [CCAnimate actionWithAnimation:redJumpAnim restoreOriginalFrame:NO];
                
                
            } else {
                blueColor = YES;
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"blue_mushroom_run_1.png"]];
                action = [CCAnimate actionWithAnimation:blueJumpAnim restoreOriginalFrame:NO];
                
            }
            break;
        }
            
        case kStateHitWall:
            if (blueColor) {
                action = [CCRepeatForever actionWithAction:[CCSequence actions:[CCRotateBy actionWithDuration:-0.5f angle:360], nil]];
            } else {
                action = [CCRepeatForever actionWithAction:[CCSequence actions:[CCRotateBy actionWithDuration:-0.5f angle:360], nil]];
            }
            break;
            
        case kStateTakeHitByTurtle: {
            b2Vec2 mushroomVel = self.body->GetLinearVelocity();
            self.body->SetLinearVelocity(b2Vec2(0.0, mushroomVel.y));
            
            float randomXVel = arc4random() % 20;
            if (randomXVel < 10) {
                randomXVel = 10;
            }
            float randomYVel = (arc4random() % 10) + 13;
            self.body->ApplyLinearImpulse(b2Vec2(-randomXVel/PTM_RATIO, randomYVel/PTM_RATIO), self.body->GetPosition());
            
            b2Vec2 vel = self.body->GetLinearVelocity();
            
            if (blueColor) {
                action = [CCRepeatForever actionWithAction:[CCSequence actions:[CCAnimate actionWithAnimation:blueGetHitAnim restoreOriginalFrame:NO], [CCRotateBy actionWithDuration:-2.5f angle:360], nil]];
            } else {
                action = [CCRepeatForever actionWithAction:[CCSequence actions:[CCAnimate actionWithAnimation:redGetHitAnim restoreOriginalFrame:NO], [CCRotateBy actionWithDuration:-2.5f angle:360], nil]];
            }
            break;
        }
            
        case kStateTakeHitByBee: {
            if (blueColor) {
                CCAnimate *getHit = [CCAnimate actionWithAnimation:blueGetHitAnim restoreOriginalFrame:NO];
                action = [CCSequence actions:getHit, [CCCallFunc actionWithTarget:self selector:@selector(despawn)], nil];
            } else {
                CCAnimate *getHit = [CCAnimate actionWithAnimation:redGetHitAnim restoreOriginalFrame:NO];
                action = [CCSequence actions:getHit, [CCCallFunc actionWithTarget:self selector:@selector(despawn)], nil];            }
            break;
        }
            
        case kStateTakeHitByJumper: {
            if (blueColor) {
                CCAnimate *getHit = [CCAnimate actionWithAnimation:blueGetHitAnim restoreOriginalFrame:NO];
                action = [CCSequence actions:getHit, [CCCallFunc actionWithTarget:self selector:@selector(despawn)], nil];
            } else {
                CCAnimate *getHit = [CCAnimate actionWithAnimation:redGetHitAnim restoreOriginalFrame:NO];
                action = [CCSequence actions:getHit, [CCCallFunc actionWithTarget:self selector:@selector(despawn)], nil];            }
            break;
        }
            
        case kStateCauseHit: {
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueHitAnim restoreOriginalFrame:NO];
                
            } else {
                action = [CCAnimate actionWithAnimation:redHitAnim restoreOriginalFrame:NO];
            }
            self.hitEnemy = NO;
            break;
        }
            
        case kStateEating: {
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueEatAnim restoreOriginalFrame:NO];
                
            } else {
                action = [CCAnimate actionWithAnimation:redEatAnim restoreOriginalFrame:NO];
            }
            break;
        }
            
        case kStateCramping: {
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueCrampAnim restoreOriginalFrame:NO];
                
            } else {
                action = [CCAnimate actionWithAnimation:redCrampAnim restoreOriginalFrame:NO];
            }
            break;
            
        }
        case kStateDead:
            [self despawn];
            break;
            
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {        
    if (self.characterState == kStateDead) {
        return;
    }
    
    
    if (!self.hitPlatformSide && !self.hitByTurtle && !self.hitByBee && !self.hitByJumper && self.gameStarted && self.mushroomReady) {
        
        b2Vec2 mushroomVel = self.body->GetLinearVelocity();
        self.body->SetLinearVelocity(b2Vec2(speed/PTM_RATIO, mushroomVel.y));
        if (self.isTouchingGround && !self.eating && !self.cramping) {
            if ([self numberOfRunningActions] == 0) {
                [self changeState:kStateWalking];
            }    
        }    
    }
    
    if (self.hitPlatformSide) {
        b2Vec2 mushroomVel = self.body->GetLinearVelocity();
        self.body->SetLinearVelocity(b2Vec2(-speed/PTM_RATIO, mushroomVel.y));
        [self changeState:kStateHitWall];
    }
    
    if (self.hitByTurtle) {
        [self changeState:kStateTakeHitByTurtle];
    }
    
    if (self.hitByBee) {
        [self changeState:kStateTakeHitByBee];
    }
    
    if (self.hitByJumper) {
        [self changeState:kStateTakeHitByJumper];
    }
    
    if (self.hitEnemy) {
        [self changeState:kStateCauseHit];
    }
    
    if (self.eating && !self.hitByTurtle && !self.hitByBee && !self.hitByJumper) {
        [self changeState:kStateEating];
    }
    
    if (self.cramping && !self.hitByTurtle && !self.hitByBee && !self.hitByJumper) {
        [self changeState:kStateCramping];
    }
    
    if ([self numberOfRunningActions] == 0) {
        if (self.characterState == kStateIdle) {
            msTimeSpentIdle += deltaTime;
            if (msTimeSpentIdle > kMushroomIdleTimer) {
                [self changeState:kStateSpawning];
                //change to a roar state
            }
        } else if (self.characterState == kStateSpawning || self.characterState == kStateChange || self.characterState == kStateLanding) {
            msTimeSpentIdle = 0.0;
            [self changeState:kStateIdle];
        }
    }
    
}

-(void) dealloc {
    
    [super dealloc];
}

@end
