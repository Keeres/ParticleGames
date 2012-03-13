//
//  MiniGameScene.mm
//  CatRun
//
//  Created by Kelvin on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MiniGameScene.h"
const float32 FIXED_TIMESTEP = 1.0f / 60.0f;
const float32 MINIMUM_TIMESTEP = 1.0f / 600.0f;  
const int32 VELOCITY_ITERATIONS = 3;
const int32 POSITION_ITERATIONS = 2;
const int32 MAXIMUM_NUMBER_OF_STEPS = 25;

@implementation MiniGameScene

#pragma mark Collisions
-(void)playerGroundCollision:(LHContactInfo*)contact {        
    LHSprite* ground = [contact spriteB];
    
    if(nil != ground)
    {
        if([ground opacity])
        {   
            player.isTouchingGround = YES;
        }
    }
}


-(void)playerStarCollision:(LHContactInfo*)contact {        
    LHSprite* star = [contact spriteB];
    
    if(nil != star)
    {
        if([star opacity])
        {   
            //[self scoreHitAtPosition:[coin position] withPoints:100];
            //[[SimpleAudioEngine sharedEngine] playEffect:@"coin.wav"];
        }
        [star setOpacity:0];   
    }
}

-(void) setupCollisionHandling
{
    [lh useLevelHelperCollisionHandling];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PLAYER andTagB:GROUND idListener:self selListener:@selector(playerGroundCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PLAYER andTagB:STAR idListener:self selListener:@selector(playerStarCollision:)];
}

#pragma mark Setup Objects
-(void) retrieveRequiredObjects {
    parallaxNode = [lh parallaxNodeWithUniqueName:@"Game_Parallax"];
    NSAssert(parallaxNode!=nil, @"Couldn't find the parallax!");
    [parallaxNode setPaused:true];
    
    id obj = [lh spriteWithUniqueName:@"catPlayer"];
    NSAssert(obj!=nil, @"Couldn't find the object player!");

    switch (typeOfPlayer) {
        case kDefaultJump: {
            if ([DefaultPlayer isSpritePlayer:obj]) {
                player = obj;
            }
            break;
        }
            
        case kDoubleJump: {
            if ([DoubleJumpPlayer isSpritePlayer:obj]) {
                player = obj;
            }
            break;
        }
            
        case kGlider: {
            if ([GliderPlayer isSpritePlayer:obj]) {
                player = obj;
            }
            break;
        }
            
        case kFlying: {
            if ([FlyingPlayer isSpritePlayer:obj]) {
                player = obj;
            }
            break;
        }
            
        case kFlapping:
            break;
            
        default:
            break;
    }

    playerBody = [player body];
    NSAssert(playerBody!=nil, @"Error taking the body from the player LHSprite.");
    
    finishLine = [lh spriteWithUniqueName:@"flag"];
    NSAssert(finishLine!=nil, @"Couldn't find the finishLine!");
    
}

-(void) setupDebug {
    // Debug Draw functions
    m_debugDraw = new GLESDebugDraw();
    world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    flags += b2Draw::e_jointBit;
    m_debugDraw->SetFlags(flags);
}


-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

////////////////////////////////////////////////////////////////////////////////
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MiniGameScene *layer = [MiniGameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
////////////////////////////////////////////////////////////////////////////////
// initialize your instance here

#pragma mark Init
-(id) init
{
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		[[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES];
        
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -20.0f);
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity);
		
		world->SetContinuousPhysics(true);
        
        [self scheduleUpdate];
        
        NSString *miniGameSelected = [GameState sharedInstance].currentMiniGameSelected;
        lh = [[LevelHelperLoader alloc] initWithContentOfFile:miniGameSelected];	        

        //Need this line to load the custom class for Player
        typeOfPlayer = [GameState sharedInstance].currentActivePerk;
        switch (typeOfPlayer) {
            case kDefaultJump:
                [[LHCustomSpriteMgr sharedInstance] registerCustomSpriteClass:[DefaultPlayer class] forTag:PLAYER];
                break;
                
            case kDoubleJump:
                [[LHCustomSpriteMgr sharedInstance] registerCustomSpriteClass:[DoubleJumpPlayer class] forTag:PLAYER];
                break;
                
            case kGlider:
                [[LHCustomSpriteMgr sharedInstance] registerCustomSpriteClass:[GliderPlayer class] forTag:PLAYER];
                break;
            case kFlying:
                [[LHCustomSpriteMgr sharedInstance] registerCustomSpriteClass:[FlyingPlayer class] forTag:PLAYER];
                break;
                
            case kFlapping:
                break;
                
            default:
                break;
        }
        
        //creating the objects
        [lh addObjectsToWorld:world cocos2dLayer:self];
        
        if([lh hasPhysicBoundaries])
            [lh createPhysicBoundaries:world];
        
        if(![lh isGravityZero])
            [lh createGravity:world];
        
        gameStart = NO;
        gameOver = NO;
        
        [self setupDebug];
        [self retrieveRequiredObjects]; // Retrieve all objects after we’ve loaded the level.
        [self setupCollisionHandling];
        
	}
	return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark Update States

-(void)afterStep {
	// process collisions and result from callbacks called by the step
}

-(void)step:(ccTime)dt {
	float32 frameTime = dt;
	int stepsPerformed = 0;
	while ( (frameTime > 0.0) && (stepsPerformed < MAXIMUM_NUMBER_OF_STEPS) ){
		float32 deltaTime = std::min( frameTime, FIXED_TIMESTEP );
		frameTime -= deltaTime;
		if (frameTime < MINIMUM_TIMESTEP) {
			deltaTime += frameTime;
			frameTime = 0.0f;
		}
		world->Step(deltaTime,VELOCITY_ITERATIONS,POSITION_ITERATIONS);
		stepsPerformed++;
		[self afterStep]; // process collisions and result from callbacks called by the step
	}
	world->ClearForces ();
}

-(void) physicsIterations {
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) 
        {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
            
            if(myActor != 0)
            {
                //THIS IS VERY IMPORTANT - GETTING THE POSITION FROM BOX2D TO COCOS2D
                myActor.position = [LevelHelperLoader metersToPoints:b->GetPosition()];
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());		
            }
            
        }	
	}
}

-(void) checkGameStartAndOver {
    if (gameStart && !gameOver) {
        [parallaxNode setPaused:false];
    }
    
    if (finishLine.position.x < player.position.x || finishLine.visible == NO) {
        gameOver = YES;
    }
    
    if (gameOver && player.isTouchingGround) {
        [parallaxNode setPaused:true];
        [player stopAllActions];
    }
}

-(void) playerTouchBuffer {
    if (playerBeginTouch) {
        if (playerTouchBufferCount < 1) {
            player.touchActivated = YES;            
            playerTouchBufferCount++;
        }
        
        if (playerTouchBufferCount >= 1 && playerEndTouch) {
            playerBeginTouch = NO;
            playerEndTouch = NO;
            player.touchActivated = NO;
        }
    }
}

-(void) updateStatesOfObjects:(ccTime)dt {
    [player updateStateWithDeltaTime:dt];
}

-(void) update:(ccTime)dt { 
	[self step:dt];
    [self physicsIterations];
    [self checkGameStartAndOver];
    [self playerTouchBuffer];
    [self updateStatesOfObjects:dt];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark ccTouches
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (gameStart && !gameOver) {
        playerBeginTouch = YES;
        playerTouchBufferCount = 0;
        player.touchTime = 0.0;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (gameStart == NO) {
        gameStart = YES;
    } else {
        playerEndTouch = YES;
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark Dealloc
- (void) dealloc {
    
    if(nil != lh)
        [lh release];
    
	delete world;
	world = NULL;
	
  	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

