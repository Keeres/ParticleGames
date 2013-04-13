//
//  MimicServer.h
//  GeoQuest
//
//  Created by Kelvin on 3/4/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <sqlite3.h>
#import "Guid.h"

@interface MimicServer : NSObject {
    sqlite3         *_database;
    
    NSString        *_username;
}

+(MimicServer*) database;

-(void) addNewPlayer:(NSString*)username;


@end
