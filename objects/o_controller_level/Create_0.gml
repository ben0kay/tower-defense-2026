/// @description Owns the current level and creates its camera.
if (!global.game.initialized)
{
    show_debug_message("LEVEL INIT FAILED - MAIN CONTROLLER MISSING");
    instance_destroy();
    exit;
}

global.level = {
    controller: id,
    camera: noone
};

var _camera = instance_create_layer(room_width * 0.5, room_height * 0.5, "Instances", o_camera);
global.level.camera = _camera;
global.LevelState = LevelState.PLAYING;