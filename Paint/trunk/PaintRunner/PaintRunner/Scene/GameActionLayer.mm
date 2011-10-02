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

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) createGround {
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    float32 margin = 10.0f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               margin/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               (winSize.height-margin)/PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2(margin/PTM_RATIO,
                              (winSize.height-margin)/PTM_RATIO);
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
    groundShape.SetAsEdge(lowerRight, upperRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperRight, upperLeft);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperLeft, lowerLeft);
    groundBody->CreateFixture(&groundFixtureDef);
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
        screenOffset = 0.0;
        timePassed = 0.0;
        PIXELS_PER_SECOND = 50.0;

        
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
    screenOffset += PIXELS_PER_SECOND * dt;
    float backgroundWidth = [backgroundLayer background].contentSize.width;
    if(screenOffset >= backgroundWidth) {
        screenOffset = screenOffset - backgroundWidth;
    }
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
    timePassed += dt;
    if (timePassed > 3) {
        [paintChipCache addPaintChips];
        timePassed = 0.0;
    }
}

-(void) updateStatesOfObjects:(ccTime)dt {
    //////////////////////////////
    //Update states of all objects
    //////////////////////////////
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:dt andListOfGameObjects:listOfGameObjects];
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
    
    [self updateStatesOfObjects:dt];
    [self updateBackgroundState:dt];
    [paintChipCache updatePaintChipsWithTime:dt andSpeed:PIXELS_PER_SECOND];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (player.isTouchingGround || player.doubleJumpAvailable) {
        if (player.doubleJumpAvailable == NO) {
            player.doubleJumpAvailable = YES;
        } else {
            player.doubleJumpAvailable = NO;
        }
        
        playerStartJump = YES;
        player.jumpTime = 0.0;
        backgroundLayer.baseBrushColor = [backgroundLayer randomBrushColor];
        jumpBufferCount = 0;
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
