//
//  Jumper.mm
//  mushroom
//
//  Created by Kelvin on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Jumper.h"

@implementation Jumper

@synthesize isHit;
@synthesize blueColor;
@synthesize blueJumpAnim;
@synthesize blueLandAnim;
@synthesize redJumpAnim;
@synthesize redLandAnim;
@synthesize isBurning;
@synthesize isFrozen;

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
    
    jumperFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}

-(void) initAnimations {
    [self setBlueJumpAnim:[self loadPlistForAnimationWithName:@"blueJumpAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueJumpAnim name:@"blueJumpAnim"];
    
    [self setRedJumpAnim:[self loadPlistForAnimationWithName:@"redJumpAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redJumpAnim name:@"redJumpAnim"];
    
    [self setBlueLandAnim:[self loadPlistForAnimationWithName:@"blueLandAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueLandAnim name:@"blueLandAnim"];
    
    [self setRedLandAnim:[self loadPlistForAnimationWithName:@"redLandAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redLandAnim name:@"redLandAnim"];
}

-(id) initWithWorld:(b2World *)world {
    if((self=[super init])) {
        type = kJumperType;
        NSString *jumperFrameName = @"blue_jumper_jump_1.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:jumperFrameName]];
        [self createBodyWithWorld:world];
        blueColor = YES;
        self.visible = NO;
        self.isTouchingGround = NO;
        self.isHit = NO;
        self.isFrozen = NO;
        jumpTimer = 0.0;
        self.scale = 1;
        
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
    jumpTimer = 0.0;

    self.visible = YES;
    self.characterState = kStateNone;
    [self changeState:kStateSpawning];
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
        case kStateSpawning: {
            self.isTouchingGround = NO;
            if (blueColor) {
                action = [CCAnimate actionWithAnimation:blueJumpAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:redJumpAnim restoreOriginalFrame:NO];
            }
            break;
        }
        case kStateJumping: {
            self.isTouchingGround = NO;
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
            jumpTimer = 0.0;
            break;
        }
            
        case kStateBurning: {
            [self despawn];
           break;
        }
          
        case kStateFrozen: {
            //insert frozen animation
            self.body->SetLinearVelocity(b2Vec2(0, 0));

                setBodyMask(self.body, kMaskStageEffect);
            CCMoveBy *moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 100)];
            self.body->ApplyForce(b2Vec2(0,15), self.body->GetPosition());
            
            action = [CCSequence actions:moveBy, [CCCallFunc actionWithTarget:self selector:@selector(despawn)], nil];
;
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
     jumpTimer += deltaTime;
    if (self.isHit) {
        [self changeState:kStateDead];
    }
    
    else if (self.isBurning){
        [self changeState:kStateBurning];
    }
    
    else if (self.isFrozen){
        [self changeState:kStateFrozen];
    }
    
    else if (self.isTouchingGround) {
        [self changeState:kStateLanding];
        if (jumpTimer > 1.0) {
                self.body->ApplyLinearImpulse(b2Vec2(0.0,15.0/PTM_RATIO), self.body->GetPosition());
                [self changeState:kStateJumping];
            }
    }
    
    else if (!self.isTouchingGround && self.characterState == kStateJumping) {
        b2Vec2 jumperPosition = self.body->GetPosition();
        self.body->SetTransform(b2Vec2(jumperPosition.x-50.0*deltaTime/PTM_RATIO, jumperPosition.y), 0.0);
    }
    
  /* if (jumpTimer > 1.0) {
        if (self.isTouchingGround) {
            self.body->ApplyLinearImpulse(b2Vec2(0.0,15.0/PTM_RATIO), self.body->GetPosition());
            [self changeState:kStateJumping];
        }
    }*/
}

-(void) despawn {
    body->SetLinearVelocity(b2Vec2(0.0, 0.0));
    body -> SetActive(NO);
    self.visible = NO;
    self.isHit = NO;
    self.isBurning = NO;
    self.isFrozen = NO;
    setBodyMask(self.body, kMaskEnemy);
}

-(void) dealloc {
    [super dealloc];
}

@end
