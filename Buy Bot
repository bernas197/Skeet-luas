client.log("Dev: bernas198")

local ui_get, ui_new_checkbox, ui_new_combobox, ui_new_multiselect, console_cmd = 
    ui.get, ui.new_checkbox, ui.new_combobox, ui.new_multiselect, client.exec

-- UI
local auto_buy_enabled = ui_new_checkbox("MISC", "Miscellaneous", "Auto Buy")
local primary_weapon = ui_new_combobox("MISC", "Miscellaneous", "Primary weapon", "None", "AWP", "SCOUT", "Auto Sniper")
local secondary_weapon = ui_new_combobox("MISC", "Miscellaneous", "Secondary weapon", "None", "Desert Eagle/Revolver", "Five Seven")
local extra_items = ui_new_multiselect("MISC", "Miscellaneous", "Extra items", 
    "Kevlar + Helmet", "Defuse Kit", "Tazer", "HE Grenade", "Smoke", "Molotov")

-- Mapas de compra para evitar ifs repetitivos
local weapon_map = {
    ["AWP"] = "buy awp;",
    ["SCOUT"] = "buy ssg08;",
    ["Auto Sniper"] = "buy g3sg1; buy sg553;",
    ["Desert Eagle/Revolver"] = "buy deagle; buy revolver;",
    ["Five Seven"] = "buy fiveseven;"
}

local extra_map = {
    ["Kevlar + Helmet"] = "buy vesthelm;",
    ["Defuse Kit"] = "buy defuser;",
    ["Tazer"] = "buy taser;",
    ["HE Grenade"] = "buy hegrenade;",
    ["Smoke"] = "buy smokegrenade;",
    ["Molotov"] = "buy molotov; buy incgrenade;"
}

local function on_round_prestart()
    if not ui_get(auto_buy_enabled) then return end

    local buy_commands = {}

    -- Adicionar armas selecionadas à lista de compras
    table.insert(buy_commands, weapon_map[ui_get(primary_weapon)] or "")
    table.insert(buy_commands, weapon_map[ui_get(secondary_weapon)] or "")

    -- Adicionar equipamentos extras à lista de compras
    for _, item in ipairs(ui_get(extra_items) or {}) do
        table.insert(buy_commands, extra_map[item] or "")
    end

    -- Executar comandos de compra
    console_cmd(table.concat(buy_commands, " "))
end

client.set_event_callback("round_prestart", on_round_prestart)
