//
//  GeoQuestQuestion.m
//  SQLitePractice
//
//  Created by Kelvin on 11/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoQuestQuestion.h"


@implementation GeoQuestQuestion

@synthesize key = _key;
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
}

@end
