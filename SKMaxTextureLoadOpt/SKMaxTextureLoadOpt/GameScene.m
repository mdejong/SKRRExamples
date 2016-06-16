//
//  GameScene.m
//  SKMaxTextureLoadOpt
//
//  Created by Mo DeJong on 5/27/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameScene.h"

@import RenderReduce;

@interface GameScene ()

@property (nonatomic, retain) SKSpriteNode *backgroundNode;

@property (nonatomic, assign) CGSize backgroundSize;

@property (nonatomic, assign) int frameOffset;

@end

@implementation GameScene

// iPad memory use with largest possible texture.
// Note that dynamic resize is done in hardware so this
// animation has minimal CPU impact.
//
// With 4096x4096 grayscale sources : 68 megs
//
// Using compressed impl            : 17.5 Megs

-(void)didMoveToView:(SKView *)view {
  self.scene.backgroundColor = [UIColor redColor];
  
  NSString *filename = @"SmileyFace8bitGray_4096.png";
  
  NSDictionary *options = @{
                            @"render": @"reduce",
                            @"filename": filename,
#if defined(DEBUG)
                            // Validation and dumping of intermediate files really slows both
                            // the encodeTexture and makeSpriteNode calls and should not be
                            // enabled for an optimized build.
                            
                            @"validate": @"original",
                            @"dumpIntermediate": @(TRUE),
#endif // DEBUG
                            };
  
  NSMutableDictionary *results = [NSMutableDictionary dictionary];
  
  RRTexture *texture = [RRTexture encodeTexture:options results:results];
  
  SKSpriteNode *background = [RRNode makeSpriteNode:view texture:texture];
  
  if (background) {
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    NSLog(@"background.size : %d %d", (int)background.size.width, (int)background.size.height);
    NSLog(@"background.position : %d %d", (int)background.position.x, (int)background.position.y);
    
    NSLog(@"original   num bytes %@ : aka %d kB", results[@"originalNumBytes"], (int)round([results[@"originalNumBytes"] floatValue]/1000.0));
    NSLog(@"compressed num bytes %@ : aka %d kB", results[@"packedNumBytes"], (int)round([results[@"packedNumBytes"] floatValue]/1000.0));
    
    NSLog(@"compression ratio : %0.3f", [results[@"packedNumBytes"] floatValue] / [results[@"originalNumBytes"] floatValue]);
    
    [self addChild:background];
    
    self.backgroundNode = background;
    self.backgroundSize = background.size;
    
    if (1) {
      NSLog(@"initial background size %d x %d", (int)self.backgroundSize.width, (int)self.backgroundSize.height);
    }
    
#if defined(DEBUG)
    // Print MSG in DEBUG mode so that user is not confused as to memory usage when DEBUG is enabled
    NSLog(@"compiled in DEBUG mode, build with optimizations enabled to see reduced memory usage at runtime");
#endif // DEBUG
  }
  
  return;
}

-(void)update:(CFTimeInterval)currentTime {
  const BOOL dumpBackgroundSize = FALSE;
  
  const int speedStep = 4;
  
  // Set this to 1 to disable the animation on each render
  if ((0)) {
    return;
  }
  
  self.frameOffset = self.frameOffset + 1;
  SKSpriteNode *backgroundNode = self.backgroundNode;
  int over = self.frameOffset % 300;
  over *= (speedStep * speedStep);
  
  backgroundNode.size = CGSizeMake(self.backgroundSize.width - over, self.backgroundSize.height - over);
  
  if (backgroundNode.size.width < 10 || backgroundNode.size.height < 10) {
    self.frameOffset = 0;
    backgroundNode.size = self.backgroundSize;
  }
  
  if (dumpBackgroundSize) {
    NSLog(@"resize background to %d x %d", (int)backgroundNode.size.width, (int)backgroundNode.size.height);
  }
  
  return;
}

@end
