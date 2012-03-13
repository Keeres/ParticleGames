//
//  Achievements.m
//  PaintRunner
//
//  Created by Wayne on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Achievements.h"
#import "GameState.h"
#import "GCHelper.h"


int numberOfTimesJumped;

@implementation Achievements

// Achievement Description: Require a player to jump 20 times in one level to earn this simple achievement
+ (void) jumperIncreaseCount;
{
    if (![GameState sharedInstance].completedAchievement_Jumper)
    {
        // Condition to test for achievement
        if(numberOfTimesJumped < 20)
        {
            numberOfTimesJumped++;
        }
        else
        {
            [GameState sharedInstance].completedAchievement_Jumper = true;
            [[GameState sharedInstance] save];
            [[GCHelper sharedInstance] reportAchievement:kAchievement_Jump20 percentComplete:100.0];
            NSLog(@"Achievement Earned! Jumper");
        }
    }
}

@end
