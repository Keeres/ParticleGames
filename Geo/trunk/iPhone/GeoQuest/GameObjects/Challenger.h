//
//  Challenger.h
//  GeoQuest
//
//  Created by Kelvin on 2/6/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Challenger : NSObject {
    NSString *_userID;
    NSString *_name;
    NSString *_email;
    NSString *_profilePic;
    int _win;
    int _loss;
    NSString *matchStarted;
    NSString *lastPlayed;
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *profilePic;
@property (assign) int win;
@property (assign) int loss;
@property (nonatomic, retain) NSString *matchStarted;
@property (nonatomic, retain) NSString *lastPlayed;

@end
