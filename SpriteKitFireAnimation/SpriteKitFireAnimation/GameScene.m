//
//  GameScene.m
//  SpriteKitFireAnimation
//
//  Created by Mo DeJong on 4/1/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameScene.h"

//#define USE_RENDER_REDUCE

#if defined(USE_RENDER_REDUCE)
@import RenderReduce;
#endif // USE_RENDER_REDUCE

@interface GameScene ()

@property (nonatomic, retain) SKSpriteNode *background;

@property (nonatomic, retain) SKSpriteNode *pedestal;


@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
  // Setup your scene here

  self.scaleMode = SKSceneScaleModeFill;
  
  // background
  
#if defined(USE_RENDER_REDUCE)
  NSDictionary *options = @{
                            @"render": @"reduce",
                            @"filename": @"Background",
                            
                            // When the original does not exactly match the dimensions
                            // of an output node the use CoreGraphics to resize
                            @"textureSizePoints": [NSValue valueWithCGSize:self.scene.size],
                            
                            // Note that validation is not possible when original input is explicitly
                            // resized by passing a "textureSizePoints"
                            
//#if defined(DEBUG)
//                            // Validation and dumping of intermediate files really slows both
//                            // the encodeTexture and makeSpriteNode calls and should not be
//                            // enabled for an optimized build.
//                            @"validate": @"original",
//                            @"dumpIntermediate": @(TRUE),
//#endif // DEBUG
                            };
  
  NSMutableDictionary *results = [NSMutableDictionary dictionary];
  
  RRTexture *texture = [RRTexture encodeTexture:options results:results];
  
  SKSpriteNode *background = [RRNode makeSpriteNode:view texture:texture];
  
  background.position = CGPointMake(self.scene.size.width / 2, self.scene.size.height / 2);
  
  assert(CGSizeEqualToSize(background.size, self.scene.size) == 1);
  
  if (background) {
    NSLog(@"background.position : %d %d", (int)background.position.x, (int)background.position.y);
    
    NSLog(@"background.size : %d %d", (int)background.size.width, (int)background.size.height);
    
    NSLog(@"original   num bytes %10d : aka %10d kB", [results[@"originalNumBytes"] intValue], (int)round([results[@"originalNumBytes"] floatValue]/1000.0));
    NSLog(@"compressed num bytes %10d : aka %10d kB", [results[@"packedNumBytes"] intValue], (int)round([results[@"packedNumBytes"] floatValue]/1000.0));
    
    NSLog(@"compression ratio : %0.3f", [results[@"packedNumBytes"] floatValue] / [results[@"originalNumBytes"] floatValue]);
  }
#else
  SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
  background.position = CGPointMake(self.scene.size.width / 2, self.scene.size.height / 2);
  background.size = self.scene.size;
#endif // USE_RENDER_REDUCE
  
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
}

// Print out where the anchor point of the pedestal is in terms of the screen
// location where the node is ?

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
  
//  NSLog(@"pedestal position %d,%d", (int)self.pedestal.position.x, (int)self.pedestal.position.y);
//  NSLog(@"est pedestal anchor position %d,%d", (int)(self.pedestal.position.x + self.pedestal.size.width * self.pedestal.anchorPoint.x), (int)(self.pedestal.position.y + self.pedestal.size.height * self.pedestal.anchorPoint.y));
  
    for (UITouch *touch in touches) {
        //CGPoint location = [touch locationInNode:self];
        CGPoint location = CGPointMake(1068 / 2, 425 / 2);
      
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"FireVector"];
        
        sprite.xScale = 0.8 / 2;
        sprite.yScale = 0.8 / 2;
        sprite.position = location;
      
        sprite.anchorPoint = CGPointMake(0.5, 0.0);
      
        sprite.zPosition = 2;
      
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        [sprite runAction:[SKAction repeatActionForever:action]];
      
        [self addChild:sprite];
      
  NSLog(@"click position %d,%d", (int)sprite.position.x, (int)sprite.position.y);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
