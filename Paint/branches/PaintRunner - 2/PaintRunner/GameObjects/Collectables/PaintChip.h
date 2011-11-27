//
//  PaintChip.h
//  PaintRunner
//
//  Created by Kelvin on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#import "CommonProtocols.h"
#import "Constants.h"

@interface PaintChip : Box2DSprite {
    //Box2D
    b2World *world;
    b2Fixture *paintChipFixture;
    
    //Variables
    BOOL isHit;
    BOOL isSpawning;
    BOOL isIdle;
}

@property BOOL isHit;
@property BOOL isSpawning;
@property BOOL isIdle;

-(id) initWithWorld:(b2World*)world;
-(void) despawn;

@end
