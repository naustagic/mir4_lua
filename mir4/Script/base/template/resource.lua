------------------------------------------------------------------------------------
-- game/resources/login_res.lua
--
-- 这是登陆要用到的资源表，等号和后面的注释尽量保持对齐。
--
-- @module      login_res
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local login_res = import('game/resources/login_res')
------------------------------------------------------------------------------------

-- 登陆资源
local login_res = {
    -- 职业名称对应ID列表
    JOB_IDS = {
        ['战士']              = 0x0C,    -- 战士
        ['术士']              = 0x15,    -- 术士
        ['道士']              = 0x1F,    -- 道士
    },

    -- 启动页面
    STATUS_INTRO_PAGE         = 0x01,    -- 进入游戏时的启动页面
    STATUS_LOGO_PAGE          = 0x02,    -- 游戏logo页面
    STATUS_DOWNLOAD_PAGE      = 0x04,    -- 游戏下载更新页面
    STATUS_RESERVED1          = 0x08,    -- 预留状态1
    STATUS_RESERVED2          = 0x10,    -- 预留状态2
    -- 登陆页面
    STATUS_LOGIN_PAGE         = 0x20,    -- 登陆页面
    STATUS_ACCOUNT_LOGIN_PAGE = 0x40,    -- 帐号密码登陆页面
    STATUS_THIRD_LOGIN_PAGE   = 0x40,    -- 第三方登陆页面(暂定成一个)
    STATUS_GOOGLE_LOGIN_PAGE  = 0x80,    -- Google账号登陆页面
    STATUS_APPLE_LOGIN_PAGE   = 0x100,   -- Apple账号登陆页面
    STATUS_FB_LOGIN_PAGE      = 0x200,   -- Facebook账号登陆页面
    STATUS_TERMS_PAGE         = 0x400,   -- 服务条款同意页面
    STATUS_SERVER_SELECT_PAGE = 0x800,   -- 服务器选择页面
    STATUS_RESERVED3          = 0x1000,  -- 预留状态3
    STATUS_RESERVED4          = 0x2000,  -- 预留状态4
    -- 选择角色
    STATUS_CHARACTER_SELECT   = 0x4000,  -- 角色选择页面
    STATUS_RESERVED5          = 0x8000,  -- 预留状态5
    STATUS_RESERVED6          = 0x10000, -- 预留状态6
    -- 创建角色
    STATUS_CREATE_CHARACTER   = 0x20000, -- 创建角色页面
    STATUS_RESERVED7          = 0x40000, -- 预留状态7
    STATUS_RESERVED8          = 0x80000, -- 预留状态8
    -- 游戏里面
    STATUS_IN_GAME            = 0x100000,-- 进入游戏内部状态
    STATUS_LOADING_MAP        = 0x200000,-- 地图加载中状态
    STATUS_RESERVED9          = 0x400000,-- 预留状态9
    STATUS_RESERVED10         = 0x800000 -- 预留状态10
}

-- 自身模块
local this = login_res

-------------------------------------------------------------------------------------
-- 读取控制台设置(职业ID)
-- 
-- @return                   integer   返回控制台设置的职业名称转换后的ID
-------------------------------------------------------------------------------------
function login_res.get_job_id_by_setting()
    return JOB_IDS[main_ctx:c_job()] or 0
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-- 
-- @export
return login_res

-------------------------------------------------------------------------------------