//
//  MainMenuLayer.h
//  PaintRunner
//
//  Created by Kelvin Chan on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h" 

@interface MainMenuLayer : CCLayer {
    CGSize winSize;
    
    CCMenu *mainMenu;
}
@end