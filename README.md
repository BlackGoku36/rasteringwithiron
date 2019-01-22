# rasteringwithiron
Basic rasterizer written in Haxe with help of Iron Framework for learning purpose.

# Features
* PBR(need fixing).
* Cel-Shade(little joke, need to do more).

# To-Do
* Fully implement Old-School rendering model.
* Improve Cel-shading.
* Add Zui to control.
* Try using different PBR diffuse model.

# Movements
* WASD to move around.
* Q to go strafe and E to strafe up.
* Mouse click to lock mouse.
* Escape to unlock mouse.

#Models
There are bunch of models to test with, Change this line ``data_ref:"Barel.arm/barel"`` where `Barel.arm` is arm file that has model and `barel` is model name, in Scene .json file, model are listed below, you can add your own!(Note: Make sure your model is uv-unwarped or else it will not show texture, but this isn't case in shader without texture).
* `Suzanne.arm/Suzanne`(Suzanne)(Warning: No UV in this one).
* `SBunny.arm/bunny`(Standford Rabbit).
* `Teapot.arm/teapot`(Utah Teapot).
* `SSphere.arm/Sphere`(Smooth Sphere).
* `Icosphere.arm/Icosphere`(Flat Icosphere).
* `Cube.arm/Cube`(Box/Cube).

Feel free to open Issue and Make PR.

#Scene
There are 3 Scene.
* `ScenePBR`- PBR with textures.
* `ScenePBRCol`- PBR with materials (without textures).
* `SceneToon`- Toon Shading.