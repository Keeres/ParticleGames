//
//  PaintChip.h
//  PaintRunner
//
//  Created by Kelvin on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DSprite.h"
#import "CommonProtocols.h"

@interface PaintChip : Box2DSprite {
    //Box2D
    b2World *world;
    b2Fixture *paintChipFixture;
    
    //Variables
    BOOL isHit;
}

@property BOOL isHit;

-(id) initWithWorld:(b2World*)world;
-(void) despawn;

@end
