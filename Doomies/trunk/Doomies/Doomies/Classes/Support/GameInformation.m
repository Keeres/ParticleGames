//
//  GameInformation.m
//  SmishiSmashi
//
//  Created by Kelvin on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameInformation.h"

static GameInformation *sharedGameInformation = NULL;

@implementation GameInformation

@synthesize gameHighScore;

+(id) sharedInformation {
	@synchronized(self) {
		if (sharedGameInformation == NULL) {
			sharedGameInformation = [[super allocWithZone:NULL] init];
		}
	}
	return sharedGameInformation;
}

+(id) allocWithZone:(NSZone *)zone {
	return [[self sharedInformation] retain];
}

-(id) copyWithZone:(NSZone *)zone {
	return self;
}

-(id) retain {
	return self;
}

-(void) release {
	
}

-(id) autorelease {
	return self;
}

-(id) init {
	self = [super init];
	if (self) {
		//gameHighScore = 0;
	}
	return self;
}

-(void) setGameHighScore:(int64_t)a {
	gameHighScore = a;
}

-(void) saveGameState {
	NSLog(@"saveGameState");
	//Set up the game state path to the data file that the game state will be saved to.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
	
	//Set up the endcoder and strage for the game state data
	NSMutableData *gameData;
	NSKeyedArchiver	*encoder;
	gameData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
	
	//Archive our object
	[encoder encodeInt:[self gameHighScore] forKey:@"gameHighScore"];
	
	//Finish encoding and write to the gameState.dat file
	[encoder finishEncoding];
	[gameData writeToFile:gameStatePath atomically:YES];
	[encoder release];
	
}

-(void) loadGameState {
	// Check to see if there is a gameState.dat file. If there is then load the contents.
	NSLog(@"loadGameState - gameHighScore: %i", [self gameHighScore]);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSMutableData *gameData;
	NSKeyedUnarchiver *decoder;
	
	NSString *documentPath = [documentsDirectory stringByAppendingFormat:@"/gameState.dat"];
	gameData = [NSData dataWithContentsOfFile:documentPath];
	
	if (gameData) {
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameData];
		NSLog(@"%i", [decoder decodeIntForKey:@"gameHighScore"]);
		
		[self setGameHighScore:[decoder decodeIntForKey:@"gameHighScore"]];
		//sharedInformation.gameHighScore = [decoder decodeIntForKey:@"gameHighScore"];
		
		[decoder release];
	} else {
		NSLog(@"There is no gameState.dat");
	}
	
}

-(void) dealloc {
	[super dealloc];
}

@end
