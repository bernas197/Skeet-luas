client.log("Dev: bernas198")



---------------------------------------------Edit this----------------------------------------


local player_models = {
    ["Nigga_Balla"] = "models/player/custom_player/eminem/gta_sa/vla2.mdl",
    ["White Balla"] = "models/player/custom_player/eminem/gta_sa/ballas1.mdl",
    ["Somyst"] = "models/player/custom_player/eminem/gta_sa/somyst.mdl",
    ["vwfypro"] = "models/player/custom_player/eminem/gta_sa/vwfypro.mdl",
    ["wuzimu"] = "models/player/custom_player/eminem/gta_sa/wuzimu.mdl",
    ["swmotr5"] = "models/player/custom_player/eminem/gta_sa/swmotr5.mdl",
    ["fam1"] = "models/player/custom_player/eminem/gta_sa/fam1.mdl",
    ["bmybar"] = "models/player/custom_player/eminem/gta_sa/bmybar.mdl",
    ["t_arctic"] = "models/player/custom_player/eminem/css/t_arctic.mdl",
}
---------------------------------------------Edit this----------------------------------------


local ffi = require("ffi")

ffi.cdef [[
    typedef struct {
        void* fnHandle;
        char szName[260];
        int nLoadFlags;
        int nServerCount;
        int type;
        int flags;
        float vecMins[3];
        float vecMaxs[3];
        float radius;
        char pad[0x1C];
    } model_t;

    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local class_ptr = ffi.typeof("void***")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003")
local ientitylist = ffi.cast(class_ptr, rawientitylist)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3])

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004")
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2])
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39])

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001")
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3])

local model_names = {}
for key, _ in pairs(player_models) do
    table.insert(model_names, key)
end

local localplayer_model_all = ui.new_combobox("lua", "a", "Change local player model", model_names)

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache")
    if rawprecache_table then
        local precache_table = ffi.cast(class_ptr, rawprecache_table)
        local add_string = ffi.cast("add_string_t", precache_table[0][8])
        find_or_load_model(ivmodelinfo, modelname)
        local idx = add_string(precache_table, false, modelname, -1, nil)
        if idx == -1 then
            return false
        end
    end
    return true
end

local function set_model_index(entity, idx)
    local raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then
        local gce_entity = ffi.cast(class_ptr, raw_entity)
        local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index then
            a_set_model_index(gce_entity, idx)
        end
    end
end

local function change_model(ent, model)
    if model:len() > 5 then
        if not precache_model(model) then return end
        local idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then return end
        set_model_index(ent, idx)
    end
end

client.set_event_callback("pre_render", function()
    local me = entity.get_local_player()
    if not me then return end

    local team = entity.get_prop(me, 'm_iTeamNum')
    if team == 2 or team == 3 then
        local selected_model = ui.get(localplayer_model_all)
        change_model(me, player_models[selected_model])
    end
end)
