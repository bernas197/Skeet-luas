local url = "https://discord.gg/CAr3AEHHGZ"

-- Adiciona a checkbox "Enable resolver" acima do botão "Credits for the Resolver"
local enable_resolver_checkbox = ui.new_checkbox("Lua", "B", "Enable resolver")

local discord_button = ui.new_button("Lua", "B", "Credits for the Resolver", function()
    panorama.loadstring([[
        SteamOverlayAPI.OpenExternalBrowserURL("]] .. url .. [[");
    ]])()
end)

local plist_set, plist_get = plist.set, plist.get
local getplayer = entity.get_players
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop

-- Função para calcular o yaw baseado na direção do movimento
local function calculate_yaw(player)
    local velocity = {entity_get_prop(player, "m_vecVelocity")}
    
    -- Verifica se velocity contém valores válidos
    if velocity and velocity[1] and velocity[2] then
        local speed = math.sqrt(velocity[1]^2 + velocity[2]^2)

        -- Se o jogador está em movimento, ajusta o yaw
        if speed > 0 then
            local angle = math.atan2(velocity[2], velocity[1]) * (180 / math.pi) -- Converte para graus
            return angle + math.random(-10, 10) -- Adiciona um pequeno desvio
        else
            return math.random(-60, 60) -- Se parado, usa um yaw aleatório
        end
    else
        -- Se não for uma tabela válida, retorna um yaw aleatório
        return math.random(-60, 60)
    end
end

-- Função para resolver a posição do jogador
local function resolve(player)
    -- Desativa a correção padrão
    plist_set(player, "Correction active", false)

    -- Calcula o yaw baseado na direção do movimento
    local yaw_value = calculate_yaw(player)
    plist_set(player, "Force body yaw", true)
    plist_set(player, "Force body yaw value", yaw_value)
end

-- Função chamada a cada atualização de rede
local function on_net_update()
    if not ui.get(enable_resolver_checkbox) then return end -- Verifica se o resolver está ativado

    local enemies = getplayer(true) -- Obtém todos os inimigos
    for i = 1, #enemies do
        local player = enemies[i]
        resolve(player) -- Resolve a posição do jogador
    end
end

client.set_event_callback('net_update_start', on_net_update)
