------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   actor_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class actor_ent
local actor_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'actor_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = actor_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local map_unit = map_unit
local actor_unit = actor_unit
local local_player = local_player
local actor_ctx = actor_ctx
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function actor_ent.super_preload()

end

---- 通过NPC名字获取NPCid
--function actor_ent.get_npc_id_by_name(npc_name)
--    local npc_id = 0
--    local list = map_unit.list(0)
--    for i = 1, #list
--    do
--        local obj = list[i]
--        if map_ctx:init(obj) then
--            if map_ctx:name() == npc_name then
--                npc_id = map_ctx:id()
--                break
--            end
--        end
--    end
--    return npc_id
--end

-- 通过NPC名字获取NPCid
function actor_ent.get_npc_id_by_name(npc_name)
    local npc_id = 0
    -- 周边NPC
    local actor_list = actor_unit.list(2)
    for i = 1, #actor_list
    do
        local obj = actor_list[i]
        if actor_ctx:init(obj) then
            if npc_name == actor_ctx:name() then
                npc_id = actor_ctx:res_id() or 0
                break
            end
        end
    end
    return npc_id
end

-- 通过采集物res_id获取采集物信息
function actor_ent.get_gather_info_by_res_id(res_id,gather)
    local actor_info_list = {}
    local actor_list = actor_unit.list(4)
    for i = 1, #actor_list do
        local obj = actor_list[i]
        if actor_ctx:init(obj) then
            local can_gather = true
            -- 不是指定的采集物
            if actor_ctx:res_id() ~= res_id then
                can_gather = false
            end
            -- 被其他玩家采集中
            if can_gather and actor_ctx:gather_player_id() ~= 0 then
                can_gather = false
            end
            -- 不能移动过去的位置
            if can_gather and not actor_ctx:can_moveto(true) then
                if not gather then
                    can_gather = false
                end

            end
            -- 不可采集的
            if can_gather and not actor_ctx:can_gather() then
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
                    dist = actor_ctx:dist(),
                }
                table.insert(actor_info_list,actor_info)
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



--获取周围怪物_距离排序
function actor_ent.get_near_mon_5list(kill_dist, max_level_mon)
    local r_table = {}
    kill_dist = kill_dist or 99999
    max_level_mon = max_level_mon or 999
    local list = actor_unit.list(3)
    local max_z = this.get_max_z()
    local my_z = local_player:cz()
    for i = 1, #list
    do
        local obj = list[i]
        if actor_ctx:init(obj) then
            local cx = actor_ctx:cx()
            local cy = actor_ctx:cy()
            local cz = actor_ctx:cz()
            local name = actor_ctx:name()
            local level = actor_ctx:level()
            local sys_id = actor_ctx:sys_id()
            local dist = actor_ctx:dist()
            local read = true
            if read and sys_id == -1 then
                read = false
            end
            if read and actor_ctx:dead() then
                read = false
            end
            if read and dist > kill_dist then
                read = false
            end
            if read and math.abs(my_z - cz) > max_z then
                read = false
            end

            if read and level > max_level_mon then
                read = false
            end
            if read and this.is_aberrant_mon(name) then
                read = false
            end

            if read then
                table.insert(r_table, { sys_id = sys_id, hp = actor_ctx:hp(), dist = dist, cx = cx, cy = cy })
            end
        end
    end
    local r_table1 = {}
    if #r_table > 0 then
        table.sort(r_table, function(a, b)
            return a.dist < b.dist
        end)
        local idx = 1
        for i = 1, #r_table do
            r_table1[idx] = r_table[i].sys_id
            idx = idx + 1
            if idx >= 5 then
                break
            end
        end
    end
    return r_table1
end


function actor_ent.is_aberrant_mon(name)
    local monster = { '黑铁', '岩石陷阱' }
    for i = 1, #monster do
        if string.find(name, monster[i]) ~= nil then
            return true
        end
    end
    return false
end

function actor_ent.get_max_z()
    local mapId = actor_unit.map_id()
    if mapId == 201003010 or mapId == 201003011 or mapId == 201003012 then
        return 500
    end
    return 450
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function actor_ent.__tostring()
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
function actor_ent.__newindex(t, k, v)
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
actor_ent.__index = actor_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function actor_ent:new(args)
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
    return setmetatable(new, actor_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return actor_ent:new()

-------------------------------------------------------------------------------------
