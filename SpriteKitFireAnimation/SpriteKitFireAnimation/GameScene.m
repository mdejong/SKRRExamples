//
//  GameScene.m
//  SpriteKitFireAnimation
//
//  Created by Mo DeJong on 4/1/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//
//  This example demonstrates rendering an animation loop
//  using the default uncompressed texture loading path
//  as compared to the optimized path. When DISABLE_RENDER_REDUCE_FOR_FIRE
//  is defined the memory consumtion is 286 megs. When the
//  DISABLE_RENDER_REDUCE_FOR_FIRE symbol is commented out then the
//  optimized render path is enabled as the memory usage is only
//  130 megs. Note that the FPS is 60 FPS in either case.

#import "GameScene.h"

#define USE_RENDER_REDUCE

//#define DISABLE_RENDER_REDUCE_FOR_FIRE

#if defined(USE_RENDER_REDUCE)
@import RenderReduce;
#endif // USE_RENDER_REDUCE

@interface GameScene ()

@property (nonatomic, retain) SKSpriteNode *background;

@property (nonatomic, retain) SKSpriteNode *pedestal;

@property (nonatomic, retain) NSMutableArray *fireTextures;

@property (nonatomic, assign) int frameNum;

@property (nonatomic, retain) SKSpriteNode *fireSprite;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
  // Setup your scene here

  self.scaleMode = SKSceneScaleModeFill;
  
  // background
  
  SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
  background.position = CGPointMake(self.scene.size.width / 2, self.scene.size.height / 2);
  background.size = self.scene.size;
  
  background.zPosition = 0;
  
  [self addChild:background];
  self.background = background;
  
  // Insert node for Pedestal
  
  SKSpriteNode *pedestal = [SKSpriteNode spriteNodeWithImageNamed:@"Pedestal"];
  
  pedestal.position = CGPointMake((int)(self.scene.size.width / 2), (int)(self.scene.size.height * 1.0/3.5));
  
  pedestal.anchorPoint = CGPointMake(0.5, 0.95);
  
  pedestal.xScale = 0.8 / 2;
  pedestal.yScale = 0.8 / 2;
  
  pedestal.zPosition = 1;
  
//  SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//  [pedestal runAction:[SKAction repeatActionForever:action]];
  
  self.pedestal = pedestal;
  
  [self addChild:pedestal];
  
  NSLog(@"pedestal position %d,%d", (int)self.pedestal.position.x, (int)self.pedestal.position.y);
  
  // Kick off encode timer
  
  {
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(startEncode) userInfo:nil repeats:FALSE];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
  }
  
  return;
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

// timer invoked after startup to encode texture frames

- (void) startEncode
{
  if (self.fireTextures == nil) {
    self.fireTextures = [NSMutableArray array];
  }
  
//  const int maxNumFrames = 10;
  const int maxNumFrames = 60;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    for (int i=1; i <= maxNumFrames; i++) @autoreleasepool {
      NSString *filename = [NSString stringWithFormat:@"FireCroppedLoop%04d.png", i];
      RRTexture *texture = [self encodeTexture:filename];
      [self.fireTextures addObject:texture];
    }
    
    // Duplicate the textures going backwards to produce a more smooth loop
    
    for (int i=maxNumFrames-1; i > 0; i--) @autoreleasepool {
      RRTexture *texture = self.fireTextures[i];
      [self.fireTextures addObject:texture];
    }
    
    // Invoke method back in main thread once all texture encoding is finished.
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self doneEncodeInMainThread];
    });
  });
  
  return;
}

// timer invoked after startup to encode texture frames

- (void) doneEncodeInMainThread
{
  CGPoint location = CGPointMake(1068 / 2, 425 / 2);
  
  RRTexture *texture = self.fireTextures[0];
  
  SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:texture.pointSize];

  [RRNode updateSpriteNode:self.view texture:texture node:sprite];
  
//  sprite.xScale = 0.8 / 2;
//  sprite.yScale = 0.8 / 2;
  sprite.position = location;
  
  sprite.anchorPoint = CGPointMake(0.55, 0.035);
  
  sprite.zPosition = 2;
  
//  SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//  [sprite runAction:[SKAction repeatActionForever:action]];
  
  [self addChild:sprite];
  
  NSLog(@"animation position %d,%d", (int)sprite.position.x, (int)sprite.position.y);
  
  self.fireSprite = sprite;
  
  // Animation
  
  SKAction *action = [SKAction customActionWithDuration:1.0f/30.0f actionBlock:^(SKNode *node, CGFloat elapsedTime) {
    [self showNextFrame:nil];
  }];
  
  [self.fireSprite runAction:[SKAction repeatActionForever:action] withKey:@"animation"];
                      
  return;
}

- (void) showNextFrame:(NSTimer*)timer
{
  if (self.frameNum >= self.fireTextures.count) {
    self.frameNum = 0;
    
    // Stop loop at this point
    //[timer invalidate];
    //return;
  }
  
  RRTexture *texture = self.fireTextures[self.frameNum];
  
  [RRNode updateSpriteNode:self.view texture:texture node:self.fireSprite];

  self.frameNum = self.frameNum + 1;
  
  return;
}

// Encode a PNG as a ReduceRender texture

#if defined(USE_RENDER_REDUCE)

- (RRTexture*) encodeTexture:(NSString*)filename {
  // encode
  
  NSDictionary *options = @{
#if defined(DISABLE_RENDER_REDUCE_FOR_FIRE)
                            @"render": @"default",
#else
                            @"render": @"reduce",
#endif // DISABLE_RENDER_REDUCE_FOR_FIRE
                            @"filename": filename,
#if defined(DEBUG) && !defined(DISABLE_RENDER_REDUCE_FOR_FIRE)
                            // Validation and dumping of intermediate files really slows both
                            // the encodeTexture and makeSpriteNode calls and should not be
                            // enabled for an optimized build.
                            @"validate": @"original",
                            @"dumpIntermediate": @(TRUE),
#endif // DEBUG
                            };
  
  NSMutableDictionary *results = [NSMutableDictionary dictionary];
  
  RRTexture *texture = [RRTexture encodeTexture:options results:results];
  
  if (texture) {
    NSLog(@"original   num bytes %10d : aka %10d kB", [results[@"originalNumBytes"] intValue], (int)round([results[@"originalNumBytes"] floatValue]/1000.0));
    NSLog(@"compressed num bytes %10d : aka %10d kB", [results[@"packedNumBytes"] intValue], (int)round([results[@"packedNumBytes"] floatValue]/1000.0));
    
    NSLog(@"compression ratio : %0.3f", [results[@"packedNumBytes"] floatValue] / [results[@"originalNumBytes"] floatValue]);
  }
  
  return texture;
}

#endif // USE_RENDER_REDUCE

@end
