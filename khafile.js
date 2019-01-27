let project = new Project('Empty');

project.addSources('Sources');
project.addParameter('arm.RotateObject');
project.addParameter('arm.CameraController');
project.addShaders('Shaders');
project.addLibrary('../../iron');
project.addAssets('Assets/**');

resolve(project);
