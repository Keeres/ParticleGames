//
//  GeoQuestDB.h
//  SQLitePractice
//
//  Created by Kelvin on 11/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <sqlite3.h>
#import "GeoQuestQuestion.h"
#import "GeoQuestAnswer.h"
#import "Constants.h"

@interface GeoQuestDB : NSObject {
    sqlite3 *_database;
}

+(GeoQuestDB*) database;

-(GeoQuestQuestion*) getQuestionFrom:(NSString*)category;
-(NSArray*) getAnswerChoicesFrom:(GeoQuestQuestion*)question difficulty:(int)diff;
-(NSArray*) getSpecialStageAnswerChoices;


-(BOOL) checkAnswer:(GeoQuestAnswer*)answer withQuestion:(GeoQuestQuestion*)question;

-(BOOL) checkAnswer:(GeoQuestAnswer *)answer withCategory:(NSString*)category;

@end
