//
//  GeoQuestAnswer.m
//  SQLitePractice
//
//  Created by Kelvin on 11/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoQuestAnswer.h"


@implementation GeoQuestAnswer

/*@synthesize key = _key;
@synthesize name = _name;
@synthesize category = _category;

-(id) initWithKey:(NSString *)key name:(NSString *)name category:(NSString*)category {
    if ((self = [super init])) {
        self.key = key;
        self.name = name;
        self.category = category;
    }
    return self;
}


-(void) dealloc {
    self.key = nil;
    self.name = nil;
    self.category = nil;
    [super dealloc];
}*/

@synthesize answerID = _answerID;
@synthesize answer = _answer;

-(id) initWithAnswerID:(NSString *)answerID answerType:(NSString *)answer {
    if ((self = [super init])) {
        self.answerID = answerID;
        self.answer = answer;
    }
    return self;
}

-(void) dealloc {
    self.answerID = nil;
    self.answer = nil;
    [super dealloc];
}

@end
