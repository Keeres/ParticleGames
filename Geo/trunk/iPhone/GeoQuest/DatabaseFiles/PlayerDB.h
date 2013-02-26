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
    NSString *_password;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

+(PlayerDB*) database;

-(void) createNewPlayerStatsTable:(NSString*)username;
-(void) updatePlayerChallengersTable:(NSMutableArray*)array;
-(void) updatePlayerTerritoriesTable:(NSMutableArray*)array;
//-(void) updateInformation;
-(NSMutableArray*) retrievePlayerChallengersTable;
-(void)saveUsername;
-(void)loadUsername;
-(void)logOut;

@end
