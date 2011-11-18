//
//  GameState.h
//  PaintRunner
//
//  Created by Wayne on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GameState : NSObject <NSCoding> {
    BOOL completedJumper;
    int timesJumped;
}

+ (GameState *) sharedInstance;
- (void)save;

@property (assign) BOOL completedJumper;
@property (assign) int timesJumped;
@end