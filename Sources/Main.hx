package;

import kha.System;
import iron.system.Input;
import iron.math.Vec3;
import haxe.ds.Vector;
import iron.data.MaterialData.MaterialContext;
import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import iron.math.Vec4;
import kha.Image;

class Main {

	static var raw:TSceneFormat;

	public static var textureImg:Image = null;

	public static function main() {
		kha.System.start({title: "Empty", width: 1280, height: 720}, function(window:kha.Window) {
			App.init(ready);
		});
	}

	static function ready() {
		var path = new RenderPath();
		path.commands = function() {
			path.setTarget("");
			path.clearTarget(0xff6495ED, 1.0);
			path.drawMeshes("mesh");
		};
		RenderPath.setActive(path);

		raw = {
			name: "Scene",
			shader_datas: [],
			material_datas: [],
			mesh_datas: [],
			camera_datas: [],
			camera_ref: "Camera",
			objects: [],
			light_datas: []
		};
		Data.cachedSceneRaws.set(raw.name, raw);

		var cd:TCameraData = {
			name: "MyCamera",
			near_plane: 0.1,
			far_plane: 100.0,
			fov: 0.85
		};
		raw.camera_datas.push(cd);
		
		var sh:TShaderData = {
			name: "MyShader",
			contexts: [
				{
					name: "mesh",
					vertex_shader: "pbr.vert",
					fragment_shader: "pbr.frag",
					compare_mode: "less",
					cull_mode: "clockwise",
					depth_write: true,
					constants: [
						{ name: "albedo", type: "vec3" },
						{name: "lightCol", type: "vec3"},
						{ name: "metallic", type :"float" },
						{ name: "roughness", type :"float" },
						{ name: "ao", type :"float" },
						{name: "W", type: "mat4", link: "_worldMatrix"},
						{ name: "P", type: "mat4", link: "_projectionMatrix" },
						{ name: "V", type: "mat4", link: "_viewMatrix" },
						{ name: "N", type: "mat3", link: "_normalMatrix"},
						{
                            link: "_lightColor",
                            name: "lightCol",
                            type: "vec3"
                        },
                        {
                            link: "_lightDirection",
                            name: "lightDir",
                            type: "vec3"
                        },
						{
							link: "_lightPosition",
                            name: "lightPos",
                            type: "vec3"
						},
						{
							link: "_cameraPosition",
							name: "cameraPos",
							type: "vec3"
						},
						{
							link: "_cameraDirection",
							name: "cameraDir",
							type: "vec3"
						}
					],
					texture_units: [
						{name: "albedoMap"},
						{name: "normalMap"},
						{name: "metallicMap"},
						{name: "roughnessMap"},
						{name: "aoMap"}
					],
					vertex_elements: [
						{ name: "pos", data: "short4norm" },
						{ name: "nor",data: "short2norm"},
						{ name: "tex", data: "short2norm"}
					]
				}
			]
		};
		raw.shader_datas.push(sh);

		var colL = new kha.arrays.Float32Array(3);
		colL[0] = 10.0; colL[1] = 10.0; colL[2] = 10.0;

		var ls:TLightData = {
            "name": "LightData",
            "type": "point",
            "color": colL,
            "strength": 100.0,
			"light_size": 1.0,
            "near_plane": 0.1,
            "far_plane": 50.0,
            "fov": 0.8
        };
		raw.light_datas.push(ls);

		var col = new kha.arrays.Float32Array(3);
		col[0] = 0.5; col[1] = 0.0; col[2] = 0.0;

		var md:TMaterialData = {
			name: "MyMaterial",
			shader: "MyShader",
			contexts: [
				{
					name: "mesh",
					bind_constants: [
						{ name: "albedo", vec3: col },
						{name: "lightCol", vec3: colL},
						{ name: "metallic", float: 0.0 },
						{ name: "roughness", float: 0.1 },
						{ name: "ao", float: 1.0 },
					],
					bind_textures: [
						{name: "albedoMap", file: "rustedironDiffuse.png"},
						{name: "normalMap", file: "rustedironNormal.png"},
						{name: "metallicMap", file: "rustedironMetalness.png"},
						{name: "roughnessMap", file: "rustedironRoughness.png"},
						{name: "aoMap", file: "rustedironAO.png"}
					]
				}
			]
		};
		raw.material_datas.push(md);

		MaterialData.parse(raw.name, md.name, function(res:MaterialData) {
			dataReady();
		});
	}

	static function dataReady() {
		// Camera object
		var co:TObj = {
			name: "Camera",
			type: "camera_object",
			data_ref: "MyCamera",
			transform: null
		};
		raw.objects.push(co);

		// Mesh object
		var o:TObj = {
			name: "Object",
			type: "mesh_object",
			data_ref: "Teapot.arm/teapot",
			material_refs: ["MyMaterial"],
			transform: null,
		};
		raw.objects.push(o);

		var col = new kha.arrays.Float32Array(16);
		col[0] = -0.29; col[1] = -0.77; col[2] = 0.56; col[3] = 11.0;
		col[4] = 0.95; col[5] = -0.19; col[6] = 0.21; col[7] = 4.0;
		col[8] = -0.05; col[9] = 0.6; col[10] = 0.79; col[11] = 16.0;
		col[12] = 0.0; col[13] = 0.0; col[14] = 0.0; col[15] = 1.0;

		var lo:TObj = {
			name: "Light",
			"type": "light_object",
            "data_ref": "LightData",
            "transform": {
                "values": col
            }
		};
		raw.objects.push(lo);

		// Instantiate scene
		Scene.create(raw, function(o:Object) {
			trace('Monkey ready');
			sceneReady();
		});
	}

	static function sceneReady() {
		var mouse = Input.getMouse();
		mouse.lock();
		// Set camera
		var t = Scene.active.camera.transform;//Set camera location on init
		t.loc.set(0, -3, 0);
		t.rot.fromTo(new Vec4(0, 0, 1), new Vec4(0, -1, 0));
		t.buildMatrix();

		var l = Scene.active.getChild("Light").transform;//Set light location on init
		l.loc.set(2.6, 0.0, 5.9);
		l.buildMatrix();

		var object = Scene.active.getChild("Object");//set rotation of object to be appear straight(case in object like standford bunny/Utah teapot)
		object.transform.setRotation(1.570796, 0, 0);

		//update
		App.notifyOnUpdate(update);
	}
	static function update(){
		var kb = Input.getKeyboard();
		var mouse = Input.getMouse();

		var doRotate= true;
		//Rotate Object
		var object = Scene.active.getChild("Object");

		//object.transform.rotate(new Vec4(0, 0, 1.570796), 0.02);

		//Camera Controller
		var dir = new Vec4();
		var xvec = new Vec4();
		var yvec = new Vec4();

		var camera = Scene.active.camera;

		var moveForward =  kb.down("w");
		var moveBackward = kb.down("s");
		var moveLeft = kb.down("a");
		var moveRight = kb.down("d");
		var moveUP = kb.down("e");
		var moveDown = kb.down("q");

		dir.set(0.0, 0.0, 0.0);

		if (moveForward){
			dir.addf(camera.look().x, camera.look().y, camera.look().z);
		}
		if (moveBackward){
			dir.addf(-camera.look().x, -camera.look().y, -camera.look().z);
		}
		if (moveLeft){
			dir.addf(-camera.right().x,-camera.right().y, -camera.right().z);
		}
		if (moveRight){
			dir.addf(camera.right().x, camera.right().y, camera.right().z);
		}
		if (moveUP){
			dir.addf(camera.up().x, camera.up().y, camera.up().z);
		}
		if (moveDown){
			dir.addf(-camera.up().x, -camera.up().y, -camera.up().z);
		}

		if (moveForward || moveBackward || moveLeft || moveRight || moveUP || moveDown){
			if (kb.down("shift")){
				dir.mult(2.5);
			}
			camera.transform.translate(dir.x/100, dir.y/100, dir.z/100);
		}
		if (mouse.started("left")){
			mouse.lock();
		}
		if (kb.started("escape")){
			mouse.unlock();
		}
		if (mouse.locked){
			if (mouse.moved){
				camera.transform.rotate(Vec4.zAxis(), -mouse.movementX/200);
				camera.transform.rotate(camera.right(), -mouse.movementY/200);
			}
		}
	}
}