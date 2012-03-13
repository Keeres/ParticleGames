//
//  Player.h
//  CatRun
//
//  Created by Kelvin on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LHSprite.h"
#import "LHSettings.h"

@interface Player : LHSprite {
    BOOL    isTouchingGround;
    BOOL    touchActivated;
    float   touchTime;
}

@property (readwrite) BOOL isTouchingGround;
@property (readwrite) BOOL touchActivated;
@property (readwrite) float touchTime;

//------------------------------------------------------------------------------
//the following are required in order for the custom sprite to work properly
+(id) spriteWithFile:(NSString*)filename rect:(CGRect)rect;
+(id) spriteWithBatchNode:(CCSpriteBatchNode*)batchNode rect:(CGRect)rect;

-(id) initWithFile:(NSString*)filename rect:(CGRect)rect;
-(id) initWithBatchNode:(CCSpriteBatchNode*)batchNode rect:(CGRect)rect;
//------------------------------------------------------------------------------
//the following method will test if a sprite object is really of LHSpritePlayer type
+(bool) isSpritePlayer:(id)object; 

//------------------------------------------------------------------------------
//create your own custom methods here

-(void) updateStateWithDeltaTime:(ccTime)dt;



@end
