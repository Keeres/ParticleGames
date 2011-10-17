//
//  GameBackgroundLayer.m
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBackgroundLayer.h"

@implementation GameBackgroundLayer

@synthesize background;
@synthesize renderTexture;
@synthesize brush;
@synthesize baseBrushColor;

-(CCSprite *)stripedSpriteWithColor1:(ccColor4F)c1 color2:(ccColor4F)c2 textureSize:(float)textureSize  stripes:(int)nStripes {
    
    // 1: Create new CCRenderTexture
    //CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    //[renderTexture beginWithClear:c1.r g:c1.g b:c1.b a:c1.a];
    //[renderTexture beginWithClear:255 g:255 b:255 a:255];
    [renderTexture beginWithClear:125.0/255.0 g:145.0/255.0 b:160.0/255.0 a:1.0];
    
    // 3: Draw into the texture    
    
    // Layer 1: Stripes
    /*glDisable(GL_TEXTURE_2D);
     glDisableClientState(GL_TEXTURE_COORD_ARRAY);
     glDisableClientState(GL_COLOR_ARRAY);
     
     CGPoint vertices[nStripes*6];
     int nVertices = 0;
     float x1 = -textureSize;
     float x2;
     float y1 = textureSize;
     float y2 = 0;
     float dx = textureSize / nStripes * 2;
     float stripeWidth = dx/2;
     for (int i=0; i<nStripes; i++) {
     x2 = x1 + textureSize;
     vertices[nVertices++] = ccpMult(CGPointMake(x1, y1), CC_CONTENT_SCALE_FACTOR());
     vertices[nVertices++] = ccpMult(CGPointMake(x1+stripeWidth, y1), CC_CONTENT_SCALE_FACTOR());
     vertices[nVertices++] = ccpMult(CGPointMake(x2, y2), CC_CONTENT_SCALE_FACTOR());
     vertices[nVertices++] = vertices[nVertices-2];
     vertices[nVertices++] = vertices[nVertices-2];
     vertices[nVertices++] = ccpMult(CGPointMake(x2+stripeWidth, y2), CC_CONTENT_SCALE_FACTOR());
     x1 += dx;
     }
     
     glColor4f(c2.r, c2.g, c2.b, c2.a);
     glVertexPointer(2, GL_FLOAT, 0, vertices);
     glDrawArrays(GL_TRIANGLES, 0, (GLsizei)nVertices);*/
    
    // layer 2: gradient
    /*glEnableClientState(GL_COLOR_ARRAY);
     
     float gradientAlpha = 0.7;    
     ccColor4F colors[4];
     nVertices = 0;
     
     vertices[nVertices] = CGPointMake(0, 0);
     colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
     vertices[nVertices] = CGPointMake(textureSize, 0);
     colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
     vertices[nVertices] = CGPointMake(0, textureSize);
     colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
     vertices[nVertices] = CGPointMake(textureSize, textureSize);
     colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
     
     glVertexPointer(2, GL_FLOAT, 0, vertices);
     glColorPointer(4, GL_FLOAT, 0, colors);
     glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);*/
    
    // layer 3: top highlight
    /*float borderWidth = textureSize/16;
     float borderAlpha = 0.3f;
     nVertices = 0;
     
     vertices[nVertices] = CGPointMake(0, 0);
     colors[nVertices++] = (ccColor4F){1, 1, 1, borderAlpha};
     vertices[nVertices] = CGPointMake(textureSize, 0);
     colors[nVertices++] = (ccColor4F){1, 1, 1, borderAlpha};
     
     vertices[nVertices] = CGPointMake(0, borderWidth);
     colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
     vertices[nVertices] = CGPointMake(textureSize, borderWidth);
     colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
     
     glVertexPointer(2, GL_FLOAT, 0, vertices);
     glColorPointer(4, GL_FLOAT, 0, colors);
     glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
     glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
     
     glEnableClientState(GL_COLOR_ARRAY);
     glEnableClientState(GL_TEXTURE_COORD_ARRAY);
     glEnable(GL_TEXTURE_2D);*/
    
    // Layer 2: Noise    
    //CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    //[noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    //noise.position = ccp(textureSize/2, textureSize/2);
    //[noise visit];        
    
    // 4: Call CCRenderTexture:end
    [renderTexture end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:renderTexture.sprite.texture];
    
}

- (ccColor4F)randomBrightColor {
    
    while (true) {
        float requiredBrightness = 192;
        ccColor4B randomColor = 
        ccc4(arc4random() % 255,
             arc4random() % 255, 
             arc4random() % 255, 
             255);
        if (randomColor.r > requiredBrightness || 
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }        
    }
    
}

- (ccColor3B)randomBrushColor {
    while (true) {
        float requiredBrightness = 192;
        ccColor3B randomColor = 
        ccc3(arc4random() % 255,
             arc4random() % 255, 
             arc4random() % 255);
        if (randomColor.r > requiredBrightness || 
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return randomColor;
        }        
    }
}

- (void)genBackground {
    
    [background removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self randomBrightColor];
    ccColor4F color2 = [self randomBrightColor];
    //background = [self spriteWithColor:bgColor textureSize:winSize.width];
    int nStripes = ((arc4random() % (int)(4 * CC_CONTENT_SCALE_FACTOR())) + 1) * 2;
    background = [self stripedSpriteWithColor1:bgColor color2:color2 textureSize:1024 stripes:nStripes];
        
    //background.position = ccp(background.contentSize.width/2, winSize.height - background.contentSize.height/2);

    background.position = ccp(background.contentSize.width/2, winSize.height/2);

    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [background.texture setTexParameters:&tp];
    
    [self addChild:background];
}

-(id) init {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        renderTexture = [[CCRenderTexture renderTextureWithWidth:1024 height:1024] retain];

        brush = [[CCSprite spriteWithFile:@"brush.png"] retain];

        //NSString *brushFrameName = @"Brush2.png";
        //[brush setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:brushFrameName]];
        ccColor3B tempColor = [self randomBrushColor];
        brush.color = tempColor;
        
        //brush.scale = 0.5;
        prevBrushScale = brush.scale;
        
        offset = 0;
        timePassed = 0;
        
        [self genBackground];
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) updateBackground:(ccTime)dt 
          playerPosition:(CGPoint)playerPoint 
andPlayerPreviousPosition:(CGPoint)playerPrevPoint 
       andPlayerOnGround:(BOOL)isTouchingGround 
          andPlayerScale:(float)playerScale
        andScreenOffsetX:(float)screenOffsetX
        andScreenOffsetY:(float)screenOffsetY 
                andScale:(float)screenScale {
    
    //Calculates how much to shift the background up to match the player's jump
    float yPos = background.position.y + screenOffsetY;
    background.position = ccp(background.position.x, yPos);

    //Change scale to match the action layer's scale
    background.scale = screenScale;
    
    //Calculates how much to shift the screen to the left based on the zooming (scale) effect
    float scaledOffsetX = background.contentSize.width/2*(1-background.scale);
    background.position = ccp(background.contentSize.width/2-scaledOffsetX, background.position.y);

    timePassed += dt;
    offset = screenOffsetX;
    
    CGSize textureSize = background.textureRect.size;
    [background setTextureRect:CGRectMake(offset, 0, textureSize.width, textureSize.height)];
    
    prevBrushScale = brush.scale;
    brush.color = baseBrushColor;
    baseBrushScale = playerScale;
    brush.scale = baseBrushScale;
    
    //if (!isTouchingGround) {
    if (timePassed > 0.1) {
        if (timePassed > 0.1) {
            timePassed = 0.0;
            //brush.opacity -= 5;
            if (brush.opacity < 5) {
                //    brush.opacity = 255;
            }
        }
        
        [renderTexture begin];
        
        CGPoint playerPosition = ccpAdd(playerPoint, ccp(0,352)); //Offsetting playerPoint by y:352 so that background will draw correctly on the openGL coordinate system.
        
        //Calculating where the player is located on the moving background.
        //Because the player is stagnant and only the background is moving, we need to find the remainder of the current offset to the background size.
        float offset_int = offset * 10000.0;
        float textureWidth_int = textureSize.width * 10000.0;
        float textureOffset = ((int) offset_int % (int) textureWidth_int)/10000.0;
        
        playerPosition.x = playerPosition.x + textureOffset;
        if (playerPosition.x > background.contentSize.width) {
            playerPosition.x = playerPosition.x - background.contentSize.width;
        }
        
        //Slightly alter brush scale randomly
        float tempBrushScale = ((float)(rand()%25)/10.f) * baseBrushScale;
        brush.scale = tempBrushScale;
        
        brush.position = playerPosition;
        brush.opacity = 125;
        [brush visit];
        
        //Calculate the buffer brush stroke to eliminate the cut off at edges
        //This section checks the brush at x:1024 and draws a buffer brush at x:0
        if (playerPosition.x > (background.contentSize.width - (brush.contentSize.width/2 * brush.scale))) {
            //CCLOG(@"x:1024");
            CCSprite *tempSprite = brush;
            tempSprite.anchorPoint = ccp(1,0.5);
            
            float edgeDistanceRemaining = background.contentSize.width - playerPosition.x;
            float newTempPositionX = (tempSprite.contentSize.width/2 * tempSprite.scale) - edgeDistanceRemaining;
            tempSprite.position = ccp(newTempPositionX, tempSprite.position.y);
                        
            [tempSprite visit];
            tempSprite.anchorPoint = ccp(0.5,0.5);
        }
        
        //Calculate the buffer brush stroke to eliminate the cut off at edges
        //This section checks the brush at x:0 and draws a buffer brush at x:1024
        if (playerPosition.x < (brush.contentSize.width/2*brush.scale)) {
            //CCLOG(@"x:0");
            CCSprite *tempSprite = brush;
            tempSprite.anchorPoint = ccp(0,0.5);
            
            float edgeDistanceRemaining = playerPosition.x;
            float newTempPositionX = background.contentSize.width - ((tempSprite.contentSize.width/2 * tempSprite.scale) - edgeDistanceRemaining);
            tempSprite.position = ccp(newTempPositionX, tempSprite.position.y);
            
            [tempSprite visit];
            tempSprite.anchorPoint = ccp(0.5,0.5);
        }
         
        //This section does the randomizing for size, color, opacity of the brush stroke.
        //The section also contains brush buffer code
        
        CGPoint playerPositionPrev = ccpAdd(playerPrevPoint, ccp(0,352)); //Offsetting playerPrevPoint by y:352 so that background will draw correctly on the openGL coordinate system.
        
        //float distance = ccpDistance(playerPoint, playerPrevPoint);
        float distance = 0; //Turn off bottom if statement
        if (distance > 1)
        {
            int d = (int)distance;
            for (int i = 0; i < d; i++)
            {
                CGPoint playerPositionPoint = ccpAdd(playerPoint, ccp(0,352)); //Offsetting playerPoint by y:352 so that background will draw correctly on the openGL coordinate system.

                float difx = playerPositionPrev.x - playerPositionPoint.x;
                float dify = playerPositionPrev.y - playerPositionPoint.y;
                float delta = (float)i / distance;
                CGPoint deltaPosition = ccp(playerPosition.x + (difx * delta), playerPosition.y + (dify * delta));
                brush.position = deltaPosition;
                //[brush setRotation:rand()%360];
                [brush setOpacity:(arc4random() % 175) + 25];
                
                //Modify scale of each brush stroke against the base brush size.
                //The base brush size is increased when moving up (jumping) and decreased when moving down (dropping)
                //float r = ((float)(rand()%50)/50.f) + 0.25f;
                //float tempBrushScale = ((float)(rand()%20)/10.f) * baseBrushScale;
                //brush.scale = tempBrushScale;
                
                //Change color of each brush stroke
                /*if (baseBrushColor.r > baseBrushColor.g && 
                    baseBrushColor.r > baseBrushColor.b) {
                    brush.color = ccc3(63 + CCRANDOM_0_1() * baseBrushColor.r, baseBrushColor.g, baseBrushColor.b);
                } else if (baseBrushColor.g > baseBrushColor.r &&
                           baseBrushColor.g > baseBrushColor.b) {
                    brush.color = ccc3(baseBrushColor.r, 63 + CCRANDOM_0_1() * baseBrushColor.g, baseBrushColor.b);
                } else if (baseBrushColor.b > baseBrushColor.r &&
                           baseBrushColor.b > baseBrushColor.g) {
                    brush.color = ccc3(baseBrushColor.r, baseBrushColor.g, 63 + CCRANDOM_0_1() * baseBrushColor.b);
                }*/
                
                // Call visit to draw the brush, don't call draw..
                [brush visit];
                
                //Buffer stroke for the edges
                //Check x:1024 draw at x:0
                if (deltaPosition.x > (background.contentSize.width - (brush.contentSize.width/2 * brush.scale))) {
                    //CCLOG(@"1024");
                    CCSprite *tempSprite = brush;
                    tempSprite.anchorPoint = ccp(1,0.5);
                    float edgeDistanceRemaining = background.contentSize.width - deltaPosition.x;
                    float newTempPositionX = (tempSprite.contentSize.width/2 * brush.scale) - edgeDistanceRemaining;
                    tempSprite.position = ccp(newTempPositionX, tempSprite.position.y);
                    
                    [tempSprite visit];
                    tempSprite.anchorPoint = ccp(0.5,0.5);
                }
                
                //Buffer stroke for the edges
                //Check x:0 draw at x:1024
                if (deltaPosition.x < (brush.contentSize.width/2*brush.scale)) {
                    //CCLOG(@"0000");
                    CCSprite *tempSprite = brush;
                    tempSprite.anchorPoint = ccp(0,0.5);
                    float edgeDistanceRemaining = deltaPosition.x;
                    float newTempPositionX = background.contentSize.width - ((tempSprite.contentSize.width/2 * brush.scale) - edgeDistanceRemaining);
                    tempSprite.position = ccp(newTempPositionX, tempSprite.position.y);
                    
                    [tempSprite visit];
                    tempSprite.anchorPoint = ccp(0.5,0.5);
                    
                }
            }
        }
        
        [renderTexture end];
    }
}

-(void) dealloc {
    [renderTexture release];
    [super dealloc];
}

@end
