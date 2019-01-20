# rasteringwithiron
Basic rasterizer written in Haxe with help of Iron Library for learning purpose.

# Features
* PBR.
* Cel-Shade(little joke, need to do more).

# To-Do
* Fully implement Old-School rendering model.
* Improve Cel-shading.
* Add Zui to control.
* Try using different PBR diffuse model.
* Move scene and material datas to their individual .json for "Keeping it tidy" reason.
* * Toon Scene works
* * PBRCol Scene doesn't works
* * PBR Scene doesn't works

# Movements
* WASD to move around.
* Q to go strafe and E to strafe up.
* Mouse click to lock mouse.
* Escape to unlock mouse.

#Models
There are bunch of models to test with, Change this line ``data_ref:"Barel.arm/barel"`` where `Barel.arm` is arm file that has model and `barel` is model name, model are listed below, you can add your own!(Note: Make sure your model is uv-unwarped or else it will not show texture, but this isn't case in shader without texture).
* `Suzanne.arm/Suzanne`(Suzanne)(Warning: No UV in this one)
* `SBunny.arm/bunny`(Standford Rabbit)
* `Teapot.arm/teapot`(Utah Teapot)
* `SSphere.arm/Sphere`(Smooth Sphere)
* `Icosphere.arm/Icosphere`(Flat Icosphere)
* `B.arm/Cube`(Box/Cube)
* `Barel.arm/barel`(Barel used in Armory's Playground)

Feel free to open Issue and Make PR.

## Demo
[PBR Demo](https://blackgoku36.github.io/rasteringwithiron/Demo/Assets/PBR.mp4)

[](Toon-ShadingBunny.JPG)


