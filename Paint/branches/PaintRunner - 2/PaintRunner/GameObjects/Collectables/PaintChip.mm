//
//  PaintChip.mm
//  PaintRunner
//
//  Created by Kelvin on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintChip.h"

@implementation PaintChip

@synthesize isHit;
@synthesize isSpawning;
@synthesize isIdle;

-(void) createBody {
    b2BodyDef bodyDef;
   // bodyDef.type = b2_dynamicBody;
    bodyDef.type = b2_staticBody;
    bodyDef.position = b2Vec2(0.0, 0.0);
    bodyDef.allowSleep = false;
    bodyDef.fixedRotation = true;
    //bodyDef.isGravitated = false;
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2CircleShape shape;        
    shape.m_radius = (self.contentSize.width/2)/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    
    fixtureDef.filter.categoryBits = kCategoryEnemy;
    fixtureDef.filter.maskBits = kMaskEnemy;
    fixtureDef.filter.groupIndex = kGroupEnemy;
    fixtureDef.density = 0.01;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    
    paintChipFixture = body->CreateFixture(&fixtureDef);
    body->SetActive(NO);
}


-(id) initWithWorld:(b2World*)theWorld {
    if ((self = [super init])) {
        world = theWorld;
        
        NSString *paintChipFrameName = @"brush.png";
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:paintChipFrameName]];
        
        self.tag = kPaintChipType;
        self.visible = NO;
        self.isHit = NO;
        self.isSpawning = NO;
        self.isIdle = NO;
        self.scale = 0.0;
        
        [self createBody];
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions]; 
    id action = nil; 

    [self setCharacterState:newState];
    switch (newState) {
        case kStateSpawning:
            self.scale = 0.0;
            action = [CCSequence actions:[CCScaleTo actionWithDuration:0.25 scale:1.5], [CCScaleTo actionWithDuration:0.25 scale:1.0], nil];
                     
            self.isSpawning = NO;
            self.isIdle = YES;
            break;
            
        case kStateIsHit:
            PLAYSOUNDEFFECT(COIN_COLLECT_SOUND_EFFECT);
            break;
            
        default:
            break;
    }
    if(action != nil){
        [self runAction:action];
    }
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime {  
    if (self.isSpawning) {
        [self changeState:kStateSpawning];
    }
     if (self.isHit) {
        [self changeState:kStateIsHit];
        self.visible = NO;
        self.body->SetActive(NO);
    }
}

-(void) despawn {
    self.visible = NO;
    self.isHit = NO;
    self.isSpawning = NO;
    self.isIdle = NO;
    self.scale = 0.0;
    self.body->SetActive(NO);
}

-(void) dealloc {
    [super dealloc];
}

@end
