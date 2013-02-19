//
//  Challenger.h
//  GeoQuest
//
//  Created by Kelvin on 2/6/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Challenger : NSObject {
    NSString *_userID;
    NSString *_name;
    NSString *_email;
    NSString *_profilePic;
    int _win;
    int _loss;
    NSString *_matchStarted;
    NSString *_lastPlayed;
    BOOL _myTurn;
    NSString *_playerPrevRaceData;
    NSString *_playerNextRaceData;
    NSString *_challengerPrevRaceData;
    NSString *_challengerNextRaceData;
    NSString *_questionData;
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *profilePic;
@property (assign) int win;
@property (assign) int loss;
@property (nonatomic, retain) NSString *matchStarted;
@property (nonatomic, retain) NSString *lastPlayed;
@property (assign) BOOL myTurn;
@property (nonatomic, retain) NSString *playerPrevRaceData;
@property (nonatomic, retain) NSString *playerNextRaceData;
@property (nonatomic, retain) NSString *challengerPrevRaceData;
@property (nonatomic, retain) NSString *challengerNextRaceData;
@property (nonatomic, retain) NSString *questionData;

-(id) initChallenger:(NSArray*)array;

@end
