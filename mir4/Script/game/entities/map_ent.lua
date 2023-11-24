------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   map_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class map_ent
local map_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'map_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = map_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local map_unit = map_unit
local actor_unit = actor_unit
local local_player = local_player
---@type map_res
local map_res = import('game/resources/map_res')
---@type game_ent
local game_ent = import('game/entities/game_ent')
---@type item_ent
local item_ent = import('game/entities/item_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function map_ent.super_preload()

end


------------------------------------------------------------------------------------
-- [行为] 逃跑回血
--
-- @treturn     boolean     复血是否成功
------------------------------------------------------------------------------------
map_ent.escape_for_recovery = function(v)
    local hp_percent = v or 40
    local run_time = os.time()
    local out_dis = 100
    local map_name = actor_unit.map_name()
    local escape_pos = map_res.ESCAPE_POS[map_name] -- 一个逃跑点
    local escape_list = map_res.ESCAPE_POS_LIST[map_name] -- 多个逃跑点
    if not escape_pos and table.is_empty(escape_list) then
        return false, map_name .. '没有添加坐标'
    end

    local cx, cy, cz = 0, 0, 0
    if escape_pos then -- 单点
        cx, cy, cz = escape_pos.x, escape_pos.y, escape_pos.z

    elseif not table.is_empty(escape_list) then -- 多点
        local map_point_name = this.get_near_point(escape_list)
        local map_point_info = escape_list[map_point_name]
        cx, cy, cz = map_point_info.x, map_point_info.y, map_point_info.z

    end
    -- local cx, cy, cz = escape_pos.x, escape_pos.y, escape_pos.z
    if not cx or cx == 0 then
        return false, '没有添加坐标'
    end

    if local_player:hp()*100/local_player:max_hp() > hp_percent then
        return false, '当前血量百分比不需要恢复'
    end
    while decider.is_working() do

        if game_ent.player_is_dead() then
            return false, '主角已死亡'
        end
        if local_player:hp()*100/local_player:max_hp() > 70 then
            break
        end
        if os.time() - run_time > 60 then
            return false, '逃跑超时'
        end
        if map_name ~= actor_unit.map_name() then
            return false, '不在逃跑地图'
        end
        trace.output(string.format('逃跑回血%0.0f/100', (local_player:hp()*100/local_player:max_hp())))
        if not map_ent.is_move() and local_player:dist_xy(cx, cy) > out_dis then
            map_ent.auto_move_to(cx, cy, cz)
        end
        decider.sleep(1000)
    end
    return true, ''
end

-- 获得最近的安全点
function map_ent.get_near_point(map_tab)
    local min_point = -1
    local point_name = nil
    for key, value in pairs(map_tab) do
        if min_point == -1 then
            min_point = local_player:dist_xy(value.x, value.y)
            point_name = key
        elseif min_point > local_player:dist_xy(value.x, value.y) then
            min_point = local_player:dist_xy(value.x, value.y)
            point_name = key
        end
    end
    return point_name
end

-- 移动
function map_ent.auto_move_to(cx, cy, cz, map_id)
    local random = math.random(-10, 10)
    cx = cx + random
    cy = cy + random
    cz = cz + random
    map_id = map_id or actor_unit:map_id()
    actor_unit.move_to(cx, cy, cz, map_id)
    decider.sleep(1000)
end

-- 判断是否移动
function map_ent.is_move()
    local status = local_player:status()
    if status ~= 4 and status ~= 24 and status ~= 27 then
        return false
    end
    return true
end




-- 移动到指定位置
function map_ent.auto_move(map_id, x, y, z, str, dist, not_ride, break_func)
    local b_ret = false
    if type(map_id) == 'string' then
        map_id = map_res.GET_MAP_ID[map_id]
    end
    --移动地图
    map_id = map_id or actor_unit.map_id()

    dist = dist or 100
    if map_id ~= actor_unit.map_id() then
        map_ent.teleport_map(map_id)
    end
    while decider.is_working() do
        if game_ent.player_is_dead() then
            break
        end
        if local_player:dist_xy(x, y) < dist and actor_unit.map_id() == map_id then
            b_ret = true
            break
        end
        if break_func and break_func() then
            break
        end
        trace.output(str)
        if not map_ent.is_move() then
            map_ent.auto_move_to(x, y, z, map_id)
        end
        if not_ride then
            -- TODO:不骑马
        end
        if map_ent.move_lag(60) then
            local map_name = map_res.GET_MAP_NAME[map_id]
            local escape_pos = map_res.ESCAPE_POS[map_name]
            if not escape_pos then
                map_ent.teleport_map(101003010)
            end
            actor_unit.fast_move(escape_pos.x, escape_pos.y, escape_pos.z)
            decider.sleep(5000)
        end
        decider.sleep(1000)
    end
end

--------------------------------------------------------------------------------
-- [判断] 判断是否卡位置
--
-- @static
-- @tparam      integer      num    在同一位置范围的次数
-- @treturn     boolean
-- @usage
-- if move_ent.move_lag() then main_ctx:end_game() end
--------------------------------------------------------------------------------
map_ent.move_lag = function(num)
    local ret_b = false
    num = num or 120
    this.check_auto = this.check_auto or 0
    if not this.last_x or this.last_x == 0 then
        this.last_x = local_player:cx()
        this.last_y = local_player:cy()
    else
        if local_player:dist_xy(this.last_x, this.last_y) < 2 and 2 == local_player:status() then
            this.check_auto = this.check_auto + 1
        else
            this.last_x = 0
            this.last_y = 0
            this.check_auto = 0
        end
        if this.check_auto > num then
            this.check_auto = 0
            ret_b = true
        end
    end
    return ret_b
end

function map_ent.teleport_map(map_id)
    if item_ent.get_item_num_by_name('瞬移卷轴') <= 0 then
        return false
    end
    local  teleport_id =map_unit.get_map_teleport_id(map_id)
    if not teleport_id or teleport_id == 0 then
        return false
    end
    if map_id == actor_unit.map_id() then
        return false
    end
    if not decider.is_working() then
        return false
    end
    map_unit.teleport(teleport_id, true)
    for i = 1, 30 do
        decider.sleep(1000)
        if local_player:status() ~= 24 then
            break
        end
    end
    decider.sleep(1000)
end

function map_ent.get_teleport_id_by_map_id(map_name)
    local teleport_id = 0
    local teleport_map_num = map_unit.teleport_map_num()
    for i = 0, teleport_map_num - 1 do
        if map_unit.get_teleport_name(i) == map_name then
            teleport_id = map_unit.get_teleport_id(i)
            break
        end

    end
    return teleport_id
end

--[EA78--0000] 1B 00 00 00 00 78 EA 00 00 00 00 00 00 00 00 00 00 08 E6 DA 80 CA 07 10 03 18 64
--[EA78--0000] 1C 00 00 00 00 78 EA 00 00 00 00 00 00 00 00 00 00 08 E6 DA 80 CA 07 10 03 18 EE 07



------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function map_ent.__tostring()
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
function map_ent.__newindex(t, k, v)
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
map_ent.__index = map_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function map_ent:new(args)
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
    return setmetatable(new, map_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return map_ent:new()

-------------------------------------------------------------------------------------
