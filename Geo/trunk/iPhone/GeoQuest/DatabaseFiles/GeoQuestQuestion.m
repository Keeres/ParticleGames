//
//  GeoQuestQuestion.m
//  SQLitePractice
//
//  Created by Kelvin on 11/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoQuestQuestion.h"


@implementation GeoQuestQuestion

/*@synthesize key = _key;
@synthesize type = _type;
@synthesize text = _text;
@synthesize answer = _answer;
@synthesize answerTable = _answerTable;
@synthesize answerChoice = _answerChoice;
@synthesize powerUpTypeQuestion = _powerUpTypeQuestion;

-(id) initWithKey:(NSString*)key type:(NSString *)type text:(NSString *)text answer:(NSString *)answer answerTable:(NSString*)answerTable answerChoice:(NSString *)answerChoice {
    if ((self = [super init])) {
        self.key = key;
        self.type = type;
        self.text = text;
        self.answer = answer;
        self.answerTable = answerTable;
        self.answerChoice = answerChoice;
        self.powerUpTypeQuestion = kNullPowerUp;
    }
    return self;
}

-(void) dealloc {
    self.key = nil;
    self.type = nil;
    self.text = nil;
    self.answer = nil;
    self.answerTable = nil;
    self.answerChoice = nil;
    [super dealloc];
}*/

@synthesize question = _question;
@synthesize questionType = _questionType;
@synthesize answerTable = _answerTable;
@synthesize answerType = _answerType;
@synthesize answerID = _answerID;
@synthesize answer = _answer;
@synthesize info = _info;
@synthesize powerUpTypeQuestion = _powerUpTypeQuestion;

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
