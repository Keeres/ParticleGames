//
//  PerkLayer.h
//  PaintRunner
//
//  Created by Kelvin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"

@interface PerkLayer : CCLayer {
    //Variables
    CGSize winSize;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    CCMenu *backButtonMenu;
}

@end
