//
//  GeoQuestTerritory.h
//  GeoQuest
//
//  Created by Kelvin on 1/8/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoQuestTerritory : NSObject {
    
    NSString *_territoryID;
    NSString *_name;
    NSString *_questionTable;
    NSString *_answerTable;    
}

@property (nonatomic, copy) NSString *territoryID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *questionTable;
@property (nonatomic, copy) NSString *answerTable;

-(id) initWithTerritoryID:(NSString*)territoryID name:(NSString*)name questionTable:(NSString*)questionTable answerTable:(NSString*)answerTable;

@end
