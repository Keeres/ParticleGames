//
//  ChallengesInProgress.h
//  GeoQuest
//
//  Created by Kelvin on 3/28/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface ChallengesInProgress : PFObject <PFSubclassing>

+(NSString*) parseClassName;

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *match_start_time;
@property (nonatomic, retain) NSString *player1_id;
@property (nonatomic, retain) NSString *player1_last_played;
@property (nonatomic, retain) NSString *player1_next_race;
@property (nonatomic, retain) NSString *player1_prev_race;
@property int player1_wins;
@property (nonatomic, retain) NSString *player2_id;
@property (nonatomic, retain) NSString *player2_last_played;
@property (nonatomic, retain) NSString *player2_next_race;
@property (nonatomic, retain) NSString *player2_prev_race;
@property int player2_wins;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *turn;

@end
