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
#import "GeoQuestTerritory.h"
#import "Challenger.h"
#import "RaceData.h"

@interface PlayerDB : NSObject {
    sqlite3 *_database;
    
    NSString *_username;
    NSString *_password;
    
    NSString *_gameGUID;
    NSString *_challenger;
    
    BOOL    _playerInPlayer1Column;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *gameGUID;
@property (nonatomic, retain) NSString *challenger;
@property BOOL playerInPlayer1Column;

+(PlayerDB*) database;

-(void) createNewPlayerStatsTable:(NSString*)username;
-(void) updatePlayerChallengersTable:(NSMutableArray*)array;
-(void) updatePlayerChallenger:(Challenger*)c inPlayerChallengerDatabase:(NSString*)playerUsername;

#pragma mark - Retrieve Data
-(NSString*) retrieveDataFromColumn:(NSString*)column forUsername:(NSString*)username andID:(NSString*)ID;

#pragma mark - Modify Data
-(void) updateData:(NSString*)data intoColumn:(NSString*)column forUsername:(NSString*)username andID:(NSString*)ID;
-(void) moveDataFromColumn:(NSString*)columnA toColumn:(NSString*)columnB forUsername:(NSString*)username andID:(NSString*)ID;
-(void) deleteDataFromColumn:(NSString*)column forUsername:(NSString*)username andID:(NSString*)ID;

#pragma mark - Parse Data
-(NSMutableArray*) parseRaceDataFromString:(NSString*)raceData;
-(NSMutableArray*) parseQuestionFromString:(NSString*)questions;

-(void) updatePlayerTerritoriesTable:(NSMutableArray*)array;
-(NSMutableArray*) retrievePlayerChallengersTable;
-(NSMutableArray*) availableTerritories;
-(void)saveUsername;
-(void)loadUsername;
-(void)logOut;

//-(void) updateInformation;


@end
