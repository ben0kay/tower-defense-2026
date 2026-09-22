/// @description Initializes the game before a level starts.
function sc_game_init()
{
    global.GameState = GameState.BOOT;
    global.LevelState = LevelState.NONE;

    global.game = {
        initialized: false,
        tick: 0
    };

    global.profile = undefined;
    global.level = undefined;

    if (!sc_config_init())
    {
        show_debug_message("GAME INIT FAILED - CONFIG");
        return false;
    }

    global.game.initialized = true;
    global.GameState = GameState.PLAYING;
    return true;
}