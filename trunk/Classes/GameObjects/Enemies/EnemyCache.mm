//
//  TurtleCache.m
//  mushroom
//
//  Created by Kelvin on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnemyCache.h"
#import "GameActionLayer.h"


@implementation EnemyCache

@synthesize totalEnemies;
@synthesize visibleEnemies;
@synthesize garbageEnemies;

-(void) initEnemiesInWorld:(b2World*)theWorld {
    totalEnemies = [[CCArray alloc] initWithCapacity:kMaxEnemyType];
    visibleEnemies = [[NSMutableArray alloc] init];
    for (int i = 0; i < kMaxEnemyType; i++) {
        int capacity;
        switch (i) {
            case kTurtleType:
                capacity = 8;
                break;
            case kBeeType:
                capacity = 8;
                break;
            case kJumperType:
                capacity = 8;
                break;
                
            default:
                [NSException exceptionWithName:@"EnemyTypeCache Exception" reason:@"unhandled enemy type" userInfo:nil];
                break;
        }
        CCArray *enemyOfType = [CCArray arrayWithCapacity:capacity];
        [totalEnemies addObject:enemyOfType];
    }
    
    for (int i = 0; i<kMaxEnemyType; i++) {
        CCArray *enemyOfType = [totalEnemies objectAtIndex:i];
        int numberEnemyOfType = [enemyOfType capacity];
        
        if (i == kTurtleType) {
            for (int j = 0; j < numberEnemyOfType; j++) {
                Turtle *turtle = [[[Turtle alloc] initWithWorld:theWorld] autorelease];
                [enemyOfType addObject:turtle];      
            }
        } else if (i == kBeeType) {
            for (int j = 0; j < numberEnemyOfType; j++) {
                Bee *bee = [[[Bee alloc] initWithWorld:theWorld] autorelease];
                [enemyOfType addObject:bee];      
            }
        } else if (i == kJumperType) {
            for (int j = 0; j < numberEnemyOfType; j++) {
                Jumper *jumper = [[[Jumper alloc] initWithWorld:theWorld] autorelease];
                [enemyOfType addObject:jumper];      
            }
        }

    }
}

-(void) chooseTurtle {
    CCArray *enemyOfType = [totalEnemies objectAtIndex:kTurtleType];
    
    for (int i = 0; i < [enemyOfType capacity]; i++) {
        Turtle *tempTurtle = [enemyOfType objectAtIndex:i];
        
        if (tempTurtle.visible == NO) {
            CGPoint location = ccp(offset + winSize.width/self.scale, winSize.height/2);
            
            [[enemyOfType objectAtIndex:i] spawn:location];
            [visibleEnemies addObject:tempTurtle];
            return;
        }
    }
}

-(void) chooseBee {
    CCArray *enemyOfType = [totalEnemies objectAtIndex:kBeeType];
    
    for (int i = 0; i < [enemyOfType capacity]; i++) {
        Bee *tempBee = [enemyOfType objectAtIndex:i];
        
        if (tempBee.visible == NO) {
            int randomLocation = arc4random() % 2;
            CGPoint location;
            if (randomLocation) {
                tempBee.onLeftSide = NO;
                location = ccp(offset + winSize.width/self.scale, 2*winSize.height/3);
            } else {
                tempBee.onLeftSide = YES;
                location = ccp(offset - winSize.width/self.scale, 2*winSize.height/3);
            }
            
            [[enemyOfType objectAtIndex:i] spawn:location];
            [visibleEnemies addObject:tempBee];
            return;
        }
    }
}

-(void) chooseJumper {
    CCArray *enemyOfType = [totalEnemies objectAtIndex:kJumperType];
    
    for (int i = 0; i < [enemyOfType capacity]; i++) {
        Jumper *tempJumper = [enemyOfType objectAtIndex:i];
        
        if (tempJumper.visible == NO) {
            CGPoint location;
            location = ccp(offset + winSize.width/self.scale, winSize.height);
            [[enemyOfType objectAtIndex:i] spawn:location];
            [visibleEnemies addObject:tempJumper];
            return;
        }
    }
}

-(void) randomlySpawnEnemy:(ccTime)dt atOffset:(float)newOffset andScale:(float)scale {
    offset = newOffset;
    self.scale = scale;
    float randomTime = arc4random() % 5 + 2;
    if (timePassed > randomTime) {
        timePassed = 0.0;
        if ([visibleEnemies count] < 4) {
            int randomEnemy = arc4random() % 3;
            if (randomEnemy == 0) {
                [self chooseTurtle];
            } else if (randomEnemy == 1) {
                [self chooseBee];
            } else {
                [self chooseJumper];
            }
        }
    } else {
        timePassed += dt;
    }
}

-(void) detectMushroomCheck {
    for (int i = 0; i < [visibleEnemies count]; i++) {
        Enemy *tempEnemy = [visibleEnemies objectAtIndex:i];
        if (tempEnemy.type == kTurtleType) {
            Turtle *tempTurtle = [visibleEnemies objectAtIndex:i];
            if ([[actionLayer visibleMushrooms] count] > 0) {
                Mushroom *tempMushroom = [[actionLayer visibleMushrooms] objectAtIndex:0];
                float distBtwnTurtleAndMushroom = tempTurtle.position.x - tempMushroom.position.x;
                if (distBtwnTurtleAndMushroom < tempTurtle.contentSize.width*3) {
                    tempTurtle.detectMushroom = YES;
                }
            }
        }
    }
}

-(void) cleanEnemies {
    for (int i = 0; i < [visibleEnemies count]; i++) {
        Turtle *tempTurtle = [visibleEnemies objectAtIndex:i];
        if (tempTurtle.isHit || tempTurtle.position.x < -winSize.width/2 || tempTurtle.position.y < -winSize.height/2) {
            [tempTurtle changeState:kStateDead];
            [visibleEnemies removeObjectAtIndex:i];
        }
    }
}

-(id) initWithWorld:(b2World*)theWorld withActionLayer:(id)gameActionLayer{
	if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        world = theWorld;
        actionLayer = gameActionLayer;
		[self initEnemiesInWorld:world];
        garbageEnemies = [[NSMutableArray alloc] init];
        timePassed = 0.0;
	}
	return self;
}

- (void)dealloc {
    [totalEnemies release];
    [visibleEnemies release];
    [garbageEnemies release];
    [super dealloc];
}


@end
