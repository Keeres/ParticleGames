//
//  CCRenderTexturePlus.h
//  GeoQuest
//
//  Created by Kelvin on 2/21/13.
//  Copyright (c) 2013 Particle Games LLC. All rights reserved.
//

#import "CCRenderTexture.h"

@interface CCRenderTexturePlus : CCRenderTexture {
    CGRect          boundaryRect;
}

@property (assign) CGRect boundaryRect;

/** initializes a RenderTexture object with width and height in Points and a pixel format( only RGB and RGBA formats are valid ) and depthStencil format*/
+(id)renderTextureWithWidth:(int)w height:(int)h pixelFormat:(CCTexture2DPixelFormat) format depthStencilFormat:(GLuint)depthStencilFormat;

/** creates a RenderTexture object with width and height in Points and a pixel format, only RGB and RGBA formats are valid */
+(id)renderTextureWithWidth:(int)w height:(int)h pixelFormat:(CCTexture2DPixelFormat) format;

/** creates a RenderTexture object with width and height in Points, pixel format is RGBA8888 */
+(id)renderTextureWithWidth:(int)w height:(int)h;

-(void) updateBoundaryRect;

@end
