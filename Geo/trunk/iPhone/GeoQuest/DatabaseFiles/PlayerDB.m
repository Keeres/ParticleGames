//
//  PlayerDB.m
//  GeoQuest
//
//  Created by Kelvin on 11/30/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "PlayerDB.h"
#import "Territory.h"
#import "Challenger.h"


@implementation PlayerDB
@synthesize username = _username;
@synthesize password = _password;

static PlayerDB *_database;

#pragma mark - Initialize

+(PlayerDB*) database {
    if (_database == nil) {
        _database = [[PlayerDB alloc] init];
    }
    return _database;
}

-(id) init {
    if ((self = [super init])) {
        [self openDB];
    }
    return self;
}

#pragma mark - Open Database

-(NSString*) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    CCLOG(@"Documents: %@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PlayerDB.sqlite"];
}

-(void) openDB {
    if (sqlite3_open([[self filePath] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Database failed to open");
    } else {
        CCLOG(@"PlayerDB: Database opened");
    }
}

#pragma mark - Create new username table

-(void) createNewPlayerStatsTable:(NSString*)username {
    CCLOG(@"username: %@", username);
    _username = [username retain];
    if (_username != NULL) {
        NSString *sqlTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS [%@STATS] ("
                              "[Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                              "[Name] TEXT UNIQUE NOT NULL,"
                              "[Type] TEXT NOT NULL,"
                              "[Picture] TEXT,"
                              "[Data] TEXT NOT NULL)",_username];
        
        char *err;
        
        if (sqlite3_exec(_database, [sqlTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            CCLOG(@"err:%s", err);
            NSAssert(0, @"Could not create Player table");
        } else {
            CCLOG(@"PlayerDB: Player table created");
        }
    }
    [self createNewPlayerChallengersTable];
}

-(void) createNewPlayerChallengersTable {
    if (_username != NULL) {
        NSString *sqlTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS [%@CHALLENGERS] ("
                              "[Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                              "[ID] VARCHAR(32) UNIQUE NOT NULL,"
                              "[NAME] TEXT NOT NULL,"
                              "[EMAIL] TEXT,"
                              "[PICTURE] TEXT,"
                              "[WIN] INTEGER,"
                              "[LOSS] INTEGER,"
                              "[MATCHSTARTED] TEXT,"
                              "[LASTPLAYED] TEXT,"
                              "[MYTURN] INTEGER NOT NULL,"
                              "[PLAYERPREVRACEDATA] TEXT,"
                              "[PLAYERNEXTRACEDATA] TEXT,"
                              "[CHALLENGERPREVRACEDATA] TEXT,"
                              "[CHALLENGERNEXTRACEDATA] TEXT,"
                              "[QUESTIONDATA] TEXT)", _username];
        
        char *err;
        
        if (sqlite3_exec(_database, [sqlTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            CCLOG(@"err:%s", err);
            NSAssert(0, @"Could not create Player table");
        } else {
            CCLOG(@"PlayerDB: Player table created");
        }
    }
    [self createNewPlayerTerritoriesTable];
}

-(void) createNewPlayerTerritoriesTable {
    if (_username != NULL) {
        NSString *sqlTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS [%@TERRITORIES] ("
                              "[Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                              "[ID] VARCHAR(32) UNIQUE NOT NULL, [NAME] TEXT NOT NULL,"
                              "[QUESTION] TEXT NOT NULL,"
                              "[ANSWER] TEXT NOT NULL,"
                              "[CONTINENTOFCATEGORY] TEXT NOT NULL,"
                              "[WEEKLYUSABLE] TEXT NOT NULL,"
                              "[OWNERUSABLE] TEXT NULL)", _username];
        
        char *err;
        
        if (sqlite3_exec(_database, [sqlTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            CCLOG(@"err:%s", err);
            NSAssert(0, @"Could not create Player table");
        } else {
            CCLOG(@"PlayerDB: Player Territories Table created");
        }
    }
}

-(void) updatePlayerChallengersTable:(NSMutableArray *)array {
    if (_username != NULL) {
        for (int i = 0; [array count]; i++) {
            Challenger *c = (Challenger*)[array objectAtIndex:i];
            
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@CHALLENGERS ("
                             "ID, NAME, EMAIL, PICTURE, WIN, LOSS, MATCHSTARTED, LASTPLAYED, MYTURN, PLAYERPREVRACEDATA, PLAYERNEXTRACEDATA, CHALLENGERPREVRACEDATA, CHALLENGERNEXTRACEDATA, QUESTIONDATA)"
                             "VALUES ('%@','%@','%@','%@','%i','%i','%@','%@','%i','%@','%@','%@','%@','%@')", _username, c.userID, c.name, c.email, c.profilePic, c.win, c.loss, c.matchStarted, c.lastPlayed, c.myTurn, c.playerPrevRaceData, c.playerNextRaceData, c.challengerPrevRaceData, c.challengerNextRaceData, c.questionData];
            
            char *err;
            
            if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
                CCLOG(@"err:%s", err);
                NSAssert(0, @"Could not update Challenger entry");
            } else {
                CCLOG(@"PlayerDB: Updated Player Challenger entry");
            }
        }
    }
}

-(void) updatePlayerTerritoriesTable:(NSMutableArray*)array {
    if (_username != NULL) {
        for (int i = 0; i < [array count]; i++) {
            Territory *t = (Territory*)[array objectAtIndex:i];
            
            NSString *sql = [NSString stringWithFormat:@"SELECT OWNERUSABLE FROM %@TERRITORIES WHERE ID = '%@'", _username, t.territoryID];
            
            sqlite3_stmt *compiledStatement;
            
            if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    t.ownerUsable = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
                }
                sqlite3_finalize(compiledStatement);
            } else {
                NSAssert(0, @"Could not retrieve Territory entry");
            }
            
            sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@TERRITORIES ("
                   "ID, NAME, QUESTION, ANSWER, CONTINENTOFCATEGORY, OWNERUSABLE, WEEKLYUSABLE)"
                   "VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", _username, t.territoryID, t.name, t.question, t.answer, t.continentOfCategory, t.ownerUsable, t.weeklyUsable];
            
            char *err;
            
            if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
                CCLOG(@"err:%s", err);
                NSAssert(0, @"Could not create Territory entry");
            } else {
                CCLOG(@"PlayerDB: Updated Player Territory Entry");
            }
        }
    }
}

/*-(void) retrieveInformation {
    NSString *sqlQuestion = [NSString stringWithFormat:@"SELECT * FROM Player WHERE Name='%@'", _username];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlQuestion UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            self.name = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            self.experience = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] intValue];
            self.coins = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] intValue];
            self.territoriesOwned = [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];
            self.timePlayed = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 5)] floatValue];
            self.totalQuestions = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 6)] intValue];
            self.totalAnswersCorrect = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 7)] intValue];
        }
        sqlite3_finalize(compiledStatement);
    } else {
        CCLOG(@"Could not retrieve Player information");
    }
}*/

-(NSMutableArray*) retrievePlayerChallengersTable {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@CHALLENGERS", _username];
    NSMutableArray *challengerArray = [[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            Challenger *c = [[[Challenger alloc] init] autorelease];
            c.userID = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            c.name = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            c.email = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            c.profilePic = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            c.win = [[NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] intValue];
            c.loss = [[NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] intValue];
            c.matchStarted = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
            c.lastPlayed = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
            c.myTurn = [[NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] boolValue];
            c.playerPrevRaceData = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
            c.playerNextRaceData = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
            c.challengerPrevRaceData = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
            c.challengerNextRaceData = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
            c.questionData = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
            [challengerArray addObject:c];
        }
        sqlite3_finalize(compiledStatement);
    } else {
        CCLOG(@"Could not retrieve Player information");
    }
    return challengerArray;
}

/*-(void) updateInformation {
    NSString *sql = [NSString stringWithFormat:@"UPDATE Player SET Experience=%i, Coins=%i, TerritoriesOwned='%@', TimePlayed=%f, TotalQuestions=%i, TotalAnswersCorrect=%i WHERE Name='%@'", self.experience, self.coins, self.territoriesOwned, self.timePlayed, self.totalQuestions, self.totalAnswersCorrect, self.name];
    
    char *err;
    
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        CCLOG(@"err:%s", err);
        NSAssert(0, @"Could not update Player");
    } else {
        CCLOG(@"PlayerDB: Player updated");
    }
}*/


-(NSString *) saveFilePath
{
	NSArray *path =	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"savefile.plist"];
    
}

-(void) saveUsername {
    NSArray *values = [[NSArray alloc] initWithObjects:self.username, self.password,nil];
	[values writeToFile:[[PlayerDB database] saveFilePath] atomically:YES];
	[values release];
}

-(void) loadUsername {
    NSString *myPath = [self saveFilePath];
    
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    
	if (fileExists)
	{
		NSArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
        if ([values count] != 0) {
            [PlayerDB database].username = [values objectAtIndex:0];
            [PlayerDB database].password = [values objectAtIndex:1];            
            CCLOG(@"GameManager: Loaded username:%@ and password:%@", self.username, self.password);
        }
        [values release];
	}
}

-(void) logOut {
    self.username = NULL;
    self.password = NULL;
    [self saveFilePath];
}


//UPDATE Kelvin SET Experience=101;
//INSERT INTO Kelvin ("Name") VALUES ('Kelvin');
//INSERT INTO "main"."Kelvin" ("Name") VALUES ('Kelvin');
//INSERT INTO table (column) SELECT value WHERE NOT EXISTS (SELECT 1 FROM table WHERE column = value)

-(void) dealloc {
    [_username release];
    [_password release];
    [super dealloc];
}


@end
