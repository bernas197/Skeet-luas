-- You can use FFI instead of client.exec

client.log("Dev: bernas198")

local nades = 0

local drop_nades_bind = ui.new_hotkey("LUA", "A", "Drop all grenades", false)

client.set_event_callback("setup_command", function(cmd)
    if ui.get(drop_nades_bind) and nades < 1 then
        nades = nades + 1

        local function dropGrenade(cmd_str, delay)
            client.delay_call(delay, function()
                client.exec(cmd_str)
            end)
        end

        dropGrenade("use weapon_knife;use weapon_flashbang;drop", 0.05)
        dropGrenade("use weapon_knife;use weapon_flashbang;drop", 0.10)
        dropGrenade("use weapon_knife;use weapon_hegrenade;drop", 0.15)
        dropGrenade("use weapon_knife;use weapon_smokegrenade;drop", 0.20)
        dropGrenade("use weapon_knife;use weapon_molotov;drop", 0.25)
        dropGrenade("use weapon_knife;use weapon_incgrenade;drop", 0.30)
        dropGrenade("use weapon_knife;use weapon_decoy;drop", 0.35)

    elseif not ui.get(drop_nades_bind) and nades ~= 0 then
        nades = 0
    end
end)
