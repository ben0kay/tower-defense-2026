/// @description Creates game-wide tuning values.
function sc_config_init()
{
    global.config = {
        camera: {
            width: 1920,
            height: 1080,
            pan_speed: 18
        },

        map: {
            cell_size: 64,
            grid_colour: make_colour_rgb(38, 56, 70)
        }
    };

    return true;
}