package;

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
						//{ name: "color", type: "vec3" },
						//{ name: "albedo", type: "vec3" },
						//{name: "lightCol", type: "vec3"},
						//{ name: "metallic", type :"float" },
						//{ name: "roughness", type :"float" },
						//{ name: "ao", type :"float" },
						//{ name: "WVP", type: "mat4", link: "_worldViewProjectionMatrix" },
						//{ name: "M", type: "mat4", link: "_modelMatrix" },
						{name: "W", type: "mat4", link: "_worldMatrix"},
						{ name: "P", type: "mat4", link: "_projectionMatrix" },
						{ name: "V", type: "mat4", link: "_viewMatrix" },
						//{ name: "N", type: "mat3", link: "_normalMatrix"},
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
							link: "_cameraLook",
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
		colL[0] = 1.0; colL[1] = 1.0; colL[2] = 1.0;

		var ls:TLightData = {
            "name": "LightData",
            "type": "point",
            "color": colL,
            "strength": 10.0,
            "near_plane": 0.1,
            "far_plane": 50.0,
            "fov": 0.85
        };
		raw.light_datas.push(ls);

		//var col = new kha.arrays.Float32Array(3);
		//col[0] = 0.5; col[1] = 0.0; col[2] = 0.0;

		var md:TMaterialData = {
			name: "MyMaterial",
			shader: "MyShader",
			contexts: [
				{
					name: "mesh",
					bind_constants: [
						//{ name: "color", vec3: col },
						//{ name: "albedo", vec3: col },
						//{name: "lightCol", vec3: colL},
						//{ name: "metallic", float: 0.1 },
						//{ name: "roughness", float: 1.0 },
						//{ name: "ao", float: 1.0 },
						//{name: "cameraPos", vec3: caLoc}
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
			data_ref: "Wood.arm/Cube",
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

		// Instantiate single object
		// Scene.active.parseObject(raw.name, o.name, null, function(o:Object) {
		// 	trace('Monkey ready');
		// });
	}

	static function sceneReady() {
		// Set camera
		var t = Scene.active.camera.transform;
		t.loc.set(0, -3, 0);
		t.rot.fromTo(new Vec4(0, 0, 1), new Vec4(0, -1, 0));
		t.buildMatrix();
			
		// Rotate suzanne
		var suzanne = Scene.active.getChild("Object");
		App.notifyOnUpdate(function() {
			suzanne.transform.rotate(new Vec4(0, 0, 1), 0.005);
		});
	}
}
