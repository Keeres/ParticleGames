//
//  ChallengesInProgress.m
//  GeoQuest
//
//  Created by Kelvin on 3/28/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "ChallengesInProgress.h"
#import <Parse/PFObject+Subclass.h>

@implementation ChallengesInProgress

@dynamic objectId;
@dynamic match_start_time;
@dynamic player1_id;
@dynamic player1_last_played;
@dynamic player1_next_race;
@dynamic player1_prev_race;
@dynamic player1_wins;
@dynamic player2_id;
@dynamic player2_last_played;
@dynamic player2_next_race;
@dynamic player2_prev_race;
@dynamic player2_wins;
@dynamic question;
@dynamic turn;

+(NSString*) parseClassName {
    return @"ChallengesInProgress";
}

@end