//
//  PlayerAction.h
//  GeoQuest
//
//  Created by Kelvin on 5/20/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerAction : NSObject

@property (nonatomic, retain) NSString *username;
@property BOOL isCorrect;
@property float moveDistance;
@property (nonatomic, retain) NSString *powerUp;
@property (nonatomic, retain) NSString *attackUsername;
@property BOOL isWinner;

@end
