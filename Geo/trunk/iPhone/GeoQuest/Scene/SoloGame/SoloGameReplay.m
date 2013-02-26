//
//  SoloGameReplay.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "SoloGameReplay.h"

@implementation SoloGameReplay

-(void) showReplay {
    reverseRaceDataArray = [[NSMutableArray alloc] initWithCapacity:[raceDataArray count]];
    
    if (renderTexture != NULL) {
        return;
    }
    
    CCSprite *currentTimeLine = [CCSprite spriteWithSpriteFrameName:@"DifficultyDisplay.png"];
    currentTimeLine.position = ccp(winSize.width/2, winSize.height/4);
    [self addChild:currentTimeLine z:0];
    
    soloGameUI.playerVehicle.position = ccp(soloGameUI.playerVehicle.contentSize.width/2, 30.0);
    
    int renderTextureSize = 2048;
    renderTexture = [CCRenderTexturePlus renderTextureWithWidth:renderTextureSize height:renderTextureSize];
    renderTexture.position = ccp(winSize.width/2, -renderTexture.boundaryRect.size.height/2 + winSize.height * .5);
    [renderTexture updateBoundaryRect];
    renderTextureOrigPos = renderTexture.position;
    
    [self addChild:renderTexture z:1];
    
    CCSprite *s = [CCSprite spriteWithSpriteFrameName:@"ReplayLine.png"];
    raceLineWidth = s.contentSize.width;
    s.rotation = 90;
    s.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - winSize.height/4);
    [renderTexture beginWithClear:0 g:0 b:0 a:.2];
    
    // Draw lines from Start to Finish
    for (int i = 0; i < 60; i++) {
        s.position = ccp(s.position.x, s.position.y - s.contentSize.width);
        [s visit];
    }
    
    // Draw individual lines from middle line to answer picture
    s.rotation = 0;
    for (int i = 0; i < [raceDataArray count]; i++) {
        RaceData *r = [raceDataArray objectAtIndex:i];
        
        s.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - winSize.height/4 - (s.contentSize.width * r.time));
        
        for (int j = 0; j <= r.points; j++) {
            s.position = ccp(s.position.x - s.contentSize.width/3, s.position.y);
            [s visit];
        }
        
        s.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - winSize.height/4 - (s.contentSize.width * r.time));
        
        if ([r.answerType isEqualToString:@"TP"]) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:r.answer fontName:@"Arial" fontSize:14];
            if (r.correct) {
                label.color = ccc3(0, 255, 0);
            } else {
                label.color = ccc3(255, 0, 0);
            }
            label.position = ccp(s.position.x - label.contentSize.width/2 - (s.contentSize.width/3 * r.points), s.position.y);
            [label visit];
        } else {
            CCSprite *picture = [CCSprite spriteWithSpriteFrameName:r.answer];
            picture.scale = 0.3;
            
            if (r.correct) {
                picture.color = ccc3(0, 255, 0);
            } else {
                picture.color = ccc3(255, 0, 0);
            }
            picture.position = ccp(s.position.x - (picture.contentSize.width/2 * picture.scale) - (s.contentSize.width/3 * r.points), s.position.y);
            [picture visit];
        }
        
    }
    
    // Draw being and start
    CCSprite *begin = [CCSprite spriteWithSpriteFrameName:@"MainMenuCompass.png"];
    raceStartHeight = begin.contentSize.height;
    begin.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - winSize.height/4);
    [begin visit];
    begin.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - winSize.height/4 - (60 * s.contentSize.width));
    [begin visit];
    
    
    [renderTexture end];
}


-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        // Setup Layers
        soloGameUI = soloUI;
        [soloGameUI setSoloReplayLayer:self];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) setRaceData:(NSMutableArray*)r {
    [r retain];
    raceDataArray = r;
}

-(void) showLayerAndObjects {
    self.visible = YES;
    [self showReplay];
}

-(void) hideLayerAndObjects {
    self.visible = NO;
}


#pragma mark - Methods for Touches

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#define BOUNCE_DISTANCE 100
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    //CCLOG(@"rt.sprite boundaryRect: %f, %f, %f, %f", renderTexture.boundaryRect.origin.x, renderTexture.boundaryRect.origin.y , renderTexture.boundaryRect.size.width, renderTexture.boundaryRect.size.height);
    //CCLOG(@"curPoint: %f, %f", currentPoint.x, currentPoint.y);
    /*if (CGRectContainsPoint(renderTexture.boundaryRect, currentPoint)) {
     touchedRenderTexture = YES;
     } else {
     touchedRenderTexture = NO;
     }*/
    
    [renderTexture stopAllActions];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    previousPoint = currentPoint;
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    float yDif = previousPoint.y - currentPoint.y;
    float boundaryDistance = (raceLineWidth * 60);
    //if (touchedRenderTexture) {
    if (renderTexture.position.y <= renderTextureOrigPos.y + boundaryDistance + BOUNCE_DISTANCE && renderTexture.position.y >= renderTextureOrigPos.y - BOUNCE_DISTANCE) {
        renderTexture.position = ccp(renderTexture.position.x, renderTexture.position.y - yDif);
        [renderTexture updateBoundaryRect];
    }
    //}
    
    float deltaY = renderTexture.position.y - renderTextureOrigPos.y;
    float currentTime = deltaY/raceLineWidth;
    
    if (yDif < 0) {
        if ([raceDataArray count] != 0) {
            RaceData *r = [raceDataArray objectAtIndex:0];
            if (r.time < currentTime) {
                
                if ((soloGameUI.playerVehicle.position.x + ((winSize.width - soloGameUI.playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * r.points)) > winSize.width - soloGameUI.playerVehicle.contentSize.width/2) {
                    soloGameUI.playerVehicle.position = ccp(winSize.width - soloGameUI.playerVehicle.contentSize.width/2, soloGameUI.playerVehicle.position.y);
                } else {
                    soloGameUI.playerVehicle.position = ccp(soloGameUI.playerVehicle.position.x + ((winSize.width - soloGameUI.playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * r.points), soloGameUI.playerVehicle.position.y);
                }
                
                [r retain];
                [reverseRaceDataArray insertObject:r atIndex:0];
                [raceDataArray removeObjectAtIndex:0];
                [r release];
            }
        }
    } else {
        if ([reverseRaceDataArray count] != 0) {
            RaceData *r = [reverseRaceDataArray objectAtIndex:0];
            if (r.time > currentTime) {
                if ((soloGameUI.playerVehicle.position.x - ((winSize.width - soloGameUI.playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * r.points)) < soloGameUI.playerVehicle.contentSize.width/2) {
                    soloGameUI.playerVehicle.position = ccp(soloGameUI.playerVehicle.contentSize.width/2, soloGameUI.playerVehicle.position.y);
                } else {
                    soloGameUI.playerVehicle.position = ccp(soloGameUI.playerVehicle.position.x - ((winSize.width - soloGameUI.playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * r.points), soloGameUI.playerVehicle.position.y);
                }
                
                [r retain];
                [raceDataArray insertObject:r atIndex:0];
                [reverseRaceDataArray removeObjectAtIndex:0];
                [r release];
            }
        }
    }
    
    if (renderTexture.position.y > renderTextureOrigPos.y + boundaryDistance + BOUNCE_DISTANCE) {
        renderTexture.position = ccp(renderTexture.position.x, renderTextureOrigPos.y + boundaryDistance + BOUNCE_DISTANCE);
    } else if (renderTexture.position.y < renderTextureOrigPos.y - BOUNCE_DISTANCE) {
        renderTexture.position = ccp(renderTexture.position.x, renderTextureOrigPos.y - BOUNCE_DISTANCE);
    }
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    float boundaryDistance = (raceLineWidth * 60);
    
    if (renderTexture.position.y > renderTextureOrigPos.y + boundaryDistance) {
        id renderTextureAction = [CCMoveTo actionWithDuration:0.75 position:ccp(renderTexture.position.x, renderTextureOrigPos.y + boundaryDistance)];
        id renderTextureEase = [CCEaseBackOut actionWithAction:renderTextureAction];
        
        [renderTexture runAction:renderTextureEase];
        //renderTexture.position = ccp(renderTexture.position.x, renderTextureOrigPos.y + boundaryDistance);
    } else if (renderTexture.position.y < renderTextureOrigPos.y) {
        id renderTextureAction = [CCMoveTo actionWithDuration:0.75 position:ccp(renderTexture.position.x, renderTextureOrigPos.y)];
        id renderTextureEase = [CCEaseBackOut actionWithAction:renderTextureAction];
        
        [renderTexture runAction:renderTextureEase];
        //renderTexture.position = ccp(renderTexture.position.x, renderTextureOrigPos.y);
    }
}


-(void) dealloc {
    [raceDataArray release];
    [super dealloc];
}

@end
