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


#pragma mark - Retreive Question/Answer

-(Question*) getQuestionFrom:(Territory *)territory {
    Question *q = NULL;

    NSString *sqlQuestion = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE specialquestion='NO' ORDER BY RANDOM() LIMIT 1", territory.question];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlQuestion UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *objectId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 1)];
            NSString *question = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 2)];
            NSString *questionType = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 3)];
            NSString *answerType = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 4)];
            BOOL specialQuestion = [[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 5)] boolValue];
            NSString *info = [NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 6)];

            NSString *answerTable = territory.answer;
            
            q = [[[Question alloc] initQuestionWithObjectId:objectId question:question questionType:questionType answerType:answerType answerTable:answerTable specialQuestion:specialQuestion info:info] autorelease];
        }
        sqlite3_finalize(compiledStatement);
    } else {
        return NULL;
    }
    
    //Get correct answer choices - Place correct answer into question.answerID
    sqlQuestion = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ ORDER BY RANDOM() LIMIT 1", q.questionType, q.answerTable];
    
    
    if (sqlite3_prepare_v2(_database, [sqlQuestion UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *answerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *answer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            q.answerId = answerId;
            q.answer = answer;
        }
        sqlite3_finalize(compiledStatement);
    }
    
    return q;
}

-(NSMutableArray*) getAnswerChoicesFrom:(Question *)question specialPower:(int)power {
    NSMutableArray *answerChoices = [[[NSMutableArray alloc] init] autorelease];
    NSString *sqlAnswerChoices;
    
    sqlite3_stmt *compiledStatement;
    
    //Get correct answer choice
    sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID ='%@' ORDER BY RANDOM() LIMIT 1", question.answerType, question.answerTable, question.answerId];
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *aAnswerID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aAnswerType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                        
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithAnswerID:aAnswerID answerType:aAnswerType];
            [answerChoices addObject:answer];
            [answer release];
        }
        sqlite3_finalize(compiledStatement);
    }

    //Get wrong answer choices	
    switch (power) {
        case k5050PowerUp:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID !='%@' ORDER BY RANDOM() LIMIT 1", question.answerType, question.answerTable, question.answerId];
            break;
            
        case kNormalDifficulty:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID !='%@' ORDER BY RANDOM() LIMIT 3", question.answerType, question.answerTable, question.answerId];
            break;
            
        case kExtremeDifficuly:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT answerID, %@ FROM %@ WHERE answerID !='%@' ORDER BY RANDOM() LIMIT 5", question.answerType, question.answerTable, question.answerId];
            break;

        default:
            break;
    }
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *aAnswerID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aAnswerType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                        
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithAnswerID:aAnswerID answerType:aAnswerType];
            [answerChoices addObject:answer];
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


-(BOOL) checkAnswer:(GeoQuestAnswer *)answer withQuestion:(Question *)question {
    GeoQuestAnswer *a = answer;
    Question *q = question;
    
    if ([a.answerID isEqualToString:q.answerId]) {
        CCLOG(@"CORRECT ANSWER!");
        return YES;
    } else {
        CCLOG(@"WRONG ANSWER!");
        return NO;
    }
}


- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}
@end
