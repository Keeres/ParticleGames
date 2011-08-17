//
//  VolcanoFireball.m
//  mushroom
//
//  Created by Steven Chen on 8/9/11.
//  Copyright 2011 UIUC. All rights reserved.
//

#import "VolcanoFireball.h"


@implementation VolcanoFireball

@synthesize hasLanded;
@synthesize isLanding;
@synthesize rockSpeed;
@synthesize rockSensorBody;

-(void) createSensorWithWorld:(b2World *)world{
    b2BodyDef bodydef;
    bodydef.type = b2_dynamicBody;
    bodydef.position = b2Vec2(0,0);
    bodydef.isGravitated = false;
    body = world->CreateBody(&bodydef);
    body->SetUserData(self);

    b2CircleShape shape;
    shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.density = 0.05;
    fixtureDef.shape = &shape;
    fixtureDef.filter.categoryBits = kCategoryStageEffect;
    fixtureDef.filter.maskBits = kMaskStageEffect;
    fixtureDef.filter.groupIndex = kGroupStageEffect;
    fixtureDef.isSensor = true;
    
    RockSensor = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}

-(void) spawn:(CGPoint)location{
    CCLOG(@"rock spawned");
    self.visible = YES;
    self.hasLanded = FALSE;
    self.position = location;
    self.isLanding = FALSE;
     body->SetActive(YES);
    self.characterState = kStateSpawning;
     [self changeState:kStateSpawning];
    landingOffset = 0;
      body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
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
        case kStateFlying:{
            //insert animation here
            break;
        case kStateLanding:
            //insert landing animation here
            break;
        case kStateDead:
            [self despawn];
            
        default:
            break;
        }
    }
    if (action != nil) {
        [self runAction:action];
    }
}


-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects {
    //   CGSize winSize = [CCDirector sharedDirector].winSize;

    if(self.characterState == kStateSpawning)
        [self changeState:kStateFlying];
    else if(isLanding == TRUE){
        b2Vec2 rockPosition = self.body->GetPosition();
        self.body->SetTransform(b2Vec2(rockPosition.x + rockSpeed*deltaTime/PTM_RATIO, rockPosition.y - 10.0f/PTM_RATIO), 0.0);
        [self changeState:kStateLanding];
        
        //landing offset provides a smoother landing, matches falling speed until it is at a certain distance below platform then turns off all movements
        landingOffset += 10.0f;
        if(landingOffset >= 30.0f){
            CCLOG(@"Landed");
            self.hasLanded = TRUE;
            self.isLanding = FALSE;
            landingOffset = 0;
        }
    }
    else if(self.characterState == kStateFlying){
    //CCLOG(@"time update");
       // [self changeState:kStateFlying];
        b2Vec2 rockPosition = self.body->GetPosition();
        self.body->SetTransform(b2Vec2(rockPosition.x + rockSpeed*deltaTime/PTM_RATIO, rockPosition.y - 10/PTM_RATIO), 0.0);
    }
        
}

-(id) initWithWorld:(b2World *)world {
    if((self=[super init])) {
       type = kVolcanoType;
        
     // [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"RockAirTemp.png"]];
        
        //place holder
         [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:  @"red_mushroom_jump_1.png"]];
 
        [self createSensorWithWorld:world];
        hasLanded = NO;
        isLanding = NO;
        self.visible = NO;
    }
    return self;
}

-(void) despawn {
    body->SetActive(NO);
    self.visible = NO;
    self.hasLanded = NO;
    self.isLanding = NO;
}
        
-(void) dealloc{
    [super dealloc];
}
@end
