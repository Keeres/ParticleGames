//
//  Challenger.m
//  GeoQuest
//
//  Created by Kelvin on 2/6/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "Challenger.h"

@implementation Challenger

@synthesize userID = _userID;
@synthesize name = _name;
@synthesize email = _email;
@synthesize profilePic = _profilePic;
@synthesize win = _win;
@synthesize loss = _loss;
@synthesize matchStarted = _matchStarted;
@synthesize lastPlayed = _lastPlayed;

-(id) init {
    if ((self = [super init])) {
        self.userID = nil;
        self.name = nil;
        self.email = nil;
        self.profilePic = nil;
        self.win = 0;
        self.loss = 0;
        self.matchStarted = nil;
        self.lastPlayed = nil;
    }
    return self;
}

-(id) initChallenger:(NSArray*)array {
    if ((self = [super init])) {
        self.userID = [array objectAtIndex:1];
        self.name = [array objectAtIndex:2];
        self.email = [array objectAtIndex:3];
        self.profilePic = [array objectAtIndex:4];
        self.win = [[array objectAtIndex:5] intValue];
        self.loss = [[array objectAtIndex:6] intValue];
        self.matchStarted = [array objectAtIndex:7];
        self.lastPlayed = [array objectAtIndex:8];
        
        CCLOG(@"userID:%@ name:%@ email:%@ profilePic:%@ win:%i loss:%i matchStarted:%@ lastPlayed:%@", self.userID, self.name, self.email, self.profilePic, self.win, self.loss, self.matchStarted, self.lastPlayed);
    }
    return self;
}

-(void) dealloc {
    self.userID = nil;
    self.name = nil;
    self.email = nil;
    self.profilePic = nil;
    self.matchStarted = nil;
    self.lastPlayed = nil;
    [super dealloc];
}

@end
