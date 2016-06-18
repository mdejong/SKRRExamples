//
//  GameScene.m
//  SpriteKitFireAnimation
//
//  Created by Mo DeJong on 4/1/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (nonatomic, retain) SKSpriteNode *background;

@property (nonatomic, retain) SKSpriteNode *pedestal;


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
  
  pedestal.xScale = 0.8;
  pedestal.yScale = 0.8;
  
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
        CGPoint location = CGPointMake(1068, 425);
      
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"FireVector"];
        
        sprite.xScale = 0.8;
        sprite.yScale = 0.8;
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
