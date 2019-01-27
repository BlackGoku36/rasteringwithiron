package arm;

import iron.math.Vec4;
import iron.system.Input;
import iron.Scene;

//Key config for different keyboard layout
class KeyboardLayout {
	#if arm_azerty
	public static inline var keyUp = 'z';
	public static inline var keyDown = 's';
	public static inline var keyLeft = 'q';
	public static inline var keyRight = 'd';
	public static inline var keyStrafeUp = 'e';
	public static inline var keyStrafeDown = 'a';
	public static inline var keyRun = 'shift';
	#else
	public static inline var keyUp = 'w';
	public static inline var keyDown = 's';
	public static inline var keyLeft = 'a';
	public static inline var keyRight = 'd';
	public static inline var keyStrafeUp = 'e';
	public static inline var keyStrafeDown = 'q';
	public static inline var keyRun = 'shift';
	#end
}

class CameraController extends iron.Trait {
	var keyboard = Input.getKeyboard();
	var mouse = Input.getMouse();

	public function new(){
		super();

		notifyOnInit(function (){
			//Set camera location on init
			object.transform.loc.set(0, -3, 0);
			object.transform.rot.fromTo(new Vec4(0, 0, 1), new Vec4(0, -1, 0));
			object.transform.buildMatrix();
		});

		notifyOnUpdate(update);
	}

	public function update(){

		//Camera Movement
		var dir = new Vec4();

		var camera = Scene.active.camera;

		var moveForward =  keyboard.down(KeyboardLayout.keyUp);
		var moveBackward = keyboard.down(KeyboardLayout.keyDown);
		var moveLeft = keyboard.down(KeyboardLayout.keyLeft);
		var moveRight = keyboard.down(KeyboardLayout.keyRight);
		var moveUP = keyboard.down(KeyboardLayout.keyStrafeUp);
		var moveDown = keyboard.down(KeyboardLayout.keyStrafeDown);

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
			if (keyboard.down("shift")){//Speed multiplier while holding shift
				dir.mult(2.5);
			}
			camera.transform.translate(dir.x/100, dir.y/100, dir.z/100);//Translate camera to look direction
		}

		//mouse lock
		if (mouse.started("left")) mouse.lock();

		//mouse unlock
		if (keyboard.started("escape")) mouse.unlock();

		//Mouse movement to look around
		if (mouse.locked){
			if (mouse.moved){
				camera.transform.rotate(Vec4.zAxis(), -mouse.movementX/300);
				camera.transform.rotate(camera.right(), -mouse.movementY/300);
			}
		}
	}
}