client.log("Dev: bernas198")

local lp = entity.get_local_player

local enable = ui.new_checkbox("LUA", "A", "Enable China hat", true)
local color = ui.new_color_picker("LUA", "A", "China color", 0, 255, 255, 255)
local gradient = ui.new_checkbox("LUA", "A", "Gradient")
local speed = ui.new_slider("LUA", "A", "Speed \n China", 1, 10, 5)

local thirdperson = {ui.reference("Visuals", "Effects", "Force third person (alive)")}

local function renderer_triangle(v2_A, v2_B, v2_C, r, g, b, a)
    local function sign(p1, p2, p3)
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    end

    if sign(v2_A, v2_B, v2_C) < 0 then
        renderer.triangle(v2_A.x, v2_A.y, v2_B.x, v2_B.y, v2_C.x, v2_C.y, r, g, b, a)
    else
        renderer.triangle(v2_C.x, v2_C.y, v2_B.x, v2_B.y, v2_A.x, v2_A.y, r, g, b, a)
    end
end

local function hsv_to_rgb(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255
end

local function world_circle(origin, size)
    if origin[1] == nil then
        return
    end

    local last_point = nil
    local gradient_enabled = ui.get(gradient)
    local color_values = {ui.get(color)}

    for i = 0, 360, 5 do
        local new_point = {
            origin[1] - (math.sin(math.rad(i)) * size),
            origin[2] - (math.cos(math.rad(i)) * size),
            origin[3]
        }

        -- Update color with gradient effect
        if gradient_enabled then
            local hue_offset = (globals.realtime() * (ui.get(speed) * 50) + i) % 360
            local r, g, b = hsv_to_rgb(hue_offset / 360, 1, 1)
            color_values = {r, g, b, 255}
        end

        -- Draw lines and triangles between points
        if last_point ~= nil then
            local old_screen_point = {renderer.world_to_screen(last_point[1], last_point[2], last_point[3])}
            local new_screen_point = {renderer.world_to_screen(new_point[1], new_point[2], new_point[3])}
            local origin_screen_point = {renderer.world_to_screen(origin[1], origin[2], origin[3] + 8)}

            if old_screen_point[1] and new_screen_point[1] and origin_screen_point[1] then
                renderer_triangle(
                    {x = old_screen_point[1], y = old_screen_point[2]},
                    {x = new_screen_point[1], y = new_screen_point[2]},
                    {x = origin_screen_point[1], y = origin_screen_point[2]},
                    color_values[1], color_values[2], color_values[3], 50
                )
                renderer.line(old_screen_point[1], old_screen_point[2], new_screen_point[1], new_screen_point[2], color_values[1], color_values[2], color_values[3], 255)
            end
        end

        last_point = new_point
    end
end

client.set_event_callback("paint_ui", function()
    local master_state = ui.get(enable)
    ui.set_visible(color, master_state)
    ui.set_visible(gradient, master_state)
    ui.set_visible(speed, master_state and ui.get(gradient))

    -- Make the actual "China hat"
    if not master_state or (not ui.get(thirdperson[1]) or not ui.get(thirdperson[2])) or lp() == nil or not entity.is_alive(lp()) then
        return
    end

    world_circle({entity.hitbox_position(lp(), 0)}, 10)
end)
