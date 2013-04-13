//
//  MimicServer.m
//  GeoQuest
//
//  Created by Kelvin on 3/4/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "MimicServer.h"

@implementation MimicServer

static MimicServer *_database;

#pragma mark - Initialize

+(MimicServer*) database {
    if (_database == nil) {
        _database = [[MimicServer alloc] init];
    }
    return _database;
}

-(id) init {
    if ((self = [super init])) {
        [self openDB];
        [self createAllPlayersTable];
    }
    return self;
}

#pragma mark - Open Database

-(NSString*) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    CCLOG(@"Documents: %@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MimicServer.sqlite"];
}

-(void) openDB {
    if (sqlite3_open([[self filePath] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Database failed to open");
    } else {
        CCLOG(@"PlayerDB: Database opened");
    }
}

-(void) createAllPlayersTable {
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS [AllPlayers] ("
                     "[Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                     "[ID] VARCHAR(32) UNIQUE NOT NULL"
                     "[Name] TEXT UNIQUE NOT NULL"
                     "[Email] TEXT NOT NULL"
                     "[Password] TEXT NOT NULL"
                     "[Picture] TEXT"
                     "[InQueue] BOOL NOT NULL"
                     "[TimeInQueue] TEXT"];
    char *err;
    
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        CCLOG(@"err:%s", err);
        NSAssert(0, @"Could not create AllPlayers table");
    } else {
        CCLOG(@"PlayerDB: AllPlayers table created");
    }
}



#pragma mark - Create new username tables

-(void) addNewPlayer:(NSString *)username {
    _username = username;
    [_username retain];
    
    
    Guid *randomGuid = [[Guid randomGuid] autorelease];
    NSString *guid = [randomGuid stringValue];
    NSString *name = _username;
    NSString *email = @"asdf@asdf.com";
    NSString *password = @"asdfasdf";
    NSString *picture = @"pic.png";
    BOOL inQueue = NO;
    NSString *timeInQueue = @"";
    
    if (_username != NULL) {
        NSString* sql = [NSString stringWithFormat:
                         @"INSERT OR REPLACE INTO ALLPLAYERS ("
                         "ID,"
                         "NAME,"
                         "EMAIL,"
                         "PASSWORD,"
                         "PICTURE,"
                         "INQUEUE,"
                         "TIMEINQUEUE)"
                         "VALUES (%@, %@, %@,%@, %@, %i, %@)", guid, name, email, password, picture, inQueue, timeInQueue];
        char *err;
        
        if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            CCLOG(@"err:%s", err);
            NSAssert(0, @"Could not add new player entry into AllPlayers");
        } else {
            CCLOG(@"PlayerDB: Added new player entry into AllPlayers");
        }

    }
    [self createNewPlayerStatsTable];
}

-(void) createNewPlayerStatsTable {
    NSString *sqlTable = [NSString stringWithFormat:
                          @"CREATE TABLE IF NOT EXISTS [%@Stats] ("
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
    [self createNewPlayerChallengersTable];
}

-(void) createNewPlayerChallengersTable {
    if (_username != NULL) {
        NSString *sqlTable = [NSString stringWithFormat:
                              @"CREATE TABLE IF NOT EXISTS [%@Challengers] ("
                              "[Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                              "[ID] VARCHAR(32) UNIQUE NOT NULL,"
                              "[NAME] TEXT NOT NULL,"
                              "[EMAIL] TEXT,"
                              "[PICTURE] TEXT,"
                              "[WIN] INTEGER,"
                              "[LOSS] INTEGER,"
                              "[MATCHSTARTED] TEXT,"
                              "[LASTPLAYED] TEXT,"
                              "[MYTURN] BOOL NOT NULL,"
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
        NSString *sqlTable = [NSString stringWithFormat:
                              @"CREATE TABLE IF NOT EXISTS [%@Territories] ("
                              "[Index] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                              "[ID] VARCHAR(32) UNIQUE NOT NULL, [NAME] TEXT NOT NULL,"
                              "[QUESTION] TEXT NOT NULL,"
                              "[ANSWER] TEXT NOT NULL,"
                              "[CONTINENTOFCATEGORY] TEXT NOT NULL,"
                              "[WEEKLYUSABLE] BOOL NULL,"
                              "[OWNERUSABLE] BOOL NULL)", _username];
        
        char *err;
        
        if (sqlite3_exec(_database, [sqlTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            CCLOG(@"err:%s", err);
            NSAssert(0, @"Could not create Player table");
        } else {
            CCLOG(@"PlayerDB: Player Territories Table created");
        }
    }
}

- (void)dealloc
{
    [_username release];
    [super dealloc];
}


@end
