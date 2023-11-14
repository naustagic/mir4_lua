-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   ZhengHao
--- @email:    88888@qq.com
--- @date:     2023-2-11
--- @module:   func
--- @describe: 功能模块
--- @version:  v1.0
-------------------------------------------------------------------------------------
local VERSION = '20211017' -- version history at end of file
local AUTHOR_NOTE = '-[20211017]-'
---@class func
local func = {
    VERSION = VERSION,
    AUTHOR_NOTE = AUTHOR_NOTE,


}
local this = func

------------------------------------------------------------------------------------
-----以下新增
-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串) 读取表数据 从1开始
func.split = function(str, split_char)
    if str == nil or str == "" or str == " " or type(str) == "table" then
        return {}
    end
    local g_char_sp = ','
    if split_char ~= nil then
        g_char_sp = split_char
    end
    local sub_str_tab = {}
    while true do
        local pos = string.find(str, g_char_sp)
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        str = string.sub(str, pos + 1, #str)
    end
    return sub_str_tab
end

------------------------------------------------------------------------------------
func.split1 = function(str, split_char)
    local result = {}
    local length = string.len(str)
    local start = 1
    
    while start <= length do
        local nextIndex = string.find(str, split_char, start)
        if nextIndex == nil then
            nextIndex = length + 1
        end
        
        table.insert(result, string.sub(str, start, nextIndex - 1))
        start = nextIndex + 1
    end
    
    return result
end

-------------------------------------------------------------------------------------------------------
--
func.split_string = function(input_string, delimiter)
    if delimiter == nil then
        delimiter = '%s'
    end
    local result = {}
    for match in string.gmatch(input_string, '([^' .. delimiter .. ']+)') do
        table.insert(result, match)
    end
    return result
end

-------------------------------------------------------------------------------------------------------
--数量从小到大排序
function func.sort_num(x, y)
    return x.num < y.num
end

-------------------------------------------------------------------------------------------------------
--距离从小到大排序
func.sort = function(x, y)
    return x.dist < y.dist
end

-------------------------------------------------------------------------------------------------------
--获取本角色职业名
func.my_race = function()
    local race = local_player:race()
    if race == 0xC then
        return '战士'
    end
    if race == 0x15 or race == 22 then
        return '法师'
    end
    if race == 0x1F or race == 32 then
        return '道士'
    end
    return '其他'
end

-------------------------------------------------------------------------------------------------------
-- 负重百分比
func.get_bag_weight_per = function()
    -- 获取当前背包负重
    local bag_weight = item_unit.get_bag_weight()
    -- 获取最大负重
    local max_weight = item_unit.get_bag_max_weight()
    return bag_weight * 100 / max_weight
end

-------------------------------------------------------------------------------------------------------
--获取本角色职业名
func.my_job = function()
    local race = local_player:race()
    if race == 0xC then
        return 1
    end
    if race == 0x15 or race == 22 then
        return 2
    end
    if race == 0x1F or race == 32 then
        return 3
    end
    return 0
end

-------------------------------------------------------------------------------------------------------
--返回年份
func.get_time_year = function()
    return tonumber(os.date("%Y"))
end

--返回月份
func.get_time_mon = function()
    return tonumber(os.date("%m"))
end

--返回当日
func.get_time_day = function()
    return tonumber(os.date("%d"))
end

--返回当前时
func.get_time_h = function()
    return tonumber(os.date("%H"))
end

--返回当前分
func.get_time_m = function()
    return tonumber(os.date("%M"))
end

--返回当前秒
function func.get_time_s()
    return tonumber(os.date("%S"))
end

--返回星期
func.get_time_w = function()
    return tonumber(os.date("%w"))
end

-------------------------------------------------------------------------------------------------------
--A(x,y) ,B(x1,y1),C(x2,y2) A 代表目标坐标，B 代表圆心坐标 C 代表柱距坐标
func.is_rang_by_point = function(x, y, x1, y1, R)
    --
    local x2, y2 = x1 - R, y1
    local dist = this.get_dis_by_two_point(x1, y1, x2, y2) --  即把B坐标比作圆心，与C坐标的距离比作轴距

    local target = this.get_dis_by_two_point(x, y, x1, y1) --即 A坐标 与B坐标的距离，用于判断 是否在映射范围内
    if target < dist then
        --  即 A坐标  在 B与C 的范围内  卡路时  先寻C 再寻A
        return true
    end
    return false
end

-------------------------------------------------------------------------------------------------------
-- 计算2坐标距离
func.distance = function(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-------------------------------------------------------------------------------------------------------
---计算2坐标距离
func.get_dis_by_two_point = function(x, y, x1, y1)
    local jx = math.abs(x - x1)
    local jy = math.abs(y - y1)
    local distance = math.sqrt(jx * jx + jy * jy)
    if distance <= 0 then
        return math.ceil(distance)
    end
    if math.ceil(distance) == distance then
        distance = math.ceil(distance)
    else
        distance = math.ceil(distance) - 1
    end
    return distance
end

-------------------------------------------------------------------------------------------------------
-- 获取指定时间是否在 当日凌晨4点到隔日4点
func.is_time_rand_by_times = function(timestamp)
    timestamp                = timestamp or os.time()
    local d                  = this.get_time_day()
    local last_day_timestamp = this.get_timestamp_by_time_val(nil,nil,d - 1,4,5,0)
    local next_day_timestamp = this.get_timestamp_by_time_val(nil,nil,d + 1,4,5,0)
    if timestamp >= last_day_timestamp and timestamp < next_day_timestamp then
        return true
    end
    return false
end

-------------------------------------------------------------------------------------------------------
-- 获取指定时间的时间戳
func.get_timestamp_by_time_val = function( year,month,day,hour,min,sec )
    year  = year  or this.get_time_year()
    month = month or this.get_time_mon()
    day   = day   or this.get_time_day()
    hour  = hour  or this.get_time_h()
    min   = min   or this.get_time_m()
    sec   = sec   or this.get_time_s()
    local time = os.time({ year = year, month = month, day = day, hour = hour, min = min, sec = sec } )
    return time
end

-------------------------------------------------------------------------------------------------------
--每周54点刷新
func.GetWeek_timestamp = function()
    local thisweek = tonumber(os.date("%w"))
    local thishour = tonumber(os.date("%H"))
    local thisM = tonumber(os.date("%M"))
    local thisS = tonumber(os.date("%S"))
    if thisweek == 0 then
        return os.time() - thishour * 60 * 60 - thisM * 60 - thisS + 24 * 60 * 60 * 5 + 4 * 60 * 60
    elseif thisweek == 6 then
        return os.time() - thishour * 60 * 60 - thisM * 60 - thisS + 24 * 60 * 60 * 6 * 4 * 60 * 60
    elseif thisweek == 5 then
        return os.time() - thishour * 60 * 60 - thisM * 60 - thisS + 24 * 60 * 60 * 7 * 4 * 60 * 60
    else
        return os.time() - thishour * 60 * 60 - thisM * 60 - thisS + 24 * 60 * 60 * (5 - thisweek) * 4 * 60 * 60
    end
end

-------------------------------------------------------------------------------------------------------
--每天6点
func.Getday_sixh = function()
    local thishour = tonumber(os.date("%H"))
    local thisM = tonumber(os.date("%M"))
    local thisS = tonumber(os.date("%S"))
    return os.time() - thishour * 60 * 60 - thisM * 60 - thisS +  30 * 60 * 60
end

------------------------------------------------------------------------------------
-- 实例化新对象

function func.__tostring()
    return "Mirm func package"
end

func.__index = func

function func:new(args)
    local new = { }

    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end

    -- 设置元表
    return setmetatable(new, func)
end

-------------------------------------------------------------------------------------
-- 返回对象
return func:new()

-------------------------------------------------------------------------------------