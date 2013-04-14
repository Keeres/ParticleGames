//
//  Question.m
//  GeoQuest
//
//  Created by Kelvin on 4/10/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize objectId = _objectId;
@synthesize question = _question;
@synthesize questionType = _questionType;
@synthesize answerType = _answerType;
@synthesize answerTable = _answerTable;
@synthesize answerId = _answerId;
@synthesize answer = _answer;
@synthesize specialQuestion = _specialQuestion;
@synthesize info = _info;
@synthesize powerUpTypeQuestion = _powerUpTypeQuestion;

-(id) initQuestionWithObjectId:(NSString *)objectId question:(NSString *)question questionType:(NSString *)questionType answerType:(NSString *)answerType answerTable:(NSString *)answerTable specialQuestion:(BOOL)specialQuestion info:(NSString *)info {
    
    if ((self = [super init])) {
        self.objectId = objectId;
        self.question = question;
        self.questionType = questionType;
        self.answerType = answerType;
        self.answerTable = answerTable;
        self.answerId = nil;
        self.answer = nil;
        self.specialQuestion = specialQuestion;
        self.info = info;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary *)d {
    
    if ((self = [super init])) {
        self.objectId = [d objectForKey:@"objectId"];
        self.question = [d objectForKey:@"question"];
        self.questionType = [d objectForKey:@"questionType"];
        self.answerType = [d objectForKey:@"answerType"];
        self.answerTable = [d objectForKey:@"answerTable"];
        self.answerId = [d objectForKey:@"answerId"];
        self.answer = [d objectForKey:@"answer"];
        self.specialQuestion = [[d objectForKey:@"specialQuestion"] boolValue];
        self.info = [d objectForKey:@"info"];
    }
    return self;
}

-(NSDictionary*) dictionary {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:self.objectId, @"objectId", self.question, @"question", self.questionType, @"questionType", self.answerType, @"answerType", self.answerTable, @"answerTable", self.answer, @"answer", self.answerId, @"answerId", [NSNumber numberWithBool:self.specialQuestion], @"specialQuestion", self.info, @"info", nil];
}

- (void)dealloc
{
    self.objectId = nil;
    self.question = nil;
    self.questionType = nil;
    self.answerType = nil;
    self.answerTable = nil;
    self.answerId = nil;
    self.answer = nil;
    self.info = nil;
    
    [_objectId release];
    [_question release];
    [_questionType release];
    [_answerType release];
    [_answerTable release];
    [_answerId release];
    [_answer release];
    [_info release];
    
    [super dealloc];
}

@end
