//
//  PlayerDB.m
//  GeoQuest
//
//  Created by Kelvin on 11/30/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "PlayerDB.h"


@implementation PlayerDB
@synthesize name = _name;
@synthesize experience = _experience;
@synthesize coins = _coins;
@synthesize territoriesOwned = _territoriesOwned;
@synthesize timePlayed = _timePlayed;
@synthesize totalQuestions = _totalQuestions;
@synthesize totalAnswersCorrect = _totalAnswersCorrect;

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

-(void) createNewPlayerTable:(NSString*)username {
    _username = username;
    
    NSString *sqlTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS [Player] ([Index] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT, [Name] TEXT  UNIQUE NOT NULL, [Experience] INTEGER NULL, [Coins] INTEGER NULL, [TerritoriesOwned] TEXT NULL, [TimePlayed] FLOAT NULL,[TotalQuestions] INTEGER NULL, [TotalAnswersCorrect] INTEGER NULL)"];
    
    char *err;
    
    if (sqlite3_exec(_database, [sqlTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        CCLOG(@"err:%s", err);
        NSAssert(0, @"Could not create Player table");
    } else {
        CCLOG(@"PlayerDB: Player table created");
    }
    
    [self createNewPlayerEntry];
}

-(void) createNewPlayerEntry {
    NSString *sql = [NSString stringWithFormat:@"INSERT OR IGNORE INTO Player (NAME, EXPERIENCE, COINS, TERRITORIESOWNED, TIMEPLAYED, TOTALQUESTIONS, TOTALANSWERSCORRECT) VALUES ('%@', '0', '0', '%@TerritoriesOwned', '0', '0', '0')", _username, _username];
    
    char *err;
    
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        CCLOG(@"err:%s", err);
        NSAssert(0, @"Could not create Player entry");
    } else {
        CCLOG(@"PlayerDB: Player entry created");
    }
    
    [self createNewTerritoriesOwnedTable];  
    [self retrieveInformation];
}

-(void) createNewTerritoriesOwnedTable {
    
}

-(void) retrieveInformation {
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
}

-(void) updateInformation {
    NSString *sql = [NSString stringWithFormat:@"UPDATE Player SET Experience=%i, Coins=%i, TerritoriesOwned='%@', TimePlayed=%f, TotalQuestions=%i, TotalAnswersCorrect=%i WHERE Name='%@'", self.experience, self.coins, self.territoriesOwned, self.timePlayed, self.totalQuestions, self.totalAnswersCorrect, self.name];
    
    char *err;
    
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        CCLOG(@"err:%s", err);
        NSAssert(0, @"Could not update Player");
    } else {
        CCLOG(@"PlayerDB: Player updated");
    }
}

//UPDATE Kelvin SET Experience=101;
//INSERT INTO Kelvin ("Name") VALUES ('Kelvin');
//INSERT INTO "main"."Kelvin" ("Name") VALUES ('Kelvin');
//INSERT INTO table (column) SELECT value WHERE NOT EXISTS (SELECT 1 FROM table WHERE column = value)

-(void) dealloc {
    [super dealloc];
}


@end
