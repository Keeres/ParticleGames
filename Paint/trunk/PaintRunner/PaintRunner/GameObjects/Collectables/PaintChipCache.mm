//
//  PaintChipCache.m
//  PaintRunner
//
//  Created by Kelvin on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintChipCache.h"

@implementation PaintChipCache

@synthesize totalPaintChips;
@synthesize visiblePaintChips;

-(void) initPaintChips {
    int capacity = 50;

    totalPaintChips = [[CCArray alloc] initWithCapacity:capacity];
    
    for (int i = 0; i < [totalPaintChips capacity]; i++) {
        PaintChip *paintChip = [[[PaintChip alloc] initWithWorld:world] autorelease];
        [totalPaintChips addObject:paintChip];
    }
}

-(id) initWithWorld:(b2World*)theWorld {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
        
        visiblePaintChips = [[NSMutableArray alloc] init];

        [self initPaintChips];
    }
    return self;
}

-(void) addPaintChips {
    //static int count = 3;
    int count = (arc4random() % 5) + 3;
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < [totalPaintChips count]; j++) {
            PaintChip *tempPC = [totalPaintChips objectAtIndex:j];
            
            if (tempPC.visible == NO) {
            CGPoint location = ccp((winSize.width)+(15*i), (winSize.height/4));
                tempPC.position = location;
                tempPC.visible = YES;
                tempPC.body->SetActive(YES);
                tempPC.body->SetTransform(b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO), 0.0);
                [visiblePaintChips addObject:tempPC];
                break;
            }
        }
    }
}

-(void) updatePaintChipsWithTime:(ccTime)dt andSpeed:(float)speed {
    for (int i = 0; i < [visiblePaintChips count]; i++) {
        PaintChip *tempPC = [visiblePaintChips objectAtIndex:i];
        b2Vec2 bodyPos = tempPC.body->GetPosition();
        tempPC.body->SetTransform(b2Vec2(bodyPos.x-speed*dt/PTM_RATIO,bodyPos.y), 0.0);
    }
    [self cleanPaintChips];
}

-(void) cleanPaintChips {
    for (int i = 0; i < [visiblePaintChips count]; i++) {
        PaintChip *tempPC = [visiblePaintChips objectAtIndex:i];
        if (tempPC.visible == NO) {
            [tempPC despawn];
            [visiblePaintChips removeObject:tempPC];
        }
        
        if (tempPC.position.x < 0) {
            [tempPC despawn];
            [visiblePaintChips removeObject:tempPC];
        }
    }
}

-(void) resetPaintChips { 
    for (int i = 0; i < [visiblePaintChips count]; i++) {
        PaintChip *tempPC = [visiblePaintChips objectAtIndex:i];
            [tempPC despawn];
            [visiblePaintChips removeObject:tempPC];
    }
}

-(void) dealloc {
    [totalPaintChips release];
    [visiblePaintChips release];
    [super dealloc];
}

@end
