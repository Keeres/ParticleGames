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
#import "GeoQuestTerritory.h"
#import "GeoQuestQuestion.h"
#import "GeoQuestAnswer.h"
#import "Constants.h"

@interface GeoQuestDB : NSObject {
    sqlite3 *_database;
}

+(GeoQuestDB*) database;

-(NSMutableArray*) displayTerritories;

-(GeoQuestQuestion*) getQuestionFrom:(GeoQuestTerritory*)questionTable;

-(NSMutableArray*) getAnswerChoicesFrom:(GeoQuestQuestion*)question specialPower:(int)power;

-(BOOL) checkAnswer:(GeoQuestAnswer*)answer withQuestion:(GeoQuestQuestion*)question;

@end
