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

@synthesize completedAchievement_Jumper;
@synthesize highScore;

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
}

 - (id)initWithCoder:(NSCoder *)decoder {

    if ((self = [super init])) {
         completedAchievement_Jumper = [decoder decodeBoolForKey:@"CompletedAchievement_Jumper"];
         highScore = [decoder decodeIntForKey:@"HighScore"];
    }
    return self;
}
@end