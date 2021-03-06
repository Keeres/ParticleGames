//
//  GeoQuestDB.m
//  SQLitePractice
//
//  Created by Kelvin on 11/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoQuestDB.h"  

@implementation GeoQuestDB

static GeoQuestDB *_database;

#pragma mark - Initialize

+(GeoQuestDB*) database {
    if (_database == nil) {
        _database = [[GeoQuestDB alloc] init];
    }
    return _database;
}

-(id) init {
    if ((self = [super init])) {
        
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"GeoQuestDB" ofType:@"sqlite"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

/*-(NSMutableArray*) displayTerritories {
    NSMutableArray *territoryChoices = [[[NSMutableArray alloc] init] autorelease];
    NSString *sqlTerritoryChoices = [NSString stringWithFormat:@"SELECT territoryid, name, question, answer FROM UserTerritoryQuestions where weeklyusable = 1 OR ownerusable = 1"];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlTerritoryChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            char *tID = (char*)sqlite3_column_text(compiledStatement, 0);
            char *tN = (char*)sqlite3_column_text(compiledStatement, 1);
            char *tQ = (char*)sqlite3_column_text(compiledStatement, 2);
            char *tA = (char*)sqlite3_column_text(compiledStatement, 3);
            
            NSString *tTerritoryID = [[NSString alloc] initWithUTF8String:tID];
            NSString *tName = [[NSString alloc] initWithUTF8String:tN];
            NSString *tQuestion = [[NSString alloc] initWithUTF8String:tQ];
            NSString *tAnswer = [[NSString alloc] initWithUTF8String:tA];
            
            GeoQuestTerritory *territory = [[GeoQuestTerritory alloc] initWithTerritoryID:tTerritoryID name:tName questionTable:tQuestion answerTable:tAnswer];
            [territoryChoices addObject:territory];
            
            [tTerritoryID release];
            [tName release];
            [tQuestion release];
            [tAnswer release];
            [territory release];
        }
        
        sqlite3_finalize(compiledStatement);
    }
    
    for (NSInteger i = territoryChoices.count-1; i > 0; i--)
    {
        [territoryChoices exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i+1)];
    }
    
    return territoryChoices;
}*/


#pragma mark - Retreive Question/Answer

-(GeoQuestQuestion*) getQuestionFrom:(GeoQuestTerritory*)territory {
    GeoQuestQuestion *question = NULL;
    
    NSString *sqlQuestion = [NSString stringWithFormat:@"SELECT question, questiontype, answertype, info FROM %@ WHERE specialquestion='NO' ORDER BY RANDOM() LIMIT 1", territory.questionTable];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlQuestion UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            char *qQues = (char*)sqlite3_column_text(compiledStatement, 0);
            char *qQuesType = (char*)sqlite3_column_text(compiledStatement, 1);
            char *qAnsType = (char*)sqlite3_column_text(compiledStatement, 2);
            char *qI = (char*)sqlite3_column_text(compiledStatement, 3);
            
            NSString *qQuestion = [[NSString alloc] initWithUTF8String:qQues];
            NSString *qQuestionType = [[NSString alloc] initWithUTF8String:qQuesType];
            NSString *qAnswerType = [[NSString alloc] initWithUTF8String:qAnsType];
            NSString *qInfo = [[NSString alloc] initWithUTF8String:qI];
            
            /*NSString *qQuestion = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)];
            NSString *qQuestionType = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 1)];
            NSString *qAnswerType = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 2)];
            NSString *qInfo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 3)];*/

            
            NSString *qAnswerTable = territory.answerTable;
            
            question = [[[GeoQuestQuestion alloc] initWithQuestion:qQuestion questionType:qQuestionType answerTable:qAnswerTable answerType:qAnswerType info:qInfo] autorelease];
            [qQuestion release];
            [qQuestionType release];
            [qAnswerType release];
            [qInfo release];
        }
        sqlite3_finalize(compiledStatement);
    } else {
        return NULL;
    }
    
    //Get correct answer choices - Place correct answer into question.answerID
    sqlQuestion = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ ORDER BY RANDOM() LIMIT 1", question.questionType, question.answerTable];
    
    
    if (sqlite3_prepare_v2(_database, [sqlQuestion UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            char *aAnsID = (char *)sqlite3_column_text(compiledStatement, 0);
            char *aAnsType = (char *)sqlite3_column_text(compiledStatement, 1);
            
            NSString *aAnswerID = [[NSString alloc] initWithUTF8String:aAnsID];
            NSString *aAnswerType = [[NSString alloc] initWithUTF8String:aAnsType];
            
            /*NSString *aAnswerID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aAnswerType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];*/
            
            question.answerID = aAnswerID;
            question.answer = aAnswerType;
            
            [aAnswerID release];
            [aAnswerType release];
            
        }
        sqlite3_finalize(compiledStatement);
    }
    
    
    return question;
}

-(NSMutableArray*) getAnswerChoicesFrom:(GeoQuestQuestion *)question specialPower:(int)power {
    NSMutableArray *answerChoices = [[[NSMutableArray alloc] init] autorelease];
    NSString *sqlAnswerChoices;
    
    sqlite3_stmt *compiledStatement;
    
    //Get correct answer choice
    sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID ='%@' ORDER BY RANDOM() LIMIT 1", question.answerType, question.answerTable, question.answerID];
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

            char *ansID = (char *)sqlite3_column_text(compiledStatement, 0);
            char *ansType = (char *)sqlite3_column_text(compiledStatement, 1);
            
            NSString *aAnswerID = [[NSString alloc] initWithUTF8String:ansID];
            NSString *aAnswerType = [[NSString alloc] initWithUTF8String:ansType];
            
            //NSString *aAnswerID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            //NSString *aAnswerType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                        
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithAnswerID:aAnswerID answerType:aAnswerType];
            [answerChoices addObject:answer];
            [aAnswerID release];
            [aAnswerType release];
            [answer release];
        }
        sqlite3_finalize(compiledStatement);
    }

    //Get wrong answer choices	
    switch (power) {
        case k5050PowerUp:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID !='%@' ORDER BY RANDOM() LIMIT 1", question.answerType, question.answerTable, question.answerID];
            break;
            
        case kNormalDifficulty:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID !='%@' ORDER BY RANDOM() LIMIT 3", question.answerType, question.answerTable, question.answerID];
            break;
            
        case kExtremeDifficuly:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID !='%@' ORDER BY RANDOM() LIMIT 5", question.answerType, question.answerTable, question.answerID];
            break;

        default:
            break;
    }
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            //NSString *aAnswerID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            //NSString *aAnswerType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            char *ansID = (char *)sqlite3_column_text(compiledStatement, 0);
            char *ansType = (char *)sqlite3_column_text(compiledStatement, 1);
            
            NSString *aAnswerID = [[NSString alloc] initWithUTF8String:ansID];
            NSString *aAnswerType = [[NSString alloc] initWithUTF8String:ansType];
                        
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithAnswerID:aAnswerID answerType:aAnswerType];
            [answerChoices addObject:answer];
            [aAnswerID release];
            [aAnswerType release];
            [answer release];
        }
        sqlite3_finalize(compiledStatement);
    }
    
    for (NSInteger i = answerChoices.count-1; i > 0; i--)
    {
        [answerChoices exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i+1)];
    }
    
    return answerChoices;
}

/*-(NSArray*) getSpecialStageAnswerChoices {
    NSMutableArray *answerChoices = [[[NSMutableArray alloc] init] autorelease];
    NSString *sqlAnswerChoices;
    
    //////////////////////////////////////////////////////////
    //Randomize category from where to retrieve answer choices
    //////////////////////////////////////////////////////////
    
    NSString *category = [NSString stringWithFormat:@"USAStates"];
    
    sqlAnswerChoices = [NSString stringWithFormat:@"SELECT key, name, media, category  FROM %@ ORDER BY RANDOM() LIMIT 5", category];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *aKey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            NSString *aCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithKey:aKey name:aName category:aCategory];
            [answerChoices addObject:answer];
        }
        sqlite3_finalize(compiledStatement);
    }
    
    category = [NSString stringWithFormat:@"USACapitals"];
    sqlAnswerChoices = [NSString stringWithFormat:@"SELECT key, name, media, category  FROM %@ ORDER BY RANDOM() LIMIT 7", category];
    
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *aKey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            NSString *aCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithKey:aKey name:aName category:aCategory];
            [answerChoices addObject:answer];
        }
        sqlite3_finalize(compiledStatement);
    }
    
    for (NSInteger i = answerChoices.count-1; i > 0; i--)
    {
        [answerChoices exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i+1)];
    }
    
    return answerChoices;
    
}*/

#pragma mark - Check Question/Answer


-(BOOL) checkAnswer:(GeoQuestAnswer *)answer withQuestion:(GeoQuestQuestion *)question {
    GeoQuestAnswer *a = answer;
    GeoQuestQuestion *q = question;
    
    if ([a.answerID isEqualToString:q.answerID]) {
        CCLOG(@"CORRECT ANSWER!");
        return YES;
    } else {
        CCLOG(@"WRONG ANSWER!");
        return NO;
    }
}

#pragma mark - Mimicking Server Functions

-(NSMutableArray*) retrieveTerritories {
    NSMutableArray *territoriesArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *sql = @"";
    
    sqlite3_stmt *compiledStatement;
    
    // Retrieve territories from Local GeoQuestDB.sqlite
    // Need to retrive territories from playerTERRITORIES instead.
    //Uncomment tOwner to retrienve ownerUsable information.
    sql = [NSString stringWithFormat:@"SELECT * FROM UserTerritoryQuestions"];
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *tID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *tName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            NSString *tQuestion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            NSString *tAnswer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            NSString *tContinent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
            NSString *tWeekly = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
            //BOOL *tOwner = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] boolValue];
            BOOL tOwner = NO;

            
            Territory *t = [[Territory alloc] initTerritoryWithID:tID name:tName question:tQuestion answer:tAnswer continentOfCategory:tContinent weeklyUsable:[tWeekly boolValue] ownerUsable:tOwner];
            [territoriesArray addObject:t];
            [t release];
        }
        sqlite3_finalize(compiledStatement);
    }
    return territoriesArray;
    
}


- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}
@end
