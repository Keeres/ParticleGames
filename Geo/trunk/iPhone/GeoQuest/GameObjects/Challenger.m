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
@synthesize myTurn = _myTurn;
@synthesize playerPrevRaceData = _playerPrevRaceData;
@synthesize playerNextRaceData = _playerNextRaceData;
@synthesize challengerPrevRaceData = _challengerPrevRaceData;
@synthesize challengerNextRaceData = _challengerNextRaceData;
@synthesize questionData = _questionData;

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
        self.myTurn = NO;
        self.playerPrevRaceData = nil;
        self.playerNextRaceData = nil;
        self.challengerPrevRaceData = nil;
        self.challengerNextRaceData = nil;
        self.questionData = nil;
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
        self.myTurn = [[array objectAtIndex:9] boolValue];
        self.playerPrevRaceData = [array objectAtIndex:10];
        self.playerNextRaceData = [array objectAtIndex:11];
        self.challengerPrevRaceData = [array objectAtIndex:12];
        self.challengerNextRaceData = [array objectAtIndex:13];
        self.questionData = [array objectAtIndex:14];
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
    self.playerPrevRaceData = nil;
    self.playerNextRaceData = nil;
    self.challengerPrevRaceData = nil;
    self.challengerNextRaceData = nil;
    self.questionData = nil;

    [super dealloc];
}

@end
