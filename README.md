# rasteringwithiron
Basic rasterizer written in Haxe with help of Iron Framework for learning purpose.

# Features
* PBR:
	* Cook-Torrance Model.
	* Diffuse Model: Lambertian.
	* Fresnel Equation: Schlick.
	* Microfacet Distribution: GGX.
	* Geometry Attenuation: GGX-Smith.
	* **To-Do**: IBL:
		* **To-Do**: Diffuse Irradiance.
		* **To-Do**: Specular Radiance.

* Cel-Shade(little joke, need to do more).
	* Steps based lighting.
	* **To-Do**: Outline.

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

# Models
There are bunch of models to test with, Change this line ``data_ref:"Barel.arm/barel"`` where `Barel.arm` is arm file that has model and `barel` is model name, in Scene .json file, model are listed below, you can add your own!(Note: Make sure your model is uv-unwarped or else it will not show texture, but this isn't case in shader without texture).
* `Suzanne.arm/Suzanne`(Suzanne)(Warning: No UV in this one).
* `SBunny.arm/bunny`(Standford Rabbit).
* `Teapot.arm/teapot`(Utah Teapot).
* `SSphere.arm/Sphere`(Smooth Sphere).
* `Icosphere.arm/Icosphere`(Flat Icosphere).
* `Cube.arm/Cube`(Box/Cube).

Feel free to open Issue and Make PR.

# Scene
There are 3 Scene:
* `ScenePBR`- PBR with textures.
* `ScenePBRCol`- PBR Material.
* `SceneToon`- Toon Shading.

# Showcase
PBR Texture:
![PBR with textures](https://blackgoku36.github.io/rasteringwithiron/Demo/Assets/PBRTexture.png)

PBR Material:
![PBR Material](https://blackgoku36.github.io/rasteringwithiron/Demo/Assets/PBRCol.png)

Toon Shading:
![Toon Shader](https://blackgoku36.github.io/rasteringwithiron/Demo/Assets/ToonShader.png)