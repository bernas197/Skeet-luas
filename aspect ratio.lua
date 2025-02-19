client.log("Dev: bernas198")

local ui_new_checkbox, ui_new_slider, ui_get, ui_set_callback = ui.new_checkbox, ui.new_slider, ui.get, ui.set_callback
local cvar_r_aspectratio = cvar.r_aspectratio

-- Criar UI
local aspect_ratio_enable = ui_new_checkbox("MISC", "Miscellaneous", "Enable Aspect Ratio")
local aspect_ratio_value = ui_new_slider("MISC", "Miscellaneous", "Aspect Ratio", 50, 200, 100, true, "%", 1)

-- Função para atualizar o aspecto
local function update_aspect_ratio()
    if ui_get(aspect_ratio_enable) then
        local ratio = ui_get(aspect_ratio_value) / 100
        cvar_r_aspectratio:set_float(ratio)
    else
        cvar_r_aspectratio:set_float(0)
    end
end

-- Definir callbacks
ui_set_callback(aspect_ratio_enable, update_aspect_ratio)
ui_set_callback(aspect_ratio_value, update_aspect_ratio)
