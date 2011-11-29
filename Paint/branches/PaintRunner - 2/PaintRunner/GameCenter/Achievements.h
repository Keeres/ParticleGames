//
//  Achievements.h
//  PaintRunner
//
//  Created by Wayne on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Achievements ID List
#define kAchievement_FinishTutorial @"Learn2Play"
#define kAchievement_Jump20 @"Jumper"

// Leaderboard ID List
#define kHighScoreLeaderboardID @"HighScores"

// Scale high scores by one decimal point
#define kHighScoreScaler 10

@interface Achievements : NSObject

+ (void) jumperIncreaseCount;


@end
