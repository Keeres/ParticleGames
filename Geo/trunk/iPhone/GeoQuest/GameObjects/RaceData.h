//
//  RaceData.h
//  GeoQuest
//
//  Created by Kelvin on 2/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface RaceData : NSObject {
    float           _time;
    NSString        *_answerType;
    NSString        *_answer;
    BOOL            _correct;
    float           _points;
}

@property (assign) float time;
@property (nonatomic, retain) NSString *answerType;
@property (nonatomic, retain) NSString *answer;
@property (assign) BOOL correct;
@property (assign) float points;

-(id) initWithTime:(float)time answerType:(NSString*)answerType answer:(NSString*)answer correct:(BOOL)correct points:(float)points;
-(id) initWithArray:(NSArray*)array;
-(void) print;
-(NSString*) stringValue;

@end
