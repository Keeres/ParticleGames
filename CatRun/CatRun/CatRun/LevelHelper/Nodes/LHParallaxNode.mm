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
#import "LHParallaxNode.h"
#import "LHSettings.h"
#import "LHSprite.h"
#import "LevelHelperLoader.h"
////////////////////////////////////////////////////////////////////////////////

@interface LHSprite (LH_PARALLAX_SPRITE_EXT) 
-(void)setParallaxFollowingThisSprite:(LHParallaxNode*)par;
-(void)setSpriteIsInParallax:(LHParallaxNode*)node;
@end
@implementation LHSprite (LH_PARALLAX_SPRITE_EXT)
-(void)setParallaxFollowingThisSprite:(LHParallaxNode*)par{
    parallaxFollowingThisSprite = par;
}
-(void)setSpriteIsInParallax:(LHParallaxNode*)node{
    spriteIsInParallax = node;
}
@end

@interface LHParallaxPointObject : NSObject
{
    CGPoint virtualPosition;
	CGPoint position;
	CGPoint	ratio;
	CGPoint offset;
    bool isLHSprite;
	CGPoint initialPosition;
#ifndef LH_ARC_ENABLED
	CCNode *ccsprite;	//weak ref
	b2Body *body;		//weak ref
#endif
}
@property (readwrite) CGPoint virtualPosition;
@property (readwrite) CGPoint ratio;
@property (readwrite) CGPoint offset;
@property (readwrite) bool isLHSprite;
@property (readwrite) CGPoint initialPosition;
@property (readwrite) CGPoint position;
@property (readwrite,assign) CCNode *ccsprite;
@property (readwrite,assign) b2Body *body;

+(id) pointWithCGPoint:(CGPoint)point;
-(id) initWithCGPoint:(CGPoint)point;
@end

@implementation LHParallaxPointObject
@synthesize virtualPosition;
@synthesize ratio;
@synthesize isLHSprite;
@synthesize initialPosition;
@synthesize offset;
@synthesize position;
@synthesize ccsprite;
@synthesize body;

-(void) dealloc{
	
	//NSLog(@"LH PARALLAX POINT OBJ DEALLOC");
#ifndef LH_ARC_ENABLED
	[super dealloc];
#endif
}
+(id) pointWithCGPoint:(CGPoint)_ratio{
#ifndef LH_ARC_ENABLED
	return [[[self alloc] initWithCGPoint:_ratio] autorelease];
#else
    return [[self alloc] initWithCGPoint:_ratio];
#endif
}
-(id) initWithCGPoint:(CGPoint)_ratio{
	if( (self=[super init])) {
		ratio = _ratio;
	}
	return self;
}
@end

////////////////////////////////////////////////////////////////////////////////
@interface LHParallaxNode (Private)

@end

@implementation LHParallaxNode

@synthesize isContinuous;
@synthesize direction;
@synthesize speed;
@synthesize paused;

-(void) dealloc{	
	
    for(LHParallaxPointObject* pt in sprites){
        if(pt.ccsprite){
            if([pt.ccsprite isKindOfClass:[LHSprite class]])
                [(LHSprite*)pt.ccsprite setSpriteIsInParallax:nil];            
            if(removeSpritesOnDelete)
            {
                if(NULL != lhLoader)
                {
                    [lhLoader removeSprite:(LHSprite*)pt.ccsprite];
                }
            }

        }
	}
    
	//NSLog(@"LHParallaxNode DEALLOC");
#ifndef LH_ARC_ENABLED
    [uniqueName release];
	[sprites release];
	[super dealloc];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithDictionary:(NSDictionary*)parallaxDict loader:(LevelHelperLoader*)loader;
{
	if( (self=[super init])) {

		//sprites = [[NSMutableArray alloc] init];
        sprites = [[CCArray alloc] init];
		isContinuous = [[parallaxDict objectForKey:@"ContinuousScrolling"] boolValue];
		direction = [[parallaxDict objectForKey:@"Direction"] intValue];
		speed = [[parallaxDict objectForKey:@"Speed"] floatValue];
		lastPosition = CGPointMake(-100,-100);
        paused = false;
		winSize = [[CCDirector sharedDirector] winSize];
		screenNumberOnTheRight = 1;
		screenNumberOnTheLeft = 0;
		screenNumberOnTheTop = 0;
        
        movedEndListenerObj = nil;
        movedEndListenerSEL = nil;
        
        removeSpritesOnDelete = false;
        
        lhLoader = loader;
        
        uniqueName  = [[NSString alloc] initWithString:[parallaxDict objectForKey:@"UniqueName"]];
		if(!isContinuous)
			speed = 1.0f;
	}
	return self;
}
////////////////////////////////////////////////////////////////////////////////
+(id) nodeWithDictionary:(NSDictionary*)properties loader:(LevelHelperLoader*)loader
{
#ifndef LH_ARC_ENABLED
	return [[[self alloc] initWithDictionary:properties loader:loader] autorelease];
#else
    return [[self alloc] initWithDictionary:properties loader:loader];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(LHParallaxPointObject *) createParallaxPointObjectWithNode:(CCNode*)node
                                                       ratio:(CGPoint)ratio{
    NSAssert( node != NULL, @"Argument must be non-nil");
	
	LHParallaxPointObject *obj = [LHParallaxPointObject pointWithCGPoint:ratio];
	obj.ccsprite = node;
	obj.body = NULL;
	obj.position = [node position];
    obj.virtualPosition = obj.ccsprite.position;
	obj.offset = [node position];
	obj.initialPosition = [node position];
	[sprites addObject:obj];
	//[sprite setSpriteIsInParallax:self];
	
	int scrRight = (int)(obj.initialPosition.x/winSize.width);
	
	if(screenNumberOnTheRight <= scrRight)
		screenNumberOnTheRight = scrRight+1;
    
	int scrLeft = (int)(obj.initialPosition.x/winSize.width);
    
	if(screenNumberOnTheLeft >= scrLeft)
		screenNumberOnTheLeft = scrLeft-1;
    
    
	int scrTop = (int)(obj.initialPosition.y/winSize.height);
	
	if(screenNumberOnTheTop <= scrTop)
		screenNumberOnTheTop = scrTop + 1;
	
	int scrBottom = (int)(obj.initialPosition.y/winSize.height);
    
	if(screenNumberOnTheBottom >= scrBottom)
		screenNumberOnTheBottom = scrBottom-1;
    
    return obj;
}
////////////////////////////////////////////////////////////////////////////////
-(void) addSprite:(LHSprite*)sprite 
   parallaxRatio:(CGPoint)ratio
{
    NSAssert( sprite != NULL, @"Argument must be non-nil");
    LHParallaxPointObject *obj = [self createParallaxPointObjectWithNode:sprite 
                                                                   ratio:ratio];
    
	obj.body = [sprite body];
    obj.isLHSprite = true;
	[sprite setSpriteIsInParallax:self];
}
////////////////////////////////////////////////////////////////////////////////
-(void) addNode:(CCNode*)node parallaxRatio:(CGPoint)ratio{
    [self createParallaxPointObjectWithNode:node ratio:ratio];
}
////////////////////////////////////////////////////////////////////////////////
-(void) removeChild:(LHSprite*)sprite{
    
    if(nil == sprite) 
        return;
        
    for(int i = 0; i < (int)[sprites count]; ++i)
    {        
        LHParallaxPointObject* pt = [sprites objectAtIndex:i];
	
        if(pt.ccsprite == sprite)
        {
			[sprites removeObjectAtIndex:i];
            break;
        }
	}
    
    if([sprites count] == 0){
        if(lhLoader)[lhLoader removeParallaxNode:self];                     
    }
}
////////////////////////////////////////////////////////////////////////////////
-(void) registerSpriteHasMovedToEndListener:(id)object selector:(SEL)method{
    movedEndListenerObj = object;
    movedEndListenerSEL = method;
}
////////////////////////////////////////////////////////////////////////////////
-(NSString*)uniqueName{
    return uniqueName;
}
////////////////////////////////////////////////////////////////////////////////
-(void) followSprite:(LHSprite*)sprite 
   changePositionOnX:(bool)xChange 
   changePositionOnY:(bool)yChange{
    
    if(NULL == sprite)
    {
        if(NULL != followedSprite)
            [followedSprite setParallaxFollowingThisSprite:NULL];
    }
    
    followedSprite = sprite;
    
    followChangeX = xChange;
    followChangeY = yChange;
    
    if(NULL != sprite)
    {
        lastFollowedSpritePosition = [sprite position];
        [sprite setParallaxFollowingThisSprite:self];
    }
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*)spritesInNode{
	
#ifndef LH_ARC_ENABLED
	NSMutableArray* sprs = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* sprs = [[NSMutableArray alloc] init];
#endif
	for(LHParallaxPointObject* pt in sprites){
		if(pt.ccsprite != nil)
			[sprs addObject:pt.ccsprite];
	}
	
	return sprs;
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*)bodiesInNode
{
#ifndef LH_ARC_ENABLED
	NSMutableArray* sprs = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* sprs = [[NSMutableArray alloc] init];
#endif
        
	for(LHParallaxPointObject* pt in sprites){
		if(0 != pt.body)
			[sprs addObject:[NSValue valueWithPointer:pt.body]];
	}	
			 
	return sprs;
}
////////////////////////////////////////////////////////////////////////////////
-(bool)shouldTransformPoint:(LHParallaxPointObject*)point
{
    if(!point.ccsprite) return false;
    
    //lets move the sprite only if it enters in view - else just leave it there
    CGSize spriteContentSize = [point.ccsprite contentSize];
    
    switch (direction) {
        case 1: //right to left
            if(point.virtualPosition.x - spriteContentSize.width < winSize.width + spriteContentSize.width)    
                return true;
            break;
            
        case 0: //left to right
            if(point.virtualPosition.x + spriteContentSize.width > -spriteContentSize.width)    
                return true;
            break;
            
        case 2://up to bottom
			if(point.virtualPosition.y - spriteContentSize.height < winSize.height + spriteContentSize.height)
                return true;
            break;
        case 3://bottom to top
            if(point.virtualPosition.y + spriteContentSize.height > -spriteContentSize.height)
                return true;
            break;
    }
    return false;
}

-(void) setPosition:(CGPoint)pos 
            onPoint:(LHParallaxPointObject*)point 
             offset:(CGPoint)offset
{
    if(!isContinuous)
    {
        if(point.ccsprite != nil){
            point.ccsprite.position = pos;
        
            if(point.body != NULL){
            
                float angle = [point.ccsprite rotation];
                point.body->SetAwake(TRUE);
                
                point.body->SetTransform(b2Vec2(pos.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                                pos.y/[[LHSettings sharedInstance] lhPtmRatio]), 
                                         CC_DEGREES_TO_RADIANS(-angle));
            }
        }
    }
    else
    {

        if(point.ccsprite != nil){
            
            bool shouldTransformBody = [self shouldTransformPoint:point];
                       
            CGPoint newPos = CGPointMake(point.virtualPosition.x - offset.x,
                                         point.virtualPosition.y - offset.y);
            
            if(point.isLHSprite)
            {
                if([(LHSprite*)point.ccsprite pathNode] != nil)
                {
                    shouldTransformBody = true;
                    newPos = CGPointMake(point.ccsprite.position.x - offset.x,
                                         point.ccsprite.position.y - offset.y);

                }
            }
            
            if(shouldTransformBody)
            {                                
                [point.ccsprite setPosition:newPos];
                
                if(point.body != NULL){
            
                    float angle = [point.ccsprite rotation];
                    point.body->SetTransform(b2Vec2(newPos.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                                    newPos.y/[[LHSettings sharedInstance] lhPtmRatio]), 
                                             CC_DEGREES_TO_RADIANS(-angle));
                }
            }
            
            point.virtualPosition = newPos;
        }
    }
}
////////////////////////////////////////////////////////////////////////////////
-(CGSize) getBounds:(float)rw height:(float)rh angle:(float)radians
{
    float x1 = -rw/2;
    float x2 = rw/2;
    float x3 = rw/2;
    float x4 = -rw/2;
    float y1 = rh/2;
    float y2 = rh/2;
    float y3 = -rh/2;
    float y4 = -rh/2;
    
    float x11 = x1 * cos(radians) + y1 * sin(radians);
    float y11 = -x1 * sin(radians) + y1 * cos(radians);
    float x21 = x2 * cos(radians) + y2 * sin(radians);
    float y21 = -x2 * sin(radians) + y2 * cos(radians);
    float x31 = x3 * cos(radians) + y3 * sin(radians);
    float y31 = -x3 * sin(radians) + y3 * cos(radians);
    float x41 = x4 * cos(radians) + y4 * sin(radians);
    float y41 = -x4 * sin(radians) + y4 * cos(radians);

    float x_min = MIN(MIN(x11,x21),MIN(x31,x41));
    float x_max = MAX(MAX(x11,x21),MAX(x31,x41));
    
    float y_min = MIN(MIN(y11,y21),MIN(y31,y41));
    float y_max = MAX(MAX(y11,y21),MAX(y31,y41));
 
    return CGSizeMake(x_max-x_min, y_max-y_min);
}
////////////////////////////////////////////////////////////////////////////////
-(void)repositionPoint:(LHParallaxPointObject*)point
{
    if(![self shouldTransformPoint:point])
        return;
        
    CGSize spriteContentSize = [point.ccsprite contentSize];
    
    float angle = [point.ccsprite rotation];
    float rotation = CC_DEGREES_TO_RADIANS(angle);
	float scaleX = [point.ccsprite scaleX];
	float scaleY = [point.ccsprite scaleY];
    
    CGSize contentSize = [self getBounds:spriteContentSize.width 
                                  height:spriteContentSize.height 
                                   angle:rotation];
        
	switch (direction) {
		case 1: //right to left
		{
			if(point.virtualPosition.x + contentSize.width/2.0f*scaleX <= 0)
			{
				float difX = point.virtualPosition.x + contentSize.width/2.0f*scaleX;
		
				[point setOffset:ccp(winSize.width*screenNumberOnTheRight - point.ratio.x*speed -  contentSize.width/2.0f*scaleX + difX, point.offset.y)];
	
                if(nil != point.ccsprite){
                    CGPoint newPos = CGPointMake(point.offset.x, point.virtualPosition.y);
    
                    [point.ccsprite setPosition:newPos];
                    point.virtualPosition = newPos;
                    //[point.ccsprite setVisible:NO];
                    
                    if(point.body != NULL){
                    
                        float angle = [point.ccsprite rotation];
                        point.body->SetTransform(b2Vec2(newPos.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                                        newPos.y/[[LHSettings sharedInstance] lhPtmRatio]), 
                                                 CC_DEGREES_TO_RADIANS(-angle));
                    }
                }
                    
                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                    #pragma clang diagnostic pop
                }
			}
		}	
			break;
			
		case 0://left to right
		{
			if(point.virtualPosition.x - contentSize.width/2.0f*scaleX >= winSize.width)
			{
				float difX = point.virtualPosition.x - contentSize.width/2.0f*scaleX - winSize.width;
				
				[point setOffset:ccp(winSize.width*screenNumberOnTheLeft + point.ratio.x*speed +  contentSize.width/2.0f*scaleX + difX, point.offset.y)];
                
                
                
                if(nil != point.ccsprite){
                    CGPoint newPos = CGPointMake(point.offset.x, point.virtualPosition.y);
                    [point.ccsprite setPosition:newPos];
                    point.virtualPosition = newPos;
                    //[point.ccsprite setVisible:NO];
                    
                    if(point.body != NULL){
                        
                        float angle = [point.ccsprite rotation];
                        point.body->SetTransform(b2Vec2(newPos.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                                        newPos.y/[[LHSettings sharedInstance] lhPtmRatio]), 
                                                 CC_DEGREES_TO_RADIANS(-angle));
                    }
                }

                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                     #pragma clang diagnostic pop
                }
			}
		}
			break;
			
		case 2://up to bottom
		{
            float virtualX = point.virtualPosition.x;
            float virtualY = point.virtualPosition.y;
            
//            if([(LHSprite*)point.ccsprite pathNode])
//            {
//                NSLog(@"FOUND PATH NODE %@", [point.ccsprite uniqueName]);
//                virtualX = point.ccsprite.position.x;
//                virtualY = point.ccsprite.position.y; 
//            }
                
			if(virtualY + contentSize.height/2.0f*scaleY <= 0)
			{
//                NSLog(@"UP TO BOTTOM set transform");
                
				float difY = virtualY + contentSize.height/2.0f*scaleY;
				
				[point setOffset:ccp(point.offset.x, winSize.height*screenNumberOnTheTop - point.ratio.y*speed - contentSize.height/2.0f*scaleY + difY)];
                
                
                if(nil != point.ccsprite){
                    CGPoint newPos = CGPointMake(virtualX, point.offset.y);
                    [point.ccsprite setPosition:newPos];
                    //[point.ccsprite setVisible:NO];
                    point.virtualPosition = newPos;
                    if(point.body != NULL){
                        

                        float angle = [point.ccsprite rotation];
                        point.body->SetTransform(b2Vec2(newPos.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                                        newPos.y/[[LHSettings sharedInstance] lhPtmRatio]), 
                                                 CC_DEGREES_TO_RADIANS(-angle));
                    }
                }
                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                    #pragma clang diagnostic pop
                }
			}
		}
			break;
			
		case 3://bottom to top
		{
			if(point.virtualPosition.y - contentSize.height/2.0f*scaleY >= winSize.height)
			{
				float difY = point.virtualPosition.y - contentSize.height/2.0f*scaleY - winSize.height;
				
				[point setOffset:ccp(point.offset.x, winSize.height*screenNumberOnTheBottom + point.ratio.y*speed + contentSize.height/2.0f*scaleY + difY)];
                
                if(nil != point.ccsprite){
                    CGPoint newPos = CGPointMake(point.virtualPosition.x, point.offset.y);
                    [point.ccsprite setPosition:newPos];
                    point.virtualPosition = newPos;
                    //[point.ccsprite setVisible:NO];
                    
                    if(point.body != NULL){
                        
                        float angle = [point.ccsprite rotation];
                        point.body->SetTransform(b2Vec2(newPos.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                                        newPos.y/[[LHSettings sharedInstance] lhPtmRatio]), 
                                                 CC_DEGREES_TO_RADIANS(-angle));
                    }
                }
                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                    #pragma clang diagnostic pop
                }
			}
		}
			break;
		default:
			break;
	}
}
////////////////////////////////////////////////////////////////////////////////
-(void)visit
{
    if([[LHSettings sharedInstance] levelPaused]) //level is paused
        return;
    
    if(paused) //this parallax is paused
        return;
    
    if(NULL != followedSprite)
    {
        CGPoint spritePos = [followedSprite position];
        float deltaFX = lastFollowedSpritePosition.x - spritePos.x;
        float deltaFY = lastFollowedSpritePosition.y - spritePos.y;
        lastFollowedSpritePosition = spritePos;
        
        CGPoint lastNodePosition = [self position];        
        if(followChangeX && !followChangeY){
            [super setPosition:ccp(lastNodePosition.x + deltaFX, 
                                   lastNodePosition.y)];
        }
        else if(!followChangeX && followChangeY){
            [super setPosition:ccp(lastNodePosition.x, 
                                   lastNodePosition.y + deltaFY)];
        }
        else if(followChangeX && followChangeY){
            [super setPosition:ccp(lastNodePosition.x + deltaFX, 
                                   lastNodePosition.y + deltaFY)];
        }
    }
    
    int i = -1; //direction left to right //bottom to up
	CGPoint pos = [self position];
	if(isContinuous || ! CGPointEqualToPoint(pos, lastPosition)) 
	{
            
		for(LHParallaxPointObject *point in sprites){
            i = -1; //direction left to right //bottom to up
            if(direction == 1 || direction == 2) //right to left //up to bottom
                i = 1;

			[self setPosition:CGPointMake(pos.x * point.ratio.x + point.offset.x, 
                                          pos.y * point.ratio.y + point.offset.y)
                      onPoint:point offset:CGPointMake(i*point.ratio.x*speed, i*point.ratio.y*speed)];	
			
			if(isContinuous)
			{
				[self repositionPoint:point];
			
				[point setOffset:ccp(point.offset.x + i*point.ratio.x*speed, 
									 point.offset.y + i*point.ratio.y*speed)];

			}
		}
		lastPosition = pos;
	}
	//[super visit];
}
				   
@end
