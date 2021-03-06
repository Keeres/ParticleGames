//
//  GeoQuestQuestion.m
//  SQLitePractice
//
//  Created by Kelvin on 11/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoQuestQuestion.h"


@implementation GeoQuestQuestion

@synthesize question = _question;
@synthesize questionType = _questionType;
@synthesize answerTable = _answerTable;
@synthesize answerType = _answerType;
@synthesize answerID = _answerID;
@synthesize answer = _answer;
@synthesize info = _info;
@synthesize powerUpTypeQuestion = _powerUpTypeQuestion;

-(id) initWithArray:(NSArray *)array {
    if ((self = [super init])) {
        self.question = [array objectAtIndex:0];
        self.questionType = [array objectAtIndex:1];
        self.answerTable = [array objectAtIndex:2];
        self.answerType = [array objectAtIndex:3];
        self.answerID = [array objectAtIndex:4];
        self.answer = [array objectAtIndex:5];
        self.info = [array objectAtIndex:6];
        self.powerUpTypeQuestion = kNullPowerUp;
    }
    return self;
}

-(id) initWithQuestion:(NSString *)question questionType:(NSString *)questionType answerTable:(NSString *)answerTable answerType:(NSString *)answerType info:(NSString *)info {
    if ((self = [super init])) {
        self.question = question;
        self.questionType = questionType;
        self.answerTable = answerTable;
        self.answerType = answerType;
        self.answerID = nil;
        self.answer = nil;
        self.info = info;
        self.powerUpTypeQuestion = kNullPowerUp;
    }
    return self;
}

-(void) dealloc {
    self.question = nil;
    self.questionType = nil;
    self.answerTable = nil;
    self.answerType = nil;
    self.answerID = nil;
    self.answer = nil;
    self.info = nil;
    [super dealloc];
}


@end
