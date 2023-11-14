------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   skill_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class skill_ent
local skill_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'skill_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = skill_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local skill_unit = skill_unit
local skill_ctx = skill_ctx
local local_player = local_player
local actor_unit = actor_unit
---@type item_ent
local item_ent = import('game/entities/item_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function skill_ent.super_preload()

end

-- 升级技能




-- 学习技能
function skill_ent.study_skill()
    local skill_list = {
        ['漫天花雨'] = {},
        ['速射'] = {},
        ['疾风腿'] = {},
        ['幻影矢'] = {},
        ['爆热弹'] = {},
        ['闪光矢'] = {},
        ['天飞弓'] = {},
        ['心眼'] = {},
        ['冰牢'] = {},
        ['破功歼'] = {},
        ['毒雾弹'] = {},
        ['追魂箭'] = {},
        ['隐身术'] = {},

    }
    local my_level = local_player:level()
    local list = skill_unit.list(-1)
    for i = 1, #list do
        local obj = list[i]
        if skill_ctx:init(obj) and skill_ctx:   () > 0 then
            local skill_name = skill_ctx:name()
            if skill_list[skill_name] then
                local skill_id = skill_ctx:id()
                if skill_unit.get_study_skill_obj_byid(skill_id) == 0 and my_level >= skill_ctx:study_level() then
                    skill_unit.study(skill_id)
                    trace.output('激活技能[' .. skill_name .. ']')
                    decider.sleep(1000)
                end
            end
        end
    end
end

-- 升级技能
function skill_ent.up_skill()
    if actor_unit.get_cost_data(2) < 64000 then
        return
    end
    local skill_list = {
        ['漫天花雨'] = {},
        ['速射'] = {},
        ['疾风腿'] = {},
        ['幻影矢'] = {},
        ['爆热弹'] = {},
        ['闪光矢'] = {},
        ['天飞弓'] = {},
        ['心眼'] = {},
        ['冰牢'] = {},
        ['破功歼'] = {},
        ['毒雾弹'] = {},
        ['追魂箭'] = {},
        ['隐身术'] = {},

    }
    local my_level = local_player:level()
    for name, info in pairs(skill_list) do
        while decider.is_working() do
            local skill_info = skill_ent.get_skill_info_by_name(name, 0)
            if table.is_empty(skill_info) then
                break
            end
            if actor_unit.get_cost_data(2) < 64000 then
                return
            end
            if skill_info.study_level > my_level then
                break
            end
            if skill_info.level >= 4 then
                break
            end
            local need_num = 2
            if skill_info.level == 2 then
                need_num = 3
            elseif skill_info.level == 3 then
                need_num = 4
            end
            local item_num = item_ent.get_item_num_by_name('高级武功秘籍')
            if item_num < need_num then
                break
            end
            skill_unit.up(skill_info.id)
            trace.output('升级技能[' .. name .. ']')
            decider.sleep(1000)
            for i = 1, 10 do
                if item_num ~= item_ent.get_item_num_by_name('高级武功秘籍') then
                    break
                end
                decider.sleep(1000)
            end
        end
    end
end

-- 强化技能
function skill_ent.enhanced_skill()
    if actor_unit.get_cost_data(2) < 64000 then
        return
    end
    local skill_list = {
        ['漫天花雨'] = {},
        ['速射'] = { enhanced = '稀有速射武功秘境' },
        ['疾风腿'] = { enhanced = '稀有疾风腿武功秘境' },
        ['幻影矢'] = { enhanced = '稀有幻影矢武功秘境' },
        ['爆热弹'] = { enhanced = '稀有爆热弹武功秘境' },
        ['闪光矢'] = { enhanced = '稀有闪光矢武功秘境' },
        ['天飞弓'] = { enhanced = '稀有天飞弓武功秘境' },
        ['心眼'] = { enhanced = '稀有心眼武功秘境' },
        ['冰牢'] = { enhanced = '稀有冰牢武功秘境' },
        ['破功歼'] = { enhanced = '稀有破功歼武功秘境' },
        ['毒雾弹'] = { enhanced = '稀有毒雾弹武功秘境' },
        ['追魂箭'] = { enhanced = '稀有追魂箭武功秘境' },
        ['隐身术'] = { enhanced = '稀有隐身术武功秘境' },

    }
    local my_level = local_player:level()
    for name, info in pairs(skill_list) do
        while decider.is_working() do
            if not info.enhanced then
                break
            end
            local skill_info = skill_ent.get_skill_info_by_name(name, 0)
            if table.is_empty(skill_info) then
                break
            end
            if actor_unit.get_cost_data(2) < 64000 then
                return
            end
            if skill_info.study_level > my_level then
                break
            end
            if skill_info.level < 4 then
                break
            end
            if skill_info.level >= 7 then
                break
            end
            local need_num = 1
            if skill_info.level == 5 then
                need_num = 2
            elseif skill_info.level == 6 then
                need_num = 3
            end
            local item_num = item_ent.get_item_num_by_name(info.enhanced)
            if item_num < need_num then
                break
            end
            skill_unit.up(skill_info.id)

            decider.sleep(1000)
            for i = 1, 10 do
                trace.output('强化技能[' .. name .. ']'..i)
                if item_num ~= item_ent.get_item_num_by_name(info.enhanced) then
                    break
                end
                decider.sleep(1000)
            end
        end
    end
end

-- 设置技能到快捷栏
function skill_ent.config_skill()

    local skill_list = {
        ['漫天花雨'] = {config_skill = false},
        ['速射'] = { enhanced = '稀有速射武功秘境',config_skill = true },
        ['疾风腿'] = { enhanced = '稀有疾风腿武功秘境' ,config_skill = true},
        ['幻影矢'] = { enhanced = '稀有幻影矢武功秘境',config_skill = true },
        ['爆热弹'] = { enhanced = '稀有爆热弹武功秘境' ,config_skill = true},
        ['闪光矢'] = { enhanced = '稀有闪光矢武功秘境' ,config_skill = true},
        ['天飞弓'] = { enhanced = '稀有天飞弓武功秘境',config_skill = true },
        ['心眼'] = { enhanced = '稀有心眼武功秘境' ,config_skill = true},
        ['冰牢'] = { enhanced = '稀有冰牢武功秘境' ,config_skill = true},
        ['破功歼'] = { enhanced = '稀有破功歼武功秘境' ,config_skill = true},
        ['毒雾弹'] = { enhanced = '稀有毒雾弹武功秘境' ,config_skill = true},
        ['追魂箭'] = { enhanced = '稀有追魂箭武功秘境' ,config_skill = true},
        ['隐身术'] = { enhanced = '稀有隐身术武功秘境' ,config_skill = true},

    }
    local list = skill_unit.list(0)
    for i = 1, #list do
        local obj = list[i]
        if skill_ctx:init(obj) then
            local skill_name = skill_ctx:name()
            if skill_list[skill_name] and skill_list[skill_name].config_skill then
                local skill_id = skill_ctx:id()
                if not skill_unit.skill_is_config(skill_id) then
                    skill_unit.set_skill_deck_ex(skill_id)
                    trace.output('激活技能[' .. skill_name .. ']到快捷栏')
                    decider.sleep(1000)
                end
            end
        end
    end
end


--通过技能名称获取技能信息
skill_ent.get_skill_info_by_name = function(name, action)
    local skill_info = {}
    action = action or -1
    local list = skill_unit.list(action)
    for i = 1, #list
    do
        local obj = list[i]
        if skill_ctx:init(obj) and skill_ctx:name() == name then
            skill_info = {
                obj = obj,
                id = skill_ctx:id(),
                name = name,
                level = skill_ctx:level(),
                study_level = skill_ctx:study_level(),
                action_num = skill_ctx:action_num(), -- 行为数量.. 有几个行为不可以发几次
                first_action = skill_ctx:get_action_byidx(0), -- 第一个行为
            }
            break
        end
    end

    return skill_info
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function skill_ent.__tostring()
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
function skill_ent.__newindex(t, k, v)
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
skill_ent.__index = skill_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function skill_ent:new(args)
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
    return setmetatable(new, skill_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return skill_ent:new()

-------------------------------------------------------------------------------------
