//
//  PlayerDB.m
//  GeoQuest
//
//  Created by Kelvin on 11/30/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "PlayerDB.h"
#import "Territory.h"


@implementation PlayerDB
@synthesize currentChallenge = _currentChallenge;
@synthesize player1Stats = _player1Stats;
@synthesize player2Stats = _player2Stats;
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


#pragma mark - Parse Data

-(NSMutableArray*) parseRaceDataFromString:(NSString *)raceData {
    
    NSScanner *scanner = [NSScanner scannerWithString:raceData];
    NSMutableArray *raceDataArray = [[[NSMutableArray alloc] init] autorelease];
    
    while ([scanner isAtEnd] == NO) {
        NSString *raceString;
        if (![scanner scanUpToString:@"(" intoString:NULL]) {
            [scanner setScanLocation:scanner.scanLocation+1];
            [scanner scanUpToString:@")" intoString:&raceString];
            NSArray *components = [raceString componentsSeparatedByString:@","];
            RaceData *r = [[[RaceData alloc] initWithArray:components] autorelease];
            [raceDataArray addObject:r];
        }
    }
    return raceDataArray;
}

/*-(NSMutableArray*) parseQuestionFromString:(NSString *)questions {
    
    NSScanner *scanner = [NSScanner scannerWithString:questions];
    NSMutableArray *questionsArray = [[[NSMutableArray alloc] init] autorelease];
    
    while ([scanner isAtEnd] == NO) {
        NSString *questionString;
        if (![scanner scanUpToString:@"(" intoString:NULL]) {
            [scanner setScanLocation:scanner.scanLocation+1];
            [scanner scanUpToString:@")" intoString:&questionString];
            NSArray *components = [questionString componentsSeparatedByString:@","];
            GeoQuestQuestion *q = [[[GeoQuestQuestion alloc] initWithArray:components] autorelease];
            [questionsArray addObject:q];
        }
    }
    return questionsArray;
}*/

//UPDATE Kelvin SET Experience=101;
//INSERT INTO Kelvin ("Name") VALUES ('Kelvin');
//INSERT INTO "main"."Kelvin" ("Name") VALUES ('Kelvin');
//INSERT INTO table (column) SELECT value WHERE NOT EXISTS (SELECT 1 FROM table WHERE column = value)

-(void) dealloc {

    self.currentChallenge = nil;
    self.player1Stats = nil;
    self.player2Stats = nil;

    [_currentChallenge release];
    [_player1Stats release];
    [_player2Stats release];
    [super dealloc];
}


@end
