------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   training_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class training_ent
local training_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'training_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = training_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local skill_unit = skill_unit
local force_unit = force_unit
local actor_unit = actor_unit
local main_ctx = main_ctx
---@type item_ent
local item_ent = import('game/entities/item_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function training_ent.super_preload()
    --training_ent.force()
    --training_ent.physical()
end

-- 内功
function training_ent.force()
    local inner_skill_num = force_unit.get_inner_skill_num()
    for i = 0, inner_skill_num - 1 do
        while decider.is_working() do
            local skill_name = force_unit.get_inner_skill_name(i)
            local skill_id = force_unit.get_inner_skill_id(i)
            -- 判断内功是否可以解锁
            if force_unit.inner_skill_can_study(i) then
                trace.output('激活内功[' .. skill_name .. ']')
                force_unit.unlock_inner_skill(skill_id) -- 解锁
                decider.sleep(1000)
            end
            -- 判断内功是否激活
            if force_unit.inner_skill_is_study(i) then
                -- 取内功等级
                local inner_level = force_unit.get_inner_level(skill_id)
                -- 可升等级
                local can_up_level = inner_level * 5
                local num = 0
                for j = 0, 3 do
                    while decider.is_working() do
                        -- 体质小项等级
                        local mastery_level = force_unit.get_force_child_level(skill_id, j)
                        if mastery_level < can_up_level then
                            if force_unit.force_can_update(skill_id, j) and actor_unit.get_cost_data(0xB) >= 500 then
                                force_unit.train_inner_skill(skill_id, j)
                                trace.output('升级内功[' .. skill_name .. ']第[' .. j .. ']项中...')
                                decider.sleep(1000)
                                main_ctx:do_skey(0x1B)
                            else
                                break
                            end
                        else
                            break
                        end
                        decider.sleep(1000)
                    end
                    if force_unit.get_force_child_level(skill_id, j) >= can_up_level then
                        num = num + 1
                    end
                end
                if num >= 4 then
                    -- 升阶功法
                    if training_ent.can_up_force(skill_id) then
                        trace.output('升阶内功[' .. skill_name .. ']中...')
                        force_unit.inner_update(i)
                        decider.sleep(1000)
                        force_unit.inner_refresh(skill_id)
                        decider.sleep(1000)
                        main_ctx:do_skey(0x1B)
                    else
                        break
                    end
                else
                    break
                end
            else
                break
            end
            decider.sleep(1000)
        end
    end
end

-- 体质
function training_ent.physical()
    local physical_list = {
        ['物理防御'] = { idx = 1 },
        ['法术防御'] = { idx = 1 },
        ['生命值'] = { idx = 1 },
        ['魔力'] = { idx = 1 },
        ['回避'] = { idx = 1 },
        ['命中'] = { idx = 1 },
        ['物理攻击'] = { idx = 1 },
    }
    while decider.is_working() do

        -- 体质等级
        local can_up_level = force_unit.get_mastery_main_level() * 5
        local up_num = 0
        for name, info in pairs(physical_list) do
            local idx = info.idx
            while decider.is_working() do
                -- 体质小项等级
                local mastery_level = force_unit.get_mastery_level_byid(idx)
                if mastery_level < can_up_level then
                    if force_unit.mastery_can_update(idx) and actor_unit.get_cost_data(0xB) >= 500 then
                        skill_unit.sta_training(idx)
                        trace.output('升级体质[' .. name .. ']中...')
                        decider.sleep(1000)

                    else
                        break
                    end
                else
                    break
                end
                decider.sleep(1000)
            end
            if force_unit.get_mastery_level_byid(idx) >= can_up_level then
                up_num = up_num + 1
            end
        end
        if up_num >= 7 and training_ent.can_up_physical() then
            force_unit.mastery_update()  --体质升阶
            trace.output('体质升阶中...')
            decider.sleep(1000)
        else
            break
        end
        decider.sleep(1000)
    end
end


-- 是否可升体质
function training_ent.can_up_physical()
    local mastery_main_level = force_unit.get_mastery_main_level()
    if mastery_main_level >= 4 then
        return false
    end
    local need_item_list = {
        [1] = {
            item1 = { name = '月光魔石', num = 10 },
            item2 = { name = '青魔鬼石', num = 10 },
            item3 = { name = '净化水', num = 5 },
            item4 = { name = '善隣丸', num = 2 },
            need_type = '',
        },
        [2] = {
            item1 = { name = '月光魔石', num = 10 },
            item2 = { name = '青魔鬼石', num = 10 },
            item3 = { name = '净化水', num = 5 },
            item4 = { name = '善隣丸', num = 2 },
            need_type = '高级',
        },
        [3] = {
            item1 = { name = '月光魔石', num = 30 },
            item2 = { name = '青魔鬼石', num = 30 },
            item3 = { name = '净化水', num = 15 },
            item4 = { name = '善隣丸', num = 6 },
            need_type = '高级',
        },

    }
    local need_type = need_item_list[mastery_main_level].need_type
    local item1_name = need_item_list[mastery_main_level].item1.name
    local item1_num = need_item_list[mastery_main_level].item1.num
    if item_ent.get_item_num_by_name(need_type .. item1_name) < item1_num then
        return false
    end
    local item2_name = need_item_list[mastery_main_level].item2.name
    local item2_num = need_item_list[mastery_main_level].item2.num
    if item_ent.get_item_num_by_name(need_type .. item2_name) < item2_num then
        return false
    end

    local item3_name = need_item_list[mastery_main_level].item3.name
    local item3_num = need_item_list[mastery_main_level].item3.num
    if item_ent.get_item_num_by_name(need_type .. item3_name) < item3_num then
        return false
    end

    local item4_name = need_item_list[mastery_main_level].item4.name
    local item4_num = need_item_list[mastery_main_level].item4.num
    if item_ent.get_item_num_by_name(need_type .. item4_name) < item4_num then
        return false
    end
    return true
end

-- 是否可升级体质
function training_ent.can_up_force(skill_id)
    local inner_level = force_unit.get_inner_level(skill_id)
    if inner_level >= 4 then
        return false
    end

    local need_item_list = {
        [1] = {
            item1 = { name = '月光魔石', num = 10 },
            item2 = { name = '青魔鬼石', num = 10 },
            item3 = { name = '净化水', num = 5 },
            item4 = { name = '善隣丸', num = 3 },
            need_type = '高级',
        },
        [2] = {
            item1 = { name = '月光魔石', num = 30 },
            item2 = { name = '青魔鬼石', num = 30 },
            item3 = { name = '净化水', num = 15 },
            item4 = { name = '善隣丸', num = 6 },
            need_type = '高级',
        },
        [3] = {
            item1 = { name = '月光魔石', num = 30 },
            item2 = { name = '青魔鬼石', num = 30 },
            item3 = { name = '净化水', num = 15 },
            item4 = { name = '善隣丸', num = 6 },
            need_type = '稀有',
        },

    }
    local need_type = need_item_list[inner_level].need_type
    local item1_name = need_item_list[inner_level].item1.name
    local item1_num = need_item_list[inner_level].item1.num
    if item_ent.get_item_num_by_name(need_type .. item1_name) < item1_num then
        return false
    end
    local item2_name = need_item_list[inner_level].item2.name
    local item2_num = need_item_list[inner_level].item2.num
    if item_ent.get_item_num_by_name(need_type .. item2_name) < item2_num then
        return false
    end

    local item3_name = need_item_list[inner_level].item3.name
    local item3_num = need_item_list[inner_level].item3.num
    if item_ent.get_item_num_by_name(need_type .. item3_name) < item3_num then
        return false
    end

    local item4_name = need_item_list[inner_level].item4.name
    local item4_num = need_item_list[inner_level].item4.num
    if item_ent.get_item_num_by_name(need_type .. item4_name) < item4_num then
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
function training_ent.__tostring()
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
function training_ent.__newindex(t, k, v)
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
training_ent.__index = training_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function training_ent:new(args)
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
    return setmetatable(new, training_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return training_ent:new()

-------------------------------------------------------------------------------------
