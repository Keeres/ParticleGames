//
//  GameActionLayer.mm
//  mushroom
//
//  Created by Kelvin on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameActionLayer.h"
#import "GameUILayer.h"
#import "GameManager.h"
#import "SimpleQueryCallback.h"
#import "SimpleAudioEngine.h"
#import "Mushroom.h"
#import "Turtle.h"
#import "StageEffectCache.h"

@implementation GameActionLayer

@synthesize contactListener;
@synthesize visibleMushrooms;
@synthesize visibleEnemies;

- (void)setupWorld {    
    b2Vec2 gravity = b2Vec2(0.0f, -20.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);            
}

- (void)setupDebugDraw {  
    debugDraw = new GLESDebugDraw(PTM_RATIO * [[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);  
}

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}


- (void)createMushroom {
    mushroomCache = [[MushroomCache alloc] initWithWorld:world withActionLayer:self];
    
    totalMushrooms = [mushroomCache totalMushrooms];
    
    for (int i = 0; i < [totalMushrooms count]; i++) {
        [sceneSpriteBatchNode addChild:[totalMushrooms objectAtIndex:i] z:1000 tag:kVikingSpriteTagValue];
    }
    visibleMushrooms = [mushroomCache visibleMushrooms];
}


-(void) spawnMushroomAtPoint:(CGPoint)point isNewSpawn:(BOOL)newSpawn {
    
    if (newSpawn) {
        for (int i = 0; i < [totalMushrooms count]; i++) {
            Mushroom *tempMushroom = [totalMushrooms objectAtIndex:i];
            
            if (tempMushroom.visible == NO && [visibleMushrooms count] < [totalMushrooms count]) {
                CGPoint location;
                
                if ([visibleMushrooms count] == 0) {
                    //location = ccp(-1*self.position.x + winSize.width/8, winSize.height/2);
                    location = ccp(previousOffset - winSize.width/4/self.scale, winSize.height/2);
                } else {
                    Mushroom *lastMushroom = [visibleMushrooms objectAtIndex:[visibleMushrooms count]-1];
                    location = ccp(lastMushroom.position.x - lastMushroom.contentSize.width, lastMushroom.position.y);
                }
                
                [tempMushroom spawn:location withColor:[mushroomCache blueColor]];
                [visibleMushrooms addObject:tempMushroom];
                return;
            }
        }
    } else {
        for (int i = 0; i < [totalMushrooms count]; i++) {
            Mushroom *tempMushroom = [totalMushrooms objectAtIndex:i];
            
            if (tempMushroom.visible == NO && [visibleMushrooms count] < [totalMushrooms count]) {
                CGPoint location;
                
                if ([visibleMushrooms count] == 0) {
                    //location = ccp(-1*self.position.x + winSize.width/8, winSize.height/2);
                    //location = ccp(previousOffset - winSize.width/4/self.scale, winSize.height/2);
                    location = point;
                } else {
                    //Mushroom *lastMushroom = [visibleMushrooms objectAtIndex:[visibleMushrooms count]-1];
                    //location = ccp(lastMushroom.position.x - lastMushroom.contentSize.width, lastMushroom.position.y);
                    location = point;
                }
                
                [tempMushroom spawn:location withColor:[mushroomCache blueColor]];
                [visibleMushrooms addObject:tempMushroom];
                return;
            }
        }
    }
}

-(void) createPlatforms {
    platformCache = [[PlatformCache alloc] initWithWorld:world andScale:self.scale];
    [self addChild:platformCache z:0];
    groundBody = [platformCache platformBody];
    sideBody = [platformCache platformSideBody];
}

-(void) createTurtles {
    enemyCache = [[EnemyCache alloc] initWithWorld:world withActionLayer:self];
    for (int i = 0; i < [[enemyCache totalEnemies] capacity]; i++) {
        CCArray *turtleOfType = [[enemyCache totalEnemies] objectAtIndex:i];
        for (int j = 0; j < [turtleOfType capacity]; j++) {
            [sceneSpriteBatchNode addChild:[turtleOfType objectAtIndex:j] z:1000 tag:kVikingSpriteTagValue];
        }
    }
    visibleEnemies = [enemyCache visibleEnemies];
    
}

//NEEDS EDIT possibly change z value
- (void) createStageEffects{
    stageEffectCache = [[StageEffectCache alloc] initWithWorld:world withStageEffectType:kVolcanoLava];
    for (int i=0; i < [[stageEffectCache totalStageEffectType] capacity]; i++) {
        CCArray *stageEffectOfType = [[stageEffectCache totalStageEffectType] objectAtIndex:i];
        for(int j=0; j<[stageEffectOfType capacity];j++){
            [sceneSpriteBatchNode addChild:[stageEffectOfType objectAtIndex:j] z:1000];
        }
    }
    visibleStageEffect = [stageEffectCache visibleStageObjects];
}

- (void) resetGame {
    for (int i = 0; i < [visibleMushrooms count]; i++) {
        Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
        [tempMushroom despawn];
    }
    
    for (int j = 0; j < [visibleEnemies count]; j++) {
        Enemy *tempEnemy = [visibleEnemies objectAtIndex:j];
        [tempEnemy despawn];
    }
    
    NSMutableArray *tempVisiblePlatform = [platformCache platformsVisible];
    
    for (int k = 0; k < [tempVisiblePlatform count]; k++) {
        CCSprite *tempPlatformSprite = [tempVisiblePlatform objectAtIndex:k];
        tempPlatformSprite.visible = NO;
    }
    
    [visibleMushrooms removeAllObjects];
    [visibleEnemies removeAllObjects];
    
    platformCache.fromKeyPointI = 0.0;
    platformCache.toKeyPointI = 0.0;
    platformCache.previousXLocation = 0.0;
    
    jumpCount = 0;
    touchStarted = NO;
    PIXELS_PER_SECOND = 0.0;
    currentSpeed = 300.0;
    offset = 0;
    previousOffset = winSize.width;
    timePassed = 0.0;
    totalDistance = 0;
    
    backgroundLayer.backgroundState = kVolcanoDormant;
    [self spawnMushroomAtPoint:ccp(0, 0) isNewSpawn:YES];
}

-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andBackgroundLayer:(GameBackgroundLayer*)gameBGLayer {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        uiLayer = gameUILayer;
        backgroundLayer = gameBGLayer;
        
        //Setup initialial variables
        self.isTouchEnabled = YES;
        jumpCount = 0;
        touchStarted = NO;
        PIXELS_PER_SECOND = 0.0;
        currentSpeed = 300.0;
        offset = 0;
        previousOffset = winSize.width;
        timePassed = 0.0;
        totalDistance = 0;
        self.scale = .50;
        
        /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene3atlas-hd.plist"];
         sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene3atlas-hd.png"];
         } else {
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene3atlas.plist"];
         sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene3atlas.png"];
         }*/
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game1atlas.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"game1atlas.png"];
        [self addChild:sceneSpriteBatchNode z:1];
        
        [self setupWorld];
        [self setupDebugDraw];
        [self createMushroom];
        [self createPlatforms];
        [self createTurtles];
        [self createStageEffects];
        
        //Update Tick
        [self scheduleUpdate];
        
        //Create contact listener
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
        [self spawnMushroomAtPoint:ccp(0, 0) isNewSpawn:YES];
        
        //[[GameManager sharedGameManager] playBackgroundTrack:BACKGROUND_TRACK_MINECART];
        
    }
    return self;
}


-(void) update:(ccTime)dt {
    [uiLayer updateStats:offset];
    ////////////////////////////////
    //Check how much time has passed
    ////////////////////////////////
    
    /*timePassed += dt;
     //currentSpeed = mushroomCache.currentSpeed;
     if (timePassed >= 5.0) {
     if (currentSpeed < 800.0) {
     //currentSpeed += 50.0;
     }
     
     if (mushroomCache.jumpPercentage > 0.2) {
     //mushroomCache.jumpPercentage -= 0.05;
     }
     timePassed = 0.0;
     }
     
     if ([visibleMushrooms count] > 0) {
     PIXELS_PER_SECOND = currentSpeed/self.scale;
     } else {
     PIXELS_PER_SECOND = 0.0;
     }*/
    
    for (int i = 0; i < [visibleMushrooms count]; i++) {
        Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
        tempMushroom.speed = 250 + [visibleMushrooms count] * 50;
    }
    
    for (int i = 0; i < [visibleEnemies count]; i++) {
        Enemy *tempEnemy = [visibleEnemies objectAtIndex:i];
        if (tempEnemy.type == kBeeType) {
            tempEnemy.speed = 250 + [visibleMushrooms count] * 50;
        }
    }
    
    ////////////////////////////////////
    //Disable gravity on certain objects
    ////////////////////////////////////
    
    b2Vec2 customGravity = b2Vec2(0.0, 20.0);
    for (int i = 0;  i < [visibleEnemies count]; i++) {
        Enemy *tempEnemy = [visibleEnemies objectAtIndex:i];
        if (tempEnemy.type == kBeeType) {
            Bee *tempBee = [visibleEnemies objectAtIndex:i];
            tempBee.body->ApplyForce(tempBee.body->GetMass()*customGravity, tempBee.body->GetPosition());
            
        }
    }
    
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
    
    /*int32 velocityIterations = 3;
     int32 positionIterations = 2;
     world->Step(dt, velocityIterations, positionIterations);
     for(b2Body *b = world->GetBodyList(); b != NULL; b = b->GetNext()) {    
     if (b->GetUserData() != NULL) {
     Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
     sprite.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
     sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
     }        
     }*/
    
    //////////////////////
    //Mushrooms Jump Check
    //////////////////////
    [mushroomCache jumpCheck:dt];
    
    //When you press and release the jump very quickly, there is a chance mushroomCache may miss the jump.
    //This if-statement(jumpCount==3) makes sure that when the jump is pressed it will have time be to recognized by mushroomCache.
    if (touchStarted == NO && [visibleMushrooms count] > 0) {
        Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:0];
        
        if (jumpCount == 3) {
            if ([visibleMushrooms count] > 1) {                    
                float mushroomDistanceTraveled = tempMushroom.position.y - tempMushroom.mushroomStartHeight;                                              
                
                if (mushroomDistanceTraveled <= kMushroomMaxJumpingHeight ) {
                    tempMushroom.mushroomMaxEndHeight = tempMushroom.position.y;
                    
                } else {
                    tempMushroom.mushroomMaxEndHeight = tempMushroom.mushroomStartHeight + kMushroomMaxJumpingHeight;
                }
            }
            if ([visibleMushrooms count] > 1) {
                tempMushroom.mushroomJumped = YES;
            }
            mushroomCache.isMushroomJumping = NO;
        }
        jumpCount++;
    }
    
    //////////////////
    //Mushroom Eating
    //////////////////
    if ([visibleMushrooms count] > 0) {
        if (eatStarted) {
            mushroomEatTime += dt;
            Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:0];
            if (mushroomEatTime < 4.0 && mushroomCrampTime <= 0.0) {
                tempMushroom.eating = YES;
            } else {
                tempMushroom.eating = NO;
                tempMushroom.cramping = YES;
                mushroomCrampTime = 1.0;
            }
        } else {
            Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:0];
            if (mushroomEatTime > 0.0) {
                tempMushroom.eating = NO;
                mushroomEatTime -= 5*dt;
            }
            if (mushroomCrampTime > 0.0) {
                tempMushroom.cramping = NO;
                mushroomCrampTime -= dt;
            }
        }
    }
    
    ///////////////////////////////
    //Detect contacts from listener
    ///////////////////////////////
    for (int i = 0; i < [visibleMushrooms count]; i++) {
        Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
        tempMushroom.isTouchingGround = NO;
        tempMushroom.hitEnemy = NO;
    }
    
    for (int i = 0; i < [visibleEnemies count]; i++) {
        Enemy *tempEnemy = [visibleEnemies objectAtIndex:i];
        if (tempEnemy.type == kJumperType) {
            tempEnemy.isTouchingGround = NO;
        }
    }
    
    std::vector<MyContact>::iterator pos;
    for (pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        for (int i = 0; i < [visibleMushrooms count]; i++) {
            Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
            
            if ((contact.fixtureA->GetBody() == groundBody && contact.fixtureB->GetBody() == tempMushroom.body) || (contact.fixtureA->GetBody() == tempMushroom.body && contact.fixtureB->GetBody() == groundBody)) {
                tempMushroom.isTouchingGround = YES;
            }
            
            if ((contact.fixtureA->GetBody() == sideBody && contact.fixtureB->GetBody() == tempMushroom.body) || (contact.fixtureA->GetBody() == tempMushroom.body && contact.fixtureB->GetBody() == sideBody)) {
                tempMushroom.hitPlatformSide = YES;
            }
            
            for (int j = 0; j < [visibleEnemies count]; j++) {
                
                Enemy *tempEnemy = [visibleEnemies objectAtIndex:j];
                
                if (tempEnemy.type == kTurtleType) {
                    Turtle *tempTurtle = [visibleEnemies objectAtIndex:j];
                    
                    //Check is turtle is touching ground
                    if ((contact.fixtureA->GetBody() == groundBody && contact.fixtureB->GetBody() == tempTurtle.body) || 
                        (contact.fixtureA->GetBody() == tempTurtle.body && contact.fixtureB->GetBody() == groundBody)) {
                        tempTurtle.isTouchingGround = YES;
                    }
                    
                    //Check if turtle is touching mushroom
                    if ((contact.fixtureA->GetBody() == tempTurtle.body && contact.fixtureB->GetBody() == tempMushroom.body) || 
                        (contact.fixtureA->GetBody() == tempMushroom.body && contact.fixtureB->GetBody() == tempTurtle.body)) {
                        
                        //Check if turtle and mushroom are same color and turtle being eaten by mushroom - make new mushroom
                        if ((tempTurtle.blueColor == NO && tempMushroom.blueColor == NO && tempMushroom.eating) || 
                            (tempTurtle.blueColor == YES && tempMushroom.blueColor == YES && tempMushroom.eating)) {
                            
                            if (tempMushroom.hitEnemy == NO) {
                                tempTurtle.isHit = YES;
                                [self spawnMushroomAtPoint:tempTurtle.position isNewSpawn:NO];
                                tempMushroom.hitEnemy = YES;
                            }
                        } 
                        //Check if turtle and mushroom are same color - no new mushroom, knock turtle off platform
                        else if ((tempTurtle.blueColor == NO && tempMushroom.blueColor == NO) || 
                                 (tempTurtle.blueColor == YES && tempMushroom.blueColor == YES)) {
                            
                            if (tempMushroom.hitEnemy == NO) {
                                b2Filter tempFilter;
                                for (b2Fixture *f = tempTurtle.body->GetFixtureList(); f; f = f->GetNext()) {
                                    f->GetFilterData();
                                    tempFilter.categoryBits = kCategoryEnemy;
                                    tempFilter.maskBits = 0x0000;
                                    tempFilter.groupIndex = kGroupEnemy;
                                    f->SetFilterData(tempFilter);
                                }
                                
                                //tempTurtle.isHit = YES;
                            }
                            
                        }
                        //Check if turtle and mushroom hit each other and mushroom is in changing state - no new mushroom, kill turtle
                        else if (tempMushroom.characterState == kStateChange) {
                            if (tempMushroom.hitEnemy == NO) {
                                tempTurtle.isHit = YES;
                            }
                        }
                        //Turtle and mushroom are wrong color - no new mushroom, knock mushroom off platform
                        else {
                            
                            //Code to change the filter data on the fly.
                            b2Filter tempFilter;
                            for (b2Fixture *f = tempMushroom.body->GetFixtureList(); f; f = f->GetNext()) {
                                f->GetFilterData();
                                tempFilter.categoryBits = kCategoryMushroom;
                                tempFilter.maskBits = 0x0000;
                                tempFilter.groupIndex = kGroupMushroom;
                                f->SetFilterData(tempFilter);
                            }
                            tempMushroom.hitByTurtle = YES;
                        }
                    }
                } else if (tempEnemy.type == kBeeType) {
                    Bee *tempBee = [visibleEnemies objectAtIndex:j];
                    
                    if ((contact.fixtureA->GetBody() == tempBee.body && contact.fixtureB->GetBody() == tempMushroom.body) || (contact.fixtureA->GetBody() == tempMushroom.body && contact.fixtureB->GetBody() == tempBee.body)) {
                        
                        tempBee.isHit = YES;
                        
                        if ((tempBee.blueColor == NO && tempMushroom.blueColor == NO && tempMushroom.eating) || (tempBee.blueColor == YES && tempMushroom.blueColor == YES && tempMushroom.eating)) {
                            if (tempMushroom.hitEnemy == NO) {
                                [self spawnMushroomAtPoint:tempBee.position isNewSpawn:NO];
                                tempMushroom.hitEnemy = YES;
                            }
                        } else {
                            tempMushroom.hitByBee = YES;
                        }
                    }
                } else if (tempEnemy.type == kJumperType) {
                    Jumper *tempJumper = [visibleEnemies objectAtIndex:j];
                    
                    if ((contact.fixtureA->GetBody() == groundBody && contact.fixtureB->GetBody() == tempJumper.body) || (contact.fixtureA->GetBody() == tempJumper.body && contact.fixtureB->GetBody() == groundBody)) {
                        b2Vec2 velocity = tempJumper.body->GetLinearVelocity();
                        if (velocity.y <= 0) {
                            tempJumper.isTouchingGround = YES;
                        }
                    }
                    
                    if ((contact.fixtureA->GetBody() == tempJumper.body && contact.fixtureB->GetBody() == tempMushroom.body) || (contact.fixtureA->GetBody() == tempMushroom.body && contact.fixtureB->GetBody() == tempJumper.body)) {
                        
                        tempJumper.isHit = YES;
                        
                        if ((tempJumper.blueColor == NO && tempMushroom.blueColor == NO && tempMushroom.eating) || (tempJumper.blueColor == YES && tempMushroom.blueColor == YES && tempMushroom.eating)) {
                            if (tempMushroom.hitEnemy == NO) {
                                [self spawnMushroomAtPoint:tempJumper.position isNewSpawn:NO];
                                tempMushroom.hitEnemy = YES;
                            }
                        } else {
                            tempMushroom.hitByJumper = YES;
                        }
                    }
                    
                }
            }
            for(int j=0 ; j < [visibleStageEffect count]; j++){
                if (backgroundLayer.backgroundEffectType == kVolcanoType) {
                    VolcanicRock *tempVolcanicRock = [visibleStageEffect objectAtIndex:j];
                    
                    if((contact.fixtureA->GetBody() == groundBody && contact.fixtureB->GetBody() == tempVolcanicRock.body) || (contact.fixtureA->GetBody() == tempVolcanicRock.body && contact.fixtureB->GetBody() == groundBody)){
                        tempVolcanicRock.hasLanded = TRUE;
                        CCLOG(@"landed");
                    }
                }
            }//end for j < [visbleStageEffect count]
        }//end for i < [visibleMushrooms count]
    }//end for contactListeners                     
                
                       
                       
    
    ///////////////////////////
    //Mushroom Line Space Check
    ///////////////////////////
    [mushroomCache lineSpaceCheck:dt withOffset:offset];
    
    /////////////////////
    //Stage Effect Update
    /////////////////////
    // if(backgroundLayer.volcanoState == kVolcanoErupt)
    
    for (int i = 0; i < [visibleStageEffect count]; i++) {
        VolcanicRock *tempVolcanicRock = [visibleStageEffect objectAtIndex:i];
        tempVolcanicRock.rockSpeed = 250 + [visibleMushrooms count] * 50;
    }
    [stageEffectCache spawnStageEffectForBackgroundState:backgroundLayer.backgroundState atTime:dt atOffset:offset andScale:self.scale];
    
    
    ///////////////////////////
    //Platform Update
    ///////////////////////////
    //offset += PIXELS_PER_SECOND*dt;
    if ([visibleMushrooms count] > 0) {
        previousOffset = offset;
        Mushroom *firstMushroom = [visibleMushrooms objectAtIndex:0];
        if (previousOffset >= firstMushroom.position.x) {
            offset = previousOffset;
            //offset = firstMushroom.position.x winSize.width/8-offset*self.scale
        } else {
            offset = firstMushroom.position.x;            
        }
        self.position = ccp(winSize.width/8-offset*self.scale, self.position.y);
    }    
    [platformCache updatePlatforms:offset withScale:self.scale];
    [backgroundLayer updateOffset:offset];
    [backgroundLayer volcanoChangeState:offset];
    
    ////////////////////////////
    //Spawn Enemy randomly
    ////////////////////////////
    if (gameStarted) {
        [enemyCache randomlySpawnEnemy:dt atOffset:offset andScale:self.scale];
    }
    
    
    
    //Checks to see if Turtle is close to mushroom. If so, ram the mushroom.
    [enemyCache detectMushroomCheck];
    
    //////////////////////////////
    //Update states of all objects
    //////////////////////////////
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:dt andListOfGameObjects:listOfGameObjects];
    }
    
    /////////////////////
    //Button Testing
    /////////////////////
    if ([uiLayer changeButton].value == 1) {
        [uiLayer changeButton].value = 0;
        //[self spawnMushroomAtPoint:ccp(0, 0) isNewSpawn:YES];
        [self resetGame];
    }
    
    if ([uiLayer jumpButton].value == 1) {
        [uiLayer jumpButton].value = 0;
        if (jumpStarted) {
            gameStarted = YES;
            for (int i = 0; i < [totalMushrooms count]; i++) {
                Mushroom *tempMushroom = [totalMushrooms objectAtIndex:i];
                tempMushroom.gameStarted = YES;
            }
        }
    }
    
    ////////////////////
    //Clean up mushrooms
    ////////////////////
    [mushroomCache cleanMushrooms];
    [enemyCache cleanEnemies];
}

-(BOOL) isTouchingLeftSide:(CGPoint)touchLocation {
    CGRect leftBox = CGRectMake(0,0,winSize.width/2, winSize.height);
    return CGRectContainsPoint(leftBox, touchLocation);
}

-(BOOL) isTouchingRightSideA:(CGPoint)touchLocation {
    CGRect rightBoxA = CGRectMake(winSize.width/2,0,winSize.width/4, winSize.height);
    return CGRectContainsPoint(rightBoxA, touchLocation);
}

-(BOOL) isTouchingRightSideB:(CGPoint)touchLocation {
    CGRect rightBoxB = CGRectMake(3*winSize.width/4,0,winSize.width/4, winSize.height);
    return CGRectContainsPoint(rightBoxB, touchLocation);
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        BOOL isTouchingLeftSide = [self isTouchingLeftSide:location];
        BOOL isTouchingRightSideA = [self isTouchingRightSideA:location];
        BOOL isTouchingRightSideB = [self isTouchingRightSideB:location];
        
        if (isTouchingLeftSide) { //Make mushroom jump
            jumpStarted = YES;
            touchStarted = YES;
            if ([visibleMushrooms count] > 0) {
                Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:0];
                //Detect if first mushroom is touching the ground
                if (tempMushroom.isTouchingGround) {
                    tempMushroom.isTouchingGround = NO;
                    mushroomCache.isMushroomJumping = YES;
                    mushroomCache.jumpJustBegan = YES;
                    jumpCount = 0;
                }
            }
        } else if (isTouchingRightSideB) {
            CCLOG(@"eat");
            eatStarted = YES;
        } else if (isTouchingRightSideA) {
            CCLOG(@"switch");
            morphStarted = YES;
        }
    }
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        BOOL isTouchingLeftSide = [self isTouchingLeftSide:location];
        BOOL isTouchingRightSideA = [self isTouchingRightSideA:location];
        BOOL isTouchingRightSideB = [self isTouchingRightSideB:location];
        
        if (isTouchingLeftSide) { //Make mushroom jump
            if ([visibleMushrooms count] > 0) {
                Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:0];
                if (mushroomCache.isMushroomJumping == YES) {
                    touchStarted = NO;
                    //[tempMushroom changeState:kStateLanding];
                }
            }
        } else if (isTouchingRightSideB) {
            eatStarted = NO;
        } else if (isTouchingRightSideA) { //Mushroom switch ends
            if (morphStarted) {
                if (mushroomCache.blueColor) {
                    mushroomCache.blueColor = NO;
                } else {
                    mushroomCache.blueColor = YES;
                }
                
                for (int i = 0; i < [visibleMushrooms count]; i++) {
                    Mushroom *tempMushroom = [visibleMushrooms objectAtIndex:i];
                    [tempMushroom changeState:kStateChange];
                }
                morphStarted = NO;
            }
        }
    }
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
    
    [mushroomCache release];
    [platformCache release];
    
    [super dealloc];
}

@end
