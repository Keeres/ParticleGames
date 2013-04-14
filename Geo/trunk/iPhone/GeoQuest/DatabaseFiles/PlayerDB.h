//
//  PlayerDB.h
//  GeoQuest
//
//  Created by Kelvin on 11/30/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <sqlite3.h>
#import "GeoQuestDB.h"
#import "Challenger.h"
#import "RaceData.h"
#import "ChallengesInProgress.h"
#import "PlayerStats.h"

@interface PlayerDB : NSObject {
    sqlite3 *_database;
    
    ChallengesInProgress *_currentChallenge;
    PlayerStats *_player1Stats;
    PlayerStats *_player2Stats;
    
    BOOL    _playerInPlayer1Column;
}

@property (nonatomic, retain) ChallengesInProgress *currentChallenge;
@property (nonatomic, retain) PlayerStats *player1Stats;
@property (nonatomic, retain) PlayerStats *player2Stats;

@property BOOL playerInPlayer1Column;

+(PlayerDB*) database;

#pragma mark - Parse Data
-(NSMutableArray*) parseRaceDataFromString:(NSString*)raceData;
//-(NSMutableArray*) parseQuestionFromString:(NSString*)questions;

@end
