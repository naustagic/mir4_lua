------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   gather_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class gather_ent
local gather_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'gather_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = gather_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local actor_unit = actor_unit
local func = func
local local_player = local_player
local actor_ctx = actor_ctx
local quest_unit = quest_unit
local quest_ctx = quest_ctx
local main_ctx = main_ctx
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type quest_res
local quest_res = import('game/resources/quest_res')
---@type actor_res
local actor_res = import('game/resources/actor_res')
---@type map_res
local map_res = import('game/resources/map_res')
---@type revive_ent
local revive_ent = import('game/entities/revive_ent')
---@type redis_ent
local redis_ent = import('game/entities/redis_ent')
---@type user_ent
local user_ent = import('game/entities/user_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function gather_ent.super_preload()

end


-- 获取采集地图列表
function gather_ent.get_gather_map_list()
    local map_str = user_ent['采集点信息']

    local map_list = {}
    local list_a = func.split(map_str, '|')
    for i = 1, #list_a do
        local map_info = list_a[i]
        local map_name = func.split(map_info, '_')[1]
        local map_num = tonumber(func.split(map_info, '_')[2])
        local tab = {
            map_name = map_name,
            num = map_num
        }
        table.insert(map_list, tab)
    end
    return map_list
end





-- 获取可采集采集地图
function gather_ent.get_gather_map_name()
    local gather_map_list = gather_ent.get_gather_map_list()
    local my_data = {
        my_name = local_player:name(),
        time = os.time()
    }
    for i = 1, #gather_map_list do
        local num = gather_map_list[i].num
        local map_name = gather_map_list[i].map_name
        for j = 1, num do
            local path = '传奇4:内置数据:服务器[' .. main_ctx:c_server_name() .. ']:采集数据:采集地图:' .. map_name .. j
            local data = redis_ent.get_json_data(path)
            if table.is_empty(data) then
                redis_ent.set_json_data(path, my_data)
                return map_name
            else
                local set = false
                if data.my_name == my_data.my_name or data.my_name == '' or not data.my_name then
                    set = true
                end
                if not set and (not data.time or os.time() - data.time >= 60 * 60) then
                    set = true
                end
                if set then
                    redis_ent.set_json_data(path, my_data)
                    return map_name
                end
            end
        end
    end
    return ''
end

function gather_ent.gather_quest()
    revive_ent.revive_player()
    local side_quest_name_list = quest_res.GATHER_QUEST
    gather_ent.acc_side_quest(side_quest_name_list)
    gather_ent.sub_side_quest()
    gather_ent.del_side_quest(side_quest_name_list)

    local quest_info = gather_ent.do_side_quest()
    if not table.is_empty(quest_info) then
        gather_ent.test(quest_info)
    end
end

-- 做支线
function gather_ent.can_do_side_quest(side_quest_name_list)
    local list = quest_unit.list(0)
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local do_task = true
            local task_name = quest_ctx:name()
            if not side_quest_name_list[task_name] then
                do_task = false
            end
            if do_task then
                return true
            end
        end
    end
    return false
end

-- 接支线任务
function gather_ent.can_acc_side_quest(side_quest_name_list)
    local list = quest_unit.list(1)
    local my_combat_power = actor_unit.char_combat_power()
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local acc_task = true
            if quest_ctx:daily_num() > 0 then
                acc_task = false
            end
            if acc_task then
                local combat_power = quest_ctx:combat_power()
                if combat_power > my_combat_power then
                    acc_task = false
                end
            end
            if acc_task then
                local task_name = quest_ctx:name()
                if not side_quest_name_list[task_name] then
                    acc_task = false
                end
            end
            if acc_task then
                if quest_ctx:status() == 9 then
                    acc_task = false
                end
            end
            if acc_task then
                return true
            end
        end
    end
    return false
end


-- 接支线任务
function gather_ent.acc_side_quest(side_quest_name_list)
    local list = quest_unit.list(1)
    local my_combat_power = actor_unit.char_combat_power()
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            if #quest_unit.list(0) >= 10 then
                break
            end
            local acc_task = true
            if quest_ctx:daily_num() > 0 then
                acc_task = false
            end
            if acc_task then
                local combat_power = quest_ctx:combat_power()
                if combat_power > my_combat_power then
                    acc_task = false
                end
            end
            if acc_task then
                local task_name = quest_ctx:name()
                if not side_quest_name_list[task_name] then
                    acc_task = false
                end
            end
            if acc_task then
                quest_unit.accept(quest_ctx:id())
                decider.sleep(2000)
            end
        end
    end
end


-- 做支线
function gather_ent.do_side_quest()
    local list = quest_unit.list(0)
    local side_task_id = {}
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local do_task = true
            if quest_ctx:is_finish() then
                do_task = false
            end
            if do_task then
                side_task_id = {
                    id = quest_ctx:id(),
                    name = quest_ctx:name(),
                    tar_type = quest_ctx:tar_type(),
                    cx = quest_ctx:tx(),
                    cy = quest_ctx:ty(),
                    cz = quest_ctx:tz(),
                    map_id = quest_ctx:map_id(),
                    map_name = quest_ctx:map_name(),
                    tar_num = quest_ctx:tar_num(),
                    tar_max_num = quest_ctx:tar_max_num(),
                }
                break
            end
        end
    end
    return side_task_id
end

-- 交支线
function gather_ent.sub_side_quest()
    local list = quest_unit.list(0)
    local side_task_id = {}
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local sub_task = false
            if quest_ctx:is_finish() then
                sub_task = true
            end
            if sub_task then
                quest_unit.completed(quest_ctx:id())
            end
        end
    end
    return side_task_id
end

-- 删除任务
function gather_ent.del_side_quest(side_quest_name_list)
    local list = quest_unit.list(0)
    local my_combat_power = actor_unit.char_combat_power()
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local del_task = false
            if quest_ctx:daily_num() > 0 then
                del_task = true
            end
            if not del_task then
                local combat_power = quest_ctx:combat_power()
                if combat_power > my_combat_power then
                    del_task = true
                end
            end
            if not del_task then
                local task_name = quest_ctx:name()
                if not side_quest_name_list[task_name] then
                    del_task = true
                end
            end
            if del_task then
                quest_unit.delete(quest_ctx:id())
                decider.sleep(2000)
            end
        end
    end
end

function gather_ent.test(quest_info)

    local map_id = quest_info.map_id
    local map_name = quest_info.map_name
    local x, y, z = quest_info.cx, quest_info.cy, quest_info.cz
    local str = '[支线]' .. quest_info.name
    local gather_type = quest_res.GATHER_QUEST[quest_info.name] or quest_res.WEITUO_GATHER_QUEST[quest_info.name]

    local res_id = actor_res.GATHER_RES[map_name][gather_type]
    local map_list = actor_res.GATHER_MAP_LIST[map_name]
    local break_func = function()
        local gather_info = gather_ent.get_gather_info_by_res_id(res_id)
        if not table.is_empty(gather_info) then
            return true
        end
        return false
    end
    -- 移动到指定地图
    if map_id == actor_unit.map_id() then
        if local_player:status() ~= 14 then

            for i = 1, #map_list do
                if break_func() then
                    break
                end
                local cx, cy, cz = map_list[i].pos.x, map_list[i].pos.y, map_list[i].pos.z
                map_ent.auto_move(map_id, cx, cy, cz, str, nil, nil, break_func)
                map_ent.auto_move_to(local_player:cx(), local_player:cy(), local_player:cz(), map_id)
            end
            -- 移动到采集物附近采集
            local gather_info = gather_ent.get_gather_info_by_res_id(res_id)
            if not table.is_empty(gather_info) then
                if func.is_rang_by_point(local_player:cx(), local_player:cy(), gather_info.cx, gather_info.cy, 300) then
                    actor_unit.gather_ex(gather_info.sys_id)
                    decider.sleep(1000)
                else
                    map_ent.auto_move(nil, gather_info.cx, gather_info.cy, gather_info.cz, str)
                end
            end
        else
            local my_gather_info = gather_ent.get_my_gather_info()
            local gather = true
            if type(res_id) == 'number' then
                if my_gather_info.res_id ~= res_id then
                    gather = false
                end
            elseif type(res_id) == 'table' then
                if not res_id[my_gather_info.res_id] then
                    gather = false
                end
            end
            if not gather then
                map_ent.auto_move(map_id, x, y, z, str)
            end
        end
    else
        map_ent.auto_move(map_id, x, y, z, str)
    end
end

-- 通过采集物res_id获取采集物信息
function gather_ent.get_my_gather_info()
    local my_gather_info = {}
    local my_id = actor_unit.get_local_player_sys_id()
    local actor_list = actor_unit.list(4)
    for i = 1, #actor_list do
        local obj = actor_list[i]
        if actor_ctx:init(obj) and actor_ctx:gather_player_id() == my_id then
            my_gather_info = {
                obj = obj,
                name = actor_ctx:name(),
                cx = actor_ctx:cx(),
                cy = actor_ctx:cy(),
                cz = actor_ctx:cz(),
                sys_id = actor_ctx:sys_id(),
                res_id = actor_ctx:res_id(),
                dist = actor_ctx:dist(),
                gather_item_life = actor_ctx:gather_item_life(),
                gather_item_maxlife = actor_ctx:gather_item_maxlife(),

            }
            break
        end
    end

    return my_gather_info
end

-- 通过采集物res_id获取采集物信息
function gather_ent.get_gather_info_by_res_id(res_id)
    local actor_info_list = {}
    local actor_list = actor_unit.list(4)
    for i = 1, #actor_list do
        local obj = actor_list[i]
        if actor_ctx:init(obj) then
            local can_gather = true
            -- 不是指定的采集物
            if type(res_id) == 'number' then
                if actor_ctx:res_id() ~= res_id then
                    can_gather = false
                end
            elseif type(res_id) == 'table' then
                local actor_res_id = actor_ctx:res_id()
                if not res_id[actor_res_id] then
                    can_gather = false
                end
            end
            -- 被其他玩家采集中
            if can_gather and actor_ctx:gather_player_id() ~= 0 then
                --     xxmsg('ttt'..string.format('%X',actor_ctx:res_id()))
                can_gather = false
            end
            -- 不能移动过去的位置
            if can_gather and not actor_ctx:can_moveto(true) then
                --     xxmsg('xxx'..string.format('%X',actor_ctx:res_id()))
                can_gather = false
            end
            -- 不可采集的
            if can_gather and not actor_ctx:can_gather() then
                --  xxmsg('zzz'..string.format('%X',actor_ctx:res_id()))
                can_gather = false
            end
            if can_gather then
                local actor_info = {
                    obj = obj,
                    name = actor_ctx:name(),
                    cx = actor_ctx:cx(),
                    cy = actor_ctx:cy(),
                    cz = actor_ctx:cz(),
                    sys_id = actor_ctx:sys_id(),
                    res_id = actor_ctx:res_id(),
                    dist = actor_ctx:dist(),
                }
                table.insert(actor_info_list, actor_info)
            end
        end
    end
    if #actor_info_list > 1 then
        table.sort(actor_info_list, function(a, b)
            return a.dist < b.dist
        end)
    end

    return actor_info_list[1] or actor_info_list
end

-- 采集模块
function gather_ent.gather_mod(map_name)
    local escape_pos = map_res.ESCAPE_POS[map_name]
    local x, y, z = escape_pos.x, escape_pos.y, escape_pos.z
    local str = '[采集] - 移动到采集地图' .. map_name
    local map_id = map_res.GET_MAP_ID[map_name]
    local res_id = actor_res.GATHER_RES[map_name]['采集']
    local map_list = actor_res.GATHER_MAP_LIST[map_name]
    local break_func = function()
        local gather_info = gather_ent.get_gather_info_by_res_id2(res_id, map_name)
        if not table.is_empty(gather_info) then
            return true
        end
        return false
    end
    -- 移动到指定地图
    if map_name == actor_unit.map_name() then
        if local_player:status() ~= 14 then
            local idx = 1
            local dist = 0
            for i = 1, #map_list do
                local cx, cy, cz = map_list[i].pos.x, map_list[i].pos.y, map_list[i].pos.z
                local dist_xy = local_player:dist_xy(cx,cy)
                if dist_xy < dist or dist == 0 then
                    dist = dist_xy
                    idx = i
                end
            end
            if idx == #map_list then
                idx = 1
            end
            for i = idx, #map_list do
                if break_func() then
                    break
                end
                local cx, cy, cz = map_list[i].pos.x, map_list[i].pos.y, map_list[i].pos.z
                str = '[采集] - 移动[' .. map_name .. ']寻点' .. i
                map_ent.auto_move(map_id, cx, cy, cz, str, nil, nil, break_func)
                map_ent.auto_move_to(local_player:cx(), local_player:cy(), local_player:cz(), map_id)
            end
            -- 移动到采集物附近采集
            local gather_info = gather_ent.get_gather_info_by_res_id2(res_id, map_name)
            if not table.is_empty(gather_info) then
                if func.is_rang_by_point(local_player:cx(), local_player:cy(), gather_info.cx, gather_info.cy, 300) then
                    actor_unit.gather_ex(gather_info.sys_id)
                    decider.sleep(1000)
                else
                    str = '[采集] - 移动[' .. map_name .. ']寻草'
                    map_ent.auto_move(nil, gather_info.cx, gather_info.cy, gather_info.cz, str)
                end
            end
        else
            local my_gather_info = gather_ent.get_my_gather_info()
            local gather = true
            if type(res_id) == 'number' then
                if my_gather_info.res_id ~= res_id then
                    gather = false
                end
            elseif type(res_id) == 'table' then
                if not res_id[my_gather_info.res_id] then
                    gather = false
                end
            end
            if not gather then
                map_ent.auto_move(map_id, x, y, z, str)
            else
                str = '[采集] - 采集中（' .. my_gather_info.gather_item_life .. '/' .. my_gather_info.gather_item_maxlife .. '）'
                trace.output(str)
            end
        end
    else
        map_ent.auto_move(map_id, x, y, z, str)
    end
end



-- 通过采集物res_id获取采集物信息
function gather_ent.get_gather_info_by_res_id2(res_id, map_name)
    local actor_info_list = {}
    local actor_list = actor_unit.list(4)
    for i = 1, #actor_list do
        local obj = actor_list[i]
        if actor_ctx:init(obj) then
            local can_gather = true
            -- 不是指定的采集物
            if type(res_id) == 'number' then
                if actor_ctx:res_id() ~= res_id then
                    can_gather = false
                end
            elseif type(res_id) == 'table' then
                local actor_res_id = actor_ctx:res_id()
                if not res_id[actor_res_id] then
                    can_gather = false
                end
            end
            -- 被其他玩家采集中
            if can_gather and actor_ctx:gather_player_id() ~= 0 then
                --     xxmsg('ttt'..string.format('%X',actor_ctx:res_id()))
                can_gather = false
            end
            -- 不能移动过去的位置
            if can_gather and not actor_ctx:can_moveto(true) then
                --     xxmsg('xxx'..string.format('%X',actor_ctx:res_id()))
                can_gather = false
            end
            -- 不可采集的
            if can_gather and not actor_ctx:can_gather() then
                --  xxmsg('zzz'..string.format('%X',actor_ctx:res_id()))
                can_gather = false
            end

            if can_gather then

                if actor_res.GATHER_RES[map_name]['采集'][actor_ctx:res_id()].gather_type ~= 3 then

                    can_gather = false
                end
            end
            if can_gather then
                if actor_ctx:dist() > 7000 then
                    can_gather = false
                end
            end
            if can_gather then
                local actor_info = {
                    obj = obj,
                    name = actor_ctx:name(),
                    cx = actor_ctx:cx(),
                    cy = actor_ctx:cy(),
                    cz = actor_ctx:cz(),
                    sys_id = actor_ctx:sys_id(),
                    res_id = actor_ctx:res_id(),
                    dist = actor_ctx:dist(),
                }
                table.insert(actor_info_list, actor_info)
            end
        end
    end
    if #actor_info_list > 1 then
        table.sort(actor_info_list, function(a, b)
            return a.dist < b.dist
        end)
    end

    return actor_info_list[1] or actor_info_list
end






------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function gather_ent.__tostring()
    return this.MODULE_NAME
end

------------------------------------------------------------------------------------
-- [内部] 防止动态修改(this.READ_ONLY值控制)
--
-- @local
-- @tparam       table     t                被修改的表
-- @tparam       any       k                要修改的键
-- @tparam       any       v                要修改的值
------------------------------------------------------------------------------------
function gather_ent.__newindex(t, k, v)
    if this.READ_ONLY then
        error('attempt to modify read-only table')
        return
    end
    rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- [内部] 设置item的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
gather_ent.__index = gather_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function gather_ent:new(args)
    local new = {}
    -- 预载函数(重载脚本时)
    if this.super_preload then
        this.super_preload()
    end
    -- 将args中的键值对复制到新实例中
    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end
    -- 设置元表
    return setmetatable(new, gather_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return gather_ent:new()

-------------------------------------------------------------------------------------
