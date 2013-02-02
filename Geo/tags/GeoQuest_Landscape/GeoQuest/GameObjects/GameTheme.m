//
//  GameTheme.m
//  GeoQuest
//
//  Created by Kelvin on 11/24/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "GameTheme.h"
#import "Constants.h"

@implementation GameTheme
@synthesize boundaryRect;

-(void) setupTheme {
    switch (theme) {
        case kMetalTheme:
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SoloMetalBG.png"]];
            themeName = [NSString stringWithFormat:@"Metal"];
            break;
            
        case kTrainTheme:
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"TrainMid.png"]];
            themeName = [NSString stringWithFormat:@"Train"];
            CCLOG(@"%@", themeName);
            break;
            
        default:
            break;
    }
}

-(void) setupEdge {
    switch (edge) {
        case 0: {
            NSString *edgeName = [NSString stringWithFormat:@ "%@A.png",themeName];
            edgeSprite = [CCSprite spriteWithSpriteFrameName:edgeName];
            edgeSprite.position = ccp(-edgeSprite.contentSize.width/2+1, self.contentSize.height/2);
            [self addChild:edgeSprite];
            break;
        }
        case 1: {
            NSString *edgeName = [NSString stringWithFormat:@"%@B.png",themeName];
            edgeSprite = [CCSprite spriteWithSpriteFrameName:edgeName];
            edgeSprite.position = ccp(-edgeSprite.contentSize.width/2+1, self.contentSize.height/2);
            [self addChild:edgeSprite];
            break;
        }
            
        default:
            break;
    }

}

-(void) setupBoundaryRect {
    switch (theme) {
        case kMetalTheme:
            boundaryRect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
            break;
            
        case kTrainTheme:
            boundaryRect = CGRectMake(self.position.x - self.contentSize.width/2 - edgeSprite.contentSize.width + 1, self.position.y - self.contentSize.height/2, edgeSprite.contentSize.width + self.contentSize.width - 1, self.contentSize.height);

        default:
            break;
    }
}

-(id) initWithTheme:(int)t {
    if ((self = [super init])) {
        theme = t;
        [self setupTheme];
        [self setupBoundaryRect];
    }
    return self;
}

-(id) initWithTheme:(int)t andEdge:(int)e {
    if ((self = [super init])) {
        edge = e;
        theme = t;

        [self setupTheme];
        [self setupEdge];
        [self setupBoundaryRect];
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
}



@end
