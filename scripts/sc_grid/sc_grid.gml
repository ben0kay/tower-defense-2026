/// @description Draws the visible portion of the room's map grid.
function sc_map_grid_draw()
{
    var _cell = GCFG.map.cell_size;
    var _camera = global.level.camera.camera_data.camera_id;
    var _left = camera_get_view_x(_camera);
    var _top = camera_get_view_y(_camera);
    var _right = min(room_width, _left + camera_get_view_width(_camera));
    var _bottom = min(room_height, _top + camera_get_view_height(_camera));
    var _first_x = max(0, floor(_left / _cell) * _cell);
    var _first_y = max(0, floor(_top / _cell) * _cell);

    draw_set_colour(GCFG.map.grid_colour);

    for (var _x = _first_x; _x <= _right; _x += _cell)
        draw_line(_x, _top, _x, _bottom);

    for (var _y = _first_y; _y <= _bottom; _y += _cell)
        draw_line(_left, _y, _right, _y);

    draw_set_colour(c_white);
}