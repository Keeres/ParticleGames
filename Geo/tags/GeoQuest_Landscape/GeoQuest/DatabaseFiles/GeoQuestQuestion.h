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
    NSString *_key;
    NSString *_type;
    NSString *_text;
    NSString *_answer;
    NSString *_answerTable;
    NSString *_answerChoice;
    
    int _powerUpTypeQuestion;
    
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *answerTable;
@property (nonatomic, copy) NSString *answerChoice;
@property (readwrite) int powerUpTypeQuestion;

-(id) initWithKey:(NSString*)key type:(NSString*)type text:(NSString*)text answer:(NSString*)answer answerTable:(NSString*)answerTable answerChoice:(NSString*)answerChoice;

@end
