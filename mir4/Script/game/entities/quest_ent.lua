------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   quest_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class quest_ent
local quest_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'quest_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = quest_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local func = func
local quest_unit = quest_unit
local actor_unit = actor_unit
local ui_unit = ui_unit
local game_unit = game_unit
local local_player = local_player
local quest_ctx = quest_ctx
---@type gather_ent
local gather_ent = import('game/entities/gather_ent')
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
---@type training_ent
local training_ent = import('game/entities/training_ent')
---@type equip_ent
local equip_ent = import('game/entities/equip_ent')
---@type quest_res
local quest_res = import('game/resources/quest_res')
---@type revive_ent
local revive_ent = import('game/entities/revive_ent')

---@type map_res
local map_res = import('game/resources/map_res')

local main_ctx = main_ctx

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function quest_ent.super_preload()
    this.wi_auto_main_quest = decider.run_interval_wrapper('开启自动主线', this.auto_main_quest, 1000 * 5)
    this.wi_auto_side_quest = decider.run_interval_wrapper('开启自动支线', this.auto_side_quest, 1000 * 5)
end

------------------------------------------------------------------------------------
-- [行为] 做主线
------------------------------------------------------------------------------------
function quest_ent.do_main_task()
    revive_ent.revive_player()
    -- 主线任务名称
    local main_task_name = quest_unit.get_main_quest_name()
    -- 主线任务序号
    local main_task_idx = quest_unit.get_main_quest_idx()
    -- 主线任务类型
    local main_quest_type = quest_unit.main_quest_type()
    map_ent.escape_for_recovery()
    quest_ent.skip_game()
    local str = string.format('[主线-%s] %s 类型%s', main_task_idx, main_task_name, main_quest_type)
    if '漆黑的密道' == main_task_name and main_task_idx == 0 then
        local break_func = function()
            if quest_unit.get_main_quest_name() ~= '漆黑的密道' then
                return true
            end
            if quest_unit.get_main_quest_idx() ~= 0 then
                return true
            end
            quest_ent.skip_game()
            return false
        end

        map_ent.auto_move(nil,30851,72267, 9071, str, 100, nil, break_func)

    elseif '危险的救援计划' == main_task_name and main_task_idx == 8 then
        main_ctx:post_key(65, 1)
        decider.sleep(1000)
        main_ctx:post_key(65, 0)
    elseif '追踪痕迹' == main_task_name and main_task_idx == 11 then
        skill_ent.up_skill(true)
    elseif '黑暗之影' == main_task_name and main_task_idx == 7 then
        training_ent.physical(true)
    elseif '寻求灵药' == main_task_name and main_task_idx == 6 then
        training_ent.force()
    elseif '寻求灵药' == main_task_name and main_task_idx == 8 then
        equip_ent.build_equip_1('丝绸衣上衣')
        equip_ent.auto_use_equip()
    elseif '绑架的背后' == main_task_name and main_task_idx == 8 then
        equip_ent.auto_equip()
    elseif '江湖缘分' == main_task_name and main_task_idx == 23 then
        training_ent.auto_training()
    else
        if quest_unit.main_is_auto() then
            -- 如果当前地图与主线地图不一样
            map_ent.teleport_map(quest_unit.main_quest_map_id())
            if quest_unit.is_in_monster_smite() then
                if not quest_unit.super_man then
                    quest_unit.super_man = true
                    actor_unit.enable_super_man(true)--开启或关闭剧情中无敌
                    decider.sleep(1000)
                end

            else
                if quest_unit.super_man then
                    quest_unit.super_man = false
                    actor_unit.enable_super_man(false)--开启或关闭剧情中无敌
                    decider.sleep(1000)
                end
            end
            if quest_unit.main_quest_type() > 10 then
                if quest_unit.main_quest_map_id() == actor_unit.map_id() then
                    if local_player:status() ~= 4 and local_player:status() ~= 14 then
                        local can_gather = false
                        if '师父的决断' == main_task_name and main_task_idx == 4 then
                            can_gather = true
                        elseif '寻找龙身' == main_task_name and main_task_idx == 6 then
                            can_gather = true
                        elseif '寻找龙身' == main_task_name and main_task_idx == 11 then
                            can_gather = true
                        elseif '寻找龙身' == main_task_name and main_task_idx == 21 then
                            can_gather = true
                        elseif '芊菲的下落Ⅰ' == main_task_name and main_task_idx == 10 then
                            can_gather = true
                        elseif '牛魔神殿的怪事' == main_task_name and main_task_idx == 17 then
                            can_gather = true
                        end
                        local gather_info = actor_ent.get_gather_info_by_res_id(quest_unit.main_quest_type(), can_gather)
                        if not table.is_empty(gather_info) then
                            local dist = 300
                            if func.is_rang_by_point(local_player:cx(), local_player:cy(), gather_info.cx, gather_info.cy, dist) then
                                actor_unit.gather_ex(gather_info.sys_id)
                                decider.sleep(1000)
                            else
                                map_ent.auto_move(nil, gather_info.cx, gather_info.cy, gather_info.cz, str, dist)
                            end
                        else
                            str = string.format('[主线-%s] %s 无法获取采集物信息..', main_task_idx, main_task_name)
                        end
                    else
                        str = string.format('[主线-%s] %s 采集中..', main_task_idx, main_task_name)
                    end
                else
                    str = string.format('[主线-%s] %s 类型%s 移到到任务地图', main_task_idx, main_task_name, main_quest_type)
                end
            end
            if map_ent.move_lag(100) and 2 == local_player:status() then

                if '寻求灵药' == main_task_name and main_task_idx == 22 and quest_unit.main_quest_map_id() == actor_unit.map_id() then
                    actor_unit.fast_move(quest_unit.main_quest_tx(), quest_unit.main_quest_ty(), quest_unit.main_quest_tz())
                    decider.sleep(1000)
                    for i = 1, 10 do
                        if func.is_rang_by_point(local_player:cx(), local_player:cy(), quest_unit.main_quest_tx(), quest_unit.main_quest_ty(), 300) then
                            break
                        end
                        decider.sleep(1000)
                    end
                else
                    quest_ent.wi_auto_main_quest()
                    --  quest_unit.auto(quest_unit.get_main_quest_id(), 0)
                end
            end
        else
            local auto_main_quest = true
            if '绑架的背后' == main_task_name and main_task_idx == 6 then
                if quest_unit.main_quest_map_id() == actor_unit.map_id() then
                    if func.is_rang_by_point(local_player:cx(), local_player:cy(), quest_unit.main_quest_tx(), quest_unit.main_quest_ty(), 1000) then
                        auto_main_quest = false
                        if local_player:auto_type() ~= 3 then
                            actor_unit.set_auto_type(3)
                            decider.sleep(1000)
                        end
                    elseif func.is_rang_by_point(local_player:cx(), local_player:cy(), quest_unit.main_quest_tx(), quest_unit.main_quest_ty(), 15000) then
                        if local_player:auto_type() == 3 then
                            auto_main_quest = false
                        end
                    end
                end
            end
            if auto_main_quest then
                quest_ent.wi_auto_main_quest()
                decider.sleep(1000)
            end

        end
    end
    trace.output(str)
end

--点击自动主线
function quest_ent.auto_main_quest()
    quest_unit.auto_main_quest()
end

--点击自动支线线
function quest_ent.auto_side_quest(task_id, on)
    quest_unit.auto(task_id, on)
end

------------------------------------------------------------------------------------
-- [行为] 支线任务
------------------------------------------------------------------------------------
function quest_ent.do_side_task(side_quest_name_list)
    revive_ent.revive_player()
    map_ent.escape_for_recovery()
    quest_ent.skip_game()
    -- 接任务
    quest_ent.acc_side_quest(side_quest_name_list)
    -- 做任务
    local side_task_info = quest_ent.do_side_quest()
    if not table.is_empty(side_task_info) then

        if side_task_info.name == '以牙还牙' then
            side_task_info.map_id = 101003020
        end
        map_ent.teleport_map(side_task_info.map_id)
        if quest_unit.quest_is_auto(side_task_info.id) then
            if func.is_rang_by_point(local_player:cx(), local_player:cy(), side_task_info.cx, side_task_info.cy, 10000) then
                local str = string.format('[支线] %s 进度[%s/%s]', side_task_info.name, side_task_info.tar_num, side_task_info.tar_max_num)
                trace.output(str)
            else
                local str = string.format('[支线] 去 %s ', side_task_info.name, side_task_info.tar_num, side_task_info.tar_max_num)
                trace.output(str)
            end
            if map_ent.move_lag(100) and 2 == local_player:status() then
                quest_ent.wi_auto_side_quest(side_task_info.id, 0)
            end
        else
            quest_ent.wi_auto_side_quest(side_task_info.id, 1)
            decider.sleep(1000)
        end
    end
    -- 交支线
    quest_ent.sub_side_quest()
    -- 删除支线
    quest_ent.del_side_quest(side_quest_name_list)
end

-- 是否有可接的支线任务
function quest_ent.have_side_quest(side_quest_name_list)
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
                if combat_power / my_combat_power > 0.95 then
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
                return true
            end
        end
    end
    return false
end


-- 接支线任务
function quest_ent.acc_side_quest(side_quest_name_list)
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
                if combat_power / my_combat_power > 0.95 then
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
function quest_ent.do_side_quest()
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
function quest_ent.sub_side_quest()
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
function quest_ent.del_side_quest(side_quest_name_list)
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
                if combat_power / my_combat_power > 0.95 then
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

------------------------------------------------------------------------------------
-- [行为] 奇缘任务
------------------------------------------------------------------------------------
function quest_ent.do_relation_task()

end

------------------------------------------------------------------------------------
-- [行为] 委托任务
------------------------------------------------------------------------------------
function quest_ent.do_weituo_task()
    revive_ent.revive_player()
    map_ent.escape_for_recovery()
    -- 接任务
    local weituo_quest_name_list = quest_res.get_weituo_name_list()
    quest_ent.acc_weituo_quest(weituo_quest_name_list)
    -- 做任务
    local weituo_quest = quest_ent.do_weituo_quest()
    if not table.is_empty(weituo_quest) then
        map_ent.teleport_map(weituo_quest.map_id)
        if weituo_quest.name == '宝物的气息' or weituo_quest.name == '勉强的工作' or '莫夜的宝物' == weituo_quest.name or '底层人的隐情' == weituo_quest.name then
            if map_ent.move_lag(100) and 2 == local_player:status() then
                actor_unit.fast_move(weituo_quest.cx, weituo_quest.cy, weituo_quest.cz)
            end
            gather_ent.test(weituo_quest)
        elseif weituo_quest.name == '为了出人头地' or weituo_quest.name == '长生不老材料' or weituo_quest.name == '狂人的痕迹' then
            if weituo_quest.map_id == actor_unit.map_id() then
                local gather_info = actor_ent.get_gather_info_by_res_id(weituo_quest.entrust_gather_resid, true)
                if not table.is_empty(gather_info) then
                    local dist = 300
                    if func.is_rang_by_point(local_player:cx(), local_player:cy(), gather_info.cx, gather_info.cy, dist) then
                        actor_unit.gather_ex(gather_info.sys_id)
                        decider.sleep(4000)
                    else
                        actor_unit.fast_move(gather_info.cx, gather_info.cy, gather_info.cz)
                        decider.sleep(1000)
                    end
                else
                    if quest_unit.quest_is_auto(weituo_quest.id) then
                        if map_ent.move_lag(100) and 2 == local_player:status() then
                            quest_ent.wi_auto_side_quest(weituo_quest.id, 0)
                            actor_unit.fast_move(weituo_quest.cx, weituo_quest.cy, weituo_quest.cz)
                        end
                    else
                        quest_ent.wi_auto_side_quest(weituo_quest.id, 1)
                    end
                end
            else
                if quest_unit.quest_is_auto(weituo_quest.id) then
                    if map_ent.move_lag(100) and 2 == local_player:status() then
                        quest_ent.wi_auto_side_quest(weituo_quest.id, 0)
                    end
                else
                    quest_ent.wi_auto_side_quest(weituo_quest.id, 1)
                end
            end
            local gather_info = actor_ent.get_gather_info_by_res_id(weituo_quest.entrust_gather_resid, true)
            if not table.is_empty(gather_info) then
                if map_ent.move_lag(100) and 2 == local_player:status() then
                    local dist = 300
                    if func.is_rang_by_point(local_player:cx(), local_player:cy(), gather_info.cx, gather_info.cy, dist) then
                        actor_unit.gather_ex(gather_info.sys_id)
                        decider.sleep(1000)
                    else
                        actor_unit.fast_move(gather_info.cx, gather_info.cy, gather_info.cz)
                        decider.sleep(1000)
                    end
                end
            end
        else
            if quest_unit.quest_is_auto(weituo_quest.id) then
                if func.is_rang_by_point(local_player:cx(), local_player:cy(), weituo_quest.cx, weituo_quest.cy, 1000) then
                    local str = string.format('[支线] %s 进度[%s/%s]', weituo_quest.name, weituo_quest.tar_num, weituo_quest.tar_max_num)
                    trace.output(str)
                else
                    local str = string.format('[支线] 去 %s ', weituo_quest.name)
                    trace.output(str)
                end
                if weituo_quest.entrust_gather_resid > 10 then
                    local gather_info = actor_ent.get_gather_info_by_res_id(weituo_quest.entrust_gather_resid, true)
                    if not table.is_empty(gather_info) then
                        if map_ent.move_lag(100) and 2 == local_player:status() then
                            local dist = 300
                            if func.is_rang_by_point(local_player:cx(), local_player:cy(), gather_info.cx, gather_info.cy, dist) then
                                actor_unit.gather_ex(gather_info.sys_id)
                                decider.sleep(1000)
                            else
                                actor_unit.fast_move(gather_info.cx, gather_info.cy, gather_info.cz)
                                decider.sleep(1000)
                            end
                        end
                    else
                        quest_ent.wi_auto_side_quest(weituo_quest.id, 0)
                    end

                else
                    if map_ent.move_lag(100) and 2 == local_player:status() then
                        quest_ent.wi_auto_side_quest(weituo_quest.id, 0)
                        actor_unit.fast_move(weituo_quest.cx, weituo_quest.cy, weituo_quest.cz)
                    end
                end
            else

                quest_ent.wi_auto_side_quest(weituo_quest.id, 1)
                decider.sleep(1000)
            end

        end
    end
    -- 交任务
    quest_ent.sub_weituo_quest()
    -- 删任务
    quest_ent.del_weituo_quest(weituo_quest_name_list)

end

-- 判断是否可接委托任务
function quest_ent.can_acc_weituo_quest(weituo_quest_name_list)
    local list = quest_unit.list(2)
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
                if not weituo_quest_name_list[task_name] then
                    acc_task = false
                end
            end
            if acc_task and quest_ctx:is_over() then
                acc_task = false
            end
            if acc_task and quest_ctx:is_finish() then
                acc_task = false
            end
            if acc_task and quest_ctx:status() ~= 3 then
                acc_task = false
            end
            if acc_task then
                return true
            end
        end
    end
    return false
end

-- 做支线
function quest_ent.can_do_weituo_quest()
    local list = quest_unit.list(0)
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local do_task = true
            if do_task and quest_unit.get_quest_type(quest_ctx:id()) ~= 6 then
                do_task = false
            end
            if do_task then
                return true
            end
        end
    end
    return false
end

-- 接委托任务
function quest_ent.acc_weituo_quest(weituo_quest_name_list)
    local list = quest_unit.list(2)
    local my_combat_power = actor_unit.char_combat_power()
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            if #quest_unit.list(0) >= 1 then
                break
            end
            local acc_task = true
            if quest_ctx:daily_num() > 0 then
                acc_task = false
            end
            if acc_task then
                local combat_power = quest_ctx:combat_power()
                if combat_power > my_combat_power  then
                    acc_task = false
                end
            end
            if acc_task then
                local task_name = quest_ctx:name()
                if not weituo_quest_name_list[task_name] then
                    acc_task = false
                end
            end
            if acc_task and quest_ctx:is_over() then
                acc_task = false
            end
            if acc_task and quest_ctx:is_finish() then
                acc_task = false
            end
            if acc_task and quest_ctx:status() ~= 3 then
                acc_task = false
            end
            if acc_task then
                quest_unit.accept(quest_ctx:id())
                decider.sleep(2000)
            end
        end
    end
end

-- 做支线
function quest_ent.do_weituo_quest()
    local list = quest_unit.list(0)
    local side_task_id = {}
    for i = 1, #list do
        local obj = list[i]
        if quest_ctx:init(obj) then
            local do_task = true
            if quest_ctx:is_finish() then
                do_task = false
            end
            if do_task and quest_unit.get_quest_type(quest_ctx:id()) ~= 6 then
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
                    tar_num = quest_ctx:tar_num(),
                    tar_max_num = quest_ctx:tar_max_num(),
                    entrust_gather_resid = quest_ctx:entrust_gather_resid(),
                    map_name = quest_ctx:map_name(),


                }
                break
            end
        end
    end
    return side_task_id
end

-- 交支线
function quest_ent.sub_weituo_quest()
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
function quest_ent.del_weituo_quest(weituo_quest_name_list)
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
                if not weituo_quest_name_list[task_name] then
                    del_task = true
                end
            end
            if not del_task and quest_unit.get_quest_type(quest_ctx:id()) ~= 6 then
                del_task = true
            end
            if del_task then
                quest_unit.delete(quest_ctx:id())
                decider.sleep(2000)
            end
        end
    end
end

---跳过游戏场景
function quest_ent.skip_game()
    if ui_unit.get_parent_widget('Sequence_Skip_C', true) ~= 0 then
        -- 剧情
        this.skip_seq()
    elseif ui_unit.get_parent_widget('New_NPC_C', true) ~= 0 then
        --NPC对话
        this.skip_npc_talk()
    elseif ui_unit.get_parent_widget('Tutorial_Guid_C', true) ~= 0 then
        -- 教学
        this.skip_tutorial()
    elseif ui_unit.get_parent_widget('PlayMovieWidget_C', true) ~= 0 then
        --电影播放
        this.skip_movie()
    end
end

------------------------------------------------------------------------------------
---跳过教学
function quest_ent.skip_tutorial()
    local ret = false
    while decider.is_working() do
        if ui_unit.get_parent_widget('Tutorial_Guid_C', true) == 0 then
            break
        else
            game_unit.end_tutorial()
            ret = true
        end
        decider.sleep(500)
    end
    return ret
end

------------------------------------------------------------------------------------
---跳过npc对话
function quest_ent.skip_npc_talk()
    local ret = false
    while decider.is_working() do
        if ui_unit.get_parent_widget('New_NPC_C', true) == 0 then
            break
        else
            game_unit.next_dialg()
            ret = true
        end
        decider.sleep(500)
    end
    return ret
end

------------------------------------------------------------------------------------
---跳过剧情
function quest_ent.skip_seq()
    local ret = false
    while decider.is_working() do
        if ui_unit.get_parent_widget('Sequence_Skip_C', true) == 0 then
            break
        else
            game_unit.skip_seq()
            ret = true
        end
        decider.sleep(500)
    end
    return ret
end

------------------------------------------------------------------------------------
---跳过电影播放
function quest_ent.skip_movie()
    local ret = false
    while decider.is_working() do
        if ui_unit.get_parent_widget('PlayMovieWidget_C', true) == 0 then
            break
        else
            game_unit.skip_movie()
            ret = true
        end
        decider.sleep(500)
    end
    return ret
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function quest_ent.__tostring()
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
function quest_ent.__newindex(t, k, v)
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
quest_ent.__index = quest_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function quest_ent:new(args)
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
    return setmetatable(new, quest_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return quest_ent:new()

-------------------------------------------------------------------------------------
