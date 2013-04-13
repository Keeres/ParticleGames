//
//  CCRenderTexutrePlus.m
//  GeoQuest
//
//  Created by Kelvin on 2/21/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CCRenderTexturePlus.h"

@implementation CCRenderTexturePlus

@synthesize boundaryRect;

+(id)renderTextureWithWidth:(int)w height:(int)h pixelFormat:(CCTexture2DPixelFormat) format depthStencilFormat:(GLuint)depthStencilFormat
{
    return [[[self alloc] initWithWidth:w height:h pixelFormat:format depthStencilFormat:depthStencilFormat] autorelease];
}

// issue #994
+(id)renderTextureWithWidth:(int)w height:(int)h pixelFormat:(CCTexture2DPixelFormat) format
{
	return [[[self alloc] initWithWidth:w height:h pixelFormat:format] autorelease];
}

+(id)renderTextureWithWidth:(int)w height:(int)h
{
	return [[[self alloc] initWithWidth:w height:h pixelFormat:kCCTexture2DPixelFormat_RGBA8888 depthStencilFormat:0] autorelease];
}

-(id) init {
    if ((self = [super init])) {
        
    }
    return self;
}

-(id)initWithWidth:(int)w height:(int)h pixelFormat:(CCTexture2DPixelFormat) format depthStencilFormat:(GLuint)depthStencilFormat {
    if ((self = [super initWithWidth:w height:h pixelFormat:format depthStencilFormat:depthStencilFormat])) {
        boundaryRect = CGRectMake(self.position.x - w/2, self.position.y - h/2, w, h);
    }
    return self;
}

-(void) updateBoundaryRect {
    boundaryRect = CGRectMake(self.position.x - boundaryRect.size.width/2, self.position.y - boundaryRect.size.height/2, boundaryRect.size.width, boundaryRect.size.height);
}

@end
