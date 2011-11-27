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
        paintChipSpawnDelay = 0.0;
        
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
                CGPoint location = ccp((winSize.width)+(15.0*i), (winSize.height/4.0));
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

-(void) addPaintChipsPatternOneBetweenPlatformLocation:(CGPoint)position1 andLocation:(CGPoint)position2{
    int count = 9;
    int row = 0;
    int col = 0;
    int rowCount = 3;
    int colCount = 3;
    float ySpacing = (position2.y - position1.y)/colCount;
    float xSpacing = (position2.x - position1.x)/rowCount;
    
    for (int i=0; i<count; i++) {
        for (int j = 0; j < [totalPaintChips count]; j++) {
            PaintChip *tempPC = [totalPaintChips objectAtIndex:j];
            CGPoint location;
            if (tempPC.visible == NO) {
                if(col == colCount){
                    col = 0;
                    row ++;
                }
                if (ySpacing > 0) {
                    location = ccp(position1.x + tempPC.contentSize.width*(col+1.75), position1.y + tempPC.contentSize.height*(row+3));
                }else if(ySpacing < 0){
                    location = ccp(position1.x + tempPC.contentSize.width*(col+1.75), position2.y + tempPC.contentSize.height*(row+5));
                }
                
                col ++;
               // tempPC.isSpawning = YES;
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
    float tempTimer = 0.1;
    paintChipSpawnDelay += dt;
    for (int i = 0; i < [visiblePaintChips count]; i++) {
        PaintChip *tempPC = [visiblePaintChips objectAtIndex:i];
        b2Vec2 bodyPos = tempPC.body->GetPosition();
        tempPC.body->SetTransform(b2Vec2(bodyPos.x-speed*dt/PTM_RATIO,bodyPos.y), 0.0);
        if(paintChipSpawnDelay >= tempTimer && tempPC.isIdle == NO){
            tempPC.isSpawning = YES;
            paintChipSpawnDelay = 0.0;
        }
    }
    [self cleanPaintChips];
}

-(void) cleanPaintChips {
    for (int i = 0; i < [visiblePaintChips count]; i++) {
        PaintChip *tempPC = [visiblePaintChips objectAtIndex:i];
        if (tempPC.visible == NO || tempPC.position.x < 0) {
            [tempPC despawn];
            [visiblePaintChips removeObject:tempPC];
        }
    }
}

-(void) resetPaintChips { 
    
    for (int i = 0; i < [visiblePaintChips count]; i++) {
        PaintChip *tempPC = [visiblePaintChips objectAtIndex:i];
            [tempPC despawn];
    }
    
    [visiblePaintChips removeAllObjects];

}

-(void) dealloc {
    [totalPaintChips release];
    [visiblePaintChips release];
    [super dealloc];
}

@end
