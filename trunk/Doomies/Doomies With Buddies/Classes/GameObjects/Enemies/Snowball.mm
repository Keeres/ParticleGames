//
//  Snowball.m
//  Doomies
//
//  Created by Steven Chen on 8/27/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "Snowball.h"
#import "Box2DHelpers.h"

@implementation Snowball
@synthesize snowballSensor;
@synthesize isHit;

- (void) createBodyWithWorld:(b2World *)world{
    b2BodyDef bodydef;
    bodydef.type = b2_dynamicBody;
    bodydef.position = b2Vec2(0,0);
    body = world->CreateBody(&bodydef);
    body -> SetUserData(self);
    
    b2CircleShape shape;
    shape.m_radius = (self.contentSize.width/2*0.9)/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.density = 0.05;
  //  fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    fixtureDef.shape = &shape;
    fixtureDef.filter.categoryBits = kCategoryStageEffect;
    fixtureDef.filter.maskBits = kMaskStageEffect;
    fixtureDef.filter.groupIndex = kGroupStageEffect;
    fixtureDef.isSensor = YES;
    snowballFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}

//creates a sensor that is slightly larger than body for improvement in detection system
-(void) createSensorWithWorld:(b2World *) world{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = body->GetPosition(); 
    snowballSensor = world -> CreateBody(&bodyDef);
    
    b2CircleShape shape;
    shape.m_radius = (self.contentSize.width/2*1.1)/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.density = 0.05;
    fixtureDef.shape = &shape;
    fixtureDef.filter.categoryBits = kCategoryStageEffect;
    fixtureDef.filter.maskBits = kMaskStageEffect;
    fixtureDef.filter.groupIndex = kGroupStageEffect;
    fixtureDef.isSensor = YES;
    snowballSensorFixture = snowballSensor->CreateFixture(&fixtureDef);
    
    b2WeldJointDef weldJointDef;
    weldJointDef.Initialize(body, snowballSensor, body->GetWorldCenter());
   // weldJointDef.Initialize(body, snowballSensor, body->GetPosition());
    world->CreateJoint(&weldJointDef); 

    snowballSensor->SetActive(NO);  
}

-(void) spawn:(CGPoint)location{
  //  CCLOG(@"snowball spawned");
    self.visible = YES;
    self.position = location;
    body->SetActive(YES);
    snowballSensor->SetActive(YES);
    self.characterState = kStateSpawning;
    [self changeState:kStateSpawning];
    
    body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
    snowballSensor->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
    body->SetAngularVelocity(30);
}

-(void) changeState:(CharacterStates) newState {
    if (self.characterState == newState) {
        return;
    }
    
    [self stopAllActions];
    id action = nil;
    self.characterState = newState;
    
    switch (newState) {
        case kStateSpawning:
            break;
        case kStateRolling:
            break;
        case kStateExplode:
            //insert exploding animation
            break;
        case kStateDead:
            [self despawn];
            
        default:
            break;
    
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {
if(self.isHit == TRUE)
    [self changeState:kStateExplode];
}


-(id) initWithWorld:(b2World *)world {
    if((self=[super init])) {
        type = kSnowType;
        
        //place holder
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:  @"snowball_temp.png"]];
        
        [self createBodyWithWorld:world];
        [self createSensorWithWorld:world];
        self.visible = NO;
    }
    return self;
}

-(void) despawn {
    body->SetActive(NO);
    self.visible = NO;
    snowballSensor->SetActive(NO);
    setBodyMask(self.body, kMaskStageEffect);

}

-(void) dealloc{
    [super dealloc];
}

@end




