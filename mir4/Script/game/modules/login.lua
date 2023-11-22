-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   login
-- @describe: 登陆处理
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local login = {
    VERSION         = '202015.1',
    AUTHOR_NOTE     = "-[login module - 202015.1]-",
    MODULE_NAME     = '登陆模块',
    -- 设置脚本版本
    SCRIPT_UPDATE   = 'v23.11.07',
}

-- 自身模块
local this          = login
-- 配置模块
local settings      = settings
-- 日志模块
local trace         = trace
local common        = common
-- 决策模块
local decider       = decider
-- 优化列表
local game_unit     = game_unit
local main_ctx      = main_ctx
local setmetatable  = setmetatable
local pairs         = pairs
local import        = import
---@type login_res
local login_res = import('game/resources/login_res')
---@type login_ent
local login_ent = import('game/entities/login_ent')
---@type user_ent
local user_ent = import('game/entities/user_ent')

-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- 运行前置条件
this.eval_ifs = {
    -- [启用] 游戏状态列表
    yes_game_state = {},
    -- [禁用] 游戏状态列表
    not_game_state = { login_res.STATUS_IN_GAME,login_res.STATUS_LOADING_MAP },
    -- [启用] 配置开关列表
    yes_config     = {  },
    -- [禁用] 配置开关列表
    not_config     = {},
    -- [时间] 模块超时设置(可选)
    time_out       = 240,
    -- [其它] 特殊情况才用(可选)
    is_working     = function()
        return true
    end,
    -- [其它] 功能函数条件(可选)
    is_execute     = function()
        return true
    end,
}

-- 轮循函数列表
login.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
login.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
login.preload = function()
    -- if not game_unit.black_screen() then
    --     game_unit.black_screen()-- 黑屏
    -- end
end

-------------------------------------------------------------------------------------
-- 轮循功能入口
login.looping = function()


end
-------------------------------------------------------------------------------------
-- 功能入口函数
login.entry = function()
    local ret_b = false
    local action_list = {
        -- 选择角色进入游戏界面
        [login_res.STATUS_CHARACTER_SELECT]         = login_ent.select_char_in_game,
        -- 选择服务器
        [login_res.STATUS_SERVER_SELECT_PAGE]         = login_ent.select_server,
        -- 选择谷歌登录
        [login_res.STATUS_LOGO_PAGE]         = login_ent.google_login,
        -- 选择协议
        [login_res.SELECT_XIEYI]         = login_ent.select_all,
        -- 选择生日
        [login_res.SELECT_BIRTHDAY]         = login_ent.select_date,

        -- 选择生日
        [login_res.STATUS_FOUND_SELECT]         = login_ent.select_char,


    }
    -- 加载前延迟
    decider.sleep(3000)
    while decider.is_working()
    do
        -- 执行轮循任务
        login.looping()

        -- 读取游戏状态
        local status = game_unit.game_status_ex()
        xxmsg(string.format('0x%X',status))
        -- 根据状态执行相应功能
        local action = action_list[status]
        if action then
            xxmsg(        xxmsg(string.format('进入0x%X',status)))
            -- 执行函数
            action()
        end
        -- 适当延时(切片)
        decider.sleep(2000)

    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 模块超时处理
login.on_timeout = function()
    for i = 1, 10 do
        main_ctx:set_action('登录超时'..( 10 - i )..'秒后,重上游戏')
        decider.sleep(1000)
    end
    main_ctx:set_action('重上游戏')
    main_ctx:end_game()
end

-------------------------------------------------------------------------------------
-- 轮循模块
login.looping = function()

end

-------------------------------------------------------------------------------------
-- 卸载处理
login.unload = function()
    local str = string.format('%s：[版本:%s]脚本已停止',os.date("%H-%M"),this.SCRIPT_UPDATE)
    main_ctx:set_action(str)
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
login.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function login.__tostring()
    return this.MODULE_NAME
end

login.__index = login

function login:new(args)
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
    return setmetatable(new, login)
end

-------------------------------------------------------------------------------------
-- 返回对象
return login:new()

-------------------------------------------------------------------------------------