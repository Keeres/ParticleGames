//
//  GameState.h
//  PaintRunner
//
//  Created by Wayne on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GameState : NSObject <NSCoding> {
    BOOL completedAchievement_Jumper;
    int timesJumped;
    double highScore;
}

+ (GameState *) sharedInstance;
- (void)save;

@property (assign) BOOL completedAchievement_Jumper;
@property (assign) double highScore;
@end