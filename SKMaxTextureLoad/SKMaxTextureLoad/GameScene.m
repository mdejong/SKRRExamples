//
//  GameScene.m
//  SKMaxTextureLoad
//
//  Created by Mo DeJong on 4/22/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameScene.h"

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

-(void)didMoveToView:(SKView *)view {
  self.scene.backgroundColor = [UIColor redColor];
  
  NSString *filename = @"SmileyFace8bitGray_4096.png";
  
  // On retina iPad create Node as 2048 x 2048 points
  int scale = (int) [UIScreen mainScreen].scale;
  CGSize nodeSizeInPoints = CGSizeMake(4096 / scale, 4096 / scale);

  SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:nodeSizeInPoints];
  
  background.texture = [SKTexture textureWithImageNamed:filename];
  
  [self addChild:background];
  
  background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  
  self.backgroundNode = background;
  self.backgroundSize = background.size;
  
  if (1) {
    NSLog(@"initial background size %d x %d", (int)self.backgroundSize.width, (int)self.backgroundSize.height);
  }
  
  return;
}

-(void)update:(CFTimeInterval)currentTime {
  const BOOL dumpBackgroundSize = TRUE;
  
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
