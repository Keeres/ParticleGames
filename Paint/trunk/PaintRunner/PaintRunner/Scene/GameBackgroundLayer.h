//
//  GameBackgroundLayer.h
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface GameBackgroundLayer : CCLayer {
    //Variables
    CGSize winSize;
    float baseBrushScale;
    float prevBrushScale;
    float offset;
    float timePassed;
        
    CCSprite *background;
    CCRenderTexture *renderTexture;
    CCSprite *brush;
    ccColor3B baseBrushColor;

}

@property (nonatomic, retain) CCSprite *background;
@property (nonatomic,retain) CCRenderTexture *renderTexture;
@property (nonatomic,retain) CCSprite* brush;
@property ccColor3B baseBrushColor;

-(void) updateBackground:(ccTime)dt playerPosition:(CGPoint)playerPoint andPlayerPreviousPosition:(CGPoint)playerPrevPoint andPlayerOnGround:(BOOL)isTouchingGround andPlayerScale:(float)playerScale andScreenOffset:(float)screenOffset;

-(ccColor3B) randomBrushColor;


@end
