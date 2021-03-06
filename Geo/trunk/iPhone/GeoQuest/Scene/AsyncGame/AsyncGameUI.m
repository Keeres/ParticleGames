//
//  AsyncGameUI.m
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "AsyncGameUI.h"
#import "GameManager.h"
#import "MainMenuScene.h"
#import "ChallengesInProgress.h"
#import "PlayerStats.h"

@implementation AsyncGameUI

@synthesize playerVehicle;
@synthesize challengerVehicle;
@synthesize startingPoint;
@synthesize finishingPoint;

-(void) setAsyncGameBGLayer:(AsyncGameBG *)asyncBG {
    asyncGameBG = asyncBG;
}

-(void) setAsyncGameTerritoryLayer:(AsyncGameTerritory *)asyncTerritory {
    asyncGameTerritory = asyncTerritory;
}

-(void) setAsyncGameGameOverLayer:(AsyncGameGameOver *)asyncGameOver {
    asyncGameGameOver = asyncGameOver;
}

-(void) setAsyncReplayLayer:(AsyncGameReplay *)asyncReplay {
    asyncGameReplay = asyncReplay;
}

-(AsyncGameReplay*) getAsyncGameReplay {
    return asyncGameReplay;
}

#pragma mark - Setup Game

-(void) setupGame {
    /*[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"USAStatesSprites.plist"];
    usaStatesSheet = [CCSpriteBatchNode batchNodeWithFile:@"USAStatesSprites.png"];
    [self addChild:usaStatesSheet z:20];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"USACapitalsSprites.plist"];
    usaCapitalsSheet = [CCSpriteBatchNode batchNodeWithFile:@"USACapitalsSprites.png"];
    [self addChild:usaCapitalsSheet z:20];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"QuestionThemes.plist"];
    questionThemesSheet = [CCSpriteBatchNode batchNodeWithFile:@"QuestionThemes.png"];
    [self addChild:questionThemesSheet z:20];*/
    
    
    [self createAnswers];
    [self createRaceData];
    
    [self resetGame];
    [self setupCorrectAndWrongSprite];
    [self setupUILabels];
    [self setupAsyncGameTheme];
    [self setupTheme];
    //[self setupQuestionLayer];
    [self setupParticleSystems];
    //[self createQuestions];
    
    [self setupVehicles]; //Calls createQuestions after
}

-(void) setTerritoriesChosen:(NSMutableArray*)tChosen {
    [tChosen retain];
    territoriesChosen = tChosen;
}

-(void) setupCorrectAndWrongSprite {
    correctMark = [CCSprite spriteWithSpriteFrameName:@"AnswerCheckCorrect.png"];
    wrongMark = [CCSprite spriteWithSpriteFrameName:@"AnswerCheckWrong.png"];
    
    correctMark.position = ccp(winSize.width/4, winSize.height/2);
    wrongMark.position = correctMark.position;
    
    correctMark.visible = NO;
    wrongMark.visible = NO;
    
    [self addChild:correctMark z:Z_ORDER_TOP];
    [self addChild:wrongMark z:Z_ORDER_TOP];
}

-(void) setupVehicles {
    
    startingPoint = 20;
    finishingPoint = winSize.width - startingPoint;
    
    NSString *playerVehicleString = @"";
    NSString *challengerVehicleString = @"";
    if ([PlayerDB database].playerInPlayer1Column) {
        playerVehicleString = [PlayerDB database].player1Stats.selected_vehicle;
        challengerVehicleString = [PlayerDB database].player2Stats.selected_vehicle;
    } else {
        playerVehicleString = [PlayerDB database].player2Stats.selected_vehicle;
        challengerVehicleString = [PlayerDB database].player1Stats.selected_vehicle;
    }
    
    playerVehicle = [CCSprite spriteWithSpriteFrameName:playerVehicleString];
    playerVehicle.position = ccp(startingPoint, 20.0);
    playerVehicle.visible = NO;
    [self addChild:playerVehicle z:Z_ORDER_TOP];
    
    challengerVehicle = [CCSprite spriteWithSpriteFrameName:challengerVehicleString];
    challengerVehicle.position = ccp(startingPoint, 40.0);
    challengerVehicle.visible = NO;
    [self addChild:challengerVehicle z:Z_ORDER_TOP-1];
    
    if ([PlayerDB database].playerInPlayer1Column) {
        
        CCLabelTTF *playerLabel = [CCLabelTTF labelWithString:[PlayerDB database].player1Stats.player_id fontName:@"Arial" fontSize:14];
        playerLabel.position = ccp(playerVehicle.contentSize.width/2, playerVehicle.textureRect.size.height + playerLabel.contentSize.height);
        [playerVehicle addChild:playerLabel];
        
        CCLabelTTF *challengerLabel = [CCLabelTTF labelWithString:[PlayerDB database].player2Stats.player_id fontName:@"Arial" fontSize:14];
        challengerLabel.position = ccp(challengerVehicle.contentSize.width/2, challengerVehicle.textureRect.size.height + challengerLabel.contentSize.height);
        [challengerVehicle addChild:challengerLabel];
    } else {
        
        CCLabelTTF *playerLabel = [CCLabelTTF labelWithString:[PlayerDB database].player2Stats.player_id fontName:@"Arial" fontSize:14];
        playerLabel.position = ccp(playerVehicle.contentSize.width/2, playerVehicle.textureRect.size.height + playerLabel.contentSize.height);
        [playerVehicle addChild:playerLabel];
        
        CCLabelTTF *challengerLabel = [CCLabelTTF labelWithString:[PlayerDB database].player1Stats.player_id fontName:@"Arial" fontSize:14];
        challengerLabel.position = ccp(challengerVehicle.contentSize.width/2, challengerVehicle.textureRect.size.height + challengerLabel.contentSize.height);
        [challengerVehicle addChild:challengerLabel];
    }
    
    [self createQuestions];

}

-(void) setupUILabels {
    prepTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.f", prepTimer] fontName:@"TRS Million" fontSize:64];
    prepTimerLabel.position = ccp(winSize.width/2, winSize.height/2);
    prepTimerLabel.color = ccc3(255, 255, 255);
    [self addChild:prepTimerLabel z:20];
    
    gameTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time: %.01f", gameTimer] fontName:@"Arial" fontSize:18];
    gameTimerLabel.position = ccp(winSize.width/2, winSize.height - gameTimerLabel.contentSize.height/2);
    gameTimerLabel.color = ccc3(0, 0, 0);
    gameTimerLabel.visible = NO;
    [self addChild:gameTimerLabel z:20];
    
    questionTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.01f", gameTimer] fontName:@"Arial" fontSize:14];
    questionTimerLabel.position = ccp(winSize.width*.9, winSize.height*.8);
    questionTimerLabel.color = ccc3(0, 255, 0);
    questionTimerLabel.visible = NO;
    [self addChild:questionTimerLabel z:20];
    
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %.01f", score] fontName:@"Arial" fontSize:18];
    scoreLabel.anchorPoint = ccp(0, 0.5);
    scoreLabel.position = ccp(winSize.width*0.05, winSize.height - scoreLabel.contentSize.height/2);
    scoreLabel.color = ccc3(0, 0, 0);
    scoreLabel.visible = NO;
    [self addChild:scoreLabel z:20];
    
    pointsEarnedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.01f", pointsEarned] fontName:@"Arial" fontSize:40];
    pointsEarnedLabel.position = ccp(winSize.width/2, winSize.height/2);
    pointsEarnedLabel.color = ccc3(0, 0, 0);
    pointsEarnedLabel.visible = NO;
    [self addChild:pointsEarnedLabel z:20];
    
    quickDrawLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Quick Draw!"] fontName:@"TRS Million" fontSize:24];
    quickDrawLabel.position = ccp(winSize.width/2, winSize.height*.25);
    quickDrawLabel.color = ccc3(0, 0 ,0);
    quickDrawLabel.visible = NO;
    [self addChild:quickDrawLabel z:20];
    
    inRowLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i in a row!", answerCorrectlyInRow] fontName:@"TRS Million" fontSize:24];
    inRowLabel.position = ccp(winSize.width/2, winSize.height*.15);
    inRowLabel.color = ccc3(0, 0 ,0);
    inRowLabel.visible = NO;
    [self addChild:inRowLabel z:20];
    
    inRowQuickDrawLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i quick draws in a row!", answerQuickDrawCorrectlyInRow] fontName:@"TRS Million" fontSize:24];
    inRowQuickDrawLabel.position = ccp(winSize.width/2, winSize.height*.15);
    inRowQuickDrawLabel.color = ccc3(0, 0 ,0);
    inRowQuickDrawLabel.visible = NO;
    [self addChild:inRowQuickDrawLabel z:20];
}

-(void) setupAsyncGameTheme {
    asyncGameTheme = [CCSprite spriteWithSpriteFrameName:@"ThemeTrackDesert.png"];
    asyncGameTheme.position = ccp(winSize.width/2, asyncGameTheme.contentSize.height/2);
    asyncGameTheme.visible = NO;
    [self addChild:asyncGameTheme z:Z_ORDER_TOP-2];
}


-(void) setupTheme {
    //Question Postcard Cache
    theme = [[GameThemeCache alloc] initWithDifficulty:kNormalDifficulty andThemeName:kMetalTheme];
    themeArray = [theme theme];
    themeTotal = [[NSMutableArray alloc] init];
    themeVisible = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [themeArray count]; i++) {
        CCSprite *t = [themeArray objectAtIndex:i];
        t.position = ccp(0,0);
        [themeTotal addObject:t];
        [self addChild:t z:Z_ORDER_MIDDLE];
    }
    
    //Clock Sprite
    clock = [CCSprite spriteWithSpriteFrameName:@"ThemeClock.png"];
    clock.position = ccp(winSize.width/2, winSize.height - clock.contentSize.height/2);
    [self addChild:clock z:Z_ORDER_TOP];
}

/*-(void) setupQuestionLayer {
    questionLayerTotal = [[NSMutableArray alloc] init];
    questionLayerVisible = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i++) {
        CCLayerColor *questionLayer = [[[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 25)] autorelease];
        questionLayer.position = ccp(-winSize.width/2, -winSize.height/2);
        questionLayer.visible = NO;
        [questionLayerTotal addObject:questionLayer];
        [self addChild:questionLayer z:1];
    }  
}*/

-(void) setupParticleSystems {
    moveVehicle1Particle = [CCParticleSystemQuad particleWithFile:@"MoveVehicleParticle.plist"];
    moveVehicle1Particle.position = ccp(winSize.width/2, winSize.height/2);
    moveVehicle1Particle.visible = NO;
    [self addChild:moveVehicle1Particle z:Z_ORDER_TOP];
    
    moveVehicle2Particle = [CCParticleSystemQuad particleWithFile:@"MoveVehicleParticle.plist"];
    moveVehicle2Particle.position = ccp(winSize.width/2, winSize.height/2);
    moveVehicle2Particle.visible = NO;
    [self addChild:moveVehicle2Particle z:Z_ORDER_TOP];

    /*freezeTimePowerUpParticle = [CCParticleSystemQuad particleWithFile:@"FreezeTimePowerUpParticle.plist"];
    freezeTimePowerUpParticle.position = ccp(winSize.width/2, freezeTimePowerUpParticle.contentSize.height);
    freezeTimePowerUpParticle.visible = NO;
    [self addChild:freezeTimePowerUpParticle z:100];
    
    doublePointsPowerUpParticle = [CCParticleSystemQuad particleWithFile:@"DoublePointsPowerUpParticle.plist"];
    doublePointsPowerUpParticle.position = ccp(winSize.width/2, doublePointsPowerUpParticle.contentSize.height);
    doublePointsPowerUpParticle.visible = NO;
    [self addChild:doublePointsPowerUpParticle z:100];
    
    fiftyFiftyPowerUpParticle = [CCParticleSystemQuad particleWithFile:@"FiftyFiftyPowerUpParticle.plist"];
    fiftyFiftyPowerUpParticle.position = ccp(winSize.width/2, fiftyFiftyPowerUpParticle.contentSize.height);
    fiftyFiftyPowerUpParticle.visible = NO;
    [self addChild:fiftyFiftyPowerUpParticle z:100];
    
    specialStagePowerUpParticle = [CCParticleSystemQuad particleWithFile:@"SpecialStagePowerUpParticle.plist"];
    specialStagePowerUpParticle.position = ccp(winSize.width/2, specialStagePowerUpParticle.contentSize.height);
    specialStagePowerUpParticle.visible = NO;
    [self addChild:specialStagePowerUpParticle z:100];*/
 
}


#pragma mark - Retrieve Information

-(void) createQuestions {
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        questionArray = [[NSMutableArray alloc] init];
        NSString *questionString = challenge.question;
        
        if ([questionString isEqualToString:@""]) {
            CCLOG(@"AsyncGameUI: New set of questions");

            Territory *questionTerritory;
            
            for (int j = 0; j < 50; j++) {
                int i = arc4random() % [territoriesChosen count];
                questionTerritory = [territoriesChosen objectAtIndex:i];
                
                Question *q = [[GeoQuestDB database] getQuestionFrom:questionTerritory];
                while ([self checkQuestionInArray:q]) {
                    q = [[GeoQuestDB database] getQuestionFrom:questionTerritory];
                }
                [questionArray addObject:[q dictionary]];
            }
            
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:questionArray options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
            challenge.question = jsonString;
            
        } else {
            CCLOG(@"AsyncGameUI: Loaded old set of questions");
            
            [questionArray release];
            
            NSError *error = nil;
            NSString *jsonString = challenge.question;
            questionArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            [questionArray retain];
            
            challenge.question = @"";
        }
        //CCLOG(@"AsyncGameUI: Questions - %@", questionString);

        //Load race data
        //Schedule Update
        NSString *CNRD = @"";
        if ([PlayerDB database].playerInPlayer1Column) {
            //Loading player2_next_race data to check if there is data.
            //If there is data, load it into challengerRaceDataArray to compare later with playerRaceData
            CNRD = challenge.player2_next_race;
        } else {
            //Player is in player2 column.
            //Load player1_next_race into challengerRaceDataArray.
            CNRD = challenge.player1_next_race;
        }
        
        if (![CNRD isEqualToString:@""]) {
            challengerVehicle.visible = YES;
            NSError *jsonError = nil;
            challengerRaceDataArray = [NSJSONSerialization JSONObjectWithData:[CNRD dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
            [challengerRaceDataArray retain];
        }
        
        playerVehicle.visible = YES;
        //asyncGameTheme.visible = YES;
        
        [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSMutableArray *convertedArray = [NSMutableArray arrayWithObjects:nil];
            
            for (int i = 0; i < [questionArray count]; i++) { //Convert dictionary objects to Question objects
                Question *convertedQuestion = [[Question alloc] initWithDictionary:[questionArray objectAtIndex:i]];
                [convertedArray addObject:convertedQuestion];
                [convertedQuestion release];
            }
            [questionArray release];
            
            questionArray = [[NSMutableArray alloc] initWithArray:convertedArray];
            
            [self scheduleUpdate];
        }];
    }];
}

-(BOOL) checkQuestionInArray:(Question*)q {
    
    for (int i = 0; i < [questionArray count]; i++) {
        Question* duplicate = [[Question alloc] initWithDictionary:[questionArray objectAtIndex:i]];
        if ([q.question isEqualToString:duplicate.question] && [q.questionType isEqualToString:duplicate.questionType] && [q.answerId isEqualToString:duplicate.answerId]) {
            CCLOG(@"duplicate");
            [duplicate release];
            return YES;
        }
        [duplicate release];
    }
    return NO;
}

-(void) createAnswers {
    answerArray = [[NSMutableArray alloc] init];
}

-(void) createRaceData {
    playerRaceDataArray = [[NSMutableArray alloc] init];
}

-(id) getQuestion {
    currentQuestion = [questionArray objectAtIndex:questionsAsked];
    questionsAsked++;
    
    
    int powerUpPercentage = arc4random() % 100;
    //int powerUpPercentage = 0;
    if (powerUpPercentage < powerUpPercentageRequirement) {
        powerUpPercentageRequirement = 0;
        int whichPowerUp = arc4random() % kTotalPowerUps;
        //int whichPowerUp = kSpecialStagePowerUp;
        switch (whichPowerUp) {
            case kFreezeTimePowerUp:
                //currentQuestion.powerUpTypeQuestion = kFreezeTimePowerUp;
                currentQuestion.powerUpTypeQuestion = k5050PowerUp;
                CCLOG(@"AsyncGameUI: Freeze Timer Power UP");
                break;
            case kDoublePointsPowerUp:
                currentQuestion.powerUpTypeQuestion = kDoublePointsPowerUp;
                CCLOG(@"AsyncGameUI: Double Points Power UP");
                break;
            case k5050PowerUp:
                currentQuestion.powerUpTypeQuestion = k5050PowerUp;
                CCLOG(@"AsyncGameUI: 50/50 Power UP");
                break;
            case kSpecialStagePowerUp:
                currentQuestion.powerUpTypeQuestion = kDoublePointsPowerUp;
                //currentQuestion.powerUpTypeQuestion = kSpecialStagePowerUp;
                //CCLOG(@"AsyncGameUI: Special Stage Power UP");
                break;
            default:
                break;
        }
    } else {
        currentQuestion.powerUpTypeQuestion = kNullPowerUp;
        powerUpPercentageRequirement += 15;
        CCLOG(@"powerup percentage req: %i", powerUpPercentageRequirement);
    }

    //Question is a text label
    GameTheme *tempGameTheme = [themeTotal objectAtIndex:0];    
    
    CCSprite *qDisplay = [CCSprite spriteWithSpriteFrameName:@"ThemeQuestionDisplay.png"];
    qDisplay.position = ccp(tempGameTheme.boundaryRect.size.width/2, tempGameTheme.boundaryRect.size.height - qDisplay.contentSize.height/2- ASYNC_GRID_SPACING);

    CCLabelTTF *qText = [CCLabelTTF labelWithString:currentQuestion.question fontName:@"Arial" fontSize:28];
    qText.color = ccc3(255, 255, 255);
    qText.position = ccp(qDisplay.contentSize.width/2, qDisplay.contentSize.height/2);
    [qDisplay addChild:qText];
    
    CCSprite *qImageAnswer;
    CCSprite *qImageAnswerFrame;
    CCLabelTTF *qTextAnswer;
    if ([currentQuestion.info isEqualToString:@"PICTEXT"]) { //Question is a picture
        qImageAnswerFrame = [CCSprite spriteWithSpriteFrameName:@"ThemePictureFrame.png"];
        qImageAnswerFrame.position = ccp(qDisplay.contentSize.width/2, -qImageAnswerFrame.contentSize.height/2 - ASYNC_GRID_SPACING/2);
        
        qImageAnswer = [CCSprite spriteWithSpriteFrameName:currentQuestion.answer];
        qImageAnswer.scale = 2.0;
        qImageAnswer.position = qImageAnswerFrame.position;
        
        [qDisplay addChild:qImageAnswer];
        [qDisplay addChild:qImageAnswerFrame];

        
        switch (currentQuestion.powerUpTypeQuestion) {
            case kFreezeTimePowerUp:
                qImageAnswer.color = ccc3(99, 185, 242);
                break;
            case kDoublePointsPowerUp:
                qImageAnswer.color = ccc3(255, 245, 107);
                break;
            case k5050PowerUp:
                qImageAnswer.color = ccc3(250, 107, 255);
                break;
            case kSpecialStagePowerUp:
                qImageAnswer.color = ccc3(102, 227, 102);
                break;
                
            default:
                break;
        }
        

    } else { //Question is a text
        qTextAnswer = [CCLabelTTF labelWithString:currentQuestion.answer fontName:@"Arial" fontSize:28];
        qTextAnswer.position = ccp(qDisplay.contentSize.width/2, -qTextAnswer.contentSize.height/2 - ASYNC_GRID_SPACING);
        qTextAnswer.color = ccc3(100, 100, 100);
        [qDisplay addChild:qTextAnswer];

        switch (currentQuestion.powerUpTypeQuestion) {
            case kFreezeTimePowerUp:
                qTextAnswer.color = ccc3(99, 185, 242);
                break;
            case kDoublePointsPowerUp:
                qTextAnswer.color = ccc3(255, 245, 107);
                break;
            case k5050PowerUp:
                qTextAnswer.color = ccc3(250, 107, 255);
                break;
            case kSpecialStagePowerUp:
                qTextAnswer.color = ccc3(102, 227, 102);
                break;
                
            default:
                break;
        }
    }
    return qDisplay;
}

-(CCMenuAdvancedPlus*) getAnswerChoices {
    int difficultyChoice = kNormalDifficulty;
        
    if (fiftyFiftyPowerUpActivated) {
        currentAnswerChoices = [[GeoQuestDB database] getAnswerChoicesFrom:currentQuestion specialPower:k5050PowerUp];
        answerChoicesVisibleCount = 2;
        difficultyChoice = k5050PowerUp;
    } else {
        currentAnswerChoices = [[GeoQuestDB database] getAnswerChoicesFrom:currentQuestion specialPower:difficultyChoice];
    }
    
    [answerArray addObject:currentAnswerChoices];
    
    CCMenuAdvancedPlus *answerMenu = [CCMenuAdvancedPlus menuWithItems:nil];
    
    for (int i = 0; i < [currentAnswerChoices count]; i++) {
        GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
        CCMenuItemSprite *answerItemSprite;
        CCLOG(@"a.answer = %@", a.answer);
        if ([currentQuestion.info isEqualToString:@"PICTEXT"]) {
            
            //Answer choices are text labels
            answerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ThemeTextFrame.png"] target:self selector:@selector(checkAnswer:)];
            answerItemSprite.tag = i;
            
            CCLabelTTF *name = [CCLabelTTF labelWithString:a.answer fontName:@"Arial" fontSize:16];
            name.position = ccp(answerItemSprite.contentSize.width/2, answerItemSprite.contentSize.height/2);
            name.color = ccc3(100,100,100);
            
            [answerItemSprite addChild:name];
            [answerMenu addChild:answerItemSprite];
        } else {
            
            //Answer choices are images
            answerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:a.answer] selectedSprite:[CCSprite spriteWithSpriteFrameName:a.answer] target:self selector:@selector(checkAnswer:)];
            answerItemSprite.tag = i;
            switch (difficultyChoice) {
                case kEasyDifficulty:
                    answerItemSprite.scale = 1.0;
                    break;
                case kNormalDifficulty:
                    answerItemSprite.scale = 1.2;
                    break;
                case kExtremeDifficuly:
                    answerItemSprite.scale = 0.75;
                    break;
                    
                default:
                    break;
            }
            
            [answerMenu addChild:answerItemSprite];
        }
    }
    
    if ([currentQuestion.info isEqualToString:@"PICTEXT"]) {
        //Answer choices are text labels
        switch (difficultyChoice) {
            case k5050PowerUp:
                [answerMenu alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:2];
                break;
            case kEasyDifficulty:
                [answerMenu alignItemsVerticallyWithPadding:ASYNC_GRID_SPACING];
                break;
            case kNormalDifficulty:
                [answerMenu alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:2];
                break;
            case kExtremeDifficuly:
                [answerMenu alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:2];
                break;
                
            default:
                break;
        }
        
    } else {
        //Answer choices are images
        switch (difficultyChoice) {
            case k5050PowerUp:
                [answerMenu alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:2];
                break;
            case kEasyDifficulty:
                [answerMenu alignItemsVerticallyWithPadding:ASYNC_GRID_SPACING];
                break;
            case kNormalDifficulty:
                [answerMenu alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:2];
                break;
            case kExtremeDifficuly:
                [answerMenu alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:2];
                break;
                
            default:
                break;
        }
    }
    
    answerMenu.ignoreAnchorPointForPosition = NO;
    GameTheme *tempGameTheme = [themeTotal objectAtIndex:0];
    //CCLayerColor *tempLayer = [questionLayerTotal objectAtIndex:0];

    
    switch (difficultyChoice) {
        case k5050PowerUp:
            if ([currentQuestion.info isEqualToString:@"PICTEXT"]) {
                answerMenu.position = ccp(winSize.width/2, answerMenu.contentSize.height + ASYNC_GRID_SPACING * 2);

            } else {
                answerMenu.position = ccp(winSize.width/2, (answerMenu.contentSize.height + ASYNC_GRID_SPACING) * 2);
            }
            break;
        case kEasyDifficulty:
            if ([currentQuestion.info isEqualToString:@"PICTEXT"]) {
                answerMenu.position = ccp(winSize.width/2, (answerMenu.contentSize.height + ASYNC_GRID_SPACING) * 2);
            } else {
                answerMenu.position = ccp(winSize.width/2, (answerMenu.contentSize.height + ASYNC_GRID_SPACING) * 2);
            }
            break;
        case kNormalDifficulty:
            if ([currentQuestion.info isEqualToString:@"PICTEXT"]) {
                answerMenu.position = ccp(winSize.width/2, answerMenu.contentSize.height/2 + ASYNC_GRID_SPACING);
            } else {
                answerMenu.position = ccp(winSize.width/2, answerMenu.contentSize.height/2 + ASYNC_GRID_SPACING * 1.5);
            }
            break;
        case kExtremeDifficuly:
            if ([currentQuestion.info isEqualToString:@"PICTEXT"]) {
                answerMenu.position = ccp(winSize.width/2, tempGameTheme.boundaryRect.size.height*.28);
            } else {
                answerMenu.position = ccp(winSize.width/2, tempGameTheme.boundaryRect.size.height*.41);
            }
            break;
            
        default:
            break;
    }
    
    answerMenu.boundaryRect = CGRectMake(answerMenu.position.x - answerMenu.contentSize.width/2, answerMenu.position.y - answerMenu.contentSize.height/2, answerMenu.contentSize.width, answerMenu.contentSize.height);
    
    answerMenu.disableScroll = YES;
    
    [answerMenu fixPosition];
    
    return answerMenu;
}

/*-(CCMenuAdvanced*) getSpecialStageAnswerChoices {
    questionsAsked++;
    
    currentAnswerChoices = [[GeoQuestDB database] getSpecialStageAnswerChoices];
    
    CCMenuAdvanced *answerGrid = [CCMenuAdvanced menuWithItems:nil];
    
    for (int i = 0; i < [currentAnswerChoices count]; i++) {
        GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
        CCMenuItemSprite *answerItemSprite;
        
        //Answer choices are images
        answerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:a.name] selectedSprite:[CCSprite spriteWithSpriteFrameName:a.name] disabledSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] target:self selector:@selector(checkSpecialStageAnswer:)];
        answerItemSprite.tag = i;
        answerItemSprite.scale = 0.65;
        
        [answerGrid addChild:answerItemSprite];
    }
    
    [answerGrid alignItemsInGridWithPadding:ccp(ASYNC_GRID_SPACING, ASYNC_GRID_SPACING) columns:3];
    
    answerGrid.ignoreAnchorPointForPosition = NO;
    
    answerGrid.position = ccp(winSize.width/2, winSize.height/2);
    answerGrid.boundaryRect = CGRectMake(answerGrid.position.x - answerGrid.contentSize.width/2, answerGrid.position.y - answerGrid.contentSize.height/2, answerGrid.contentSize.width, answerGrid.contentSize.height);
    [answerGrid fixPosition];
    
    return answerGrid;
}*/

-(void) getTheme {
    for (int i = 0; i < [themeTotal count]; i++) {
        GameTheme *t = [themeTotal objectAtIndex:i];
        if (t.visible == NO) {
            if ([themeVisible count] != 0) {
                GameTheme *lastSprite = [themeVisible objectAtIndex:([themeVisible count]-1)];
                t.position = ccp(lastSprite.position.x + winSize.width, lastSprite.position.y);
            } else {
                t.position = ccp(winSize.width + winSize.width/2, clock.position.y - clock.contentSize.height/2 - t.contentSize.height/2 + 8.5);
            }
            t.visible = YES;
            [themeVisible addObject:t];
            break;
        }
    }
}

#pragma mark - Initialize Game

-(id) init {
    if ((self = [super init])) {
        CCLOG(@"AsyncGameUI: Game Started!");
        winSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;

        //[self setupGame];
        //[self scheduleUpdate];

        }
    return self;
}


#pragma mark - Reset Game

-(void) resetGame {
    questionAnswered = YES;
    questionChecked = NO;
    previousAnswerCorrect = NO;
    previousAnswerQuickDrawCorrect = NO;
    freezeTimePowerUpActivated = NO;
    doublePointsPowerUpActivated = NO;
    fiftyFiftyPowerUpActivated = NO;
    specialStagePowerUpActivated = NO;
    prepTimer = 2.0;
    gameTimer = ASYNC_GAME_TIMER;
    questionTimer = 7.0;
    freezeTimePowerUpTimer = 0.0;
    doublePointsPowerUpTimer = 0.0;
    fiftyFiftyPowerUpTimer = 0.0;
    specialStagePowerUpTimer = 0.0;
    quickDrawTimer = ASYNC_GAME_QUICKDRAW_TIMER;
    
    questionsAsked = 0;
    questionsAnsweredCorrectly = 0;
    powerUpPercentageRequirement = 0;
    score = 0;
    pointsEarned = 0;
    answerCorrectlyInRow = 0;
    answerQuickDrawCorrectlyInRow = 0;
    answerIncorrectlyInRow = 0;
    answerChoicesVisibleCount = 4;
}

-(void) gameOver {
    
    [self hideLayerAndObjects];

    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerRaceDataArray options:NSJSONWritingPrettyPrinted error:&jsonError];
        NSString *raceDataArrayString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
        
        NSString *CNRD = @"";
        if ([PlayerDB database].playerInPlayer1Column) { //Player is in player_id. Use player_next_race/player_prev_race
            CNRD = challenge.player2_next_race;
            
            if ([CNRD isEqualToString:@""]) {
                challenge.player1_next_race = raceDataArrayString;
                challenge.turn = challenge.player2_id;
            } else {
                [self checkWhoWonRound];
                
                challenge.player2_prev_race = challenge.player2_next_race;
                challenge.player1_prev_race = raceDataArrayString;
                challenge.player2_next_race = @"";
            }
        } else {
            CNRD = challenge.player1_next_race;
            
            if ([CNRD isEqualToString:@""]) {
                challenge.player2_next_race = raceDataArrayString;
                challenge.turn = challenge.player1_id;
            } else {
                [self checkWhoWonRound];
                
                challenge.player1_prev_race = challenge.player1_next_race;
                challenge.player2_prev_race = raceDataArrayString;
                challenge.player1_next_race = @"";
            }
        }
        
        [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [asyncGameGameOver checkGameOverMenu];
        }];
        
    }];
    
}

-(void) checkWhoWonRound {
    PFQuery *challengeQuery = [ChallengesInProgress query];
    [challengeQuery whereKey:@"objectId" equalTo:[PlayerDB database].currentChallenge.objectId];
    challengeQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *challengeObjectArray, NSError *error) {
        ChallengesInProgress *challenge = [challengeObjectArray objectAtIndex:0];
        
        NSString *CNRD = @"";
        if ([PlayerDB database].playerInPlayer1Column) {
            CNRD = challenge.player2_next_race;
        } else {
            CNRD = challenge.player1_next_race;
        }

        NSError *jsonError = nil;
        NSMutableArray *tempChallengerRaceDataArray = [NSJSONSerialization JSONObjectWithData:[CNRD dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];

        RaceData *playerLastObject = [[RaceData alloc] initWithDictionary:[playerRaceDataArray objectAtIndex:[playerRaceDataArray count] - 1]];
        RaceData *challengerLastObject = [[RaceData alloc] initWithDictionary:[tempChallengerRaceDataArray objectAtIndex:[tempChallengerRaceDataArray count] - 1]];
        
        if (playerLastObject.time < 60 && challengerLastObject.time < 60) {
            if (playerLastObject.time < challengerLastObject.time) {
                if ([PlayerDB database].playerInPlayer1Column) {
                    challenge.player1_wins++;
                } else {
                    challenge.player2_wins++;
                }
            } else {
                if ([PlayerDB database].playerInPlayer1Column) {
                    challenge.player2_wins++;
                } else {
                    challenge.player1_wins++;
                }
            }
        } else {
            int playerGameScore = 0;
            int challengerGameScore = 0;
            
            for (int i = 0; i < [playerRaceDataArray count]; i++) {
                RaceData *r = [[RaceData alloc] initWithDictionary:[playerRaceDataArray objectAtIndex:i]];
                playerGameScore += r.points;
                [r release];
            }
            
            for (int i = 0; i < [tempChallengerRaceDataArray count]; i++) {
                RaceData *r = [[RaceData alloc] initWithDictionary:[tempChallengerRaceDataArray objectAtIndex:i]];
                challengerGameScore += r.points;
                [r release];
            }
            
            if (playerGameScore > challengerGameScore) {
                if ([PlayerDB database].playerInPlayer1Column) {
                    challenge.player1_wins++;
                } else {
                    challenge.player2_wins++;
                }
            } else {
                if ([PlayerDB database].playerInPlayer1Column) {
                    challenge.player2_wins++;
                } else {
                    challenge.player1_wins++;
                }
            }
        }
        
        [playerLastObject release];
        [challengerLastObject release];
        
        [challenge saveInBackground];

    }];
    
}

#pragma mark - Update Game

-(void) updateUILabels {
    //Updates all the labels on screen.
    
    [prepTimerLabel setString:[NSString stringWithFormat:@"%.f", prepTimer]];
    [gameTimerLabel setString:[NSString stringWithFormat:@"Time: %.02f", gameTimer]];
    
    if (questionTimer < 3) {
        questionTimerLabel.color = ccc3(255, 0, 0);
    } else {
        questionTimerLabel.color = ccc3(0, 255, 0);
    }
    [questionTimerLabel setString:[NSString stringWithFormat:@"%.01f", questionTimer]];
    
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %.01f", score]];
    [pointsEarnedLabel setString:[NSString stringWithFormat:@"%.01f", pointsEarned]];
    [inRowLabel setString:[NSString stringWithFormat:@"%i in a row!", answerCorrectlyInRow]];
    [inRowQuickDrawLabel setString:[NSString stringWithFormat:@"%i quick draw in a row!", answerQuickDrawCorrectlyInRow]];
}

-(void) updateTheme {
    //Sets themes to not visible that have gone off screen.
    
    for (int i = 0; i < [themeVisible count]; i ++) {
        CCSprite *t = [themeVisible objectAtIndex:i];
        if (t.visible && t.position.x < -t.contentSize.width/2) {
            t.visible = NO;
            [themeVisible removeObjectAtIndex:i];
        }
    }
}

-(void) updateTime:(ccTime)delta {
    //if (difficultyChoice >= 0) {
        //Difficulty Selected. (Difficulty < 0 if unselected)
        
        if (prepTimer > 0) {
            //Game start count down
            
            prepTimer -= delta;
        } else {
            prepTimer = 0.0;
            prepTimerLabel.visible = NO;
            gameTimerLabel.visible = YES;
            scoreLabel.visible = YES;
        }
        
        if (prepTimer <= 0) {
            //Countdown finished. Game starts.
            
            if (questionAnswered) {
                //Check to see if Question was answered. Retrieve new question
                
                [question removeFromParentAndCleanup:YES];
                [questionTimerLabel removeAllChildrenWithCleanup:YES];
                [answerChoicesMenu removeFromParentAndCleanup:YES];
                
                [self getTheme];
                
                correctMark.visible = NO;
                wrongMark.visible = NO;
                quickDrawLabel.visible = NO;
                inRowLabel.visible = NO;
                inRowQuickDrawLabel.visible = NO;
                questionTimerLabel.visible = YES;

                if (specialStagePowerUpActivated) {
                    questionAnswered = NO;
                    question = NULL;
                    //answerChoicesMenu = [self getSpecialStageAnswerChoices];
                    //answerChoicesMenu.visible = YES;
                } else {
                    questionAnswered = NO;
                    question = [self getQuestion];
                    answerChoicesMenu = [self getAnswerChoices];
                    question.visible = YES;
                    answerChoicesMenu.visible = YES;
                }
       
                GameTheme* themeSprite = [themeVisible objectAtIndex:([themeVisible count]-1)];
                
                if (question != NULL) {
                    question.position = ccp(themeSprite.boundaryRect.size.width/2, question.position.y);
                    [themeSprite addChild:question];
                }
                
                answerChoicesMenu.position = ccp(themeSprite.contentSize.width/2, answerChoicesMenu.position.y);

                answerChoicesMenu.boundaryRect = CGRectMake(answerChoicesMenu.position.x - answerChoicesMenu.contentSize.width/2, answerChoicesMenu.boundaryRect.origin.y, answerChoicesMenu.boundaryRect.size.width, answerChoicesMenu.boundaryRect.size.height);
                
                [themeSprite addChild:answerChoicesMenu];
                
                for (int i = 0; i < [themeVisible count]; i++) {
                    GameTheme *t = [themeVisible objectAtIndex:i];
                    id themeAction = [CCMoveBy actionWithDuration:0.25 position:ccp(-winSize.width, 0)];

                    id themeEase = [CCEaseInOut actionWithAction:themeAction rate:2];
                    [t runAction:themeEase];
                }
            }
            
            if (gameTimer > 0) {
                
                // Move challenger vehicle
                if ([challengerRaceDataArray count] > 0) {
                    RaceData *r = [[[RaceData alloc] initWithDictionary:[challengerRaceDataArray objectAtIndex:0]] autorelease];
                    if (r.time < (60 - gameTimer)) {
                        id challengerVehicleAction;
                        if ((challengerVehicle.position.x + ((winSize.width - challengerVehicle.contentSize.width)/ASYNC_GAME_SCORE_TO_WIN * r.points)) > finishingPoint) {
                            challengerVehicleAction = [CCMoveTo actionWithDuration:0.35 position:ccp(finishingPoint, challengerVehicle.position.y)];
                        } else {
                            challengerVehicleAction = [CCMoveTo actionWithDuration:0.35 position:ccp(challengerVehicle.position.x + ((winSize.width - challengerVehicle.contentSize.width)/ASYNC_GAME_SCORE_TO_WIN * r.points), challengerVehicle.position.y)];
                        }
                        
                        moveVehicle2Particle.position = ccp(challengerVehicle.position.x - challengerVehicle.contentSize.width/2, challengerVehicle.position.y - challengerVehicle.contentSize.height/4);
                        moveVehicle2Particle.visible = YES;
                        [moveVehicle2Particle resetSystem];
                        
                        id challengerVehicleEase = [CCEaseInOut actionWithAction:challengerVehicleAction rate:2];
                        [challengerVehicle runAction:challengerVehicleEase];
                        [challengerRaceDataArray removeObjectAtIndex:0];
                    }
                }
                
                questionTimer -= delta;
                if (questionTimer < 5.0 && answerChoicesVisibleCount > 3) {
                    [self hideOneAnswerChoice];

                } else if (questionTimer < 3.0 && answerChoicesVisibleCount > 2) {
                    [self hideOneAnswerChoice];
                }
                
                if (questionTimer <= 0.0) {
                    questionTimer = 0.0;
                    questionTimerLabel.visible = NO;
                    if (!questionChecked  && !correctMark.visible && !wrongMark.visible) {
                        [self ranOutOfTimeToAnswer];
                        questionChecked = YES;
                    }
                }
                
                //Game timer countdown. Also counts down powerup timers.
                
                if (freezeTimePowerUpActivated == NO && specialStagePowerUpActivated == NO) {
                    if (doublePointsPowerUpActivated == YES) {
                        if (doublePointsPowerUpTimer > 0) {
                            doublePointsPowerUpTimer -= delta;
                        } else {
                            doublePointsPowerUpTimer = 0.0;
                            doublePointsPowerUpActivated = NO;
                            //doublePointsPowerUpParticle.visible = NO;
                        }
                    }
                    if (fiftyFiftyPowerUpActivated == YES) {
                        if (fiftyFiftyPowerUpTimer > 0) {
                            fiftyFiftyPowerUpTimer -= delta;
                        } else {
                            fiftyFiftyPowerUpTimer = 0.0;
                            fiftyFiftyPowerUpActivated = NO;
                            //fiftyFiftyPowerUpParticle.visible = NO;
                        }
                    }
                    
                    gameTimer -= delta;
                    
                } else {
                    if (specialStagePowerUpTimer > 0) {
                        specialStagePowerUpTimer -= delta;
                    } else {
                        if (specialStagePowerUpActivated == YES) {
                            questionAnswered = YES;
                        }
                        specialStagePowerUpTimer = 0.0;
                        specialStagePowerUpActivated = NO;
                        //specialStagePowerUpParticle.visible = NO;
                    }
                    
                    if (freezeTimePowerUpTimer > 0) {
                        freezeTimePowerUpTimer -= delta;
                    } else {
                        freezeTimePowerUpTimer = 0.0;
                        freezeTimePowerUpActivated = NO;
                        //freezeTimePowerUpParticle.visible = NO;
                    }
                }
            } else {
                gameTimer = 0.0;
            }
            
            quickDrawTimer -= delta;
        }
        
        if (gameTimer <= 0 || score > ASYNC_GAME_SCORE_TO_WIN) {
            //Game timer finished counting down. Show gameover screen and unschedule the update method.
                        
            gameTimer = 0.0;
            clock.visible = NO;
            question.visible = NO;
            correctMark.visible = NO;
            wrongMark.visible = NO;
            answerChoicesMenu.visible = NO;
            
            for (int i = 0; i < [themeVisible count]; i++) {
                CCSprite *t = [themeVisible objectAtIndex:i];
                t.visible = NO;
            }
            
            [self updateUILabels];
            if ([self numberOfRunningActions] == 0) {
                [self unscheduleUpdate];
                [self gameOver];
            }
        }
    //}
}

-(void) update:(ccTime)delta {
    [self updateUILabels];
    [self updateTheme];
    //[self updateQuestionLayer];
    [self updateTime:delta];
}

#pragma mark - Check Trivia

-(void) checkAnswer:(CCMenuItemSprite*)sender {
    //If the answer is correct then make the 'O' sprite visible. If the answer is wrong then make the 'X' sprite visible.
    if (sender == NULL) {
        return;
    }
    
    int i = sender.tag;
    
    questionTimerLabel.visible = NO;
    
    answerChoicesMenu.isTouchEnabled = NO;
    
    NSMutableArray *array = [answerArray objectAtIndex:questionsAsked-1];
    GeoQuestAnswer *a = [array objectAtIndex:i];
    CCLOG(@"answer chose:%@", a.answer);
    //GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
    
    BOOL correctAnswer = NO;
    if (specialStagePowerUpActivated) {
    //    correctAnswer = [[GeoQuestDB database] checkAnswer:a withCategory:@"USAStates"];
        CCLOG(@"SpecialStagePowerUpActivated");
    } else {
        correctAnswer = [[GeoQuestDB database] checkAnswer:a withQuestion:currentQuestion];
    }
    
    if (correctAnswer) {        
        [[GameManager sharedGameManager] playSoundEffect:@"CORRECT_SFX"];
        questionsAnsweredCorrectly++;
        
        switch (currentQuestion.powerUpTypeQuestion) {
            case kFreezeTimePowerUp:
                freezeTimePowerUpActivated = YES;
                //freezeTimePowerUpParticle.visible = YES;
                freezeTimePowerUpTimer += 10.0;
                break;
            case kDoublePointsPowerUp:
                doublePointsPowerUpActivated = YES;
                //doublePointsPowerUpParticle.visible = YES;
                doublePointsPowerUpTimer += 10.0;
                break;
            case k5050PowerUp:
                fiftyFiftyPowerUpActivated = YES;
                //fiftyFiftyPowerUpParticle.visible = YES;
                fiftyFiftyPowerUpTimer += 10.0;
                break;
            case kSpecialStagePowerUp:
                specialStagePowerUpActivated = YES;
                //specialStagePowerUpParticle.visible = YES;
                specialStagePowerUpTimer += 10.0;
                break;
                
            default:
                break;
        }
        
        correctMark.position = [answerChoicesMenu convertToWorldSpace:sender.position];
        
        //gameTimer += 1.5;
        pointsEarnedLabel.position = ccp(winSize.width/2, winSize.height/2);
        pointsEarnedLabel.visible = YES;
        
        inRowLabel.visible = YES;
        answerCorrectlyInRow++;
        pointsEarned += questionTimer + MIN(3, answerCorrectlyInRow);
        previousAnswerCorrect = YES;
        
        if (quickDrawTimer > 0.0) {
            inRowLabel.visible = NO;
            inRowQuickDrawLabel.visible = YES;
            quickDrawLabel.visible = YES;
            answerQuickDrawCorrectlyInRow++;
            pointsEarned += 1 + MIN(3, answerQuickDrawCorrectlyInRow);
        } else {
            answerQuickDrawCorrectlyInRow = 0;
        }
        
        correctMark.scale = 2.0;
        correctMark.visible = YES;
        id action = [CCScaleTo  actionWithDuration:0.25 scale:1];
        id ease = [CCEaseExponentialOut actionWithAction:action];
        [correctMark runAction:ease];
        previousAnswerCorrect = YES;
        
    } else {
        [[GameManager sharedGameManager] playSoundEffect:@"WRONG_SFX"];
        
        if (currentQuestion.powerUpTypeQuestion != kNullPowerUp) {
            powerUpPercentageRequirement = 30;
        }
        
        wrongMark.position = [answerChoicesMenu convertToWorldSpace:sender.position];
        
        previousAnswerCorrect = NO;
        answerCorrectlyInRow = 0;
        answerQuickDrawCorrectlyInRow = 0;
        
        wrongMark.scale = 2.0;
        wrongMark.visible = YES;
        id action = [CCScaleTo  actionWithDuration:0.25 scale:1];
        id ease = [CCEaseExponentialOut actionWithAction:action];
        [wrongMark runAction:ease];
        
        id shakeAction1 = [CCMoveBy actionWithDuration:0.05 position:ccp(5, 0)];
        id shakeAction2 = [CCMoveBy actionWithDuration:0.05 position:ccp(-10, 0)];
        id shakeAction3 = [CCMoveBy actionWithDuration:0.05 position:ccp(10, 0)];
        id shakeAction4 = [CCMoveBy actionWithDuration:0.05 position:ccp(-5, 0)];
        
        id shakeMiddleSequence = [CCSequence actions:shakeAction2, shakeAction3, nil];
        id shakeRepeat = [CCRepeat actionWithAction:shakeMiddleSequence times:2];
        id shakeTotalSequence = [CCSequence actions:shakeAction1, shakeRepeat, shakeAction4, nil];
        
        GameTheme* tempGameTheme = [themeVisible objectAtIndex:([themeVisible count]-1)];
        //[self runAction:shakeTotalSequence];
        [tempGameTheme runAction:shakeTotalSequence];
    }
        
    if (doublePointsPowerUpActivated == YES) {
        pointsEarned *= 2;
    }
    
    //id action = [CCMoveTo actionWithDuration:0.35 position:ccp(scoreLabel.position.x, scoreLabel.position.y - pointsEarnedLabel.contentSize.height/2)];
    id pointsAction = [CCMoveTo actionWithDuration:0.35 position:ccp(pointsEarnedLabel.position.x, pointsEarnedLabel.position.y + pointsEarnedLabel.contentSize.height)];
    id pointsEase = [CCEaseInOut actionWithAction:pointsAction rate:2];
    [pointsEarnedLabel runAction:pointsEase];
    
    RaceData *r = [[RaceData alloc] initRaceDataWithTime:(60 - gameTimer) answerType:currentQuestion.info answer:currentQuestion.answer isCorrect:correctAnswer points:pointsEarned];
    [playerRaceDataArray addObject:[r dictionary]];
    [r release];
    
    id playerVehicleAction;
    if ((playerVehicle.position.x + ((winSize.width - playerVehicle.contentSize.width)/ASYNC_GAME_SCORE_TO_WIN * pointsEarned)) > finishingPoint) {
        playerVehicleAction = [CCMoveTo actionWithDuration:0.35 position:ccp(finishingPoint, playerVehicle.position.y)];
    } else {
        playerVehicleAction = [CCMoveTo actionWithDuration:0.35 position:ccp(playerVehicle.position.x + ((winSize.width - playerVehicle.contentSize.width)/ASYNC_GAME_SCORE_TO_WIN * pointsEarned), playerVehicle.position.y)];
    }
    id playerVehicleEase = [CCEaseInOut actionWithAction:playerVehicleAction rate:2];
    [playerVehicle runAction:playerVehicleEase];
    
    if (correctAnswer) {
        moveVehicle1Particle.position = ccp(playerVehicle.position.x - playerVehicle.contentSize.width/2, playerVehicle.position.y - playerVehicle.contentSize.height/4);
        moveVehicle1Particle.visible = YES;
        [moveVehicle1Particle resetSystem];
        [self performSelector:@selector(questionAnswered) withObject:nil afterDelay:0.35];
    } else {
        [self performSelector:@selector(questionAnswered) withObject:nil afterDelay:0.75];
    }
}

-(void) hideOneAnswerChoice {
    BOOL findingAnswer = YES;
    while (findingAnswer) {
        int i = arc4random() % 4;
        
        NSMutableArray *array = [answerArray objectAtIndex:questionsAsked-1];
        GeoQuestAnswer *a = [array objectAtIndex:i];
        //GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
        BOOL correctAnswer = [[GeoQuestDB database] checkAnswer:a withQuestion:currentQuestion];
        if (!correctAnswer) {
            CCArray *ansArray = [answerChoicesMenu children];
            CCMenuItemSprite *s = [ansArray objectAtIndex:i];
            if (s.visible == YES) {
                s.visible = NO;
                s.isEnabled = NO;
                answerChoicesVisibleCount--;
                findingAnswer = NO;
            }
        }
    }
}

/*-(void) checkSpecialStageAnswer:(CCMenuItemSprite*)sender {
    int i = sender.tag;
 
    CCMenuItemSprite *menuItem = sender;
 
    GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
    
    BOOL correctAnswer = [[GeoQuestDB database] checkAnswer:a withCategory:@"USAStates"];
    
    if (correctAnswer) {
        [[GameManager sharedGameManager] playSoundEffect:@"CORRECT_SFX"];
        
        correctMark.position = [answerChoicesMenu convertToWorldSpace:sender.position];
           
        correctMark.scale = 2.0;
        correctMark.visible = YES;
        id action = [CCScaleTo  actionWithDuration:0.25 scale:1];
        id ease = [CCEaseExponentialOut actionWithAction:action];
        [correctMark runAction:ease];
        menuItem.isEnabled = NO;
    } else {
        [[GameManager sharedGameManager] playSoundEffect:@"WRONG_SFX"];

        wrongMark.position = [answerChoicesMenu convertToWorldSpace:sender.position];
        
        wrongMark.scale = 2.0;
        wrongMark.visible = YES;
        id action = [CCScaleTo  actionWithDuration:0.25 scale:1];
        id ease = [CCEaseExponentialOut actionWithAction:action];
        [wrongMark runAction:ease];
        
        id shakeAction1 = [CCMoveBy actionWithDuration:0.05 position:ccp(5, 0)];
        id shakeAction2 = [CCMoveBy actionWithDuration:0.05 position:ccp(-10, 0)];
        id shakeAction3 = [CCMoveBy actionWithDuration:0.05 position:ccp(10, 0)];
        id shakeAction4 = [CCMoveBy actionWithDuration:0.05 position:ccp(-5, 0)];
        
        id shakeMiddleSequence = [CCSequence actions:shakeAction2, shakeAction3, nil];
        id shakeRepeat = [CCRepeat actionWithAction:shakeMiddleSequence times:2];
        id shakeTotalSequence = [CCSequence actions:shakeAction1, shakeRepeat, shakeAction4, nil];
        [self runAction:shakeTotalSequence];
    }
    
    if (correctAnswer) {
        [self performSelector:@selector(specialStageAnswered) withObject:nil afterDelay:0.35];
    } else {
        specialStagePowerUpTimer -= 1.0;
    }

}*/

-(void) ranOutOfTimeToAnswer {

    [[GameManager sharedGameManager] playSoundEffect:@"WRONG_SFX"];
    
    answerChoicesMenu.isTouchEnabled = NO;

    wrongMark.position = question.position;
    
    previousAnswerCorrect = NO;
    answerCorrectlyInRow = 0;
    answerQuickDrawCorrectlyInRow = 0;
    pointsEarned = 0;
        
    wrongMark.scale = 2.0;
    wrongMark.visible = YES;
    id action = [CCScaleTo  actionWithDuration:0.25 scale:1];
    id ease = [CCEaseExponentialOut actionWithAction:action];
    [wrongMark runAction:ease];
    
    id shakeAction1 = [CCMoveBy actionWithDuration:0.05 position:ccp(5, 0)];
    id shakeAction2 = [CCMoveBy actionWithDuration:0.05 position:ccp(-10, 0)];
    id shakeAction3 = [CCMoveBy actionWithDuration:0.05 position:ccp(10, 0)];
    id shakeAction4 = [CCMoveBy actionWithDuration:0.05 position:ccp(-5, 0)];
    
    id shakeMiddleSequence = [CCSequence actions:shakeAction2, shakeAction3, nil];
    id shakeRepeat = [CCRepeat actionWithAction:shakeMiddleSequence times:2];
    id shakeTotalSequence = [CCSequence actions:shakeAction1, shakeRepeat, shakeAction4, nil];
    [self runAction:shakeTotalSequence];
    
    RaceData *r = [[RaceData alloc] initRaceDataWithTime:(60 - gameTimer) answerType:currentQuestion.info answer:currentQuestion.answer isCorrect:NO points:pointsEarned];
    [playerRaceDataArray addObject:[r dictionary]];
    [r release];
    
    [self performSelector:@selector(questionAnswered) withObject:nil afterDelay:0.75];
}


-(void) specialStageAnswered {
    static int correctCount = 0;
    correctCount++;
    CCLOG(@"correct count = %i", correctCount);
    correctMark.visible = NO;
    if (correctCount == 5) {
        correctCount = 0;
        questionAnswered = YES;
        specialStagePowerUpActivated = NO;
        //specialStagePowerUpParticle.visible = NO;
        specialStagePowerUpTimer = 0.0;
    }
}

-(void) questionAnswered {
    score += pointsEarned;

    answerChoicesMenu.isTouchEnabled = YES;
    questionAnswered = YES;
    quickDrawTimer = ASYNC_GAME_QUICKDRAW_TIMER;
    pointsEarned = 0;
    pointsEarnedLabel.visible = NO;
    questionTimer = 7.0;
    questionChecked = NO;
    answerChoicesVisibleCount = 4;
    currentQuestion = nil;
    moveVehicle1Particle.visible = NO;
    moveVehicle2Particle.visible = NO;
}

-(void) hideLayerAndObjects {
    /*freezeTimePowerUpParticle.visible = NO;
    doublePointsPowerUpParticle.visible = NO;
    fiftyFiftyPowerUpParticle.visible = NO;
    specialStagePowerUpParticle.visible = NO;*/
    
}

-(void) showTerritoryLayer {
    [asyncGameTerritory showLayerAndObjects];
}

-(void) dealloc {
    [territoriesChosen release];
    [themeTotal release];
    [themeVisible release];
    [theme release];
    [questionArray release];
    [answerArray release];
    [playerRaceDataArray release];
    [challengerRaceDataArray release];
    [super dealloc];
}

@end
