package arm;

import iron.data.MeshData;
import iron.object.Object;
import iron.Trait;
import iron.math.Vec4;

class RotateObject extends iron.Trait {
	public function new(){
		super();
		notifyOnInit(function (){
			// Set Object rotation and location on init
			object.transform.loc.set(0.0, 0.0, 0.0);
			object.transform.setRotation(1.570796, 0, 0);
			object.transform.buildMatrix();
		});
		notifyOnUpdate(function (){
			//Rotate Object
			object.transform.rotate(new Vec4(0.0, 0.0, 1.570796), 0.02);
		});
	}
}