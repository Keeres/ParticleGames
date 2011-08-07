//
//  MushroomCache.h
//  mushroom
//
//  Created by Kelvin on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Mushroom.h"
#import "CommonProtocols.h"
#import "MyContactListener.h"
#import "GameActionLayer.h"

@class GameActionLayer;

@interface MushroomCache : CCNode {
    //CCSpriteBatchNode *batch;
    //CCArray *blackMushrooms;
    //CCArray *blueMushrooms;
    CCArray *totalMushrooms;

    NSMutableArray *visibleMushrooms;
    NSMutableArray *garbageMushrooms;
    
    b2World *world;
    GameActionLayer *actionLayer;
    CGSize winSize;
    
    BOOL isMushroomJumping;
    BOOL jumpJustBegan;
    BOOL blueColor;
    
    float jumpPercentage;
    float currentSpeed;
    float offset;
    
}

@property (nonatomic, retain) CCArray *totalMushrooms;
@property (nonatomic, retain) NSMutableArray *visibleMushrooms;
@property (nonatomic, retain) NSMutableArray *garbageMushrooms;

@property BOOL isMushroomJumping;
@property BOOL jumpJustBegan;
@property BOOL blueColor;
@property float jumpPercentage;
@property float currentSpeed;

-(id) initWithWorld:(b2World*)theWorld withActionLayer:(GameActionLayer*)gameActionLayer;
-(void) mushroomJump:(int)number withYForce:(float)yVector;
-(void) jumpCheck:(ccTime)dt;
-(void) lineSpaceCheck:(ccTime)dt withOffset:(float)newOffset;
-(void) cleanMushrooms;

@end
