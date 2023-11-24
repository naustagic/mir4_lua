-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   main_quest
-- @describe: 测试模块
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local main_quest = {
    VERSION = '202015.1',
    AUTHOR_NOTE = "-[main_quest module - 202015.1]-",
    MODULE_NAME = '主线模块',
    -- 设置脚本版本
    SCRIPT_UPDATE = 'v1.0.0',
}

-- 自身模块
local this = main_quest
-- 配置模块
local settings = settings
-- 日志模块
local trace = trace
local common = common
-- 决策模块
local decider = decider
-- 优化列表
local game_unit = game_unit
local main_ctx = main_ctx
local login_unit = login_unit
local setmetatable = setmetatable
local pairs = pairs
local import = import
---@type login_res
local login_res = import('game/resources/login_res')
---@type transfer_ent
local transfer_ent = import('game/entities/transfer_ent')
---@type main_quest_ent
local main_quest_ent = import('game/entities/main_quest_ent')

---@type equip_ent
local equip_ent = import('game/entities/equip_ent')
local example = import('example/example')
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
---@type shop_ent
local shop_ent = import('game/entities/shop_ent')
---@type training_ent
local training_ent = import('game/entities/training_ent')
---@type item_res
local item_res = import('game/resources/item_res')
---@type item_ent
local item_ent = import('game/entities/item_ent')
---@type gift_ent
local gift_ent = import('game/entities/gift_ent')
---@type quest_ent
local quest_ent = import('game/entities/quest_ent')
---@type stone_ent
local stone_ent = import('game/entities/stone_ent')
---@type pet_ent
local pet_ent = import('game/entities/pet_ent')
---@type mail_ent
local mail_ent = import('game/entities/mail_ent')
---@type weiye_ent
local weiye_ent = import('game/entities/weiye_ent')
---@type switch_ent
local switch_ent = import('game/entities/switch_ent')
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- 运行前置条件
this.eval_ifs = {
    -- [启用] 游戏状态列表
    yes_game_state = { login_res.STATUS_IN_GAME, login_res.STATUS_LOADING_MAP },
    -- [禁用] 游戏状态列表
    not_game_state = {  },
    -- [启用] 配置开关列表
    yes_config = {  },
    -- [禁用] 配置开关列表
    not_config = {},
    -- [时间] 模块超时设置(可选)
    time_out = 0,
    -- [其它] 特殊情况才用(可选)
    is_working = function()
        return switch_ent.main_task() and not switch_ent.secret_fb() and not switch_ent.side_task() and not switch_ent.mf_fb() and not switch_ent.weituo_task() and not switch_ent.gather_quest()
    end,
    -- [其它] 功能函数条件(可选)
    is_execute = function()
        return true
    end,
}

-- 轮循函数列表
main_quest.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
main_quest.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
main_quest.preload = function()


end

-------------------------------------------------------------------------------------
-- 轮循功能入口
main_quest.looping = function()
    if game_unit.is_sleep_mode() then
        game_unit.leave_sleep_mode()
        decider.sleep(1000)
    end
    training_ent.wi_auto_training()
    stone_ent.wi_set_magic_stone()
    skill_ent.wi_auto_skill()
    pet_ent.wi_auto_pet()
    mail_ent.wi_get_mail()
    item_ent.wi_use_unsealing_box()
    item_ent.wi_use_fashion_item()
    item_ent.wi_sell_item()
    item_ent.wi_auto_use_item()
    item_ent.wi_use_zhaohuan_item()
    gift_ent.wi_daily_work()
    gift_ent.wi_sign()
    gift_ent.wi_achievement()
    equip_ent.wi_auto_equip()
    shop_ent.wi_auto_buy_item()
    item_ent.wi_set_quick_slot()
    weiye_ent.wi_auto_great()
end

-------------------------------------------------------------------------------------
-- 功能入口函数
main_quest.entry = function()
    local ret_b = false

    -- 加载前延迟

    while decider.is_working()
    do
        -- 执行轮循任务
        main_quest.looping()

        quest_ent.do_main_task()

        decider.sleep(100)

    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 模块超时处理
main_quest.on_timeout = function()

end



-------------------------------------------------------------------------------------
-- 卸载处理
main_quest.unload = function()
    --xxmsg('main_quest.unload')
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
main_quest.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function main_quest.__tostring()
    return this.MODULE_NAME
end

main_quest.__index = main_quest

function main_quest:new(args)
    local new = { }

    -- 预载函数(重载脚本时)
    if this.super_preload then
        this.super_preload()
    end

    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end

    -- 设置元表
    return setmetatable(new, main_quest)
end

-------------------------------------------------------------------------------------
-- 返回对象
return main_quest:new()

-------------------------------------------------------------------------------------