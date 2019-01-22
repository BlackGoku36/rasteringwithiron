package;

import kha.System;
import iron.system.Input;
import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.object.Object;
import iron.math.Vec4;

class Main {

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
    
		//Set Scene from Scene json file
		iron.Scene.setActive("ScenePBR.json", function(object:iron.object.Object) {
			sceneReady();
		});
	}

	static function sceneReady() {
		var mouse = Input.getMouse();
		mouse.lock();//lock mouse on init

		//Set camera location on init
		var t = Scene.active.camera.transform;
		t.loc.set(0, -3, 0);
		t.rot.fromTo(new Vec4(0, 0, 1), new Vec4(0, -1, 0));
		t.buildMatrix();

		//Set light location on init
		var l = Scene.active.getChild("Light").transform;
		l.loc.set(5.0, 0.0, 6.0);
		l.buildMatrix();

		//set rotation of object to be appear straight(case in object like standford bunny/Utah teapot)
		var object = Scene.active.getChild("Object");
		object.transform.loc.set(0.0, 0.0, 0.0);
		object.transform.setRotation(1.570796, 0, 0);
		object.transform.buildMatrix();

		//update
		App.notifyOnUpdate(update);
	}

	static function update(){
		var kb = Input.getKeyboard();
		var mouse = Input.getMouse();

		//Rotate Object
		var object = Scene.active.getChild("Object");

		object.transform.rotate(new Vec4(0, 0, 1.570796), 0.02);

		//Camera Controller
		var dir = new Vec4();

		var camera = Scene.active.camera;

		var moveForward =  kb.down("w");
		var moveBackward = kb.down("s");
		var moveLeft = kb.down("a");
		var moveRight = kb.down("d");
		var moveUP = kb.down("e");
		var moveDown = kb.down("q");

		dir.set(0.0, 0.0, 0.0);

		//Movements
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
			if (kb.down("shift")){//Speed multiplier while holding shift
				dir.mult(2.5);
			}
			camera.transform.translate(dir.x/100, dir.y/100, dir.z/100);//Translate camera to look direction
		}

		//mouse lock
		if (mouse.started("left")){
			mouse.lock();
		}
		//mouse unlock
		if (kb.started("escape")){
			mouse.unlock();
		}
		//Mouse movement to look around
		if (mouse.locked){
			if (mouse.moved){
				camera.transform.rotate(Vec4.zAxis(), -mouse.movementX/200);
				camera.transform.rotate(camera.right(), -mouse.movementY/200);
			}
		}
	}
}