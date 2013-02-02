//
//  ChallengerMenuItemSprite.h
//  GeoQuest
//
//  Created by Kelvin on 10/17/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChallengerMenuItemSprite : CCMenuItemSprite {
    
}

//-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(NSNumber *)wins withLosses:(NSNumber *)losses;
-(id) initWithChallenger:(NSString *)name withPicture:(NSString *)picture withWin:(int)wins withLosses:(int)losses;

@end
