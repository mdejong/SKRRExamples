//
//  RRNode.h
//
//  Copyright (c) 2016 HelpURock. All rights reserved.
//
//  This module implements rendering logic for sprite kit that
//  reduces rendering memory requirements. The functions here
//  accept a texture object created in the RRTexture module.

@import SpriteKit;
@import ImageIO;
@import MobileCoreServices;

@class RRTexture;

@interface RRNode : NSObject

// The makeSpriteNode API creates a SKSpriteNode that joins
// a render node to the compressed texture representation.

+ (SKSpriteNode*) makeSpriteNode:(SKView*)skView
                         texture:(RRTexture*)texture;

// Update the texture and shader objects associated with a Node.
// This method will update the texture and the shader and possibly
// rerun node validation logic.

+ (BOOL) updateSpriteNode:(SKView*)skView
                  texture:(RRTexture*)texture
                     node:(SKSpriteNode*)node;

@end
