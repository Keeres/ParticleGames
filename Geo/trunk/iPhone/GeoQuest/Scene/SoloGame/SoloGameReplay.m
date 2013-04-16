//
//  SoloGameReplay.m
//  GeoQuest
//
//  Created by Kelvin on 2/26/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "SoloGameReplay.h"
#import "ChallengesInProgress.h"
#import "PlayerStats.h"

@implementation SoloGameReplay

-(void) setupNextMenu {
    nextMenu = [CCMenuAdvanced menuWithItems:nil];
    
    CCMenuItemSprite *nextItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] target:self selector:@selector(nextSelected)];
    
    CCLabelTTF *nextLabel = [CCLabelTTF labelWithString:@"Next" fontName:@"Arial" fontSize:14];
    nextLabel.position = ccp(nextItemSprite.contentSize.width/2, nextItemSprite.contentSize.height/2);
    nextLabel.color = ccc3(0, 0, 0);
    
    [nextItemSprite addChild:nextLabel];
    [nextMenu addChild:nextItemSprite];
    
    [nextMenu alignItemsVerticallyWithPadding:0 bottomToTop:NO];
    nextMenu.ignoreAnchorPointForPosition = NO;
    
    nextMenu.position = ccp(winSize.width/2, winSize.height - nextMenu.contentSize.height/2);
    nextMenu.boundaryRect = CGRectMake(nextMenu.position.x - nextMenu.contentSize.width/2, nextMenu.position.y - nextMenu.contentSize.height/2, nextMenu.contentSize.width, nextMenu.contentSize.height);
    nextMenu.enabled = NO;
    nextMenu.visible = NO;

    [self addChild:nextMenu z:Z_ORDER_TOP];
}

-(void) setupVehicles {
    // Load pictures from database
    
    startingPoint = 20;
    finishingPoint = winSize.width - startingPoint;
    
    NSString *playerVehicleString = [PlayerDB database].player1Stats.selected_vehicle;
    NSString *challengerVehicleString = [PlayerDB database].player2Stats.selected_vehicle;
    
    playerVehicle = [CCSprite spriteWithSpriteFrameName:playerVehicleString];
    playerVehicle.position = ccp(startingPoint, 20.0);
    //playerVehicle.visible = NO;
    [self addChild:playerVehicle z:Z_ORDER_TOP];
    
    challengerVehicle = [CCSprite spriteWithSpriteFrameName:challengerVehicleString];
    challengerVehicle.position = ccp(startingPoint, 40.0);
    //challengerVehicle.visible = NO;
    [self addChild:challengerVehicle z:Z_ORDER_TOP-1];
    
    CCLabelTTF *playerLabel = [CCLabelTTF labelWithString:[PlayerDB database].player1Stats.player_id fontName:@"Arial" fontSize:14];
    playerLabel.position = ccp(playerVehicle.contentSize.width/2, playerVehicle.textureRect.size.height + playerLabel.contentSize.height);
    [playerVehicle addChild:playerLabel];
    
    CCLabelTTF *challengerLabel = [CCLabelTTF labelWithString:[PlayerDB database].player2Stats.player_id fontName:@"Arial" fontSize:14];
    challengerLabel.position = ccp(challengerVehicle.contentSize.width/2, challengerVehicle.textureRect.size.height + challengerLabel.contentSize.height);
    [challengerVehicle addChild:challengerLabel];
    
    moveVehicle1Particle = [CCParticleSystemQuad particleWithFile:@"MoveVehicleParticle.plist"];
    moveVehicle1Particle.position = ccp(winSize.width/2, winSize.height/2);
    moveVehicle1Particle.visible = NO;
    [self addChild:moveVehicle1Particle z:Z_ORDER_TOP];
    
    moveVehicle2Particle = [CCParticleSystemQuad particleWithFile:@"MoveVehicleParticle.plist"];
    moveVehicle2Particle.position = ccp(winSize.width/2, winSize.height/2);
    moveVehicle2Particle.visible = NO;
    [self addChild:moveVehicle2Particle z:Z_ORDER_TOP];
    
}

-(void) setupPlayerChallengerLabels {
    
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        playerName = [CCLabelTTF labelWithString:challenge.player1_id fontName:@"Arial" fontSize:20];
        playerName.position = ccp(winSize.width*.15, winSize.height - playerName.contentSize.height);
        [self addChild:playerName z:Z_ORDER_TOP];
        
        challengerName = [CCLabelTTF labelWithString:challenge.player2_id fontName:@"Arial" fontSize:20];
        challengerName.position = ccp(winSize.width*.85, winSize.height - challengerName.contentSize.height);
        [self addChild:challengerName z:Z_ORDER_TOP];
        
        NSString *pScore = [NSString stringWithFormat:@"%d", challenge.player1_wins];
        NSString *cScore = [NSString stringWithFormat:@"%d", challenge.player2_wins];
        
        playerScore = [CCLabelTTF labelWithString:pScore fontName:@"Arial" fontSize:20];
        playerScore.position = ccp(winSize.width*.15, winSize.height - playerName.contentSize.height - playerScore.contentSize.height);
        [self addChild:playerScore z:Z_ORDER_TOP];
        
        challengerScore = [CCLabelTTF labelWithString:cScore fontName:@"Arial" fontSize:20];
        challengerScore.position = ccp(winSize.width*.85, winSize.height - challengerName.contentSize.height - challengerScore.contentSize.height);
        [self addChild:challengerScore z:Z_ORDER_TOP];
    }];
}

-(void) setupTheme {
    theme = [CCSprite spriteWithSpriteFrameName:@"ThemeTrackDesert.png"];
    theme.position = ccp(winSize.width/2, theme.contentSize.height/2);
    theme.visible = NO;
    [self addChild:theme z:Z_ORDER_TOP-2];
}

-(void) showReplay {
    nextMenu.visible = YES;
    nextMenu.enabled = YES;
    theme.visible = YES;
    playerName.visible = YES;
    challengerName.visible = YES;
    playerScore.visible = YES;
    challengerScore.visible = YES;
    
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyNetworkOnly;

    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        NSString *pRaceDataString = challenge.player1_prev_race;
        NSError *jsonError = nil;
        playerRaceDataArray = [NSJSONSerialization JSONObjectWithData:[pRaceDataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        [playerRaceDataArray retain];
        
        playerReverseRaceDataArray = [[NSMutableArray alloc] initWithCapacity:[playerRaceDataArray count]];
        
        NSString *cRaceDataString = challenge.player2_prev_race;
        challengerRaceDataArray = [NSJSONSerialization JSONObjectWithData:[cRaceDataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        [challengerRaceDataArray retain];
        
        challengerReverseRaceDataArray = [[NSMutableArray alloc] initWithCapacity:[challengerRaceDataArray count]];
        
        if (renderTexture != NULL) {
            return;
        }
        
        playerVehicle.position = ccp(startingPoint, 20.0);
        challengerVehicle.position = ccp(startingPoint, 40.0);
        playerVehicle.visible = YES;
        challengerVehicle.visible = YES;
        
        CCSprite *currentTimeLine = [CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"];
        currentTimeLine.position = ccp(winSize.width/2, winSize.height/4);
        [self addChild:currentTimeLine z:Z_ORDER_BACK];
        
        CCSprite *start = [CCSprite spriteWithSpriteFrameName:@"MainMenuCompass.png"];
        raceStartHeight = start.contentSize.height;
        
        CCSprite *line = [CCSprite spriteWithSpriteFrameName:@"ReplayLine.png"];
        raceLineWidth = line.contentSize.width;
        
        // Create Render Texture
        int renderTextureSize = 1024;
        renderTexture = [CCRenderTexturePlus renderTextureWithWidth:renderTextureSize height:renderTextureSize];
        [renderTexture beginWithClear:0 g:0 b:0 a:0];
        [self addChild:renderTexture z:Z_ORDER_MIDDLE];
        renderTexture.position = ccp(winSize.width/2, -renderTexture.boundaryRect.size.height/2 + winSize.height/4 + start.contentSize.height/2);
        [renderTexture updateBoundaryRect];
        renderTextureOrigPos = renderTexture.position;
        
        
        // Draw lines from Start to Finish
        line.rotation = 90;
        line.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2);
        
        for (int i = 0; i < 60; i++) {
            line.position = ccp(line.position.x, line.position.y - line.contentSize.width);
            [line visit];
        }
        
        // Draw individual lines from middle line to answer picture
        line.rotation = 0;
        
        // Player Answers
        for (int i = 0; i < [playerRaceDataArray count]; i++) {
            //RaceData *raceData = [playerRaceDataArray objectAtIndex:i];
            RaceData *raceData = [[[RaceData alloc] initWithDictionary:[playerRaceDataArray objectAtIndex:i]] autorelease];
            
            line.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2 - (line.contentSize.width * raceData.time));
            
            for (int j = 0; j <= raceData.points; j++) {
                line.position = ccp(line.position.x - line.contentSize.width/3, line.position.y);
                [line visit];
            }
            
            line.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2 - (line.contentSize.width * raceData.time));
            
            if ([raceData.answerType isEqualToString:@"TEXTPIC"]) {
                CCLabelTTF *label = [CCLabelTTF labelWithString:raceData.answer fontName:@"Arial" fontSize:16];
                if (raceData.isCorrect) {
                    label.color = ccc3(97, 166, 75);
                } else {
                    label.color = ccc3(255, 70, 70);
                }
                label.position = ccp(line.position.x - label.contentSize.width/2 - (line.contentSize.width/3 * raceData.points), line.position.y);
                [label visit];
            } else {
                CCSprite *picture = [CCSprite spriteWithSpriteFrameName:raceData.answer];
                picture.scale = 0.3;
                
                if (raceData.isCorrect) {
                    picture.color = ccc3(97, 166, 75);
                } else {
                    picture.color = ccc3(255, 70, 70);
                }
                picture.position = ccp(line.position.x - (picture.contentSize.width/2 * picture.scale) - (line.contentSize.width/3 * raceData.points), line.position.y);
                [picture visit];
            }
        }
        
        // Challenger Answers
        
        for (int i = 0; i < [challengerRaceDataArray count]; i++) {
            //RaceData *raceData = [challengerRaceDataArray objectAtIndex:i];
            RaceData *raceData = [[[RaceData alloc] initWithDictionary:[challengerRaceDataArray objectAtIndex:i]] autorelease];
            
            line.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2 - (line.contentSize.width * raceData.time));
            
            for (int j = 0; j <= raceData.points; j++) {
                line.position = ccp(line.position.x + line.contentSize.width/3, line.position.y);
                [line visit];
            }
            
            line.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2 - (line.contentSize.width * raceData.time));
            
            if ([raceData.answerType isEqualToString:@"TEXTPIC"]) {
                CCLabelTTF *label = [CCLabelTTF labelWithString:raceData.answer fontName:@"Arial" fontSize:16];
                if (raceData.isCorrect) {
                    label.color = ccc3(97, 166, 75);
                } else {
                    label.color = ccc3(255, 70, 70);
                }
                label.position = ccp(line.position.x + label.contentSize.width/2 + (line.contentSize.width/3 * raceData.points), line.position.y);
                [label visit];
            } else {
                CCSprite *picture = [CCSprite spriteWithSpriteFrameName:raceData.answer];
                picture.scale = 0.3;
                
                if (raceData.isCorrect) {
                    picture.color = ccc3(97, 166, 75);
                } else {
                    picture.color = ccc3(255, 70, 70);
                }
                picture.position = ccp(line.position.x + (picture.contentSize.width/2 * picture.scale) + (line.contentSize.width/3 * raceData.points), line.position.y);
                [picture visit];
            }
        }
        
        // Draw being and start
        start.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2);
        [start visit];
        start.position = ccp(renderTexture.boundaryRect.size.width/2, renderTexture.boundaryRect.size.height - start.contentSize.height/2 - (60 * line.contentSize.width));
        [start visit];
        
        [renderTexture end];
    }];
}


-(id) initWithSoloGameUILayer:(SoloGameUI *)soloUI {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        /*[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"USAStatesSprites.plist"];
        usaStatesSheet = [CCSpriteBatchNode batchNodeWithFile:@"USAStatesSprites.png"];
        [self addChild:usaStatesSheet z:20];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"USACapitalsSprites.plist"];
        usaCapitalsSheet = [CCSpriteBatchNode batchNodeWithFile:@"USACapitalsSprites.png"];
        [self addChild:usaCapitalsSheet z:20];*/
        
        // Setup Layers
        soloGameUI = soloUI;
        [soloGameUI setSoloReplayLayer:self];
        
        [self setupVehicles];
        [self setupNextMenu];
        [self setupTheme];
        [self setupPlayerChallengerLabels];
        
        self.isTouchEnabled = YES;
        [self hideLayerAndObjects];
    }
    return self;
}

-(void) checkRaceData {
    
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        NSString *PPRD = challenge.player1_prev_race;
        NSString *CPRD = challenge.player2_prev_race;
        
        if ([PPRD isEqualToString:@""] || [CPRD isEqualToString:@""]) {
            // Show territory screen
            CCLOG(@"SoloGameReplay: No replay available.");
            [self hideLayerAndObjects];
            [soloGameUI showTerritoryLayer];
        } else {
            [self showLayerAndObjects];
            // Show replay of both players
            CCLOG(@"SoloGameReplay: Show replay");
        }
    }];
}

-(void) nextSelected {
    
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        if ([PlayerDB database].playerInPlayer1Column) {
            
            if (![challenge.player2_next_race isEqualToString:@""]) {
                challenge.player1_prev_race = @"";
                challenge.player2_prev_race = @"";
                [challenge saveInBackground];
            }
        } else {
            if (![challenge.player1_next_race isEqualToString:@""]) {
                challenge.player1_prev_race = @"";
                challenge.player2_prev_race = @"";
                [challenge saveInBackground];
            }
        }
        
        [self hideLayerAndObjects];
        [soloGameUI showTerritoryLayer];
    }];
}

-(void) showLayerAndObjects {
    self.visible = YES;
    [self showReplay];
}

-(void) hideLayerAndObjects {
    self.visible = NO;
    nextMenu.visible = NO;
    nextMenu.enabled = NO;
    theme.visible = NO;
    playerName.visible = NO;
    challengerName.visible = NO;
    playerScore.visible = NO;
    challengerScore.visible = NO;
    moveVehicle1Particle.visible = NO;
    moveVehicle2Particle.visible = NO;
}

-(void) loadReplayLayer {
    [self checkRaceData];
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
        // Move player vehicle to the right 
        if ([playerRaceDataArray count] != 0) {
            RaceData *playerRaceData = [[RaceData alloc] initWithDictionary:[playerRaceDataArray objectAtIndex:0]];
            
            if (playerRaceData.time < currentTime) {
                
                if ((playerVehicle.position.x + ((winSize.width - playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * playerRaceData.points)) > finishingPoint) {
                    playerVehicle.position = ccp(finishingPoint, playerVehicle.position.y);
                } else {
                    playerVehicle.position = ccp(playerVehicle.position.x + ((winSize.width - playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * playerRaceData.points), playerVehicle.position.y);
                }
                
                if (playerRaceData.isCorrect) {
                    moveVehicle1Particle.position = ccp(playerVehicle.position.x - playerVehicle.contentSize.width/2, playerVehicle.position.y - playerVehicle.contentSize.height/4);
                    moveVehicle1Particle.visible = YES;
                    [moveVehicle1Particle resetSystem];
                }
                
                [playerReverseRaceDataArray insertObject:[playerRaceData dictionary] atIndex:0];
                [playerRaceDataArray removeObjectAtIndex:0];
                [playerRaceData release];
            }
        }
        
        // Move challenger vehicle to the right
        if ([challengerRaceDataArray count] != 0) {
            RaceData *challengerRaceData = [[RaceData alloc] initWithDictionary:[challengerRaceDataArray objectAtIndex:0]];
            
            if (challengerRaceData.time < currentTime) {
                
                if ((challengerVehicle.position.x + ((winSize.width - challengerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * challengerRaceData.points)) > finishingPoint) {
                    challengerVehicle.position = ccp(finishingPoint, challengerVehicle.position.y);
                } else {
                    challengerVehicle.position = ccp(challengerVehicle.position.x + ((winSize.width - challengerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * challengerRaceData.points), challengerVehicle.position.y);
                }
                
                if (challengerRaceData.isCorrect) {
                    moveVehicle2Particle.position = ccp(challengerVehicle.position.x - challengerVehicle.contentSize.width/2, challengerVehicle.position.y - challengerVehicle.contentSize.height/4);
                    moveVehicle2Particle.visible = YES;
                    [moveVehicle2Particle resetSystem];
                }

                [challengerReverseRaceDataArray insertObject:[challengerRaceData dictionary] atIndex:0];
                [challengerRaceDataArray removeObjectAtIndex:0];
                [challengerRaceData release];
            }
        }
    } else {
        
        // Move player vehicle to the left
        if ([playerReverseRaceDataArray count] != 0) {
            RaceData *playerRaceData = [[RaceData alloc] initWithDictionary:[playerReverseRaceDataArray objectAtIndex:0]];
            
            if (playerRaceData.time > currentTime) {
                if ((playerVehicle.position.x - ((winSize.width - playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * playerRaceData.points)) < startingPoint) {
                    playerVehicle.position = ccp(startingPoint, playerVehicle.position.y);
                } else {
                    playerVehicle.position = ccp(playerVehicle.position.x - ((winSize.width - playerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * playerRaceData.points), playerVehicle.position.y);
                }
                
                //[playerRaceData retain];
                [playerRaceDataArray insertObject:[playerRaceData dictionary] atIndex:0];
                [playerReverseRaceDataArray removeObjectAtIndex:0];
                [playerRaceData release];
            }
        }
        
        // Move challenger vehicle to the left
        if ([challengerReverseRaceDataArray count] != 0) {
            RaceData *challengerRaceData = [[RaceData alloc] initWithDictionary:[challengerReverseRaceDataArray objectAtIndex:0]];
            
            if (challengerRaceData.time > currentTime) {
                if ((challengerVehicle.position.x - ((winSize.width - challengerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * challengerRaceData.points)) < startingPoint) {
                    challengerVehicle.position = ccp(startingPoint, challengerVehicle.position.y);
                } else {
                    challengerVehicle.position = ccp(challengerVehicle.position.x - ((winSize.width - challengerVehicle.contentSize.width)/SOLO_GAME_SCORE_TO_WIN * challengerRaceData.points), challengerVehicle.position.y);
                }
                
                [challengerRaceDataArray insertObject:[challengerRaceData dictionary] atIndex:0];
                [challengerReverseRaceDataArray removeObjectAtIndex:0];
                [challengerRaceData release];
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
    [playerRaceDataArray release];
    [playerReverseRaceDataArray release];
    [challengerRaceDataArray release];
    [challengerReverseRaceDataArray release];
    [super dealloc];
}

@end
