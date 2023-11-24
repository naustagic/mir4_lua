------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   switch_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class switch_ent
local switch_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'switch_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = switch_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local skill_unit = skill_unit
local local_player = local_player
local quest_unit = quest_unit
---@type quest_ent
local quest_ent = import('game/entities/quest_ent')
---@type dungeon_ent
local dungeon_ent = import('game/entities/dungeon_ent')
---@type quest_res
local quest_res = import('game/resources/quest_res')
---@type gather_ent
local gather_ent = import('game/entities/gather_ent')
---@type secret_ent
local secret_ent = import('game/entities/secret_ent')
---@type transfer_ent
local transfer_ent = import('game/entities/transfer_ent')


------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function switch_ent.super_preload()

end

-- 是否主线
function switch_ent.main_task()
    local main_quest_idx = 0
    local main_quest_list = quest_res.MAIN_QUEST
    local main_task_idx = quest_unit.get_main_quest_idx()
    -- 主线任务名称
    local main_task_name = quest_unit.get_main_quest_name()
    for i = 1, #main_quest_list do
        if main_quest_list[i].name == main_task_name then
            main_quest_idx = i
            break
        end
    end
    if main_quest_idx > 30 or main_quest_idx == 0 then
        return false
    elseif main_quest_idx == 30 and main_task_idx >= 6 then
        return false
    end
    return true
end

-- 是否支线
function switch_ent.side_task()
    if local_player:level() >= 40 then
        return false
    end
    if #quest_unit.list(0) >= 1 then
        return true
    end
    local side_quest_name_list = quest_res.get_side_name_list()
    if quest_ent.have_side_quest(side_quest_name_list) then
        return true
    end
    return false
end

-- 是否魔方
function switch_ent.mf_fb()
    if local_player:level() >= 40 then
        return false
    end
    if local_player:level() < 28 then
        return false
    end
    if dungeon_ent.in_mf_map() then
        return true
    end

    if quest_unit.square_can_enter(0x65) then
        return true
    end

    return false
end

-- 是否秘境峰
function switch_ent.secret_fb()
    if local_player:level() >= 40 then
        return false
    end
    if local_player:level() < 32 then
        return false
    end
    if '秘境峰1层' == actor_unit.map_name() then
        return true
    end
    if secret_ent.check_qualification() then
        return true
    end

    return false
end

function switch_ent.weituo_task()
    if local_player:level() >= 40 then
        return false
    end
    if quest_ent.can_do_weituo_quest() then
        return true
    end
    local weituo_quest_name_list = quest_res.get_weituo_name_list()
    if quest_ent.can_acc_weituo_quest(weituo_quest_name_list) then
        return true
    end

    return false
end

-- 采集
function switch_ent.gather_quest()
    if local_player:level() >= 40 then
        return false
    end
    local side_quest_name_list = quest_res.GATHER_QUEST
    if gather_ent.can_do_side_quest(side_quest_name_list) then
        return true
    end
    if gather_ent.can_acc_side_quest(side_quest_name_list) then
        return true
    end
    return false
end

function switch_ent.gather()

    if transfer_ent.is_warehouse_player() then
        return false
    end
    if local_player:level() < 40 then
        return false
    end
    return true
end




------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function switch_ent.__tostring()
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
function switch_ent.__newindex(t, k, v)
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
switch_ent.__index = switch_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function switch_ent:new(args)
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
    return setmetatable(new, switch_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return switch_ent:new()

-------------------------------------------------------------------------------------
