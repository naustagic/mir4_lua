-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   login_res
-- @describe: 登陆模块用到的资源
-- @version:  v1.0


-------------------------------------------------------------------------------------
-- 登陆模块资源
---@class login_res
local login_res = {
    -- 创建角色后下线[0关闭  1开启]
    END_GAME_OFTER_CREATE = 0,
    -- 创建角色
   -- CREATE_JOB = main_ctx:c_job(),

    -- 启动页面
    STATUS_INTRO_PAGE = 0x0, -- 0x01,            -- 进入游戏时的启动页面
    STATUS_LOGO_PAGE = 0x4,             -- 游戏logo页面

    -- 登陆页面
    STATUS_GOOGLE_LOGIN_PAGE = 102,      --0x80,     -- Google账号登陆页面
    STATUS_SERVER_SELECT_PAGE = 0x820,     --0x800,   -- 服务器选择页面
    STATUS_ZHIGE_YANZHENG = 0xA0,
    -- 选择角色
    STATUS_CHARACTER_SELECT = 0x4000,       --0x4000,    -- 角色选择页面
    -- 创建角色
    -- 游戏里面
    STATUS_IN_GAME = 0x100000,                --0x100000,           -- 进入游戏内部状态
    STATUS_LOADING_MAP = 0x200000,            --0x200000,       -- 地图加载中状态

    --角色起名
    PLAYER_NAME ={ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
              "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
              "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

}

local this = login_res

-------------------------------------------------------------------------------------
-- 是否为可创建的职业
login_res.can_create_job = function(job_name)
    return this.CAN_CREATE_JOB[job_name]
end

-------------------------------------------------------------------------------------
-- 是否为可创建的职业 选择职业(战士0x65 法师0xC9  格斗0x1D2, 射手：0x1F5  巫师0x259  潜伏者0x191)
login_res.job_by_id = function(job_name)
    local job_id = 0
    if job_name == '战士' then
        job_id = 0x65
    elseif job_name == '魔法师' then
        job_id = 0xC9
    elseif job_name == '格斗家' then
        job_id = 0x1D2
    elseif job_name == '射手' then
        job_id = 0x1F5
    elseif job_name == '术士' then
        job_id = 0x259
    end
    return job_id
end

--默认进入游戏角色序号
login_res.player_idx = function()
    local idx = configer.get_user_profile_today('角色选择', '选择角色序号')
    xxmsg('选择角色序号' .. idx)
    if idx == '' then
        idx = 0
    end
    idx = tonumber(idx)
    return idx
end

-- 角色取名
login_res.get_player_name = function()
    local str = this.PLAYER_NAME
    local name = ""
    for i = 1, 8 do
        name = name .. str[math.random(#str)]
    end
    name = tostring(name)
    return name
end

-- 家族取名
login_res.get_family_name = function()
    local name = ''
    local family_name1 = login_res.FAMILY_UNIT_NAME_Q[math.random(1, #this.FAMILY_UNIT_NAME_Q)]
    local family_name2 = login_res.FAMILY_UNIT_NAME_H[math.random(1, #this.FAMILY_UNIT_NAME_H)]
    name = family_name1..family_name2




    return name
end

-------------------------------------------------------------------------------------
-- 返回对象
return login_res

-------------------------------------------------------------------------------------