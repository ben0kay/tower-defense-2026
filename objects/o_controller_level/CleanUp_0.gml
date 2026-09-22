/// @description Clears state owned by this level.
if (is_struct(global.level) && global.level.controller == id)
{
    global.LevelState = LevelState.NONE;
    global.level = undefined;
}