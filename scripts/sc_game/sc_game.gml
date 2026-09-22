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
}