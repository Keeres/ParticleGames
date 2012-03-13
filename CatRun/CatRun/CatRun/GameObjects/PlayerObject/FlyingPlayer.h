//
//  FlyingPlayer.h
//  CatRun
//
//  Created by Kelvin on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define flightVelocity 2.0
#define fallingVelocity -2.5

#import "Player.h"

@interface FlyingPlayer : Player {
    BOOL activateFlight;
}

@end
