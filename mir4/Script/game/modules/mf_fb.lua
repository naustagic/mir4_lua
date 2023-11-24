-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   mf_fb
-- @describe: 测试模块
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local mf_fb = {
    VERSION = '202015.1',
    AUTHOR_NOTE = "-[mf_fb module - 202015.1]-",
    MODULE_NAME = '魔方模块',
    -- 设置脚本版本
    SCRIPT_UPDATE = 'v1.0.0',
}

-- 自身模块
local this = mf_fb
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
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type quest_ent
local quest_ent = import('game/entities/quest_ent')
---@type map_res
local map_res = import('game/resources/map_res')
---@type pet_ent
local pet_ent = import('game/entities/pet_ent')
---@type dungeon_ent
local dungeon_ent = import('game/entities/dungeon_ent')
---@type switch_ent
local switch_ent = import('game/entities/switch_ent')
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- 运行前置条件
this.eval_ifs = {
    -- [启用] 游戏状态列表
    yes_game_state = { },
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
        return switch_ent.mf_fb()
    end,
    -- [其它] 功能函数条件(可选)
    is_execute = function()
        return true
    end,
}

-- 轮循函数列表
mf_fb.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
mf_fb.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
mf_fb.preload = function()


end

-------------------------------------------------------------------------------------
-- 轮循功能入口
mf_fb.looping = function()
    shop_ent.wi_mf_map_auto_buy_item()
    pet_ent.wi_auto_pet()
    item_ent.wi_use_unsealing_box()
    item_ent.wi_use_zhaohuan_item()
    item_ent.wi_use_fashion_item()
    item_ent.wi_sell_item()
    item_ent.wi_auto_use_item()
    item_ent.wi_set_quick_slot()
    equip_ent.wi_auto_equip()
end
-------------------------------------------------------------------------------------
-- 功能入口函数
mf_fb.entry = function()
    local ret_b = false

    -- 加载前延迟

    while decider.is_working()
    do
        -- 执行轮循任务
        mf_fb.looping()

        dungeon_ent.dungeon_mf()

        decider.sleep(100)

    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 模块超时处理
mf_fb.on_timeout = function()

end



-------------------------------------------------------------------------------------
-- 卸载处理
mf_fb.unload = function()
    --xxmsg('mf_fb.unload')
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
mf_fb.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function mf_fb.__tostring()
    return this.MODULE_NAME
end

mf_fb.__index = mf_fb

function mf_fb:new(args)
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
    return setmetatable(new, mf_fb)
end

-------------------------------------------------------------------------------------
-- 返回对象
return mf_fb:new()

-------------------------------------------------------------------------------------