------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   user_ent
--- @describe: 用户设置模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class user_ent
local user_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'user_ent module',
    -- 只读模式
    READ_ONLY = false,

    REDIS_PATH = 'mir4:游戏设置:服务器[' .. main_ctx:c_server_name() .. ']:机器[%s]:用户设置',

}

local this = user_ent
local main_ctx = main_ctx
local ini_unit = ini_unit
---@type redis_ent
local redis_ent = import('game/entities/redis_ent')
---@type user_res
local user_res = import('game/resources/user_res')

--------------------------------------------------------------------------------
-- 载入用户设置信息到全局
--
-- @usage
-- redis_ent.load_user_info()
--------------------------------------------------------------------------------
function user_ent.load_user_info()
    redis_ent.connect_redis()
    local global_set = user_res.GLOBAL_SET
    local path = string.format(this.REDIS_PATH, redis_ent.COMPUTER_ID)
    for i, v in pairs(global_set) do

        local value = redis_ent.get_string_data(path, v.session, v.key)
        if value == '' then
            redis_ent.set_string_data(path, v.session, v.key, v.value)

            value = v.value
        end
        if type(v.value) == "number" then
            value = tonumber(value)
        end
        this[v.key] = value
    end
    local ini_obj = ini_unit:new()
    ini_obj:parse(redis_ent.REDIS_OBJ:get_string(path))
    ini_obj:delete()
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function user_ent.__tostring()
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
function user_ent.__newindex(t, k, v)
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
user_ent.__index = user_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function user_ent:new(args)
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
    return setmetatable(new, user_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return user_ent:new()

-------------------------------------------------------------------------------------