//
//  Turtle.mm
//  mushroom
//
//  Created by Kelvin on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Turtle.h"

@implementation Turtle

@synthesize isHit;
@synthesize blueColor;
@synthesize detectMushroom;
@synthesize blueWalkAnim;
@synthesize redWalkAnim;

-(void) createBodyWithWorld:(b2World*)world {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(0,0);
    bodyDef.allowSleep = false;
    bodyDef.fixedRotation = true;
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    //b2CircleShape shape;        
    //shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    b2PolygonShape shape;
    //shape.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.width/2/PTM_RATIO);
    shape.SetAsBox(20.0/PTM_RATIO, 20.0/PTM_RATIO);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.05;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    fixtureDef.filter.categoryBits = kCategoryEnemy;
    fixtureDef.filter.maskBits = kMaskEnemy;
    fixtureDef.filter.groupIndex = kGroupEnemy;
    
    turtleFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}

-(void) initAnimations {
    [self setBlueWalkAnim:[self loadPlistForAnimationWithName:@"blueWalkingAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueWalkAnim name:@"blueWalkingAnim"];
    
    [self setRedWalkAnim:[self loadPlistForAnimationWithName:@"redWalkingAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redWalkAnim name:@"redWalkingAnim"];
}

-(id) initWithWorld:(b2World *)world {
    if((self=[super init])) {
        type = kTurtleType;
        NSString *turtleFrameName = @"blue_turtle_walking_1.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:turtleFrameName]];
        [self createBodyWithWorld:world];
        blueColor = YES;
        detectMushroom = NO;
        self.visible = NO;
        isTouchingGround = NO;
        isHit = NO;
        self.scale = 1;
        self.flipX = YES;
        
        [self initAnimations];
    }
	return self;
}

-(void) spawn:(CGPoint)location {
    float random = arc4random() % 2;
    if (random) {
        blueColor = YES;
    } else {
        blueColor = NO;
    }
    body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
    body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    self.position = location;
    self.isHit = NO;
    self.detectMushroom = NO;
    self.visible = YES;
    self.characterState = kStateSpawning;
    body->SetActive(YES);
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
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueWalkAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:redWalkAnim restoreOriginalFrame:NO];
            }
            break;
            break;
            
        case kStateSpawning:
            break;
            
        case kStateWalking: {            
            if (blueColor) {
                //CCAnimate *walking = [CCAnimate actionWithAnimation:blueWalkAnim restoreOriginalFrame:NO];
                //action = [CCRepeatForever actionWithAction:[CCSequence actions:walking, nil]];
                action = [CCAnimate actionWithAnimation:blueWalkAnim restoreOriginalFrame:NO];
            } else {
                //CCAnimate *walking = [CCAnimate actionWithAnimation:redWalkAnim restoreOriginalFrame:NO];
                //action = [CCRepeatForever actionWithAction:[CCSequence actions:walking, nil]];
                action = [CCAnimate actionWithAnimation:redWalkAnim restoreOriginalFrame:NO];
            }
            break;
        }
        
        case kStateRam: {
            self.flipX = NO;
            if (blueColor) {
                CCAnimate *walking = [CCAnimate actionWithAnimation:blueWalkAnim restoreOriginalFrame:NO];
                action = [CCRepeatForever actionWithAction:[CCSequence actions:walking, nil]];
            } else {
                CCAnimate *walking = [CCAnimate actionWithAnimation:redWalkAnim restoreOriginalFrame:NO];
                action = [CCRepeatForever actionWithAction:[CCSequence actions:walking, nil]];
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
    if (self.isHit) {
        [self changeState:kStateDead];
    }
    
    if (self.isTouchingGround && !detectMushroom && self.characterState != kStateIdle) {
        b2Vec2 turtlePos = self.body->GetPosition();

        if (self.flipX) {
            self.body->SetTransform(b2Vec2(turtlePos.x + 30.0*deltaTime/PTM_RATIO, turtlePos.y), 0.0);
        } else {
            self.body->SetTransform(b2Vec2(turtlePos.x - 30.0*deltaTime/PTM_RATIO, turtlePos.y), 0.0);
        }
        [self changeState:kStateWalking];

    } else if (self.isTouchingGround && detectMushroom) {
        b2Vec2 turtlePos = self.body->GetPosition();
        self.body->SetTransform(b2Vec2(turtlePos.x - 450.0*deltaTime/PTM_RATIO, turtlePos.y), 0.0);

        [self changeState:kStateRam];
    }
    
    if ([self numberOfRunningActions] == 0) {
        if (self.characterState == kStateWalking) {
            [self changeState:kStateIdle];
        } else if (self.characterState == kStateIdle) {
            if (self.flipX) {
                self.flipX = NO;
            } else {
                self.flipX = YES;
            }
            [self changeState:kStateWalking];
        }
    }
}

-(void) despawn {
    body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    body -> SetActive(NO);
    self.visible = NO;
    self.isHit = NO;
    self.detectMushroom = NO;
    setBodyMask(self.body, kMaskEnemy);
}

-(void) dealloc {
    [super dealloc];
}

@end
