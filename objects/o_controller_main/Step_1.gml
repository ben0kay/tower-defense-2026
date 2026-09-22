/// @description Advances shared game time while the level is running.
if (global.game.initialized && global.LevelState == LevelState.PLAYING)
    global.game.tick++;