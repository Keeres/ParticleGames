//
//  GliderPlayer.h
//  CatRun
//
//  Created by Kelvin on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define jumpVelocity 2.5
#define maximumTouchTime 0.2

#import "Player.h"

@interface GliderPlayer : Player {
    BOOL activateJump;
    BOOL activateGlider;    
}

@end
