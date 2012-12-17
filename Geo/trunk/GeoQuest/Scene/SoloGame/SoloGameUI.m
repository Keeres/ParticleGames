//
//  SoloGameUI.m
//  GeoQuest
//
//  Created by Kelvin on 11/8/12.
//  Copyright 2012 Particle Games LLC. All rights reserved.
//

#import "SoloGameUI.h"
#import "GameManager.h"
#import "MainMenuScene.h"



@implementation SoloGameUI

-(void) setSoloGameBGLayer:(SoloGameBG *)soloBG {
    soloGameBG = soloBG;
}

#pragma mark - Setup Game

-(void) setupGame {
    [self resetGame];
    [self setupDifficultyLayer];
}

-(void) difficultySelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0:
            difficultyChoice = kEasyDifficulty;
            break;
        case 1:
            difficultyChoice = kNormalDifficulty;
            break;
        case 2:
            difficultyChoice = kExtremeDifficuly;
            break;
            
        default:
            break;
    }
    
    difficultyChoiceMenu.visible = NO;
    difficultyChoiceMenu.enabled = NO;
    difficultyBackground.visible = NO;
    [selectDifficulty stopAllActions];
    
    [self setupCorrectAndWrongSprite];
    [self setupUILabels];
    [self setupGameOverMenu];
    [self setupTheme];
    [self setupParticleSystems];
}


-(void) setupDifficultyLayer {

    difficultyBackground = [CCSprite spriteWithSpriteFrameName:@"DifficultyBackground.png"];
    difficultyBackground.position = ccp(winSize.width/2, winSize.height/2);
        
    difficultyDisplay = [CCSprite spriteWithSpriteFrameName:@"DifficultyDisplay.png"];
    difficultyDisplay.position = ccp(winSize.width/2, winSize.height*.65);
    [difficultyBackground addChild:difficultyDisplay];
    
    selectDifficulty = [CCSprite spriteWithSpriteFrameName:@"SelectDifficulty01.png"];
    selectDifficulty.position = ccp(difficultyDisplay.contentSize.width/2, difficultyDisplay.contentSize.height/2);
    [difficultyDisplay addChild:selectDifficulty];
    
    NSMutableArray *selectDifficultyAnimFrames = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"SelectDifficulty%02d.png",i]];
        [selectDifficultyAnimFrames addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:selectDifficultyAnimFrames delay:0.30];
    [selectDifficulty runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    
    
    difficultyChoiceMenu = [CCMenuAdvanced menuWithItems:nil];
    
    CCMenuItemSprite *easyButtonSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"EasyButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"EasyButton.png"] target:self selector:@selector(difficultySelected:)];
    easyButtonSprite.tag = kEasyDifficulty;
    [difficultyChoiceMenu addChild:easyButtonSprite];
    
    CCMenuItemSprite *normButtonSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"NormButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"NormButton.png"] target:self selector:@selector(difficultySelected:)];
    normButtonSprite.tag = kNormalDifficulty;
    [difficultyChoiceMenu addChild:normButtonSprite];
    
    CCMenuItemSprite *hardButtonSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"HardButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"HardButton.png"] target:self selector:@selector(difficultySelected:)];
    hardButtonSprite.tag = kExtremeDifficuly;
    [difficultyChoiceMenu addChild:hardButtonSprite];
    
    [difficultyChoiceMenu alignItemsHorizontallyWithPadding:SOLO_GRID_SPACING/2 leftToRight:YES];

    difficultyChoiceMenu.ignoreAnchorPointForPosition = NO;
    difficultyChoiceMenu.position = ccp(winSize.width/2, winSize.height*.42);
    difficultyChoiceMenu.boundaryRect = CGRectMake(difficultyChoiceMenu.position.x - difficultyChoiceMenu.contentSize.width/2, difficultyChoiceMenu.position.y - difficultyChoiceMenu.contentSize.height/2, difficultyChoiceMenu.contentSize.width, difficultyChoiceMenu.contentSize.height);
    [difficultyChoiceMenu fixPosition];
    
    [difficultyBackground addChild:difficultyChoiceMenu z:100];
    [difficultyChoiceMenu retain];
    
    [self addChild:difficultyBackground];
    
}

-(void) setupCorrectAndWrongSprite {
    correctMark = [CCSprite spriteWithSpriteFrameName:@"AnswerCheckCorrect.png"];
    wrongMark = [CCSprite spriteWithSpriteFrameName:@"AnswerCheckWrong.png"];
    
    correctMark.position = ccp(winSize.width/4, winSize.height/2);
    wrongMark.position = correctMark.position;
    
    correctMark.visible = NO;
    wrongMark.visible = NO;
    
    [self addChild:correctMark z:20];
    [self addChild:wrongMark z:20];
}

-(void) setupUILabels {
    prepTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.f", prepTimer] fontName:@"TRS Million" fontSize:64];
    prepTimerLabel.position = ccp(winSize.width/2, winSize.height/2);
    prepTimerLabel.color = ccc3(255, 255, 255);
    [self addChild:prepTimerLabel z:20];
    
    gameTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time: %.02f", gameTimer] fontName:@"TRS Million" fontSize:18];
    gameTimerLabel.position = ccp(winSize.width/2, winSize.height - gameTimerLabel.contentSize.height/2);
    gameTimerLabel.color = ccc3(255, 255, 255);
    gameTimerLabel.visible = NO;
    [self addChild:gameTimerLabel z:20];
    
    questionTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.01f", gameTimer] fontName:@"TRS Million" fontSize:14];
    questionTimerLabel.position = ccp(winSize.width*.9, winSize.height*.8);
    questionTimerLabel.color = ccc3(0, 255, 0);
    questionTimerLabel.visible = NO;
    [self addChild:questionTimerLabel z:20];
    
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", score] fontName:@"TRS Million" fontSize:18];
    scoreLabel.anchorPoint = ccp(0, 0.5);
    scoreLabel.position = ccp(winSize.width*0.05, winSize.height - scoreLabel.contentSize.height/2);
    scoreLabel.color = ccc3(255, 255, 255);
    scoreLabel.visible = NO;
    [self addChild:scoreLabel z:20];
    
    pointsEarnedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", pointsEarned] fontName:@"TRS Million" fontSize:40];
    pointsEarnedLabel.position = ccp(winSize.width/2, winSize.height/2);
    pointsEarnedLabel.color = ccc3(255, 228, 74);
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

-(void) setupGameOverMenu {
    
    gameOverMenu = [CCMenuAdvanced menuWithItems:nil];
    
    CCMenuItemSprite *gameOverItemSprite;
    for (int i = 0; i < 3; i++) {
        gameOverItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuBlankButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MainMenuSoloButton.png"] target:self selector:@selector(gameOverSelected:)];
        gameOverItemSprite.tag = i;
        
        [gameOverMenu addChild:gameOverItemSprite];
    }
    
    [gameOverMenu alignItemsHorizontallyWithPadding:SOLO_GRID_SPACING leftToRight:YES];
    
    gameOverMenu.ignoreAnchorPointForPosition = NO;
    gameOverMenu.position = ccp(winSize.width/2, winSize.height/2);
    gameOverMenu.boundaryRect = CGRectMake(gameOverMenu.position.x - gameOverMenu.contentSize.width/2, gameOverMenu.position.y - gameOverMenu.contentSize.height/2, gameOverMenu.contentSize.width, gameOverMenu.contentSize.height);
    [gameOverMenu fixPosition];
    
    [gameOverMenu retain];
    
    [self addChild:gameOverMenu];
    
    gameOverMenu.visible = NO;
    gameOverMenu.enabled = NO;

}

-(void) setupTheme {
    /*theme = [[GameThemeCache alloc] initWithDifficulty:difficultyChoice andThemeName:kTrainTheme];
    
    themeArray = [theme theme];
    themeTotal = [[NSMutableArray alloc] init];
    themeVisible = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [themeArray count]; i++) {
        CCSprite *t = [themeArray objectAtIndex:i];
        t.position = ccp(0,0);
        [themeTotal addObject:t];
        [self addChild:t];
    }*/
    
    theme = [[GameThemeCache alloc] initWithDifficulty:difficultyChoice andThemeName:kMetalTheme];
    themeArray = [theme theme];
    themeTotal = [[NSMutableArray alloc] init];
    themeVisible = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [themeArray count]; i++) {
        CCSprite *t = [themeArray objectAtIndex:i];
        t.position = ccp(0,0);
        [themeTotal addObject:t];
        [self addChild:t z:1];
    }
}

-(void) setupParticleSystems {
    freezeTimePowerUpParticle = [CCParticleSystemQuad particleWithFile:@"FreezeTimePowerUpParticle.plist"];
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
    [self addChild:specialStagePowerUpParticle z:100];
    
}

#pragma mark - Menus Selected


-(void) gameOverSelected:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    switch (i) {
        case 0:
            CCLOG(@"SoloGameUI: Reset game");
            [[GameManager sharedGameManager] runSceneWithID:kSoloGameScene];
            break;
        case 1:
            CCLOG(@"SoloGameUI: Show answers to questions");
            break;
        case 2:
            CCLOG(@"SoloGameUI: go back to main menu");
            [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
            break;
            
        default:
            break;
    }
}

#pragma mark - Retrieve Information

-(id) getQuestionImageOrText {
    //Check the type of question. If the question type is a text then create a text image. If the question type is a media then create a sprite from spriteframename
    
    questionsAsked++;
    
    ////////////////////////////////////////////////////////////////////////////////////////
    // Temporary. Need to read from SQLite database to see what Territories the player owns.
    ////////////////////////////////////////////////////////////////////////////////////////
    int i = arc4random() % 2;
    NSString *c;
    if (i == 0) {
        c = [NSString stringWithFormat:@"USAStates"];
    } else {
        c = [NSString stringWithFormat:@"USACapitals"];
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////
    
    currentQuestion = [[GeoQuestDB database] getQuestionFrom:c];
    CCSprite *qImage;
        
    int powerUpPercentage = arc4random() % 100;
    //int powerUpPercentage = 0;
    if (powerUpPercentage < powerUpPercentageRequirement) {
        powerUpPercentageRequirement = 0;
        int whichPowerUp = arc4random() % kTotalPowerUps;
        //int whichPowerUp = kSpecialStagePowerUp;
        switch (whichPowerUp) {
            case kFreezeTimePowerUp:
                currentQuestion.powerUpTypeQuestion = kFreezeTimePowerUp;
                CCLOG(@"SoloGameUI: Freeze Timer Power UP");
                break;
            case kDoublePointsPowerUp:
                currentQuestion.powerUpTypeQuestion = kDoublePointsPowerUp;
                CCLOG(@"SoloGameUI: Double Points Power UP");
                break;
            case k5050PowerUp:
                currentQuestion.powerUpTypeQuestion = k5050PowerUp;
                CCLOG(@"SoloGameUI: 50/50 Power UP");
                break;
            case kSpecialStagePowerUp:
                currentQuestion.powerUpTypeQuestion = kSpecialStagePowerUp;
                CCLOG(@"SoloGameUI: Special Stage Power UP");
                break;
            default:
                break;
        }
    } else {
        currentQuestion.powerUpTypeQuestion = kNullPowerUp;
        powerUpPercentageRequirement += 15;
        CCLOG(@"power req: %i", powerUpPercentageRequirement);
    }
    
    
    if ([currentQuestion.type isEqualToString:@"media"]) {
        
        //Question is an image
        qImage = [CCSprite spriteWithSpriteFrameName:currentQuestion.text];
        //qImage.position = ccp(winSize.width/2, winSize.height*.42);
        qImage.position = ccp(winSize.width/2, winSize.height*.65);
        qImage.scale = 1.25;
        
        switch (currentQuestion.powerUpTypeQuestion) {
            case kFreezeTimePowerUp:
                qImage.color = ccc3(99, 185, 242);
                break;
            case kDoublePointsPowerUp:
                qImage.color = ccc3(255, 245, 107);
                break;
            case k5050PowerUp:
                qImage.color = ccc3(250, 107, 255);
                break;
            case kSpecialStagePowerUp:
                qImage.color = ccc3(102, 227, 102);
                break;
                
            default:
                break;
        }

    } else {
        
        //Question is a text label
        qImage = [CCSprite spriteWithSpriteFrameName:@"DifficultyDisplay.png"];
        CCLabelTTF *qText = [CCLabelTTF labelWithString:currentQuestion.text fontName:@"TRS Million" fontSize:28];
        qText.color = ccc3(255, 255, 255);
        qText.position = ccp(qImage.contentSize.width/2, qImage.contentSize.height/2);
        //qImage.position = ccp(winSize.width/2, winSize.height*.67);
        qImage.position = ccp(winSize.width/2, winSize.height*.8);
        
        switch (currentQuestion.powerUpTypeQuestion) {
            case kFreezeTimePowerUp:
                qImage.color = ccc3(99, 185, 242);
                break;
            case kDoublePointsPowerUp:
                qImage.color = ccc3(255, 245, 107);
                break;
            case k5050PowerUp:
                qImage.color = ccc3(250, 107, 255);
                break;
            case kSpecialStagePowerUp:
                qImage.color = ccc3(102, 227, 102);
                break;
                
            default:
                break;
        }

        [qImage addChild:qText];
    }
    
    return qImage;
}

-(CCMenuAdvanced*) getAnswerChoicesImageOrText {
    //Check the type of question. If the question is a text then create images for answer choices. If the question is a media then create text for the answer choices.
    
    if (fiftyFiftyPowerUpActivated) {
        currentAnswerChoices = [[GeoQuestDB database] getAnswerChoicesFrom:currentQuestion difficulty:k5050PowerUp];
    } else {
        currentAnswerChoices = [[GeoQuestDB database] getAnswerChoicesFrom:currentQuestion difficulty:difficultyChoice];
    }
    
    CCMenuAdvanced *answerMenu = [CCMenuAdvanced menuWithItems:nil];
    
    for (int i = 0; i < [currentAnswerChoices count]; i++) { //autorelease objects?
        GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
        CCMenuItemSprite *answerItemSprite;
        if ([currentQuestion.type isEqualToString:@"media"]) {
            
            //Answer choices are text labels
            answerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"SoloAnswerDisplay.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"SoloAnswerDisplay.png"] target:self selector:@selector(checkAnswer:)];
            answerItemSprite.tag = i;
            
            CCLabelTTF *name = [CCLabelTTF labelWithString:a.name fontName:@"TRS Million" fontSize:16];
            name.position = ccp(answerItemSprite.contentSize.width/2, answerItemSprite.contentSize.height/2);
            name.color = ccc3(255, 255, 255);
            
            [answerItemSprite addChild:name];
            [answerMenu addChild:answerItemSprite];
        } else {
            
            //Answer choices are images
            answerItemSprite = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:a.name] selectedSprite:[CCSprite spriteWithSpriteFrameName:a.name] target:self selector:@selector(checkAnswer:)];
            answerItemSprite.tag = i;
            switch (difficultyChoice) {
                case kEasyDifficulty:
                    answerItemSprite.scale = 1;
                    break;
                case kNormalDifficulty:
                    answerItemSprite.scale = .8;
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
    
    if ([currentQuestion.type isEqualToString:@"media"]) {
        //Answer choices are text labels
        switch (difficultyChoice) {
            case kEasyDifficulty:
                [answerMenu alignItemsHorizontallyWithPadding:SOLO_GRID_SPACING];
                break;
            case kNormalDifficulty:
                [answerMenu alignItemsInGridWithPadding:ccp(SOLO_GRID_SPACING, SOLO_GRID_SPACING) columns:2];
                break;
            case kExtremeDifficuly:
                [answerMenu alignItemsInGridWithPadding:ccp(SOLO_GRID_SPACING, SOLO_GRID_SPACING) columns:3];
                break;
                
            default:
                break;
        }

    } else {
        //Answer choices are images
        switch (difficultyChoice) {
            case kEasyDifficulty:
                [answerMenu alignItemsHorizontallyWithPadding:SOLO_GRID_SPACING];
                break;
            case kNormalDifficulty:
                [answerMenu alignItemsHorizontallyWithPadding:SOLO_GRID_SPACING];
                break;
            case kExtremeDifficuly:
                [answerMenu alignItemsInGridWithPadding:ccp(SOLO_GRID_SPACING, SOLO_GRID_SPACING) columns:3];
                break;
                
            default:
                break;
        }
    }
    
    answerMenu.ignoreAnchorPointForPosition = NO;
    
    switch (difficultyChoice) {
        case kEasyDifficulty:
            if ([currentQuestion.type isEqualToString:@"media"]) {
                answerMenu.position = ccp(winSize.width/2, winSize.height*.28);
            } else {
                answerMenu.position = ccp(winSize.width/2, winSize.height*.5);
            }
            break;
        case kNormalDifficulty:
            if ([currentQuestion.type isEqualToString:@"media"]) {
                answerMenu.position = ccp(winSize.width/2, winSize.height*.28);
            } else {
                answerMenu.position = ccp(winSize.width/2, winSize.height*.45);
            }
            break;
        case kExtremeDifficuly:
            if ([currentQuestion.type isEqualToString:@"media"]) {
                answerMenu.position = ccp(winSize.width/2, winSize.height*.28);
            } else {
                answerMenu.position = ccp(winSize.width/2, winSize.height*.41);
            }
            break;
            
        default:
            break;
    }

    
    answerMenu.boundaryRect = CGRectMake(answerMenu.position.x - answerMenu.contentSize.width/2, answerMenu.position.y - answerMenu.contentSize.height/2, answerMenu.contentSize.width, answerMenu.contentSize.height);
    
    [answerMenu fixPosition];

    return answerMenu;
}

-(CCMenuAdvanced*) getSpecialStageAnswerChoices {
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
    
    [answerGrid alignItemsInGridWithPadding:ccp(SOLO_GRID_SPACING, SOLO_GRID_SPACING) columns:4];
    
    answerGrid.ignoreAnchorPointForPosition = NO;
    
    answerGrid.position = ccp(winSize.width/2, winSize.height/2);
    answerGrid.boundaryRect = CGRectMake(answerGrid.position.x - answerGrid.contentSize.width/2, answerGrid.position.y - answerGrid.contentSize.height/2, answerGrid.contentSize.width, answerGrid.contentSize.height);
    [answerGrid fixPosition];
    
    return answerGrid;
}

-(void) getTheme {
    for (int i = 0; i < [themeTotal count]; i++) {
        GameTheme *t = [themeTotal objectAtIndex:i];
        if (t.visible == NO) {
            if ([themeVisible count] != 0) {
                GameTheme *lastSprite = [themeVisible objectAtIndex:([themeVisible count]-1)];
                t.position = ccp(lastSprite.position.x + t.boundaryRect.size.width, lastSprite.position.y);
            } else {
                t.position = ccp(winSize.width + winSize.width/2, winSize.height*.48);
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
        CCLOG(@"SoloGameUI: Game Started!");
        winSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;

        [self setupGame];
        
        [self scheduleUpdate];
        
        //question = [self getQuestionImageOrText];
        //answerChoices = [self getAnswerChoicesImageOrText];
        
        //[self addChild:question];
        //[self addChild:answerChoices];
        
        
        //self.scale = .5;
                
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
    gameTimer = SOLO_GAME_TIMER;
    questionTimer = 7.0;
    freezeTimePowerUpTimer = 0.0;
    doublePointsPowerUpTimer = 0.0;
    fiftyFiftyPowerUpTimer = 0.0;
    specialStagePowerUpTimer = 0.0;
    quickDrawTimer = SOLO_GAME_QUICKDRAW_TIMER;
    
    questionsAsked = 0;
    questionsAnsweredCorrectly = 0;
    powerUpPercentageRequirement = 0;
    score = 0;
    pointsEarned = 0;
    answerCorrectlyInRow = 0;
    answerQuickDrawCorrectlyInRow = 0;
    answerIncorrectlyInRow = 0;
    difficultyChoice = -1;
}

-(void) gameOver {
    freezeTimePowerUpParticle.visible = NO;
    doublePointsPowerUpParticle.visible = NO;
    fiftyFiftyPowerUpParticle.visible = NO;
    specialStagePowerUpParticle.visible  = NO;
    
    [PlayerDB database].experience += score/10;
    [PlayerDB database].coins += score/10;
    [PlayerDB database].totalQuestions += questionsAsked;
    [PlayerDB database].totalAnswersCorrect += questionsAnsweredCorrectly;
    [[PlayerDB database] updateInformation];
    
    
    gameOverMenu.position = ccp(winSize.width/2, winSize.height + gameOverMenu.contentSize.height);
    gameOverMenu.visible = YES;
    gameOverMenu.enabled = NO;
    
    id action = [CCMoveTo actionWithDuration:0.75 position:ccp(winSize.width/2, winSize.height/2)];
    id ease = [CCEaseBackInOut actionWithAction:action];
    [gameOverMenu runAction:ease];
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
    
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %i", score]];
    [pointsEarnedLabel setString:[NSString stringWithFormat:@"%i", pointsEarned]];
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
    if (difficultyChoice >= 0) {
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
                    answerChoicesMenu = [self getSpecialStageAnswerChoices];
                    answerChoicesMenu.visible = YES;
                } else {
                    questionAnswered = NO;
                    question = [self getQuestionImageOrText];
                    answerChoicesMenu = [self getAnswerChoicesImageOrText];
                    question.visible = YES;
                    answerChoicesMenu.visible = YES;
                }
       
                GameTheme* themeSprite = [themeVisible objectAtIndex:([themeVisible count]-1)];
                //[self addChild:question];
                //[self addChild:answerChoicesMenu];
                
                if (question != NULL) {
                    question.position = ccp(themeSprite.contentSize.width/2, question.position.y);
                    [themeSprite addChild:question];
                }
                answerChoicesMenu.position = ccp(themeSprite.contentSize.width/2, answerChoicesMenu.position.y);
                answerChoicesMenu.boundaryRect = CGRectMake(answerChoicesMenu.position.x - answerChoicesMenu.contentSize.width/2, answerChoicesMenu.boundaryRect.origin.y, answerChoicesMenu.boundaryRect.size.width, answerChoicesMenu.boundaryRect.size.height);
                //answerChoicesMenu.position = ccp(winSize.width/4, winSize.height/2);
                [themeSprite addChild:answerChoicesMenu];
                
                //id action = [CCMoveTo actionWithDuration:0.25 position:ccp(winSize.width/4, winSize.height/2)];
                //id ease = [CCEaseInOut actionWithAction:action rate:4];
                //[question runAction:ease];
                
                
                for (int i = 0; i < [themeVisible count]; i++) {
                    GameTheme *t = [themeVisible objectAtIndex:i];
                    //float time = t.boundaryRect.size.width/1500;
                    //id themeAction = [CCMoveBy actionWithDuration:time position:ccp(-t.boundaryRect.size.width, 0)];
                    id themeAction = [CCMoveBy actionWithDuration:0.4 position:ccp(-t.boundaryRect.size.width, 0)];
                    id themeEase = [CCEaseInOut actionWithAction:themeAction rate:2];
                    [t runAction:themeEase];
                }
            }
            
            if (gameTimer > 0) {
                
                questionTimer -= delta;
                if (questionTimer <= 0.0) {
                    questionTimer = 0.0;
                    questionTimerLabel.visible = NO;
                    if (!questionChecked) {
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
                            doublePointsPowerUpParticle.visible = NO;
                        }
                    }
                    if (fiftyFiftyPowerUpActivated == YES) {
                        if (fiftyFiftyPowerUpTimer > 0) {
                            fiftyFiftyPowerUpTimer -= delta;
                        } else {
                            fiftyFiftyPowerUpTimer = 0.0;
                            fiftyFiftyPowerUpActivated = NO;
                            fiftyFiftyPowerUpParticle.visible = NO;
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
                        specialStagePowerUpParticle.visible = NO;
                    }
                    
                    if (freezeTimePowerUpTimer > 0) {
                        freezeTimePowerUpTimer -= delta;
                    } else {
                        freezeTimePowerUpTimer = 0.0;
                        freezeTimePowerUpActivated = NO;
                        freezeTimePowerUpParticle.visible = NO;
                    }
                }
            } else {
                gameTimer = 0.0;
            }
            
            quickDrawTimer -= delta;
        }
        
        if (gameTimer <= 0) {
            //Game timer finished counting down. Show gameover screen and unschedule the update method.
            
            gameTimer = 0.0;
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
    }
}

-(void) update:(ccTime)delta {
    [self updateUILabels];
    [self updateTheme];
    [self updateTime:delta];
}

#pragma mark - Check Trivia

-(void) checkAnswer:(CCMenuItemSprite*)sender {
    //If the answer is correct then make the 'O' sprite visible. If the answer is wrong then make the 'X' sprite visible.
    int i = sender.tag;
    
    questionTimerLabel.visible = NO;
    
    answerChoicesMenu.isTouchEnabled = NO;
    
    GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
    
    BOOL correctAnswer;
    if (specialStagePowerUpActivated) {
        correctAnswer = [[GeoQuestDB database] checkAnswer:a withCategory:@"USAStates"];
    } else {
        correctAnswer = [[GeoQuestDB database] checkAnswer:a withQuestion:currentQuestion];
    }
    
    if (correctAnswer) {
        questionsAnsweredCorrectly++;
        
        switch (currentQuestion.powerUpTypeQuestion) {
            case kFreezeTimePowerUp:
                freezeTimePowerUpActivated = YES;
                freezeTimePowerUpParticle.visible = YES;
                freezeTimePowerUpTimer += 10.0;
                break;
            case kDoublePointsPowerUp:
                doublePointsPowerUpActivated = YES;
                doublePointsPowerUpParticle.visible = YES;
                doublePointsPowerUpTimer += 10.0;
                break;
            case k5050PowerUp:
                fiftyFiftyPowerUpActivated = YES;
                fiftyFiftyPowerUpParticle.visible = YES;
                fiftyFiftyPowerUpTimer += 10.0;
                break;
            case kSpecialStagePowerUp:
                specialStagePowerUpActivated = YES;
                specialStagePowerUpParticle.visible = YES;
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
        pointsEarned += 10 * answerCorrectlyInRow;
        previousAnswerCorrect = YES;
        
        if (quickDrawTimer > 0.0) {
            inRowLabel.visible = NO;
            inRowQuickDrawLabel.visible = YES;
            quickDrawLabel.visible = YES;
            answerQuickDrawCorrectlyInRow++;
            pointsEarned += 20 * answerQuickDrawCorrectlyInRow;
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
        [self runAction:shakeTotalSequence];
    }
    
    //id action = [CCMoveTo actionWithDuration:0.35 position:ccp(scoreLabel.position.x, scoreLabel.position.y - pointsEarnedLabel.contentSize.height/2)];
    id action = [CCMoveTo actionWithDuration:0.35 position:ccp(pointsEarnedLabel.position.x, pointsEarnedLabel.position.y + pointsEarnedLabel.contentSize.height)];
    id ease = [CCEaseInOut actionWithAction:action rate:2];
    [pointsEarnedLabel runAction:ease];
    
    if (doublePointsPowerUpActivated == YES) {
        pointsEarned *= 2;
    }
    
    if (correctAnswer) {
        [self performSelector:@selector(questionAnswered) withObject:nil afterDelay:0.35];
    } else {
        [self performSelector:@selector(questionAnswered) withObject:nil afterDelay:0.75];
    }
}

-(void) checkSpecialStageAnswer:(CCMenuItemSprite*)sender {
    int i = sender.tag;
    
    CCMenuItemSprite *menuItem = sender;
    
    GeoQuestAnswer *a = [currentAnswerChoices objectAtIndex:i];
    
    BOOL correctAnswer = [[GeoQuestDB database] checkAnswer:a withCategory:@"USAStates"];
    
    if (correctAnswer) {
        
        correctMark.position = [answerChoicesMenu convertToWorldSpace:sender.position];
           
        correctMark.scale = 2.0;
        correctMark.visible = YES;
        id action = [CCScaleTo  actionWithDuration:0.25 scale:1];
        id ease = [CCEaseExponentialOut actionWithAction:action];
        [correctMark runAction:ease];
        menuItem.isEnabled = NO;
    } else {
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

}

-(void) ranOutOfTimeToAnswer {
    wrongMark.position = question.position;
    
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
    [self runAction:shakeTotalSequence];
    
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
        specialStagePowerUpParticle.visible = NO;
        specialStagePowerUpTimer = 0.0;
    }
}

-(void) questionAnswered {
    score += pointsEarned;

    answerChoicesMenu.isTouchEnabled = YES;
    questionAnswered = YES;
    quickDrawTimer = SOLO_GAME_QUICKDRAW_TIMER;
    pointsEarned = 0;
    pointsEarnedLabel.visible = NO;
    questionTimer = 7.0;
    questionChecked = NO;
}

-(void) dealloc {
    [super dealloc];
}

@end
