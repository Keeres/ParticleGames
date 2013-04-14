//
//  Question.h
//  GeoQuest
//
//  Created by Kelvin on 4/10/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject {
    NSString    *_objectId;
    NSString    *_question;
    NSString    *_questionType;
    NSString    *_answerType;
    NSString    *_answerTable;
    NSString    *_answerId;
    NSString    *_answer;
    BOOL        _specialQuestion;
    NSString    *_info;
    
    int         _powerUpTypeQuestion;
}

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *questionType;
@property (nonatomic, retain) NSString *answerType;
@property (nonatomic, retain) NSString *answerTable;
@property (nonatomic, retain) NSString *answerId;
@property (nonatomic, retain) NSString *answer;
@property BOOL specialQuestion;
@property (nonatomic, retain) NSString *info;
@property int powerUpTypeQuestion;

-(id) initQuestionWithObjectId:(NSString*)objectId question:(NSString*)question questionType:(NSString*)questionType answerType:(NSString*)answerType answerTable:(NSString*)answerTable specialQuestion:(BOOL)specialQuestion info:(NSString*)info;

-(id) initWithDictionary:(NSDictionary*)d;

-(NSDictionary*) dictionary;


@end
