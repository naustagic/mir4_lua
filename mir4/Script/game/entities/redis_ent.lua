------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-15
--- @module:   redis_ent
--- @describe: 数据库模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231015' -- version history at end of file
local AUTHOR_NOTE = '-[20231015]-'
-- 模块定义
---@class redis_ent
local redis_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'redis_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = redis_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local main_ctx = main_ctx
local ReadString = ReadString
local local_player = local_player
local WriteString = WriteString
local WriteString2 = WriteString2
local ReadString2 = ReadString2
local json_unit = json_unit
local ini_unit = ini_unit
local redis_ctx = redis_ctx
local is_exit = is_exit
---@type common
local common = import('game/entities/common')

-- 组队超时
redis_ent.TEAM_TIME_OUT = 60 * 60 * 1
--队长职业
redis_ent.LIMIT_CAPTAIN_CLASS = {}

redis_ent.COMPUTER_ID = 1
redis_ent.IP = '127.0.0.1'
redis_ent.FAMILY_ID = 1
redis_ent.TEAM_ID = 1
local USERDATA_PATH = '传奇4:内置数据:服务器[' .. main_ctx:c_server_name() .. ']:共享数据:UserData:' .. main_ctx:c_account()

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function redis_ent.super_preload()

end



--------------------------------------------------------------------------------
-- 向本地角色读取
--
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @treturn      string                 读取区块中键对应的值
-- @usage
-- local str = redis_ent.read_ini_user('区块','键')
--------------------------------------------------------------------------------
redis_ent.read_ini_user = function(session, key)
    local session1 = main_ctx:utf8_to_ansi(main_ctx:c_server_name() .. session)
    local key1 = main_ctx:utf8_to_ansi(local_player:name() .. key)
    return main_ctx:ansi_to_utf8(ReadString(session1, key1))
end

--------------------------------------------------------------------------------
-- 向本地用户写入
--
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @tparam       any        str          值
-- @treturn      bool
-- @usage
-- redis_ent.write_ini_user('区块','键','值')
--------------------------------------------------------------------------------
redis_ent.write_ini_user = function(session, key, str)
    local session1 = main_ctx:utf8_to_ansi(main_ctx:c_server_name() .. session)
    local key1 = main_ctx:utf8_to_ansi(local_player:name() .. key)
    local str1 = main_ctx:utf8_to_ansi(str)
    return WriteString(session1, key1, str1)
end

--------------------------------------------------------------------------------
-- 向本地角色读取(天)
--
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @treturn      string                 读取区块中键对应的值
-- @usage
-- local str = redis_ent.read_ini_user_today('区块','键')
--------------------------------------------------------------------------------
redis_ent.read_ini_user_today = function(session, key)
    local ret = this.read_ini_user(session, key)
    if ret ~= '' then
        local info = common.split(ret, '_')
        if info[2] == os.date('%m%d') then
            return tonumber(info[1])
        end
    end
    return 0
end

--------------------------------------------------------------------------------
-- 向本地角色写入(天)
--
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @tparam       string     str          值
-- @treturn      string                 读取区块中键对应的值
-- @usage
-- local str = redis_ent.read_ini_user_today('区块','键')
--------------------------------------------------------------------------------
function redis_ent.write_ini_user_today(session, key, str)
    str = str or 1
    local str1 = str .. "_" .. os.date('%m%d')
    redis_ent.write_ini_user(session, key, str1)
end

--------------------------------------------------------------------------------
-- 向本地角色读取(时)
--
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @treturn      string                 读取区块中键对应的值
-- @usage
-- local str = redis_ent.read_ini_user_today('区块','键')
--------------------------------------------------------------------------------
redis_ent.read_ini_user_time = function(session, key)
    local ret = this.read_ini_user(session, key)
    if ret ~= '' then
        local info = common.split(ret, '_')
        if tonumber(info[2]) >= os.time() then
            return tonumber(info[1])
        end
    end
    return 0
end

--------------------------------------------------------------------------------
-- 向本地角色写入(时)
--
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @tparam       string     str          值
-- @treturn      string                 读取区块中键对应的值
-- @usage
-- local str = redis_ent.read_ini_user_today('区块','键')
--------------------------------------------------------------------------------
function redis_ent.write_ini_user_time(session, key, str, time)
    str = str or 1
    local str1 = str .. "_" .. os.time() + time
    redis_ent.write_ini_user(session, key, str1)
end

--------------------------------------------------------------------------------
-- 向本机写入
--
-- @tparam       string     txtName      文件名
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @tparam       any        str          值
-- @treturn      bool
-- @usage
-- redis_ent.write_ini_computer('文件名','区块','键','值')
--------------------------------------------------------------------------------
redis_ent.write_ini_computer = function(txtName, session, key, str)
    if this.read_ini_computer(txtName, session, key) == str then
        return false
    end
    local txtName1 = main_ctx:utf8_to_ansi(txtName)
    local session1 = main_ctx:utf8_to_ansi(session)
    local key1 = main_ctx:utf8_to_ansi(key)
    local str1 = main_ctx:utf8_to_ansi(str)
    return WriteString2(txtName1, session1, key1, str1)
end

--------------------------------------------------------------------------------
-- 向本机读取
--
-- @tparam       string     txtName      文件名
-- @tparam       string     session      区块
-- @tparam       string     key          键
-- @treturn      bool
-- @usage
-- local str = redis_ent.read_ini_computer('文件名','区块','键')
--------------------------------------------------------------------------------
redis_ent.read_ini_computer = function(txtName, session, key)
    local txtName1 = main_ctx:utf8_to_ansi(txtName)
    local session1 = main_ctx:utf8_to_ansi(session)
    local key1 = main_ctx:utf8_to_ansi(key)
    return main_ctx:ansi_to_utf8(ReadString2(txtName1, session1, key1))
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 执行连接redis服务器
--
-- @treturn      bool
-- @usage
-- local bool = redis_ent.connect_redis()
--------------------------------------------------------------------------------
redis_ent.connect_redis = function()

    --设置/读取本机ID
    local computer_id = this.read_ini_computer('本机设置.ini', '连接REDIS设置', '机器ID')
    if computer_id == '' then
        this.write_ini_computer('本机设置.ini', '连接REDIS设置', '机器ID', '1')
        this.COMPUTER_ID = 1
    else
        this.COMPUTER_ID = tonumber(computer_id)
    end

    --设置/读取本机IP
    local ip = this.read_ini_computer('本机设置.ini', '连接REDIS设置', '连接IP')
    if ip == '' then
        this.write_ini_computer('本机设置.ini', '连接REDIS设置', '连接IP', '127.0.0.1')
    else
        this.IP = ip
    end

    --设置/读取家族ID
    local family_id = this.read_ini_computer('本机设置.ini', '连接REDIS设置', '家族号')
    if family_id == '' then
        this.write_ini_computer('本机设置.ini', '连接REDIS设置', '家族号', '1')
    else
        this.FAMILY_ID = tonumber(family_id)
    end
    -- 组队链接码
    local team_connection = this.read_ini_computer('本机设置.ini', '连接REDIS设置', '组队连接码')
    if team_connection == '' then
        this.write_ini_computer('本机设置.ini', '连接REDIS设置', '组队连接码', '1')
    else
        this.TEAM_ID = tonumber(team_connection)
    end

    while not is_exit() do
        this.REDIS_OBJ = redis_ctx
        if this.REDIS_OBJ:connect(this.IP, 6379) then
            break
        else
            trace.output('连接redis服务器失败！')
        end
        decider.sleep(1000)
    end
end

--**********************************************************--
--向指定路径写入数据,数据不覆盖
--@param1 string:path for 路径
--@param2 table:data for 数据表
--@param3 number:update 不为空时不更新相同key
--@return bool:是否成功写入
--**********************************************************--
function redis_ent.write_json_data(path,data,update)
    local data_r = ''
    if type(data) == 'table' then
        data_r = data
        local data2 = this.get_json_data(path)
        if not table.is_empty(data2) then
            for key,val in pairs(data2) do
                local setVal = val
                for key1,val1 in pairs(data) do
                    if key == key1 then
                        if update == nil then
                            setVal = val1
                        end
                        break
                    end
                end
                data_r[key] = setVal
            end
        end
    end
    return this.set_json_data(path,data_r)

end


--------------------------------------------------------------------------------
-- 向redis获取指定路径下的数据(json)
--------------------------------------------------------------------------------
function redis_ent.get_json_data(path)
    local data = {}
    if path == nil or path == '' then
        return data
    end
    if type(redis_ent.REDIS_OBJ) ~= 'userdata' then
        return data
    end
    if not this.REDIS_OBJ:ping() then
        redis_ent.connect_redis()
    end
    local json_text = redis_ent.REDIS_OBJ:get_string(path)
    if json_text == 'null' or json_text == '' then
        return data
    end
    if string.len(json_text) > 0 then
        data = json_unit.decode(json_text)
    end
    return data
end

--**********************************************************--
--向redis写入数据
--@param1 string:PATH for redis中的键路径
--@param2 table:data for 写入redis中的数据
--@return {} or false or true
--**********************************************************--
function redis_ent.set_json_data(path, data)
    if path == nil or path == '' then
        return {}
    end
    if type(redis_ent.REDIS_OBJ) ~= 'userdata' then
        return {}
    end
    if not redis_ent.REDIS_OBJ:ping() then
        redis_ent.connect_redis()
    end
    if not data or data == '' then
        local nowRead = redis_ent.REDIS_OBJ:get_string(path)
        if nowRead ~= 'null' then
            redis_ent.REDIS_OBJ:set_string(path, 'null')
        end
        return {}
    end
    local json_text = json_unit.encode(data)
    if string.len(json_text) > 0 then
        local xx = redis_ent.REDIS_OBJ:set_string(path, json_text)
        return xx
    end
    return false
end

--------------------------------------------------------------------------------
-- 向redis获取指定路径下的数据(string格式)
--------------------------------------------------------------------------------
redis_ent.get_string_data = function(path, session, key)
    local str = this.REDIS_OBJ:get_string(path)
    local session_key = key
    if session then
        session_key = session .. ':' .. key
    end

    local str_r = ''
    local ini_obj = ini_unit:new()

    if ini_obj:parse(str) then
        str_r = ini_obj:get_string(session_key)
    end

    ini_obj:delete()
    return str_r
end

--------------------------------------------------------------------------------
-- 向redis设置指定路径下的数据(string格式)
--
-- @tparam       string     path        路径
-- @tparam       string     session     区块
-- @tparam       string     key         键
-- @tparam       string     value       值
-- @tparam       userdata   obj         对象[暂未使用]
-- @treturn      bool
-- @usage
-- local bool = redis_ent.set_string_redis_ini('路径',区块,键,值)
--------------------------------------------------------------------------------
redis_ent.set_string_data = function(path, session, key, value)
    local str = this.REDIS_OBJ:get_string(path)
    local session_key = key
    if session ~= nil then
        session_key = session .. ':' .. key
    end
    local ini_obj = ini_unit:new()
    local ret = false
    if ini_obj:parse(str) then
        local r = ini_obj:get_string(session_key)
        if r ~= value then
            ini_obj:set_string(session_key, value)
            local new_string = ini_obj:to_string()
            ret = this.REDIS_OBJ:set_string(path, new_string)
        end
    end
    ini_obj:delete()
    return ret

end



--**********************************************************--
--读取 UserData 指定KEY 本周记录次数
--@param1 string:session for 路径根目标下
--@param2 string:key for 键值
--@return number:本周次数
--**********************************************************--
function redis_ent.read_nums_this_week_by_key_from_userdata(session,key)
    local data = redis_ent.read_data_to_userdata_by_key(session,key)
    if type(data) == 'table' then
        if common.get_week_timestamp() == data[2] then
            return data[1]
        end
    end
    return 0
end

--**********************************************************--
--读取UserData指定key数据
--@param string:session for 路径根目标下
--@param string:key for 键值
--@return 任意数据类型 不存在数据则为 ''
--**********************************************************--
function redis_ent.read_data_to_userdata_by_key(session,key)
    local path = USERDATA_PATH..':'..session
    local data = redis_ent.read_data_to_redis_by_key(path,key)
    return data
end

--**********************************************************--
--向UserData指定key写入数据
--@param1 string:session for 路径根目标下
--@param2 string:key for 键值
--@param3 任意数据类型:args
--@return bool:是否成功
--**********************************************************--
function redis_ent.write_data_to_userdata_by_key(session,key,args)
    local path = USERDATA_PATH..':'..session
    local data = redis_ent.write_data_to_redis_by_key(path,key,args)
    return data
end

--**********************************************************--
--向指定路径指定KEY写入数据
--@param1 string:path for 路径
--@param2 string:key for 路径下数据表中键值
--@param3 args 任意数据类型
--@return bool:是否成功
--**********************************************************--
function redis_ent.write_data_to_redis_by_key(path,key,args)
    local data2 = redis_ent.get_json_data(path)
    data2[key] = args
    return redis_ent.set_json_data(path,data2)
end

--**********************************************************--
--读取指定路径,指定KEY数据
--@param1 string:path for 路径
--@param2 string:key for 路径下数据表中键值
--@return string or number or table or ''
--**********************************************************--
function redis_ent.read_data_to_redis_by_key(path,key)
    local data2 = this.get_json_data(path)
    local data = ''

    if not table.is_empty(data2) then
        if data2[key] ~= nil then
            data = data2[key]
        end
    end
    return data
end


--**********************************************************--
--写入UserData 指定KEY 本日记录次数
--@param1 string:session for 路径根目标下
--@param2 string:key for 键值
--@param3 number:count 写入次数
--@return number:本日次数
--**********************************************************--
function redis_ent.write_nums_this_day_by_key_from_userdata(session,key,count)

    local nums = redis_ent.read_nums_this_day_by_key_from_userdata(session,key) + 1
    if count ~= nil then
        nums = count
    end
    local data = {nums,
                  os.date("%m%d")}

    return redis_ent.write_data_to_userdata_by_key(session,key,data)
end

--**********************************************************--
--写入UserData 指定KEY 本周记录次数
--@param1 string:session for 路径根目标下
--@param2 string:key for 键值
--@param3 number:count 写入次数
--@return number:本周次数
--**********************************************************--
function redis_ent.write_nums_this_week_by_key_from_userdata(session,key,count)
    local nums = redis_ent.read_nums_this_week_by_key_from_userdata(session,key) + 1
    if count ~= nil then
        nums = count
    end
    local data = {nums,common.get_week_timestamp()}
    return this.write_data_to_userdata_by_key(session,key,data)
end


--**********************************************************--
--读取UserData 指定KEY 本日记录次数
--@param1 string:session for 路径根目标下
--@param2 string:key for 键值
--@return number:本日次数
--**********************************************************--
function redis_ent.read_nums_this_day_by_key_from_userdata(session,key)
    local data = redis_ent.read_data_to_userdata_by_key(session,key)
    if type(data) == 'table' then
        if os.date("%m%d") == data[2] then
            return data[1]
        end
    end
    return 0
end



-------------------------------------------------------------------------------------------------------------
-- 获取指定redis路径下可写位置,可扩展路径序号[对应路径下多个序号组成]
--
-- @tparam       any        key_args         指定key下需要配对的参数
-- @tparam       string     key_name         json中的字段key
-- @tparam       string     path             路径
-- @tparam       number     time_out         超时时间[默认600秒]
-- @tparam       number     max_t            可写批次[默认 10]
-- @tparam       number     max_data         当前批次可写最大[默认 40]
-- @tparam       userdata   obj              其他连接对象[为nil时G控制台设置的IP]
-- @treturn      number     idx              在表中的序号
-- @treturn      number     idx2             当前表的批次
-- @treturn      table      ret_data         当前路径批次下的表
-- @treturn      bool       is_exist         返回是否存在数据
-------------------------------------------------------------------------------------------------------------
redis_ent.get_idx_in_redis_table_list_path = function(key_args,key_name,path,time_out,max_t,max_data,obj)
    local name     = key_args
    -- 当前与角色名配对的key名
    key_name       = key_name or 'name'
    -- 当前路径下最大可设的路径数
    max_t          = max_t or 10
    -- 超时的时间
    time_out       = time_out or 600
    -- json中最大可写数
    max_data       = max_data or 40
    -- 保存当前redis路径下序号
    local idx      = 0
    -- 保存当前redis路径序号内表的序号
    local idx2     = 0
    -- 是否存在数据
    local is_exist = false
    -- 返回当前路径下数据
    local data     = {}
    local ret_data = {}
    local f_idx    = 0
    local f_idx2   = 0
    local f_data   = {}
    -- 遍历获取所有数据
    for i = 1,max_t do
        local path = path..i
        local data1 = this.get_json_data(path,obj)
        table.insert(data,data1)
    end
    -- 配对数据,销毁过期数据
    for i = 1,#data do
        local data1 = data[i]
        -- 移除超时
        for j = #data1,1,-1 do
            if not table.is_empty(data1[j]) then
                if  data1[j].time and os.time() - data1[j].time > time_out
                        or data1[j].day and data1[j].day ~= os.date('%m%d')  then
                    table.remove(data1,j)
                end
            end
        end
        -- 配对名称
        for k,v in pairs(data1) do
            if v[key_name] == name then
                if idx == 0 then
                    idx      = i
                    idx2     = k
                    is_exist = true
                else
                    table.remove(data1,k)
                end
            end
        end
        -- 保存自身数据
        if idx ~= 0 and table.is_empty(ret_data) then
            ret_data = data1
        end
        if f_idx2 == 0 and f_idx == 0 then
            if #data1 < max_data then
                f_idx = i
                f_data= data1
            end
        end
    end
    if f_idx ~= 0 and idx == 0 then
        idx  = f_idx
        idx2 = 0
        ret_data = f_data
    end
    return idx,idx2,ret_data,is_exist
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function redis_ent.__tostring()
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
function redis_ent.__newindex(t, k, v)
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
redis_ent.__index = redis_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function redis_ent:new(args)
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
    return setmetatable(new, redis_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return redis_ent:new()

-------------------------------------------------------------------------------------
