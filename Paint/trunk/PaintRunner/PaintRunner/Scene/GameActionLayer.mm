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

-(void) spawnObstacleAtTime:(ccTime)dt{
    obstacleTimePassed += dt;
    airObstacleTimePassed += dt;
    
    if (spawnObstacle == FALSE) {
        obstacleSpawnTimer = arc4random()%5 + 1;
        spawnObstacle = TRUE;
    }
    if (spawnAirObstacle == FALSE) {
        airObstacleSpawnTimer = arc4random()%5+3;
        spawnAirObstacle = TRUE;
    }
    if (spawnObstacle == TRUE && obstacleTimePassed > obstacleSpawnTimer) {
        int tempWidth = arc4random()%5;
        int tempHeight = arc4random()%5;
        
        [obstacleWidths insertObject:[NSNumber numberWithDouble:(10.0*tempWidth+40.0)*PTP_Ratio] atIndex:obstacleCount];
        [obstacleHeights insertObject:[NSNumber numberWithDouble:(20.0*tempHeight+40.0)*PTP_Ratio] atIndex:obstacleCount];
        [obstacleCentersX insertObject:[NSNumber numberWithDouble:winSize.width*PTP_Ratio + 80*PTP_Ratio + [[obstacleWidths objectAtIndex:obstacleCount] doubleValue]/2.0] atIndex:obstacleCount];
        [obstacleCentersY insertObject:[NSNumber numberWithDouble:10*PTP_Ratio + [[obstacleHeights objectAtIndex:obstacleCount]doubleValue]/2.0] atIndex:obstacleCount];
        
        obstacleCount ++ ;
        
        //if true sets up another obstacle next to the current one
        if (arc4random()%3 == 0) {
            tempWidth = arc4random()%5;
            tempHeight = arc4random()%5;
            
            [obstacleWidths insertObject:[NSNumber numberWithDouble:(10.0*tempWidth+40.0)*PTP_Ratio] atIndex:obstacleCount];
            [obstacleHeights insertObject:[NSNumber numberWithDouble:(12.0*tempHeight+40.0)*PTP_Ratio] atIndex:obstacleCount];
            [obstacleCentersX insertObject:[NSNumber numberWithDouble:[[obstacleCentersX objectAtIndex:obstacleCount-1]doubleValue] + [[obstacleWidths objectAtIndex:obstacleCount-1]doubleValue]/2.0 + [[obstacleWidths objectAtIndex:obstacleCount]doubleValue]/2.0] atIndex:obstacleCount];
            [obstacleCentersY insertObject:[NSNumber numberWithDouble:10*PTP_Ratio + [[obstacleHeights objectAtIndex:obstacleCount]doubleValue]/2.0] atIndex:obstacleCount];
            
            obstacleCount ++ ;            
        }
        spawnObstacle = FALSE;
        obstacleTimePassed = 0.0;
    }
    if (spawnAirObstacle == TRUE && airObstacleTimePassed > airObstacleSpawnTimer) {
        
        int tempWidth = arc4random()%7;
        int tempHeight = arc4random()%3;
        int spawnHeight = arc4random()%10;
        
        [obstacleWidths insertObject:[NSNumber numberWithDouble:(20.0*tempWidth+40.0)*PTP_Ratio] atIndex:obstacleCount];
        [obstacleHeights insertObject:[NSNumber numberWithDouble:(10.0*tempHeight+20.0)*PTP_Ratio] atIndex:obstacleCount];
        [obstacleCentersX insertObject:[NSNumber numberWithDouble:winSize.width*PTP_Ratio + 80*PTP_Ratio + [[obstacleWidths objectAtIndex:obstacleCount] doubleValue]/2.0] atIndex:obstacleCount];
        [obstacleCentersY insertObject:[NSNumber numberWithDouble:winSize.height/2.0*PTP_Ratio + [[obstacleHeights objectAtIndex:obstacleCount]doubleValue]/2.0 + spawnHeight*10.0*PTP_Ratio] atIndex:obstacleCount];
        
        obstacleCount ++ ;
        spawnAirObstacle = FALSE;
        airObstacleTimePassed = 0.0;
    }
}

-(void) updateObstacleVerticesWithTime:(ccTime)dt andSpeed:(float)speed{
    nObstalceVertices = 0;
    nObstalceBox2dVertices = 0;
    if (pixelWinSize.width > 480.0) { 
        speed = speed*PTP_Ratio;
    }
    for (int i=0; i<obstacleCount; i++) {
        [obstacleCentersX replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:[[obstacleCentersX objectAtIndex:i]doubleValue] - speed*dt]];
        
        float x1 = [[obstacleCentersX objectAtIndex:i]doubleValue] - [[obstacleWidths objectAtIndex:i]doubleValue]/2.0;
        float x2 = [[obstacleCentersX objectAtIndex:i]doubleValue] + [[obstacleWidths objectAtIndex:i]doubleValue]/2.0;  
        float y1 = [[obstacleCentersY objectAtIndex:i]doubleValue] - [[obstacleHeights objectAtIndex:i]doubleValue]/2.0;    
        float y2 = [[obstacleCentersY objectAtIndex:i]doubleValue] + [[obstacleHeights objectAtIndex:i]doubleValue]/2.0;    
    
        //sets up vertices for drawing
        obstacleVertices[nObstalceVertices++] = CGPointMake(x1, y1);
        obstacleVertices[nObstalceVertices++] = CGPointMake(x1, y2);
        obstacleVertices[nObstalceVertices++] = CGPointMake(x2, y2);
        obstacleVertices[nObstalceVertices++] = CGPointMake(x2, y2);
        obstacleVertices[nObstalceVertices++] = CGPointMake(x1, y1);
        obstacleVertices[nObstalceVertices++] = CGPointMake(x2, y1);

        
        obstacleBox2dVertices[nObstalceBox2dVertices++] = CGPointMake(x1/PTP_Ratio, y1/PTP_Ratio);
        obstacleBox2dVertices[nObstalceBox2dVertices++] = CGPointMake(x1/PTP_Ratio, y2/PTP_Ratio);
        obstacleBox2dVertices[nObstalceBox2dVertices++] = CGPointMake(x2/PTP_Ratio, y1/PTP_Ratio);
        obstacleBox2dVertices[nObstalceBox2dVertices++] = CGPointMake(x2/PTP_Ratio, y2/PTP_Ratio);
    }
    
    for (int i=0; i<obstacleCount; i++) {
        if ([[obstacleCentersX objectAtIndex:i]doubleValue] < -[[obstacleWidths objectAtIndex:i]doubleValue]) {
            [obstacleCentersX removeObjectAtIndex:i];
            [obstacleCentersY removeObjectAtIndex:i];
            [obstacleWidths removeObjectAtIndex:i];
            [obstacleHeights removeObjectAtIndex:i];
            obstacleCount--;
        }
    }
}

-(void) draw {
    //Draws obstacle
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);

    //begin drawing obstacle
    glColor4f(1.0, 1.0, 1.0, 1.0);
    glVertexPointer(2, GL_FLOAT, 0, obstacleVertices);
    glDrawArrays(GL_TRIANGLES, 0, nObstalceVertices);
    //end drawing obstacle

    world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void) createObstacleBody {
    ///////////////////////////////////
    //Creates top body for obstacle 
    ///////////////////////////////////
    if(obstacleTopBody) {
        world->DestroyBody(obstacleTopBody);
    }
    
    b2BodyDef obstacleTopBodyDef;
    obstacleTopBodyDef.type = b2_staticBody;
    obstacleTopBodyDef.position = b2Vec2(0,0);
    obstacleTopBody = world->CreateBody(&obstacleTopBodyDef);
    
    b2PolygonShape obstacleTopshape;
    b2FixtureDef obstacleTopFixture;
    obstacleTopFixture.shape = &obstacleTopshape;
    obstacleTopFixture.restitution = 0.0;
   // obstacleTopFixture.friction = 0.0;
    
    ///////////////////////////////////
    //Creates bottom body for obstacle 
    ///////////////////////////////////
    if(obstacleBottomBody) {
        world->DestroyBody(obstacleBottomBody);
    }
    
    b2BodyDef obstacleBottomBodyDef;
    obstacleBottomBodyDef.type = b2_staticBody;
    obstacleBottomBodyDef.position = b2Vec2(0,0);
    obstacleBottomBody = world->CreateBody(&obstacleBottomBodyDef);
    
    b2PolygonShape obstacleBottomShape;
    b2FixtureDef obstacleBottomFixture;
    obstacleBottomFixture.shape = &obstacleBottomShape;
  //  obstacleBottomFixture.restitution = 0.0;

    //////////////////////////////////
    //Creates side body for obstacle 
    //////////////////////////////////
    if (obstacleSideBody) {
        world->DestroyBody(obstacleSideBody);
    }
    
    b2BodyDef obstacleSideBodyDef;
    obstacleSideBodyDef.type = b2_staticBody;
    obstacleSideBodyDef.position = b2Vec2(0,0);
    obstacleSideBody = world->CreateBody(&obstacleSideBodyDef);
    
    b2PolygonShape obstacleSideShape;    
    b2FixtureDef obstacleSideFixture;
    obstacleSideFixture.shape = &obstacleSideShape;
    obstacleSideFixture.density = 1.0;
    obstacleSideFixture.restitution = 0.0;
    
    //////////////////////////////////
    //Setsup obstacle vertices
    //////////////////////////////////
    b2Vec2 lowerLeft, lowerRight, upperLeft, upperRight;
    for (int i=0; i<nObstalceBox2dVertices; i+=4) {
        //obstacle top
        upperLeft = b2Vec2(obstacleBox2dVertices[i+1].x/PTM_RATIO, obstacleBox2dVertices[i+1].y/PTM_RATIO);
        upperRight =  b2Vec2(obstacleBox2dVertices[i+3].x/PTM_RATIO, obstacleBox2dVertices[i+1].y/PTM_RATIO);
        lowerLeft = b2Vec2(obstacleBox2dVertices[i].x/PTM_RATIO, obstacleBox2dVertices[i].y/PTM_RATIO);
        lowerRight =  b2Vec2(obstacleBox2dVertices[i+2].x/PTM_RATIO, obstacleBox2dVertices[i+2].y/PTM_RATIO);

        obstacleTopshape.SetAsEdge(upperLeft, upperRight);
        obstacleTopBody->CreateFixture(&obstacleTopFixture);
        obstacleBottomShape.SetAsEdge(lowerLeft, lowerRight);
        obstacleBottomBody->CreateFixture(&obstacleBottomFixture);

        //obstacle bottom
        
        //obstacle side
        lowerLeft = b2Vec2(obstacleBox2dVertices[i].x/PTM_RATIO, (obstacleBox2dVertices[i].y+5.0)/PTM_RATIO);
        upperLeft = b2Vec2(obstacleBox2dVertices[i+1].x/PTM_RATIO, (obstacleBox2dVertices[i+1].y-5.0)/PTM_RATIO);
        lowerRight =  b2Vec2(obstacleBox2dVertices[i+2].x/PTM_RATIO, (obstacleBox2dVertices[i+2].y+5.0)/PTM_RATIO);
        upperRight =  b2Vec2(obstacleBox2dVertices[i+3].x/PTM_RATIO, (obstacleBox2dVertices[i+3].y-5.0)/PTM_RATIO);
        
        obstacleSideShape.SetAsEdge(lowerLeft, upperLeft);
        obstacleSideBody->CreateFixture(&obstacleSideFixture);
        obstacleSideShape.SetAsEdge(lowerRight, upperRight);
        obstacleSideBody->CreateFixture(&obstacleSideFixture);
    }
}

-(void) createGround {
    float32 margin = 10.0f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((winSize.width-margin)/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((winSize.width-margin)/PTM_RATIO, (winSize.height-margin)/PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2(margin/PTM_RATIO, (winSize.height-margin)/PTM_RATIO);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);
    b2PolygonShape groundShape;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    groundShape.SetAsEdge(lowerLeft, lowerRight);
    groundBody->CreateFixture(&groundFixtureDef);
    //groundShape.SetAsEdge(lowerRight, upperRight);
    //groundBody->CreateFixture(&groundFixtureDef);
    //groundShape.SetAsEdge(upperRight, upperLeft);
    //groundBody->CreateFixture(&groundFixtureDef);
    //groundShape.SetAsEdge(upperLeft, lowerLeft);
    //groundBody->CreateFixture(&groundFixtureDef);
}

-(void) createPlayer {
    player = [[[Player alloc] initWithWorld:world] retain];
    [sceneSpriteBatchNode addChild:player z:1000];
}

-(void) createPlatforms {
    platformCache = [[PlatformCache alloc] initWithWorld:world];
    [self addChild:platformCache z:0];
}

-(void) createPaintChips {
    paintChipCache = [[PaintChipCache alloc] initWithWorld:world];
    CCArray *tempArray = [paintChipCache totalPaintChips];
    for (int i = 0; i < [tempArray count]; i++) {
        PaintChip *tempPC = [tempArray objectAtIndex:i];
        [sceneSpriteBatchNode addChild:tempPC z:1000];
    }
}

-(id) initWithGameUILayer:(GameUILayer *)gameUILayer andBackgroundLayer:(GameBackgroundLayer*)gameBGLayer {
    if ((self = [super init])) {
        winSize = [CCDirector sharedDirector].winSize;

        //Setup layers
        uiLayer = gameUILayer;
        backgroundLayer = gameBGLayer;
        
        //Setup initialial variables
        self.isTouchEnabled = YES;
        jumpBufferCount = 0;
        playerStartJump = NO;
        playerEndJump = NO;
        changeDirectionToLeft = YES;
        levelMovingLeft = NO;
        screenOffset = 0.0;
        levelTimePassed = 0.0;
        paintTimePassed = 0.0;
        PIXELS_PER_SECOND = 0.0;
        MAX_PIXELS_PER_SECOND = 200.0;
        
        //For obstacle drawing
        //determines screen size in pixels
        pixelWinSize = [[[UIScreen mainScreen] currentMode] size];
        if (pixelWinSize.width > 480.0) {
            PTP_Ratio = 2.0;  
        } else {
            PTP_Ratio = 1.0;
        }
        obstacleCount = 0;
        obstacleCentersX = [[NSMutableArray alloc] init];
        obstacleCentersY = [[NSMutableArray alloc] init];
        obstacleWidths = [[NSMutableArray alloc] init];
        obstacleHeights = [[NSMutableArray alloc] init];
        obstacleTimePassed = 0.0;
        airObstacleTimePassed = 0.0;
        obstacleSpawnTimer = 0;
        airObstacleSpawnTimer = 0;
        spawnObstacle = FALSE;
        
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
        
        //Create world and objects
        [self setupWorld];
        [self setupDebugDraw];
        [self createGround];
        [self createPlayer];
        [self createPlatforms];
        [self createPaintChips];
        
        //Create contact listener
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
        
        //Update Tick
        [self scheduleUpdate];     
    }
    return self;
}

-(void) screenOffset:(ccTime)dt {
    //////////////////////////////////
    //Calculate offset to shift screen
    //////////////////////////////////
    levelTimePassed += dt;
    
    if (levelTimePassed > 20.0) {
        levelTimePassed = 0;
        
        if (changeDirectionToLeft) {
            changeDirectionToLeft = NO;
            if (MAX_PIXELS_PER_SECOND < 400.0) {
                MAX_PIXELS_PER_SECOND = MAX_PIXELS_PER_SECOND + 50;
            }
        } else {
            changeDirectionToLeft = YES;
            if (MAX_PIXELS_PER_SECOND > -400.0) {
                MAX_PIXELS_PER_SECOND = MAX_PIXELS_PER_SECOND - 50;
            }
        }
        
        MAX_PIXELS_PER_SECOND *= -1;
    }
    
    if (changeDirectionToLeft) {
        if (PIXELS_PER_SECOND < MAX_PIXELS_PER_SECOND) {
            float change = MAX_PIXELS_PER_SECOND/2;
            PIXELS_PER_SECOND += change*dt;
        }
    } else {
        if (PIXELS_PER_SECOND > MAX_PIXELS_PER_SECOND) {
            float change = MAX_PIXELS_PER_SECOND/2;
            //PIXELS_PER_SECOND -= 50.0*dt;
            PIXELS_PER_SECOND += change*dt;
        }
    }
    
    if (PIXELS_PER_SECOND > 0) {
        levelMovingLeft = YES;
    } else {
        levelMovingLeft = NO;
    }
    
    screenOffset += PIXELS_PER_SECOND * dt;
    float backgroundWidth = [backgroundLayer background].contentSize.width;
    if(screenOffset >= backgroundWidth) {
        screenOffset = screenOffset - backgroundWidth;
    }
    
    //Comment top part out for one way scrolling
    //Uncomment bottom part as well
    /*PIXELS_PER_SECOND = 200.0;
    screenOffset += PIXELS_PER_SECOND * dt;
    float backgroundWidth = [backgroundLayer background].contentSize.width;
    if(screenOffset >= backgroundWidth) {
        screenOffset = screenOffset - backgroundWidth;
    }*/
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
            }
        }
        
        //Check if player has touched the top of the obstacle
        if ((contact.fixtureA->GetBody() == obstacleTopBody && contact.fixtureB->GetBody() == player.body) || 
            (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == obstacleTopBody)) {
            player.isTouchingGround = YES;
            player.doubleJumpAvailable = YES;
        }
        
        //Checks for contact between player and side face of obstacle
        for (int i=0; i<obstacleCount; i++) {
            if ((contact.fixtureA->GetBody() == obstacleSideBody && contact.fixtureB->GetBody() == player.body) || 
                (contact.fixtureA->GetBody() == player.body && contact.fixtureB->GetBody() == obstacleSideBody)) {
              //  placeholder
               // player.hitObstacle = YES;
             //   CCLOG(@"hit obstacle");
            }
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

-(void) updateStatesOfObjects:(ccTime)dt {
    //////////////////////////////
    //Update states of all objects
    //////////////////////////////
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:dt];
    }
}

-(void) updateBackgroundState:(ccTime)dt {
    //////////////////////////////
    //Update background art
    //////////////////////////////
    [backgroundLayer updateBackground:dt 
                       playerPosition:[player openGLPosition] 
            andPlayerPreviousPosition:[player previousPosition] 
                    andPlayerOnGround:player.isTouchingGround 
                       andPlayerScale:[player basePlayerScale]
                      andScreenOffset:screenOffset];
}

-(void) update:(ccTime)dt {
    [self screenOffset:dt];
    [self physicsSimulation:dt];
    [self detectContacts:dt];
    [self playerJumpBuffer];
    [self paintChipControl:dt];
    [self createObstacleBody];
    
    [self updateStatesOfObjects:dt];
    [self updateBackgroundState:dt];
    [player updateStateWithDeltaTime:dt andSpeed:PIXELS_PER_SECOND];
    [paintChipCache updatePaintChipsWithTime:dt andSpeed:PIXELS_PER_SECOND];
    
    //obstacle updates
    [self spawnObstacleAtTime:dt];
    [self updateObstacleVerticesWithTime:dt andSpeed:PIXELS_PER_SECOND];
}

-(BOOL) isTouchingLeftSide:(CGPoint)touchLocation {
    CGRect leftBox = CGRectMake(0,0,winSize.width/2, winSize.height);
    return CGRectContainsPoint(leftBox, touchLocation);
}

/*-(BOOL) isTouchingRightSide:(CGPoint)touchLocation {
    CGRect rightBox = CGRectMake(winSize.width/2,0,winSize.width/2, winSize.height);
    return CGRectContainsPoint(rightBox, touchLocation);
}*/

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        BOOL isTouchingLeftSide = [self isTouchingLeftSide:location];
        //BOOL isTouchingRightSide = [self isTouchingRightSide:location];
        
        if (isTouchingLeftSide) {
            if (player.isTouchingGround || player.doubleJumpAvailable) {
                if (player.doubleJumpAvailable == NO) {
                    player.doubleJumpAvailable = YES;
                } else {
                    player.doubleJumpAvailable = NO;
                }
                
                playerStartJump = YES;
                player.isJumpingLeft = YES;
                player.jumpTime = 0.0;
                backgroundLayer.baseBrushColor = [backgroundLayer randomBrushColor];
                jumpBufferCount = 0;
            }
        } else {
            if (player.isTouchingGround || player.doubleJumpAvailable) {
                if (player.doubleJumpAvailable == NO) {
                    player.doubleJumpAvailable = YES;
                } else {
                    player.doubleJumpAvailable = NO;
                }
                
                playerStartJump = YES;
                player.isJumpingLeft = NO;
                player.jumpTime = 0.0;
                backgroundLayer.baseBrushColor = [backgroundLayer randomBrushColor];
                jumpBufferCount = 0;
            }
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
    [sceneSpriteBatchNode release];
    [super dealloc];
}



@end
