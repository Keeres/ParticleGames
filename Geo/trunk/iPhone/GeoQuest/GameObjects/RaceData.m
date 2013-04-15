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
@synthesize isCorrect = _isCorrect;
@synthesize points = _points;


-(id) initRaceDataWithTime:(float)time answerType:(NSString *)answerType answer:(NSString *)answer isCorrect:(BOOL)isCorrect points:(float)points {
    if ((self = [super init])) {
        self.time = time;
        self.answerType = answerType;
        self.answer = answer;
        self.isCorrect = isCorrect;
        self.points = points;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary *)d {
    if ((self = [super init])) {
        self.time = [[d objectForKey:@"time"] floatValue];
        self.answerType = [d objectForKey:@"answerType"];
        self.answer = [d objectForKey:@"answer"];
        self.isCorrect = [[d objectForKey:@"isCorrect"] boolValue];
        self.points = [[d objectForKey:@"points"] floatValue];
    }
    
    return self;
}

-(NSDictionary*) dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.time], @"time", self.answerType, @"answerType", self.answer, @"answer", [NSNumber numberWithBool:self.isCorrect], @"isCorrect", [NSNumber numberWithFloat:self.points], @"points", nil];
}

/*-(id) initWithArray:(NSArray *)array {
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
}*/

-(void) dealloc {
    [_answerType release];
    [_answer release];
    [super dealloc];
}

@end
