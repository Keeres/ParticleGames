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

@interface PlayerDB : NSObject {
    sqlite3 *_database;
    
    NSString *_username;
}

@property (nonatomic, copy) NSString *name;
@property int experience;
@property int coins;
@property (nonatomic, copy) NSString *territoriesOwned;
@property float timePlayed;
@property int totalQuestions;
@property int totalAnswersCorrect;

+(PlayerDB*) database;

-(void) createNewPlayerStatsTable:(NSString*)username;
-(void) updatePlayerChallengersTable:(NSMutableArray*)array;
-(void) updatePlayerTerritoriesTable:(NSMutableArray*)array;
-(void) updateInformation;
-(NSMutableArray*) retrievePlayerChallengersTable;

@end
