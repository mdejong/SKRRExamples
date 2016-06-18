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
  
  func makeCenteredOriginalLeftSide(view: SKView) {
    let filename = "TreeFog.png"
    
    let options: [String: String] = [
      "filename": filename,
      "render": "default",
      ]
    
    let results: NSMutableDictionary = NSMutableDictionary()
    
    // Recompress texture during app startup. If there are many textures and a long startup
    // delay then this would be better done in AppDelegate init logic, but this is fine here.
    
    let texture = RRTexture.encodeTexture(options, results:results)
    let originalNode = RRNode.makeSpriteNode(view, texture:texture)
    
    if (originalNode != nil) {
      originalNode.position = CGPoint(x:0,y:0)
      view.scene!.anchorPoint = CGPoint(x:0.5, y:0.5)
      
      self.addChild(originalNode)
      
      NSLog("background.size : %d %d", originalNode.size.width, originalNode.size.height)
    }
  }
  
  // Render reduced colorspace image created with imagemagick:
  //
  // convert TreeFog.png -colors 65536 -dither FloydSteinberg TreeFog_fs_65536.png
  
  func makeCenteredOriginalRightSide(view: SKView) {
    let filename = "TreeFog_fs_65536.png"
    
    #if DEBUG
      let options: [String: String] = [
        "filename": filename,
        "render": "reduce",
        // Validation and dumping of intermediate files really slows both
        // the encodeTexture and makeSpriteNode calls and should not be
        // enabled for an optimized build. With validation the encode and
        // validation takes about 5 seconds. Without validation the encode
        // and render takes about 1 second.
        "validate": "original",
        "dumpIntermediate": "1",
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
    
    let texture = RRTexture.encodeTexture(options, results:results)
    let originalNode = RRNode.makeSpriteNode(view, texture:texture)
    
    if (originalNode != nil) {
      originalNode.position = CGPoint(x:0,y:0)
      view.scene!.anchorPoint = CGPoint(x:0.5, y:0.5)
      
      self.addChild(originalNode)
      
      NSLog("background.size : %d %d", originalNode.size.width, originalNode.size.height)
      
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
  
  override func didMoveToView(view: SKView) {
    //makeCenteredOriginalLeftSide(view)
    makeCenteredOriginalRightSide(view)
  }
  
  override func update(currentTime: CFTimeInterval) {
    // Called before each frame is rendered
  }
}
