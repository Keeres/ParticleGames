//
//  GeoQuestAnswer.h
//  SQLitePractice
//
//  Created by Kelvin on 11/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GeoQuestAnswer : NSObject {
    NSString *_key;
    NSString *_name;
    NSString *_category;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *category;

-(id) initWithKey:(NSString*)key name:(NSString*)name category:(NSString*)category;

@end
