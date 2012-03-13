//
//  GameState.m
//  PaintRunner
//
//  Created by Wayne on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "GCDatabase.h"

@implementation GameState

//Game Achievements
@synthesize completedAchievement_Jumper;

//Game Statistics
@synthesize highScore;

//Game States
@synthesize currentSkin;
@synthesize currentActivePerk;
@synthesize currentPassivePerk;
@synthesize currentMiniGameSelected;
@synthesize activeDoubleJump;
@synthesize activeGlide;
@synthesize activeFly;
@synthesize passiveCoin;
@synthesize passiveMagnet;
@synthesize passiveSmash;
@synthesize passiveZoomOut;

static GameState *sharedInstance = nil;

+(GameState*)sharedInstance {
    @synchronized([GameState class]) {
        if(!sharedInstance) {
            sharedInstance = [loadData(@"GameState") retain];
            
            if (!sharedInstance) {
                [[self alloc] init];
            }
        }
        return sharedInstance;
    }
    return nil;
}

+(id)alloc {
    @synchronized ([GameState class]) {
        
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of the GameState singleton"); 
        sharedInstance = [super alloc];
        
        return sharedInstance;
    }
    return nil;
}
                 
- (void)save {
    saveData(self, @"GameState");
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:completedAchievement_Jumper forKey:@"CompletedAchievement_Jumper"];
    [encoder encodeInt:highScore forKey:@"HighScore"];
    
    [encoder encodeInt:currentSkin forKey:@"CurrentSkin"];
    [encoder encodeInt:currentActivePerk forKey:@"CurrentActivePerk"];
    [encoder encodeInt:currentPassivePerk forKey:@"CurrentPassivePerk"];
    [encoder encodeObject:currentMiniGameSelected forKey:@"CurrentMiniGameSelected"];
    [encoder encodeInt:activeDoubleJump forKey:@"ActiveDoubleJump"];
    [encoder encodeInt:activeGlide forKey:@"ActiveGlide"];
    [encoder encodeInt:activeFly forKey:@"ActiveFly"];
    [encoder encodeInt:passiveCoin forKey:@"PassiveCoin"];
    [encoder encodeInt:passiveMagnet forKey:@"PassiveMagnet"];
    [encoder encodeInt:passiveSmash forKey:@"PassiveSmash"];
    [encoder encodeInt:passiveZoomOut forKey:@"PassiveZoomOut"];
}

 - (id)initWithCoder:(NSCoder *)decoder {

    if ((self = [super init])) {
        completedAchievement_Jumper = [decoder decodeBoolForKey:@"CompletedAchievement_Jumper"];
        highScore = [decoder decodeIntForKey:@"HighScore"];
        
        currentSkin = [decoder decodeIntForKey:@"CurrentSkin"];
        currentActivePerk = [decoder decodeIntForKey:@"CurrentActivePerk"];
        currentPassivePerk = [decoder decodeIntForKey:@"CurrentPassivePerk"];
        currentMiniGameSelected = [decoder decodeObjectForKey:@"CurrentMiniGameSelected"];
        activeDoubleJump = [decoder decodeIntForKey:@"ActiveDoubleJump"];
        activeGlide = [decoder decodeIntForKey:@"ActiveGlide"];
        activeFly = [decoder decodeIntForKey:@"ActiveFly"];
        passiveCoin = [decoder decodeIntForKey:@"PassiveCoin"];
        passiveMagnet = [decoder decodeIntForKey:@"PassiveMagnet"];
        passiveSmash = [decoder decodeIntForKey:@"PassiveSmash"];
        passiveZoomOut = [decoder decodeIntForKey:@"PassiveZoomOut"];
    }
    return self;
}
@end