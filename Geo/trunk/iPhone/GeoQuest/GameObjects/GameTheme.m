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
            //[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MainMenuUIMetalCard.png"]];
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Postcard.png"]];
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

-(void) dealloc {
    [super dealloc];
}



@end
