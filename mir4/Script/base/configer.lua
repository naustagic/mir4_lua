------------------------------------------------------------------------------------
-- base/configer.lua
--
-- 这是一个配置管理器模块，主要用于读取和写入INI格式的配置文件以及与REDIS的交互操作。
--
-- @module      configer
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local configer = import('base/configer')
------------------------------------------------------------------------------------

-- 模块定义
local configer = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION                   = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE               = '2023-03-22 - Initial release',
    -- 模块名称
    MODULE_NAME               = 'configer module',
    -- 只读模式
    READ_ONLY                 = false,
}

-- 模块实例
local this         = configer
-- 工具函数
local utils        = utils
-- 优化列表
local os           = os
local string       = string
local tostring     = tostring
local pairs        = pairs
local setmetatable = setmetatable
local rawset       = rawset
local error        = error
local WriteString  = WriteString
local WriteString2 = WriteString2
local ReadString   = ReadString
local ReadString2  = ReadString2
local main_ctx     = main_ctx


------------------------------------------------------------------------------------
-- 写入配置文件的指定字段值。
--
-- @tparam       string    file             配置文件路径
-- @tparam       string    section          配置文件中的区段名称
-- @tparam       string    key              区段中的字段名称
-- @tparam       string    str              要写入的字符串
-- @treturn      boolean                    是否写入成功
-- @usage
-- local configer = import('base/configer')
-- configer.set_profile('本机设置.ini', '区段名称', '字段名称', '字符串内容')
------------------------------------------------------------------------------------
function configer.set_profile(file, section, key, str)
    file = main_ctx:utf8_to_ansi(file)
    return WriteString2(file, section, key, str)
end

------------------------------------------------------------------------------------
-- 获取配置文件中的指定字段值。
--
-- @tparam       string    file             配置文件路径
-- @tparam       string    section          配置文件中的区段名称
-- @tparam       string    key              区段中的字段名称
-- @treturn      string                     如果找到指定字段值，返回该值。否则返回''。
-- @usage
-- local configer = import('base/configer')
-- local str = configer.get_profile('本机设置.ini', '区段名称', '字段名称')
-- xxxmsg(2, str)
------------------------------------------------------------------------------------
function configer.get_profile(file, section, key)
    file = main_ctx:utf8_to_ansi(file)
    return ReadString2(file, section, key)
end

------------------------------------------------------------------------------------
-- 写入用户配置的指定字段值。
--
-- @tparam       string    section          用户配置文件中的区段名称
-- @tparam       string    key              区段中的字段名称
-- @tparam       string    str              要写入的字符串
-- @treturn      boolean                    是否写入成功
-- @usage
-- local configer = import('base/configer')
-- configer.set_user_profile('区段名称', '字段名称', '字符串内容')
------------------------------------------------------------------------------------
function configer.set_user_profile(section, key, str)

    return WriteString(section, key, str)
end

------------------------------------------------------------------------------------
-- 获取用户配置文件中的指定字段值。
--
-- @tparam       string    section          用户配置文件中的区段名称
-- @tparam       string    key              区段中的字段名称
-- @treturn      string                     如果找到指定字段值，返回该值。否则返回''。
-- @usage
-- local configer = import('base/configer')
-- local str = configer.get_user_profile('区段名称', '字段名称')
-- xxxmsg(2, str)
------------------------------------------------------------------------------------
function configer.get_user_profile(section, key)
    return ReadString(section, key)
end

------------------------------------------------------------------------------------
-- 写入带有过期时间的用户配置。
--
-- @tparam       string    section          配置文件中的 section 名称
-- @tparam       string    key              配置文件中的 key 名称
-- @tparam       string    value            配置文件中的 value 值
-- @tparam       number    expire_seconds   配置过期时间（秒）
-- @treturn      boolean                    写入是否成功
-- @usage
-- -- 设置登录用户信息有效期为一天
-- local name = 'John Doe'
-- local expire_seconds = 86400
-- configer.set_user_profile_expire('user', 'name', name, expire_seconds)
------------------------------------------------------------------------------------
function configer.set_user_profile_expire(section, key, value, expire_seconds)
    if expire_seconds <= 0 then
        return false
    end
    local expire_time = utils.convert_datetime(os.time() + expire_seconds)
    local content = string.format('%s,%s', expire_time, tostring(value))
    return configer.set_user_profile(section, key, content)
end

------------------------------------------------------------------------------------
--  获取带有过期时间的用户配置。
--
-- @tparam       string    section          配置文件中节点名称。
-- @tparam       string    key              配置文件中键名称。
-- @treturn      string                     配置值（如果未过期），否则返回空字符串
-- @usage
-- -- 配置文件中内容：name = '1646547599,John Doe'
-- local name = configer.get_user_profile_expire('user', 'name')
-- if name ~= '' then
--     print('欢迎回来，' .. name .. '!')
-- else
--     print('您还未登录')
-- end
------------------------------------------------------------------------------------
function configer.get_user_profile_expire(section, key)
    local content = configer.get_user_profile(section, key)
    if content ~= '' then
        local parts = utils.split_string(content, ',')
        if #parts == 2 then
            local timestamp = utils.convert_timestamp(parts[1]) 
            if timestamp > os.time() then
                return parts[2]
            end
        end
    end
    return ''
end

-------------------------------------------------------------------------------------
--- 将指定用户的配置写入 INI 文件，并将当天日期附加到配置值之前。
--
-- @tparam       string    section          配置文件中节点名称。
-- @tparam       string    key              配置文件中的键名。
-- @tparam       string    value            要写入的字符串。
-- @treturn      boolean                    写入操作是否成功。
-- @usage
-- local section = 'user_config'
-- local key = 'user_info'
-- local value = 'John Doe'
-- local success = configer.set_user_profile_today(section, key, value)
-- print(success)
--------------------------------------------------------------------------------------
function configer.set_user_profile_today(section, key, value)
    local content = string.format('%s,%s', os.date('%Y-%m-%d'), tostring(value))
    return configer.set_user_profile(section, key, content)
end

-------------------------------------------------------------------------------------
-- 获取指定用户在当天内存储的字符串值。
--
-- @tparam       string    section          配置文件中节点名称。
-- @tparam       string    key              配置文件中键名称。
-- @treturn      string                     存储的字符串值
-- @usage
-- local value = configer.get_user_profile_today('user_config', 'user_info')
-- print(value)
-------------------------------------------------------------------------------------
function configer.get_user_profile_today(section, key)
    local today = os.date('%Y-%m-%d')
    local content = configer.get_user_profile(section, key)
    local parts = utils.split_string(content, ',')
    if #parts == 2 and parts[1] == today then
        return parts[2]
    end
    return ''
end

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function configer.__tostring()
    return this.MODULE_NAME
end

------------------------------------------------------------------------------------
-- 防止动态修改(this.READ_ONLY值控制)
--
-- @local
-- @tparam       table     t                被修改的表
-- @tparam       any       k                要修改的键
-- @tparam       any       v                要修改的值
------------------------------------------------------------------------------------
function configer.__newindex(t, k, v)
    if this.READ_ONLY then
        error('attempt to modify read-only table')
        return
    end
    rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置utils的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
configer.__index = configer

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function configer:new(args)
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
    return setmetatable(new, configer)
end

------------------------------------------------------------------------------------
-- 返回实例对象
------------------------------------------------------------------------------------
return configer:new()

------------------------------------------------------------------------------------
