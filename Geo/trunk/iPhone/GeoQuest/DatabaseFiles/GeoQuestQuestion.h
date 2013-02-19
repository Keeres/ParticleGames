//
//  GeoQuestQuestion.h
//  SQLitePractice
//
//  Created by Kelvin on 11/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface GeoQuestQuestion : NSObject {
    NSString *_question;
    NSString *_questionType;
    NSString *_answerTable;
    NSString *_answerType;
    NSString *_answerID;
    NSString *_answer;
    NSString *_info;
    
    int _powerUpTypeQuestion;
    
}

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *questionType;
@property (nonatomic, copy) NSString *answerTable;
@property (nonatomic, copy) NSString *answerType;
@property (nonatomic, copy) NSString *answerID;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *info;
@property (readwrite) int powerUpTypeQuestion;


-(id) initWithQuestion:(NSString*)question questionType:(NSString*)questionType answerTable:(NSString*)answerTable answerType:(NSString*)answerType info:(NSString*)info;

@end
