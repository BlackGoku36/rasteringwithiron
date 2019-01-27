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
		kha.System.start({title: "rasteringwithiron", width: 1920, height: 1080}, function(window:kha.Window) {
			App.init(ready);
		});
	}

	static function ready() {
		var renderPath = new RenderPath();
		renderPath.commands = function() {
			renderPath.setTarget("");
			renderPath.clearTarget(0xff6495ED, 1.0);
			renderPath.drawMeshes("mesh");
		};
		RenderPath.setActive(renderPath);
    
		//Set Scene from Scene json file
		iron.Scene.setActive("ScenePBRCol.json", function(object:iron.object.Object) {
			//Lock mouse on scene init
			var mouse = Input.getMouse();
			mouse.lock();
		});
	}
}