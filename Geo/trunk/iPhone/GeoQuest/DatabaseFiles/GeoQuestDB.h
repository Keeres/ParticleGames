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
#import "GeoQuestAnswer.h"
#import "Constants.h"
#import "Territory.h"
#import "Question.h"

@interface GeoQuestDB : NSObject {
    sqlite3 *_database;
}

+(GeoQuestDB*) database;

//-(NSMutableArray*) displayTerritories;

//-(GeoQuestQuestion*) getQuestionFrom:(GeoQuestTerritory*)questionTable;
//-(GeoQuestQuestion*) getQuestionFrom:(Territory*)territory;
-(Question*) getQuestionFrom:(Territory*)territory;

//-(NSMutableArray*) getAnswerChoicesFrom:(GeoQuestQuestion*)question specialPower:(int)power;

-(NSMutableArray*) getAnswerChoicesFrom:(Question*)question specialPower:(int)power;

//-(BOOL) checkAnswer:(GeoQuestAnswer*)answer withQuestion:(GeoQuestQuestion*)question;
-(BOOL) checkAnswer:(GeoQuestAnswer*)answer withQuestion:(Question*)question;


@end
