//
//  Player.m
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize openGLPosition;
@synthesize previousPosition;
@synthesize isJumping;
@synthesize doubleJumpAvailable;
@synthesize died;
@synthesize platformNumber;
@synthesize basePlayerScale;
@synthesize jumpTime;

//CCAnimation
@synthesize runAnim;

-(void) createBodyWithWorld:(b2World*)world {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(0.2*winSize.width/PTM_RATIO, winSize.height/4/PTM_RATIO);
    bodyDef.allowSleep = false;
    //bodyDef.fixedRotation = true;
    //bodyDef.isGravitated = false;
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    //body->SetUserData(NULL);
    
    b2CircleShape shape;        
    //shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    shape.m_radius = (self.contentSize.height/2)/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.01;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    fixtureDef.filter.categoryBits = kCategoryPlayer;
    fixtureDef.filter.maskBits = kMaskPlayer;
    fixtureDef.filter.groupIndex = kGroupPlayer;
    
    playerFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
    
    //Create Sensor
    /*b2PolygonShape sensorShape;
    sensorShape.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/8/PTM_RATIO, b2Vec2(0, -self.contentSize.height/2/PTM_RATIO), 0);
    //sensorShape.SetAsBox(self.contentSize.width/6/PTM_RATIO, self.contentSize.height/2/PTM_RATIO, b2Vec2(self.contentSize.width/2/PTM_RATIO,0), 0);
    //sensorShape.SetAsBox(25.0/PTM_RATIO, 6.25/PTM_RATIO, b2Vec2(0, -50/2/PTM_RATIO),0);
    //sensorShape.SetAsBox(50/8/PTM_RATIO, 6.25/PTM_RATIO, b2Vec2(50.0/4/PTM_RATIO, -50/2/PTM_RATIO),0);
    fixtureDef.shape = &sensorShape;
    fixtureDef.density = 0.0;
    fixtureDef.isSensor = true;
    playerSensor = body->CreateFixture(&fixtureDef);*/
}

-(void) initAnimations {
    [self setRunAnim:[self loadPlistForAnimationWithName:@"runningAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:runAnim name:@"runningAnim"];
}

#pragma mark Initialize Player

-(id) initWithWorld:(b2World*)world {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        NSString *playerFrameName = @"cat_run_1.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:playerFrameName]];
        
        //Initialize Variables
        isJumping = NO;
        doubleJumpAvailable = NO;
        died = NO;
        platformNumber = 0;
        previousPosition = self.position;
        self.tag = kPlayerType;
        self.visible = NO;
        self.characterState = kStateNone;

        [self createBodyWithWorld:world];
        [self initAnimations];
    }
    return self;
}

-(void) changeState:(CharacterStates)newState {    
    if (self.characterState == newState) {
        return;
    }
    
    [self stopAllActions];
    id action = nil;
    self.characterState = newState;
    
    switch (newState) {
        case kStateRunning: {
            CCAnimate *running = [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO];
            action = [CCRepeatForever actionWithAction:[CCSequence actions:running, nil]];
            break;   
        }
            
        /*case kStateDead:
            [self despawn];
            break;*/
            
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andSpeed:(float)speed {
    previousPosition = openGLPosition;
    openGLPosition = [[CCDirector sharedDirector] convertToGL:self.position];
    b2Vec2 velocity = self.body->GetLinearVelocity();
    
    //Check to see if off screen
    //Reset to middle of screen 
    /*if (self.position.x < 10 || self.position.x > 470 || self.died) {
        self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
        self.body->SetTransform(b2Vec2(winSize.width/6/PTM_RATIO, winSize.height/2/PTM_RATIO), 0);
    }*/
    
    
    if (isTouchingGround && !self.died) {
        b2Vec2 velocity = self.body->GetLinearVelocity();
        self.body->SetLinearVelocity(b2Vec2(0.0, velocity.y));
        b2Vec2 position = self.body->GetPosition();
        
        if ([self numberOfRunningActions] == 0) {
            [self changeState:kStateRunning];
        }  
        //self.body->SetTransform(b2Vec2(position.x - speed*deltaTime/PTM_RATIO, position.y), 0);
    }

    if (self.died) {
        self.body->SetActive(NO);
        self.visible = NO;
    }
    
    if (self.position.x < -winSize.width/8 ||self.position.y < -winSize.height/8) {
        if (self.died == NO) {
            self.died = YES;
        }
    }
    
    if (isJumping) {
        jumpTime += deltaTime;

        self.body->ApplyForce(b2Vec2(0.0, jumpVelocity/PTM_RATIO), self.body->GetPosition());
        
        if (velocity.y > jumpVelocity) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, jumpVelocity));
        }
        
        if (jumpTime > 0.2) {
            isJumping = NO;
        }
    }
    
    //if (velocity.y < -jumpVelocity) {
    //    self.body->SetLinearVelocity(b2Vec2(velocity.x, -jumpVelocity));
    //}
    
    if (previousPosition.y > openGLPosition.y) {
        float playerScale = (previousPosition.y - openGLPosition.y)/100.0;
        if (basePlayerScale < 1) {
            basePlayerScale = basePlayerScale + playerScale;
        }
    }
    
    if (previousPosition.y < openGLPosition.y) {
        float playerScale = (previousPosition.y - openGLPosition.y)/100.0;
        if (basePlayerScale > 0.35) {
            basePlayerScale = basePlayerScale + playerScale;
        }
    }
    
    previousPlayerScale = basePlayerScale;
    
}

-(void) spawn {
    self.visible = YES;
    self.body->SetActive(YES);
}

-(void) despawn {
    self.visible = NO;
    self.body->SetActive(NO);
}

#pragma mark Reset Player

-(void) resetPlayer {
    isJumping = NO;
    doubleJumpAvailable = NO;
    died = NO;
    platformNumber = 0;
    previousPosition = self.position;
    self.characterState = kStateNone;

    self.body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    self.body->SetTransform(b2Vec2(0.2*winSize.width/PTM_RATIO, winSize.height/4/PTM_RATIO), 0);
    setBodyMask(self.body, kMaskPlayer);
    [self despawn];
}

-(void) dealloc {
    [super dealloc];
}


@end
