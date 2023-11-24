-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   secret
-- @describe: 秘境峰模块
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local secret = {
    VERSION = '202015.1',
    AUTHOR_NOTE = "-[secret module - 202015.1]-",
    MODULE_NAME = '秘境峰模块',
    -- 设置脚本版本
    SCRIPT_UPDATE = 'v1.0.0',
}

-- 自身模块
local this = secret
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
---@type gift_ent
local gift_ent = import('game/entities/gift_ent')
---@type stone_ent
local stone_ent = import('game/entities/stone_ent')
---@type map_res
local map_res = import('game/resources/map_res')
---@type pet_ent
local pet_ent = import('game/entities/pet_ent')
---@type mail_ent
local mail_ent = import('game/entities/mail_ent')
---@type weiye_ent
local weiye_ent = import('game/entities/weiye_ent')
---@type quest_res
local quest_res = import('game/resources/quest_res')
---@type secret_ent
local secret_ent = import('game/entities/secret_ent')
---@type switch_ent
local switch_ent = import('game/entities/switch_ent')
---@type user_ent
local user_ent = import('game/entities/user_ent')

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
        return true

    end,
    -- [其它] 功能函数条件(可选)
    is_execute = function()
        return true
    end,
}

-- 轮循函数列表
secret.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
secret.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
secret.preload = function()


end

-------------------------------------------------------------------------------------
-- 轮循功能入口
secret.looping = function()

    secret_ent.run_fight()
end

-------------------------------------------------------------------------------------
-- 功能入口函数
secret.entry = function()
    local ret_b = false
    -- 加载前延迟
    while decider.is_working()
    do
        -- 执行轮循任务
        secret.looping()
        secret_ent.enter_secret()

        decider.sleep(1000)

    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 模块超时处理
secret.on_timeout = function()

end



-------------------------------------------------------------------------------------
-- 卸载处理
secret.unload = function()
    --xxmsg('secret.unload')
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
secret.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function secret.__tostring()
    return this.MODULE_NAME
end

secret.__index = secret

function secret:new(args)
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
    return setmetatable(new, secret)
end

-------------------------------------------------------------------------------------
-- 返回对象
return secret:new()

-------------------------------------------------------------------------------------