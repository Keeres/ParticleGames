//  This file was generated by LevelHelper
//  http://www.levelhelper.org
//
//  LevelHelperLoader.mm
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////
#import "LHJointsExt.h"

@implementation LevelHelperLoader (JOINTS_EXTENSION)
////////////////////////////////////////////////////////////////////////////////
-(b2Joint*) box2dJointWithUniqueName:(NSString*)name
{
    LHJoint* levelJoint = [jointsInLevel objectForKey:name];
    if(nil == levelJoint)
        return 0;
    return [levelJoint joint];
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*) box2dJointsWithTag:(enum LevelHelper_TAG)tag{
	NSArray *keys = [jointsInLevel allKeys];
#ifndef LH_ARC_ENABLED
    NSMutableArray* jointsWithTag = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* jointsWithTag = [[NSMutableArray alloc] init];
#endif 
	for(NSString* key in keys){
        LHJoint* levelJoint = [jointsInLevel objectForKey:key];
        
        if([levelJoint tag] == tag)
        {
            [jointsWithTag addObject:[NSValue valueWithPointer:[levelJoint joint]]];
        }
	}
    return jointsWithTag;
}
////////////////////////////////////////////////////////////////////////////////
+(int) tagForJoint:(b2Joint*)joint
{
    if(0 != joint)
    {
#ifndef LH_ARC_ENABLED
        LHJoint* data = (LHJoint*)joint->GetUserData();
#else
        LHJoint* data = (__bridge LHJoint*)joint->GetUserData();
#endif
		
        if(nil != data)
        {
            return [data tag];
        }
    }
    
    return -1;
}
////////////////////////////////////////////////////////////////////////////////
+(enum LH_JOINT_TYPE) typeForJoint:(b2Joint*)joint
{
    if(0 != joint)
    {
#ifndef LH_ARC_ENABLED
        LHJoint* data = (LHJoint*)joint->GetUserData();
#else
        LHJoint* data = (__bridge LHJoint*)joint->GetUserData();
#endif
        
        if(nil != data)
        {
            return [data type];
        }
    }
    return LH_UNKNOWN_TYPE;    
}
////////////////////////////////////////////////////////////////////////////////
+(NSString*) uniqueNameForJoint:(b2Joint*)joint
{
    if(0 != joint)
    {
#ifndef LH_ARC_ENABLED
        LHJoint* data = (LHJoint*)joint->GetUserData();
#else
        LHJoint* data = (__bridge LHJoint*)joint->GetUserData();
#endif
        if(0 != data)
        {
            return [data uniqueName];
        }
    }
    return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(bool) removeJointWithUniqueName:(NSString*)name
{
    if(0 == name)
		return false;
    [jointsInLevel removeObjectForKey:name];
	return true;
}
@end
