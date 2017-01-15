//
//  GameScene.swift
//  SKSwiftCompare
//
//  Created by Mo DeJong on 6/16/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

import SpriteKit
import RenderReduce;

class GameScene: SKScene {
  
  var originalNode: SKSpriteNode? = nil

  // Load a texture directly from TreeFog.png with no runtime reduction
  
  func makeCenteredOriginalLeftSide(_ view: SKView) {
    let filename = "TreeFog.png"
    
    let options: [String: String] = [
      "filename": filename,
      "render": "default",
      ]
    
    let results: NSMutableDictionary = NSMutableDictionary()
    
    // Recompress texture during app startup. If there are many textures and a long startup
    // delay then this would be better done in AppDelegate init logic, but this is fine here.
    
    let texture = RRTexture.encode(options, results:results)
    let originalNode = RRNode.makeSpriteNode(view, texture:texture)
    
    if (originalNode != nil) {
      originalNode?.position = CGPoint(x:0,y:0)
      
      let cropNode = SKCropNode()
      let originalSize = originalNode?.size
      let w2 = (originalSize?.width)!/2
      let maskNode = SKSpriteNode(color: UIColor.white, size: CGSize(width: w2, height: (originalSize?.height)!))
      maskNode.position = CGPoint(x:-w2/2,y:0)
      cropNode.maskNode = maskNode
      
      cropNode.addChild(originalNode!)
      self.addChild(cropNode)
      
      NSLog("background.size : %d %d", originalNode!.size.width, originalNode!.size.height)
    }
  }
  
  // Render reduced colorspace image created with imagemagick:
  //
  // convert TreeFog.png -colors 65536 -dither FloydSteinberg TreeFog_fs_65536.png
  
  func makeCenteredOriginalRightSide(_ view: SKView, filename: String) {
    #if DEBUG
      let options: [String: String] = [
        "filename": filename,
        "render": "reduce",
        // Validation really slows the encodeTexture and makeSpriteNode
        // calls and should not be enabled for an optimized build.
        // With validation the encode and validation takes about 5 seconds.
        // Without validation the encode and render takes about 1 second.
        "validate": "original",
        ]
    #else
      let options: [String: String] = [
        "filename": filename,
        "render": "reduce",
        ]
    #endif
    
    let results: NSMutableDictionary = NSMutableDictionary()
    
    // Recompress texture during app startup. If there are many textures and a long startup
    // delay then this would be better done in AppDelegate init logic, but this is fine here.
    
    let texture = RRTexture.encode(options, results:results)
    let originalNode = RRNode.makeSpriteNode(view, texture:texture)
    
    if (originalNode != nil) {
      originalNode?.position = CGPoint(x:0,y:0)
      
      let cropNode = SKCropNode()
      let originalSize = originalNode?.size
      let w2 = (originalSize?.width)!/2
      let maskNode = SKSpriteNode(color: UIColor.white, size: CGSize(width: w2, height: (originalSize?.height)!))
      maskNode.position = CGPoint(x:w2/2,y:0)
      cropNode.maskNode = maskNode
      
      cropNode.addChild(originalNode!)
      self.addChild(cropNode)
      
      NSLog("background.size : %d %d", originalNode!.size.width, originalNode!.size.height)
      
      let originalNumBytes: Int = results["originalNumBytes"] as! Int
      let packedNumBytes: Int = results["packedNumBytes"] as! Int
      
      NSLog("original   num bytes %8d : aka %8d kB", originalNumBytes, originalNumBytes/1000)
      NSLog("compressed num bytes %8d : aka %8d kB", packedNumBytes, packedNumBytes/1000)
      
      NSLog("compression ratio : %0.3f", Float(packedNumBytes) / Float(originalNumBytes))
      
      #if DEBUG
        NSLog("compiled in DEBUG mode, build with optimizations enabled to see reduced memory usage at runtime")
      #endif
    }
  }
  
  func makeCenterLine(_ view: SKView) {
    // Line behind the 2 images
    let lineNode = SKShapeNode()
    let pathToDraw = CGMutablePath()
    pathToDraw.move(to: CGPoint(x: 0.0, y: -500.0))
    pathToDraw.addLine(to: CGPoint(x: 0.0, y: 500))
    lineNode.position = CGPoint(x:0, y:0)
    lineNode.lineWidth = 2.0
    lineNode.strokeColor = SKColor.white
    lineNode.path = pathToDraw
    self.addChild(lineNode)
  }
  
  override func didMove(to view: SKView) {
    view.scene!.anchorPoint = CGPoint(x:0.5, y:0.5)
    
    makeCenterLine(view)
    
    makeCenteredOriginalLeftSide(view)
  
    // Limiting to 65536 save a lot of memory but does not cause noticable loss : comp ratio 0.440
    
    makeCenteredOriginalRightSide(view, filename:"TreeFog_fs_65536.png")
    
    // Limiting the image to 256 colors creates noticable banding : comp ratio 0.255
    
//    makeCenteredOriginalRightSide(view, filename:"TreeFog_256.png")
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
}
