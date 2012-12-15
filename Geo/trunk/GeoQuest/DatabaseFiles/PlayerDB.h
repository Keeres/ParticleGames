//
//  PlayerDB.h
//  GeoQuest
//
//  Created by Kelvin on 11/30/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <sqlite3.h>

@interface PlayerDB : NSObject {
    sqlite3 *_database;
    
    NSString *_username;
    NSString *_name; //1
    int _experience; //2
    int _coins; //3
    NSString *_territoriesOwned; //4
    float _timePlayed; //5
    int _totalQuestions; //6
    int _totalAnswersCorrect; //7
}

@property (nonatomic, copy) NSString *name;
@property int experience;
@property int coins;
@property (nonatomic, copy) NSString *territoriesOwned;
@property float timePlayed;
@property int totalQuestions;
@property int totalAnswersCorrect;

+(PlayerDB*) database;

-(void) createNewPlayerTable:(NSString*)username;
-(void) updateInformation;

@end
