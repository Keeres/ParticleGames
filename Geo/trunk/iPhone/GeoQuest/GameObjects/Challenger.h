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
    NSString *_ID;
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

@property (nonatomic, retain) NSString *ID;
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

-(id) initWithArray:(NSArray*)array;
-(id) initWithUserID:(NSString*)ID
                name:(NSString*)name
               email:(NSString*)email
          profilePic:(NSString*)profilePic
                 win:(int)win
                loss:(int)loss
        matchStarted:(NSString*)matchStarted
          lastPlayed:(NSString*)lastPlayed
              myTurn:(BOOL)myTurn
  playerPrevRaceData:(NSString*)playerPrevRaceData
  playerNextRaceData:(NSString*)playerNextRaceData
challengerPrevRaceData:(NSString*)challengerPrevRaceData
challengerNextRaceData:(NSString*)challengerNextRaceData
        questionData:(NSString*)questionData;

@end
