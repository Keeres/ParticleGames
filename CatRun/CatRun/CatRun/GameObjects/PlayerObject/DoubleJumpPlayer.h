//
//  DoubleJumpPlayer.h
//  CatRun
//
//  Created by Kelvin on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#define jumpVelocity 2.5
#define maximumTouchTime 0.2

@interface DoubleJumpPlayer : Player {
    BOOL activateJump;
    BOOL activateDoubleJump;
    BOOL doubleJumpAvailable;
    
}

@end
