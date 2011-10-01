//
//  Mushroom.h
//  mushroom
//
//  Created by Kelvin on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2DSprite.h"
#import "MyContactListener.h"
#import "Constants.h"

@interface Mushroom : Box2DSprite {
    MushroomType type;
    b2Fixture *mushroomFixture;
    b2Fixture *mushroomSensor;
    
    BOOL mushroomJumped;
    BOOL mushroomJumpStarted;
    BOOL mushroomReady;
    BOOL gameStarted;
    BOOL hitPlatformSide;
    BOOL hitByTurtle;
    BOOL hitByBee;
    BOOL hitByJumper;
    BOOL hitEnemy;
    BOOL eating;
    BOOL cramping;
    BOOL blueColor;
    BOOL hitByFireball;
    BOOL hitBySnowball;
    
    float mushroomStartPositionX;
    float mushroomStartHeight;
    float mushroomCurrentHeight;
    float mushroomMaxEndHeight;
    float msTimeSpentIdle;
    
    float speed;
    
    CCAnimation *blueWalkAnim;
    CCAnimation *blueJumpAnim;
    CCAnimation *blueLandAnim;
    CCAnimation *blueHitAnim;
    CCAnimation *blueGetHitAnim;
    CCAnimation *blueSpawnAnim;
    CCAnimation *blueEatAnim;
    CCAnimation *blueCrampAnim;
    CCAnimation *redWalkAnim;
    CCAnimation *redJumpAnim;
    CCAnimation *redLandAnim;
    CCAnimation *redHitAnim;
    CCAnimation *redGetHitAnim;
    CCAnimation *redSpawnAnim;
    CCAnimation *redEatAnim;
    CCAnimation *redCrampAnim;
}

@property MushroomType type;
@property BOOL mushroomJumped;
@property BOOL mushroomJumpStarted;
@property BOOL mushroomReady;
@property BOOL gameStarted;
@property BOOL hitPlatformSide;
@property BOOL hitByTurtle;
@property BOOL hitByBee;
@property BOOL hitByJumper;
@property BOOL hitEnemy;
@property BOOL hitByFireball;
@property BOOL hitBySnowball;
@property BOOL eating;
@property BOOL cramping;
@property BOOL blueColor;
@property float mushroomStartPositionX;
@property float mushroomStartHeight;
@property float mushroomCurrentHeight;
@property float mushroomMaxEndHeight;
@property float speed;

@property (nonatomic, retain) CCAnimation *blueWalkAnim;
@property (nonatomic, retain) CCAnimation *blueJumpAnim;
@property (nonatomic, retain) CCAnimation *blueLandAnim;
@property (nonatomic, retain) CCAnimation *blueHitAnim;
@property (nonatomic, retain) CCAnimation *blueGetHitAnim;
@property (nonatomic, retain) CCAnimation *blueSpawnAnim;
@property (nonatomic, retain) CCAnimation *blueEatAnim;
@property (nonatomic, retain) CCAnimation *blueCrampAnim;

@property (nonatomic, retain) CCAnimation *redWalkAnim;
@property (nonatomic, retain) CCAnimation *redJumpAnim;
@property (nonatomic, retain) CCAnimation *redLandAnim;
@property (nonatomic, retain) CCAnimation *redHitAnim;
@property (nonatomic, retain) CCAnimation *redGetHitAnim;
@property (nonatomic, retain) CCAnimation *redSpawnAnim;
@property (nonatomic, retain) CCAnimation *redEatAnim;
@property (nonatomic, retain) CCAnimation *redCrampAnim;


-(id) initWithWorld:(b2World*)world;
-(void) spawn:(CGPoint)location withColor:(BOOL)color;



@end
