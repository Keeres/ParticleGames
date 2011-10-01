//
//  Bee.mm
//  mushroom
//
//  Created by Kelvin on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bee.h"

@implementation Bee

@synthesize isHit;
@synthesize blueColor;
@synthesize onLeftSide;
@synthesize blueFlyAnim;
@synthesize redFlyAnim;
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
    
    beeFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}

-(void) initAnimations {
    [self setBlueFlyAnim:[self loadPlistForAnimationWithName:@"blueFlyingAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:blueFlyAnim name:@"blueFlyingAnim"];
    
    [self setRedFlyAnim:[self loadPlistForAnimationWithName:@"redFlyingAnim" andClassName:NSStringFromClass([self class])]];
    [[CCAnimationCache sharedAnimationCache] addAnimation:redFlyAnim name:@"redFlyingAnim"];
    
}

-(id) initWithWorld:(b2World *)world {
    if((self=[super init])) {
        type = kBeeType;
        NSString *beeFrameName = @"blue_bee_flying_1.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:beeFrameName]];
        [self createBodyWithWorld:world];
        blueColor = YES;
        onLeftSide = NO;
        self.visible = NO;
        isTouchingGround = NO;
        isHit = NO;
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
    self.visible = YES;
    self.isBurning = NO;
    self.isFrozen = NO;
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
        case kStateSpawning:
            break;
        case kStateFlying: {
            if (blueColor) {
                CCAnimate *flying = [CCAnimate actionWithAnimation:blueFlyAnim restoreOriginalFrame:NO];
                action = [CCRepeatForever actionWithAction:[CCSequence actions:flying, nil]];
            } else {
                CCAnimate *flying = [CCAnimate actionWithAnimation:redFlyAnim restoreOriginalFrame:NO];
                action = [CCRepeatForever actionWithAction:[CCSequence actions:flying, nil]];
            }
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
            self.body->ApplyForce(b2Vec2(0, 15), self.body->GetPosition());
            
            action = [CCSequence actions:moveBy, [CCCallFunc actionWithTarget:self selector:@selector(despawn)], nil];
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

-(float) calculateForceToFly:(b2Body*)beeBody atTime:(ccTime)dt {
    b2Vec2 velocityOfBody = beeBody->GetLinearVelocity();
    
    float massOfBody = beeBody->GetMass();
    float force;
    
    float currentYVector = -velocityOfBody.y;
    //float finalYVector = 0.0;
    //float differenceYVector = (finalYVector - currentYVector);
    //force = (massOfBody * differenceYVector)/dt;
    force = (massOfBody * currentYVector)/dt;
    return force;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {
    if (self.isHit) {
        [self changeState:kStateDead];
    }
    
    else if (self.isBurning) {
        [self changeState:kStateBurning];
    }
    
    else if (self.isFrozen){
        [self changeState:kStateFrozen];
    }
    
    else if (self.characterState != kStateDead) {
        [self changeState:kStateFlying];
        b2Vec2 beePosition = self.body->GetPosition();
        if (onLeftSide) {
            self.flipX = YES;
            self.body->SetTransform(b2Vec2(beePosition.x+(speed+100.0)*deltaTime/PTM_RATIO, beePosition.y), 0.0);
        } else {
            self.flipX = NO;
            self.body->SetTransform(b2Vec2(beePosition.x-100.0*deltaTime/PTM_RATIO, beePosition.y), 0.0);
        }
        
        //float force = [self calculateForceToFly:self.body atTime:deltaTime];
        //self.body->ApplyForce(b2Vec2(0.0, force), self.body->GetPosition());
    }
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
