//
//  GameInformation.h
//  SmishiSmashi
//
//  Created by Kelvin on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameInformation : CCLayer {
	int64_t		gameHighScore;

}

@property (nonatomic,readwrite) int64_t gameHighScore;

+(GameInformation *) sharedInformation;
-(void) saveGameState;
-(void) loadGameState;
-(void) setGameHighScore:(int64_t)a;

@end
