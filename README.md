# SKRRExamples
SpriteKit Render Reduce Framework Examples

SKMaxTextureLoad/

Loads the largest possible texture into a SpriteKit node.

SKMaxTextureLoadOpt/

Loads the largest possible compressed texture using Render Reduce Framework.

WhackAMoleHD/

Simple Demo of loading a pixel perfect large background image.

SKSwiftCompare/

Side by side compare of colortable compressed images.

SpriteKitFireAnimation/

Example of 60 FPS fire animation.


These examples demonstrate a SpriteKit Framework that reduces runtime memory usage for textures rendered via a SKSpriteNode.

For non-photographic images, significant savings are often achieved by default.

For more complex photographic image, significant runtime memory saves are possible with the help of imagemagick.

% convert forest_2048_1536.png -colors 65536 -dither FloydSteinberg forest_2048_1536_65536_fs.png

To add Framework to new project.

Copy RenderReduce.framework and dummy.cpp into your project directory for an Objective-C or Swift project.

Note that the RenderReduce framework is only functional on 64bit iOS hardware. This covers A7 and newer processors.

