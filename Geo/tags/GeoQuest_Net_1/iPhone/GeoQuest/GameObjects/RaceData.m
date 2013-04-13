//
//  RaceData.m
//  GeoQuest
//
//  Created by Kelvin on 2/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "RaceData.h"

@implementation RaceData

@synthesize time = _time;
@synthesize answerType = _answerType;
@synthesize answer = _answer;
@synthesize correct = _correct;
@synthesize points = _points;

-(id) initWithArray:(NSArray *)array {
    if ((self = [super init])) {
        self.time = [[array objectAtIndex:0] floatValue];
        self.answerType = [array objectAtIndex:1];
        self.answer = [array objectAtIndex:2];
        self.correct = [[array objectAtIndex:3] boolValue];
        self.points = [[array objectAtIndex:4] floatValue];
    }
    return self;
}

-(id) initWithTime:(float)time answerType:(NSString *)answerType answer:(NSString *)answer correct:(BOOL)correct points:(float)points {
    if ((self = [super init])) {
        self.time = time;
        self.answerType = answerType;
        self.answer = answer;
        self.correct = correct;
        self.points = points;
    }
    return self;
}

-(void) print {
    CCLOG(@"RaceData: %f, %@, %@, %i, %f", self.time, self.answerType, self.answer, self.correct, self.points);
}

-(NSString*) stringValue {
    return [NSString stringWithFormat:@"(%f,%@,%@,%i,%f)", self.time, self.answerType, self.answer, self.correct, self.points];
}

-(void) dealloc {
    [_answerType release];
    [_answer release];
    [super dealloc];
}

@end
