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
@synthesize basePlayerScale;
@synthesize jumpTime;

-(void) createBodyWithWorld:(b2World*)world {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(winSize.width/2/PTM_RATIO, winSize.height/2/PTM_RATIO);
    bodyDef.allowSleep = false;
    //bodyDef.fixedRotation = true;
    //bodyDef.isGravitated = false;
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    //body->SetUserData(NULL);
    
    b2CircleShape shape;        
    shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.01;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    //fixtureDef.filter.categoryBits = kCategoryMushroom;
    //fixtureDef.filter.maskBits = kMaskMushroom;
    //fixtureDef.filter.groupIndex = kGroupMushroom;
    
    playerFixture = body->CreateFixture(&fixtureDef);    
    
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

-(id) initWithWorld:(b2World*)world {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        NSString *playerFrameName = @"player.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:playerFrameName]];
        
        //Initialize Variables
        isJumping = NO;
        doubleJumpAvailable = NO;
        previousPosition = self.position;
        self.tag = kPlayerType;
        
        [self createBodyWithWorld:world];
    }
    return self;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {
    previousPosition = openGLPosition;
    openGLPosition = [[CCDirector sharedDirector] convertToGL:self.position];

    //rotate player while moving
    /*static float degree = 0;
    degree += 270*deltaTime;
    if (degree > 360) {
        degree = 0;
    }
    self.rotation += degree;*/
    
    if (isJumping) {
        jumpTime += deltaTime;
        self.body->ApplyForce(b2Vec2(0.0, 5.0/PTM_RATIO), self.body->GetPosition());
        b2Vec2 velocity = self.body->GetLinearVelocity();
        if (velocity.y > 5.0) {
            self.body->SetLinearVelocity(b2Vec2(velocity.x, 5.0));
        }
        if (jumpTime > 0.20) {
           isJumping = NO;
        }
    }
    
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

-(void) dealloc {
    [super dealloc];
}


@end
