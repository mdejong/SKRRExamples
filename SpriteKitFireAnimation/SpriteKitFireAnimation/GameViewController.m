//
//  GameViewController.m
//  SpriteKitFireAnimation
//
//  Created by Mo DeJong on 4/1/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@interface GameViewController ()

@property (nonatomic, retain) GameScene *gameScene;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
}

// This layout method will be invoked once the actual screen size is known.
// The SKScene can then be presented at the exact screen size.

- (void) viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  // Reconfigure the scene with the current dimensions
  
  SKView * skView = (SKView *)self.view;
  
  NSLog(@"self.view.frame (%d,%d) at %d x %d", (int)skView.frame.origin.x, (int)skView.frame.origin.y, (int)skView.frame.size.width, (int)skView.frame.size.height);
  
  GameScene *scene;
  
  if (self.gameScene == nil) {
    // Create and configure the scene once the exact screen size is known
    
    scene = [GameScene nodeWithFileNamed:@"GameScene"];
    
    self.gameScene = scene;
    
    CGRect bounds = skView.bounds;
    
    NSLog(@"skView.bounds (%d,%d) at %d x %d", (int)bounds.origin.x, (int)bounds.origin.y, (int)bounds.size.width, (int)bounds.size.height);
    
    scene.size = bounds.size;
    
    scene.scaleMode = SKSceneScaleModeFill; // default
    
    NSLog(@"skView presentScene at %d x %d", (int)scene.size.width, (int)scene.size.height);
    
    [skView presentScene:scene];
  } else {
    scene = self.gameScene;
    
    CGRect bounds = skView.bounds;
    
    NSLog(@"skView resize scene to %d x %d", (int)scene.size.width, (int)scene.size.height);
    
    scene.size = bounds.size;
  }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
