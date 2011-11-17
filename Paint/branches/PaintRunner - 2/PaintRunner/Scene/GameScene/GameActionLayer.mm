//
//  GameActionLayer.m
//  PaintRunner
//
//  Created by Kelvin on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameActionLayer.h"

@implementation GameActionLayer

@synthesize contactListener;
//@synthesize comboCount;
@synthesize platformCounter;
@synthesize numPlatformsNeedToHit;
@synthesize player;
@synthesize gameScore;
@synthesize highScore;
@synthesize multiplier;
@synthesize levelTimePassed;
@synthesize PIXELS_PER_SECOND;

-(void) setupWorld {    
    b2Vec2 gravity = b2Vec2(0.0f, -20.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);            
}

-(void) setupDebugDraw {  
    debugDraw = new GLESDebugDraw(PTM_RATIO * [[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);  
}

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    if (world) {
        world->DrawDebugData();
    }
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) createPlayer {
    player = [[[Player alloc] initWithWorld:world] retain];
    
    [sceneSpriteBatchNode addChild:player z:1000];
}


-(void) createPaintChips {
    paintChipCache = [[PaintChipCache alloc] initWithWorld:world];
    CCArray *tempArray = [paintChipCache totalPaintChips];
    
    for (int i = 0; i < [tempArray count]; i++) {
        PaintChip *tempPC = [tempArray objectAtIndex:i];
        
        [sceneSpriteBatchNode addChild:tempPC z:1000];
    }
}

-(void) createPlatforms {
    platformCache = [[PlatformCache alloc] initWithWorld:world];
    
    CCArray *totalPlatforms = [platformCache totalPlatforms];
    
    for (int i = 0; i < [totalPlatforms count]; i++) {
        CCArray *platformOfType = [totalPlatforms objectAtIndex:i];
            
        for (int j = 0; j < [platformOfType count]; j++) {
            Platform *tempPlat = [platformOfType objectAtIndex:j];
            
            [sceneSpriteBatchNode addChild:tempPlat z:1000];
        }
    }
}

-(void) resetGame {
    jumpBufferCount = 0;
    //comboCount = 0;
    platformCounter = 0;
    numPlatformsNeedToHit = 20;
    playerStartJump = NO;
    playerEndJump = NO;
    changeDirectionToLeft = YES;
    levelMovingLeft = YES;
    screenOffsetX = 0.0;
    screenOffsetY = 0.0;
    levelTimePassed = 0.0;
    paintTimePassed = 0.0;
    platformTimePassed = 0.0;
    platformSpawnTime = 1.0;
    PIXELS_PER_SECOND = INITIAL_PIXELS_PER_SECOND;
    gameScore = 0.0;
    multiplier = 1.0;

    //Reset Paintchips
    [paintChipCache resetPaintChips];
    
    //Clean background/foreground
    [backgroundLayer2 resetBackground];
    [foregroundLayer resetForeground];
    
    //Remove platforms
    [platformCache resetPlatforms];
    
    //Reset player
    [player resetPlayer];
    
    [platformCache addInitialPlatforms];
    [player spawn];
}

-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andForegroundLayer:(GameForegroundLayer *)gameFGLayer andBackgroundLayer:(GameBackgroundLayer2 *)gameBGLayer { 
        
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game1atlas.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"game1atlas.png" capacity:100];

        [self addChild:sceneSpriteBatchNode z:1];

        //Setup layers
        uiLayer = gameUILayer;
        foregroundLayer = gameFGLayer;
        //backgroundLayer = gameBGLayer;
        backgroundLayer2 = gameBGLayer;
        [uiLayer setGameActionLayer:self];
        [foregroundLayer setGameActionLayer:self];
        [backgroundLayer2 setGameActionLayer:self];
        
        //Setup initialial variables
        self.isTouchEnabled = YES;
        jumpBufferCount = 0;
        //comboCount = 0;
        platformCounter = 0;
        numPlatformsNeedToHit = 20;
        playerStartJump = NO;
        playerEndJump = NO;
        changeDirectionToLeft = YES;
        levelMovingLeft = YES;
        screenOffsetX = 0.0;
        screenOffsetY = 0.0;
        levelTimePassed = 0.0;
        paintTimePassed = 0.0;
        platformTimePassed = 0.0;
        platformSpawnTime = 1.0;
        PIXELS_PER_SECOND = INITIAL_PIXELS_PER_SECOND;
        gameScore = 0.0;
        multiplier = 1.0;
        
        /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene3atlas-hd.plist"];
         sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene3atlas-hd.png"];
         } else {
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene3atlas.plist"];
         sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene3atlas.png"];
         }*/
        
        //Create world and objects
        [self setupWorld];
        [self setupDebugDraw];
        [self createPlayer];
        //[self createPaintChips];
        [self createPlatforms];
        [platformCache addInitialPlatforms];
        [player spawn];
        
        //Create contact listener
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
        
        //Update Tick
        [self scheduleUpdate];     
    }
    return self;
}

-(void) updateBackgroundState:(ccTime)dt {
    //////////////////////////////////
    //Calculate offset to shift screen
    //////////////////////////////////
    
    if (PIXELS_PER_SECOND < MAX_PIXELS_PER_SECOND) {
        PIXELS_PER_SECOND += 2*dt;
        platformSpawnTime = 170.0/PIXELS_PER_SECOND;
    }
    
    //Calculates how fast to scroll the level based on PIXELS_PER_SECOND
    /*screenOffsetX += PIXELS_PER_SECOND * dt;
    float backgroundWidth = [backgroundLayer background].contentSize.width;
    if(screenOffsetX >= backgroundWidth) {
        screenOffsetX = screenOffsetX - backgroundWidth;
    }*/
    
    //Calculates when to scroll the screen to keep the player within the screen when jumping too high. Right now the screen will start to scroll when player jumps over half the screen (winSize.height/2).
    /*float prevScreenOffsetY = screenOffsetY;
    if (player.position.y > winSize.height/2) {
        screenOffsetY = (winSize.height/2 - player.position.y)*0.4;
        self.position = ccp(self.position.x, screenOffsetY);
    } else if (player.position.y <= winSize.height/2) {
        self.position = ccp(self.position.x, 0.0);
        self.scale = 1.0;
    }*/
    
    //Calculates how much to scale the screen when screen begins to scroll.
    //float yPos = screenOffsetY - prevScreenOffsetY;
    //self.scale = self.scale + yPos*dt/10;
    
    //Calculates how much to move the X offset of the layer to keep the player in the same location on screen with the zoom out effect
    //float scaledOffsetX = winSize.width/2*(1-self.scale);
    //self.position = ccp(-scaledOffsetX, self.position.y);
        
    //Updates the background with the correct offsets so that the drawing will match where the player is on screen.
    /*[backgroundLayer updateBackground:dt 
                       playerPosition:[player openGLPosition] 
            andPlayerPreviousPosition:[player previousPosition] 
                    andPlayerOnGround:player.isTouchingGround 
                       andPlayerScale:[player basePlayerScale]
                     andScreenOffsetX:screenOffsetX
                     andScreenOffsetY:yPos
                             andScale:self.scale];*/
    
    [backgroundLayer2 updateBackgroundWithTime:dt andSpeed:PIXELS_PER_SECOND];
    [foregroundLayer updateForegroundWithTime:dt andSpeed:PIXELS_PER_SECOND];
}

-(void) updateScore:(ccTime)dt {
    gameScore += PIXELS_PER_SECOND*dt*multiplier/10;
    if (gameScore > highScore) {
        highScore = gameScore;
    }
    
    if (platformCounter >= numPlatformsNeedToHit) {
        platformCounter = 0;
        numPlatformsNeedToHit = numPlatformsNeedToHit*1.5;
        if (multiplier < 32) {
            if (multiplier < 16) {
                multiplier = multiplier*2;
            } else {
                multiplier += 8;
            }
        }
        
    }
    //Test Logs
    levelTimePassed += dt;
}

-(void) physicsSimulation:(ccTime)dt {
    /////////////////////
    //Physics Simulations
    /////////////////////
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    
    timeAccumulator += dt;    
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }    
    
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    while (timeAccumulator >= UPDATE_INTERVAL) {        
        timeAccumulator -= UPDATE_INTERVAL;        
        world->Step(UPDATE_INTERVAL, 
                    velocityIterations, positionIterations);        
        //world->ClearForces();
        
        for(b2Body *b = world->GetBodyList(); b != NULL; b = b->GetNext()) {    
            if (b->GetUserData() != NULL) {
                Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
                sprite.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
            }
        }
    }
}

-(void) detectContacts:(ccTime)dt {
    ///////////////////////////////
    //Detect contacts from listener
    ///////////////////////////////
    if (player != NULL) {
        player.isTouchingGround = NO;
    }
    
    std::vector<MyContact>::iterator pos;
    for (pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        //Check if player has touched the ground 
        if ((contact.fixtureA->GetBody() == groundBody && contact.fixtureB->GetBody() == player.body) || 
            (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == groundBody)) {
            player.isTouchingGround = YES;
            player.doubleJumpAvailable = YES;
        }
    
        //Check if player has touched a paint chip
        NSMutableArray *tempVisiblePaintChips = [paintChipCache visiblePaintChips];
        for (int i = 0; i < [tempVisiblePaintChips count]; i++) {
            PaintChip *tempPC = [tempVisiblePaintChips objectAtIndex:i];
            
            if ((contact.fixtureA->GetBody() == tempPC.body && contact.fixtureB->GetBody() == player.body) || 
                (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == tempPC.body)) {
                tempPC.isHit = YES;
                gameScore += 10;
            }
        }
        
        //Check if player has touched platform
        NSMutableArray *tempVisiblePlatforms = [platformCache visiblePlatforms];
        for (int i = 0; i < [tempVisiblePlatforms count]; i++) {
            Platform *tempPlat = [tempVisiblePlatforms objectAtIndex:i];
            
            if ((contact.fixtureA->GetBody() == tempPlat.body && contact.fixtureB->GetBody() == player.body) || 
                (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == tempPlat.body)) {
                player.isTouchingGround = YES;
                player.doubleJumpAvailable = YES;
                
                /*int platformNumberDifference = tempPlat.platformNumber - player.platformNumber;
                player.platformNumber = tempPlat.platformNumber;
                
                if (platformNumberDifference == 1) {
                    if (tempPlat.isHit == NO) {
                        tempPlat.isHit = YES;

                        comboCount++;
                        multiplier += 0.1;
                    }
                } else if (platformNumberDifference > 1) {
                    comboCount = 0;
                    multiplier = 1;
                }*/
                if (tempPlat.isHit == NO) {
                    tempPlat.isHit = YES;
                    platformCounter++;
                }
            }
        }
        
        //Check if player has touched the top of the obstacle   
        if ((contact.fixtureA->GetBody() == platformsTopAndBottomBody && contact.fixtureB->GetBody() == player.body) || 
            (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == platformsTopAndBottomBody)) {
            player.isTouchingGround = YES;
            player.doubleJumpAvailable = YES;
        }
        
        if ((contact.fixtureA->GetBody() == platformsSideBody && contact.fixtureB->GetBody() == player.body) || 
            (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == platformsSideBody)) {
            CCLOG(@"sidebody touched");
            player.died = YES;
            PIXELS_PER_SECOND = 0.0;    
        }
    }
}

-(void) playerJumpBuffer {
    //////////////////////////////
    //Update player jump buffer
    //////////////////////////////
    if (playerStartJump) {
        if (jumpBufferCount <= 2) {
            player.isJumping = YES;
            jumpBufferCount++;
        }
        
        if (jumpBufferCount > 2 && playerEndJump) {
            playerEndJump = NO;
            player.isJumping = NO;
        }
    }
}

-(void) paintChipControl:(ccTime)dt {
    paintTimePassed += dt;
    if (paintTimePassed > 3) {
        [paintChipCache addPaintChips];
        paintTimePassed = 0.0;
    }
}

-(void) platformControl:(ccTime)dt {
    platformTimePassed += dt;
    if (platformTimePassed > platformSpawnTime) {
        [platformCache addPlatform];
        platformTimePassed = 0.0;
    }
}

-(void) updateStatesOfObjects:(ccTime)dt {
    //////////////////////////////
    //Update states of all objects
    //////////////////////////////
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:dt];
    }
}

-(void) update:(ccTime)dt {    
    [self updateBackgroundState:dt];
    [self updateScore:dt];
    [self physicsSimulation:dt];
    [self detectContacts:dt];
    [self playerJumpBuffer];
    //[self paintChipControl:dt];
    [self platformControl:dt];

    [self updateStatesOfObjects:dt];
    [player updateStateWithDeltaTime:dt andSpeed:PIXELS_PER_SECOND];
    //[paintChipCache updatePaintChipsWithTime:dt andSpeed:PIXELS_PER_SECOND];
    [platformCache updatePlatformsWithTime:dt andSpeed:PIXELS_PER_SECOND];
}

-(BOOL) isTouchingLeftSide:(CGPoint)touchLocation {
    CGRect leftBox = CGRectMake(0,0,winSize.width/2, winSize.height);
    return CGRectContainsPoint(leftBox, touchLocation);
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if (player.isTouchingGround || player.doubleJumpAvailable) {
            if (player.doubleJumpAvailable == NO) {
                player.doubleJumpAvailable = YES;
            } else {
                player.doubleJumpAvailable = NO;
                b2Vec2 playerVelocity = player.body->GetLinearVelocity();
                if (playerVelocity.y < 0) {
                    player.body->SetLinearVelocity(b2Vec2(playerVelocity.x, 0.0));
                }
            }
            
            playerStartJump = YES;
            player.isJumpingLeft = YES;
            player.jumpTime = 0.0;
            jumpBufferCount = 0;
        }
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    playerEndJump = YES;
}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) dealloc {
    if (world) {
        delete world;
        world = NULL;
    }
    if (debugDraw) {
        delete debugDraw;
        debugDraw = NULL;
    }
    
    [player release];
    [platformCache release];
    [paintChipCache release];
    [super dealloc];
}



@end
