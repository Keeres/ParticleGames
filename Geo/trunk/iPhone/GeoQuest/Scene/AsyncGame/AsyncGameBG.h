//
//  AsyncGameBG.h
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AsyncGameUI.h"

@class AsyncGameUI;

@interface AsyncGameBG : CCLayer {
    CGSize              winSize;
    
    AsyncGameUI          *asyncGameUI;
    
    CCSprite            *backPanel;
    
}

-(id) initWithAsyncGameUILayer:(AsyncGameUI *)asyncUI;


//used to test background themes
-(void) changeBG;


@end
