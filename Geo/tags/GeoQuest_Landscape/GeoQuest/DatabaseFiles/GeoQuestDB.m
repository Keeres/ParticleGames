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

-(GeoQuestQuestion*) getQuestionFrom:(NSString *)category {
    GeoQuestQuestion *question;
    
    NSString *sqlQuestion = [NSString stringWithFormat:@"SELECT key, type, text, media, answer, answertable, answerchoices FROM GenericQuestions WHERE categories LIKE '%%%@%%' ORDER BY RANDOM() LIMIT 1", category];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlQuestion UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSString *qKey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *qType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *qText;
            if ([qType isEqualToString:[NSString stringWithFormat:@"text"]]) {
                qText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            } else if ([qType isEqualToString:[NSString stringWithFormat:@"media"]]) {
                qText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            } else if ([qType isEqualToString:[NSString stringWithFormat:@"both"]]) {
                int i = arc4random() % 2;
                if (i == 0) {
                    qType = [NSString stringWithFormat:@"text"];
                    qText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                } else {
                    qType = [NSString stringWithFormat:@"media"];
                    qText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
            }
            
            NSString *qAnswer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            NSString *qAnswerTable = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
            NSString *qAnswerChoice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
            
            question = [[GeoQuestQuestion alloc] initWithKey:qKey type:qType text:qText answer:qAnswer answerTable:qAnswerTable answerChoice:qAnswerChoice];
        }
        sqlite3_finalize(compiledStatement);
    }
    return question;
}

-(NSArray*) getAnswerChoicesFrom:(GeoQuestQuestion *)question difficulty:(int)diff {
    NSMutableArray *answerChoices = [[NSMutableArray alloc] init];
    NSString *sqlAnswerChoices;
    
    switch (diff) {
        case k5050PowerUp:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT key, name, media, category FROM %@ WHERE key !='%@' ORDER BY RANDOM() LIMIT 1", question.answerChoice, question.answer];
            break;
            
        case kEasyDifficulty:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT key, name, media, category FROM %@ WHERE key !='%@' ORDER BY RANDOM() LIMIT 2", question.answerChoice, question.answer];
            break;
            
        case kNormalDifficulty:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT key, name, media, category FROM %@ WHERE key !='%@' ORDER BY RANDOM() LIMIT 3", question.answerChoice, question.answer];
            break;
            
        case kExtremeDifficuly:
            sqlAnswerChoices = [NSString stringWithFormat:@"SELECT key, name, media, category FROM %@ WHERE key !='%@' ORDER BY RANDOM() LIMIT 5", question.answerChoice, question.answer];
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(_database, [sqlAnswerChoices UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            NSString *aKey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aName;
            if ([question.type isEqualToString:@"media"]) {
                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            } else {
                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
            }
            NSString *aCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            
            GeoQuestAnswer *answer = [[GeoQuestAnswer alloc] initWithKey:aKey name:aName category:aCategory];
            [answerChoices addObject:answer];
        }
        sqlite3_finalize(compiledStatement);
    }
    
    NSString *sqlAnswer = [NSString stringWithFormat:@"SELECT key, name, media, category FROM %@ WHERE key='%@'",question.answerChoice, question.answer];
    if (sqlite3_prepare_v2(_database, [sqlAnswer UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSString *aKey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *aName;
            if ([question.type isEqualToString:@"media"]) {
                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            } else {
                aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
            }
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
}

-(NSArray*) getSpecialStageAnswerChoices {
    NSMutableArray *answerChoices = [[NSMutableArray alloc] init];
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
    
}

#pragma mark - Check Question/Answer


-(BOOL) checkAnswer:(GeoQuestAnswer *)answer withQuestion:(GeoQuestQuestion *)question {
    GeoQuestAnswer *a = answer;
    GeoQuestQuestion *q = question;
    
    if ([a.key isEqualToString:q.answer]) {
        CCLOG(@"CORRECT ANSWER!");
        return YES;
    } else {
        CCLOG(@"WRONG ANSWER!");
        return NO;
    }
}

-(BOOL) checkAnswer:(GeoQuestAnswer *)answer withCategory:(NSString *)category {
    GeoQuestAnswer *a = answer;
    
    if ([a.category isEqualToString:category]) {
        CCLOG(@"CORRECT CATEGORY!");
        return YES;
    } else {
        CCLOG(@"WRONG CATEGORY!");
        return NO;
    }
}

- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}
@end
