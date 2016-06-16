//
//  GameScene.m
//  WhackAMoleHD
//
//  Created by Mo DeJong on 5/31/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameScene.h"

@import RenderReduce;

@interface GameScene ()

@property (nonatomic, retain) SKSpriteNode *backgroundNode;

@property (nonatomic, retain) SKNode *hole1;
@property (nonatomic, retain) SKNode *hole2;
@property (nonatomic, retain) SKNode *hole3;

@property (nonatomic, assign) int frameOffset;

// Lookup the Mole node given an integer id

@property (nonatomic, retain) NSMutableDictionary *moleTable;

// Total number of moles thumped

@property (nonatomic, assign) int molesThumped;

// You Win Label

@property (nonatomic, retain) SKLabelNode *youWinLabel;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
  NSString *filename = @"forest_2048_1536_65536_fs.png";
  
  NSDictionary *options = @{
                            // With no compression, about 20.1 Megs of memory.
                            //@"render": @"default",
                            
                            // With render reduce about 13.5 Megs of memory (saves about 7 Megs)
                            @"render": @"reduce",
                            
                            @"filename": filename,
#if defined(DEBUG)
                            // Validation and dumping of intermediate files really slows both
                            // the encodeTexture and makeSpriteNode calls and should not be
                            // enabled for an optimized build. With validation the encode and
                            // validation takes about 5 seconds. Without validation the encode
                            // and render takes about 1 second.
                            @"validate": @"original",
                            @"dumpIntermediate": @(TRUE),
#endif // DEBUG
                            };
  
  NSMutableDictionary *results = [NSMutableDictionary dictionary];
  
  // Recompress texture during app startup. If there are many textures and a long startup
  // delay then this would be better done in AppDelegate init logic, but this is fine here.
  
  RRTexture *texture = [RRTexture encodeTexture:options results:results];
  
  SKSpriteNode *background = [RRNode makeSpriteNode:view texture:texture];
  
  if (background) {
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    NSLog(@"background.size : %d %d", (int)background.size.width, (int)background.size.height);
    NSLog(@"background.position : %d %d", (int)background.position.x, (int)background.position.y);
    
    NSLog(@"original   num bytes %8d : aka %8d kB", (int)round([results[@"originalNumBytes"] floatValue]), (int)round([results[@"originalNumBytes"] floatValue]/1000.0));
    NSLog(@"compressed num bytes %8d : aka %8d kB", (int)round([results[@"packedNumBytes"] floatValue]), (int)round([results[@"packedNumBytes"] floatValue]/1000.0));
    
    NSLog(@"compression ratio : %0.3f", [results[@"packedNumBytes"] floatValue] / [results[@"originalNumBytes"] floatValue]);
    
    background.zPosition = 0;
    
    [self addChild:background];
    
    self.backgroundNode = background;
    
    if (1) {
      NSLog(@"initial background size %d x %d", (int)background.size.width, (int)background.size.height);
    }
    
#if defined(DEBUG)
    // Print MSG in DEBUG mode so that user is not confused as to memory usage when DEBUG is enabled
    NSLog(@"compiled in DEBUG mode, build with optimizations enabled to see reduced memory usage at runtime");
#endif // DEBUG
  }
  
  // Create mole node on left side
  
  self.hole1 = [self makeMoleNode:view position:1];
  self.hole1.zPosition = 1;
  [self addChild:self.hole1];

  // Create mole node in upper middle
  
  self.hole2 = [self makeMoleNode:view position:2];
  self.hole2.zPosition = 1;
  [self addChild:self.hole2];
  
  // Create mole node on right
  
  self.hole3 = [self makeMoleNode:view position:3];
  self.hole3.zPosition = 1;
  [self addChild:self.hole3];

  [self resetThumped];
  
  return;
}

// Util method to create a mole node at positions (1, 2, 3)

- (SKNode*) makeMoleNode:(SKView*)view position:(int)position {
  
  // Load mole hole as a regular
  
  SKCropNode *node = [SKCropNode node];

  SKSpriteNode *nodeToMask = [SKSpriteNode spriteNodeWithImageNamed:@"MoleHole"];
  
  nodeToMask.size = CGSizeMake(
                                  nodeToMask.size.width / [UIScreen mainScreen].scale,
                                  nodeToMask.size.height / [UIScreen mainScreen].scale);
  
  SKSpriteNode *maskNode = [SKSpriteNode spriteNodeWithImageNamed:@"MoleHoleMask"];

  maskNode.size = CGSizeMake(
                               maskNode.size.width / [UIScreen mainScreen].scale,
                               maskNode.size.height / [UIScreen mainScreen].scale);

  SKSpriteNode *moleNode = [SKSpriteNode spriteNodeWithImageNamed:@"mole_1"];
  
  moleNode.size = CGSizeMake(
                             moleNode.size.width / [UIScreen mainScreen].scale,
                             moleNode.size.height / [UIScreen mainScreen].scale);
  
  moleNode.size = CGSizeMake(moleNode.size.width - 30, moleNode.size.height - 30);
  
  [node addChild:nodeToMask];
  
  nodeToMask.zPosition = 0;

  [node addChild:moleNode];
  
  if (self.moleTable == nil) {
    self.moleTable = [NSMutableDictionary dictionary];
  }
  self.moleTable[@(position)] = moleNode;
  
  moleNode.zPosition = 1;

  [node setMaskNode:maskNode];
  
  if (node) {
    CGPoint p;
    
    p = CGPointZero;

    int w10 = (self.frame.size.width / 10);
    int h10 = (self.frame.size.height / 10);
    
    if (position == 1) {
      p.x = w10 + w10 + (w10 / 2);
      p.y = h10;
    } else if (position == 2) {
      p.x = w10 + w10 + w10 + w10 + w10 + (w10 * 3 / 4);
      p.y = h10 + h10;
    } else {
      p.x = w10 + w10 + w10 + w10 + w10 + w10 + w10 + w10 - (w10 / 10);
      p.y = h10 - (h10 / 4);
    }
    
    node.position = p;
    
    if ((0)) {
      NSLog(@"node.position : %d %d", (int)node.position.x, (int)node.position.y);
    }
  }
  
  return node;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  assert(self.moleTable);
  
  if (self.molesThumped == -1) {
    //NSLog(@"self.molesThumped == -1");
    return;
  }
  
  SKNode *m1 = self.moleTable[@(1)];
  SKNode *m2 = self.moleTable[@(2)];
  SKNode *m3 = self.moleTable[@(3)];
  
  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    BOOL matched = FALSE;
    
    if (node == m1) {
      NSLog(@"m1");
      matched = TRUE;
    } else if (node == m2) {
      NSLog(@"m2");
      matched = TRUE;
    } else if (node == m3) {
      NSLog(@"m3");
      matched = TRUE;
    }
    
    if (matched) {
      NSLog(@"node.position %d %d", (int)node.position.x, (int)node.position.y);
      
      SKSpriteNode *spriteNode = (SKSpriteNode*) node;
      
      spriteNode.texture = [SKTexture textureWithImageNamed:@"mole_thump4"];
      
      SKAction *action = [SKAction moveByX:0.0 y:-100.0 duration:1.0];
      [node runAction:action];
      
      self.molesThumped += 1;
    }
  }
  
  if (self.molesThumped == 3) {
    {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.3 target:self selector:@selector(showYouWin) userInfo:nil repeats:FALSE];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    {
    NSTimer *timer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(resetThumped) userInfo:nil repeats:FALSE];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    self.molesThumped = -1;
  }
}

- (void) resetThumped
{
//  NSLog(@"resetThumped");
  
  self.molesThumped = 0;
  
  if (self.youWinLabel) {
    [self.youWinLabel removeFromParent];
  }
  
  SKSpriteNode *m1 = self.moleTable[@(1)];
  SKSpriteNode *m2 = self.moleTable[@(2)];
  SKSpriteNode *m3 = self.moleTable[@(3)];
  
  m1.position = CGPointZero;
  m2.position = CGPointZero;
  m3.position = CGPointZero;

  m1.texture = [SKTexture textureWithImageNamed:@"mole_1"];
  m2.texture = [SKTexture textureWithImageNamed:@"mole_1"];
  m3.texture = [SKTexture textureWithImageNamed:@"mole_1"];
  
  return;
}

- (void) showYouWin
{
//  NSLog(@"showYouWin");
  
  if (self.youWinLabel == nil) {
    self.youWinLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
  } else {
    [self.youWinLabel removeFromParent];
  }
  
  SKLabelNode *label = self.youWinLabel;
  
  label.text = @"You Win!";
  label.fontSize = 140;
  label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  
  label.zPosition = 2;
  
  [self addChild:label];
  
  return;
}

//-(void)update:(CFTimeInterval)currentTime {}

@end
