------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   dungeon_ent
--- @describe: 副本模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class dungeon_ent
local dungeon_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'dungeon_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = dungeon_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local quest_unit = quest_unit
local actor_unit = actor_unit
local local_player = local_player
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function dungeon_ent.super_preload()

end

--判断是否在魔方中
function dungeon_ent.in_mf_map()
    local ret = false
    local map_name = actor_unit.map_name()
    if string.find(map_name,'魔方') or string.find(map_name,'之屋') then
        ret = true
    end
    return ret
end

--判断是否在经验层
function dungeon_ent.in_exp_map()
    local ret = false
    local map_name = actor_unit.map_name()
    local combat_power = actor_unit.char_combat_power()
    if combat_power >= 40000 then
        if string.find(map_name,'训练之屋') then
            ret = true
        end
    elseif combat_power >= 28000 then
        if string.find(map_name,'训练之屋') and map_name ~= '【1层】训练之屋Ⅲ' then
            ret = true
        end
    else
        if map_name == '【1层】训练之屋Ⅰ' then
            ret = true
        end
    end
    return ret
end


function dungeon_ent.dungeon_mf()
    if dungeon_ent.in_mf_map() then
        if dungeon_ent.in_exp_map() then
            if local_player:auto_type() ~= 2 then
                actor_unit.set_auto_type(2)
                decider.sleep(1000)
            else
                trace.output('魔方【'..actor_unit.map_name()..'】刷怪中...')
            end

            if quest_unit.square_can_enter(0x65) then
                --quest_unit.mofang_add_time()
                --xxmsg('加时间')
                --decider.sleep(1000)
            end
        else
            if quest_unit.aquare_can_next_map() then
                quest_unit.mofang_next_map()
                decider.sleep(1000)
                trace.output('魔方换图')
            else
                trace.output('等待魔方换图中...当前['..actor_unit.map_name()..']')
            end
        end
    else
        local mf_id = 0x65
        if actor_unit.char_combat_power() >= 26200 then
            mf_id = 0x66
        end
        if quest_unit.square_can_enter(mf_id) then
            quest_unit.enter_mofang(mf_id)
            decider.sleep(1000)
            for i = 1, 10 do
                if dungeon_ent.in_mf_map() then
                    break
                end
                trace.output('进入魔方中...'..i)
                decider.sleep(1000)
            end
        end
    end
end



------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function dungeon_ent.__tostring()
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
function dungeon_ent.__newindex(t, k, v)
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
dungeon_ent.__index = dungeon_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function dungeon_ent:new(args)
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
    return setmetatable(new, dungeon_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return dungeon_ent:new()

-------------------------------------------------------------------------------------
