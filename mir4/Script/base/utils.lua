------------------------------------------------------------------------------------
-- base/utils.lua
--
-- 本模块提供了一些通用的实用函数，包括字符串处理、表操作、数学计算等。
--
-- @module      utils
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- -- 工具函数
-- local utils = utils
------------------------------------------------------------------------------------

-- 模块定义
local utils = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION                   = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE               = '2023-03-22 - Initial release',
    -- 模块名称
    MODULE_NAME               = 'utils module',
    -- 只读模式
    READ_ONLY                 = false,
}

-- 模块实例
local this = utils
-- 文件系统
local lfs = lfs
-- 优化列表
local os = os
local math = math
local string = string
local table = table
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local tonumber = tonumber
local setmetatable = setmetatable
local error = error
local rawset = rawset
local xxxmsg = xxxmsg

------------------------------------------------------------------------------------
-- 扩展 table 功能: table.index_of
--
-- @tparam       table     t                要搜索的表
-- @tparam       any       val              要查找的值
-- @treturn      integer                    如果找到，则返回值的索引；否则返回 nil
------------------------------------------------------------------------------------
function table.index_of(t, val)
    for i = 1, #t do
        if t[i] == val then
            return i
        end
    end
    return nil
end

------------------------------------------------------------------------------------
-- 扩展 table 功能: 判断表是否为空
--
-- @tparam       table     t                要检查的表
-- @treturn      boolean                    如果表为空，则返回 true；否则返回 false
------------------------------------------------------------------------------------
function table.is_empty(t)
    return (not t) or (next(t) == nil)
end

------------------------------------------------------------------------------------
-- 检查文件是否存在
--
-- @static
-- @tparam       string    path             文件路径
-- @treturn      boolean                    存在返回 true，不存在返回 false
------------------------------------------------------------------------------------
function utils.file_exists(path)
    local f = io.open(path, 'rb')
    if f then
        f:close()
        return true
    end
    return false
end

------------------------------------------------------------------------------------
-- 读取二进制文件并返回其内容
--
-- @static
-- @tparam       string    filename         文件路径
-- @treturn      string|nil                 文件内容，如果读取失败则返回 nil
------------------------------------------------------------------------------------
function utils.read_binary_file(filename)
    local f, err = io.open(filename, 'rb')
    if not f then
        return nil, err
    end
    local content = f:read('*all')
    f:close()
    return content
end

------------------------------------------------------------------------------------
-- 将字符串写入二进制文件
--
-- @static
-- @tparam       string    filename         写入文件的路径
-- @tparam       string    str              待写入的字符串
-- @treturn      boolean                    写入是否成功
------------------------------------------------------------------------------------
function utils.write_binary_file(filename, str)
    local f, err = io.open(filename, 'wb')
    if not f then
        return false, err
    end
    f:write(str)
    f:close()
    return true
end

------------------------------------------------------------------------------------
-- 创建目录
--
-- @tparam       string    path             要创建的目录路径
-- @treturn      boolean                    成功创建目录则返回 true，否则返回 false
------------------------------------------------------------------------------------
function utils.create_directory(path)
    local result = false
    if not lfs.attributes(path, 'mode') then
        local success, err = lfs.mkdir(path)
        if not success then
            error(string.format('创建目录失败: %s (%s)', path, err))
        end
        result = success
    end
    return result
end

------------------------------------------------------------------------------------
-- 文件复制
--
-- @tparam       string    src              源文件路径
-- @tparam       string    dest             目标文件路径
-- @return       boolean                    成功复制文件则返回 true，否则抛出错误
------------------------------------------------------------------------------------
function utils.copy_file(src, dest)
    local input, err1 = io.open(src, 'rb')
    if not input then
        error(string.format('打开源文件失败: %s (%s)', src, err1))
    end

    local output, err2 = io.open(dest, 'wb')
    if not output then
        input:close()
        error(string.format('打开目标文件失败: %s (%s)', dest, err2))
    end

    local data = input:read('*a')
    output:write(data)

    input:close()
    output:close()

    return true
end

------------------------------------------------------------------------------------
-- 复制目录及其子目录
--
-- @tparam       string    src              源目录路径
-- @tparam       string    dest             目标目录路径
-- @treturn      number                     成功复制的文件数量
------------------------------------------------------------------------------------
function utils.copy_directory(src, dest)
    local result = 0
    this.create_directory(dest)
    for file in lfs.dir(src) do
        if file ~= '.' and file ~= '..' then
            local src_path = src .. '\\' .. file
            local dest_path = dest .. '\\' .. file
            local attr = lfs.attributes(src_path, 'mode')
            if attr == 'directory' then
                this.copy_directory(src_path, dest_path)
            elseif attr == 'file' then
                if this.copy_file(src_path, dest_path) then
                    result = result + 1
                end
            else
                error(string.format('未知文件类型: %s', src_path))
            end
        end
    end
    return result
end

------------------------------------------------------------------------------------
-- 生成随机字符串
--
-- @tparam       integer   n                随机字符串的长度，默认为 8
-- @treturn      string                     生成的随机字符串
------------------------------------------------------------------------------------
function utils.random_string(n)
    n = n or 8 -- 如果n为nil，使用默认值8
    local chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local result = ''
    for i = 1, n do
        local index = math.random(#chars) -- 随机生成下标
        result = result .. chars:sub(index, index) -- 取出字符并追加到结果字符串
    end
    return result
end

------------------------------------------------------------------------------------
--- 将输入字符串按照指定分隔符分割成多个字符串并返回。
--
-- @tparam       integer   n                随机字符串的长度，默认为 8
-- @tparam       string    input_string     输入字符串
-- @tparam       string    delimiter        分隔符，默认为'%s' （空格、回车、制表符）
-- @treturn      table                      包含分割后的字符串的table
-- @usage
-- local input_string = 'apple,orange,banana'
-- local delimiter = ','
-- local result = utils.split_string(input_string, delimiter)
-- for i, v in ipairs(result) do
--     print(i, v)
-- end
---------------------------------------------------------------------------------------
function utils.split_string(input_string, delimiter)
    if delimiter == nil then
        delimiter = '%s'
    end
    local result = {}
    for match in string.gmatch(input_string, '([^' .. delimiter .. ']+)') do
        table.insert(result, match)
    end
    return result
end

------------------------------------------------------------------------------
-- 获取当前年份。
--
-- @treturn      number                     当前年份
------------------------------------------------------------------------------
function utils.get_year()
    return tonumber(os.date('%Y'))
end

------------------------------------------------------------------------------
-- 获取当前月份。
--
-- @treturn      number                     当前月份
------------------------------------------------------------------------------
function utils.get_month()
    return tonumber(os.date('%m'))
end

------------------------------------------------------------------------------
-- 获取当前星期几的编号。
--
-- @treturn      number                     当前星期几的编号，0表示星期天。
------------------------------------------------------------------------------
function utils.get_weekday()
    return tonumber(os.date('%w'))
end

------------------------------------------------------------------------------
-- 获取当前日期。
--
-- @treturn      number                     当前日期
------------------------------------------------------------------------------
function utils.get_day()
    return tonumber(os.date('%d'))
end

------------------------------------------------------------------------------
-- 获取当前小时。
--
-- @treturn      number                     当前小时
------------------------------------------------------------------------------
function utils.get_hour()
    return tonumber(os.date('%H'))
end

------------------------------------------------------------------------------
-- 获取当前分钟。
--
-- @treturn      number                     当前分钟
------------------------------------------------------------------------------
function utils.get_minute()
    return tonumber(os.date('%M'))
end

------------------------------------------------------------------------------
-- 获取当前秒数。
--
-- @treturn      number                     当前秒数
------------------------------------------------------------------------------
function utils.get_second()
    return tonumber(os.date('%S'))
end

------------------------------------------------------------------------------
-- 将时间戳转换为日期时间
--
-- @tparam       number    timestamp        时间戳
-- @treturn      string                     日期时间，格式为"YYYY-MM-DD HH:mm:SS"
-- @usage
-- local datetime = utils.convert_datetime(1684489467)
-- print(datetime) -- 2023-03-28 20:44:27
------------------------------------------------------------------------------
function utils.convert_datetime(timestamp)
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

------------------------------------------------------------------------------
-- 将日期时间转换为时间戳
--
-- @tparam       string    datetime 日期时间，格式为"YYYY-MM-DD HH:mm:SS"
-- @treturn      number                     时间戳
-- @usage
-- local timestamp = utils.convert_timestamp("2023-03-28 20:44:27")
-- print(timestamp) -- 1684489467
------------------------------------------------------------------------------
function utils.convert_timestamp(datetime)
    local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = datetime:match(pattern)
    return os.time({year=year, month=month, day=day, hour=hour, min=min, sec=sec})
end

------------------------------------------------------------------------------
-- 计算两点之间的距离
--
-- @tparam       number    x1               第一个点的x坐标
-- @tparam       number    y1               第一个点的y坐标
-- @tparam       number    x2               第二个点的x坐标
-- @tparam       number    y2               第二个点的y坐标
-- @treturn      number                     距离
------------------------------------------------------------------------------
function utils.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

------------------------------------------------------------------------------
-- 计算两点之间的距离和方向角度
--
-- @tparam       number    x1               第一个点的x坐标
-- @tparam       number    y1               第一个点的y坐标
-- @tparam       number    x2               第二个点的x坐标
-- @tparam       number    y2               第二个点的y坐标
-- @treturn      number                     距离
-- @treturn      number                     方向角度（相对于x轴正方向）
-- @usage
-- local m_x, m_y = 20, 30
-- local p_x, p_y = 50, 60
-- local distance, direction  = utils.dist_and_direction(m_x, m_y, p_x, p_y)
-- print('距离:' .. distance)
-- print('方向:' .. direction)
------------------------------------------------------------------------------
function utils.dist_and_direction(x1, y1, x2, y2)    
    local dx, dy = x2 - x1, y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    local direction = 0
    if dx == 0 and dy == 0 then
        direction = 0
    elseif dx == 0 and dy > 0 then
        direction = 90
    elseif dx == 0 and dy < 0 then
        direction = 270
    elseif dx > 0 and dy >= 0 then
        direction = math.deg(math.atan(dy / dx))
    elseif dx < 0 and dy >= 0 then
        direction = 180 + math.deg(math.atan(dy / dx))
    elseif dx < 0 and dy < 0 then
        direction = 180 + math.deg(math.atan(dy / dx))
    elseif dx > 0 and dy < 0 then
        direction = 360 + math.deg(math.atan(dy / dx))
    end
    return distance, direction
end

------------------------------------------------------------------------------
-- 判断A点是否在B点的半径范围内
--
-- @tparam       number    ax               点 A 的 x 坐标
-- @tparam       number    ay               点 A 的 y 坐标
-- @tparam       number    bx               点 B 的 x 坐标
-- @tparam       number    by               点 B 的 y 坐标
-- @tparam       number    radius           半径范围
-- @treturn      boolean                    点 A 在点 B 的半径范围内，返回 true，否则 false。
-- @usage
-- local ax, ay = 3, 4
-- local bx, by = 7, 8
-- local radius = 5
-- if utils.is_inside_radius(ax, ay, bx, by, radius) then
--     print("点A在以点B为圆心、半径为5的圆内")
-- else
--     print("点A不在以点B为圆心、半径为5的圆内")
-- end
------------------------------------------------------------------------------
function utils.is_inside_radius(ax, ay, bx, by, radius)
    local dx, dy = ax - bx, ay - by
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance <= radius
end

------------------------------------------------------------------------------
-- 判断指定点 是否在 以点为中心 距离r形成的正方形中
function utils.is_inside_quire(x, y, center_x, center_y, distance)
    local minx = center_x - distance
    local maxx = center_x + distance
    local miny = center_y - distance
    local maxy = center_y + distance

    if x >= minx and x <= maxx and y >= miny and y <= maxy then
        return true
    else
        return false
    end
end

------------------------------------------------------------------------------
-- 判断点是否在多边形内部
-- @param pointX 点的X坐标
-- @param pointY 点的Y坐标
-- @param polygon 多边形的顶点坐标表 { {x = x1, y = y1}, {x = x2, y = y2}, ... }
-- @return boolean 点是否在多边形内部
function utils.is_point_in_polygon(pointX, pointY, polygon)
    local isInPolygon = false
    local j = #polygon
    for i = 1, #polygon do
        local px1, py1, px2, py2 = polygon[i].x, polygon[i].y, polygon[j].x, polygon[j].y
        if (py1 < pointY and py2 >= pointY) or (py2 < pointY and py1 >= pointY) then
            if px1 + (pointY - py1) / (py2 - py1) * (px2 - px1) < pointX then
                isInPolygon = not isInPolygon
            end
        end
        j = i
    end
    return isInPolygon
end

------------------------------------------------------------------------------
-- 检查点是否在多边形内。
--
-- @tparam       number    px               点的 x 坐标。
-- @tparam       number    py               点的 y 坐标。
-- @tparam       table     coords           包含多边形顶点坐标的表。
-- @treturn      boolean                    如果点在多边形内，则返回 true，否则返回 false。
-- @usage
-- local coords = {
--     {x = 100, y = 100},
--     {x = 200, y = 100},
--     {x = 200, y = 400},
--     {x = 100, y = 100}
-- }
-- local result = utils.is_inside_polygon(150, 200, coords)
-- print(result)  -- 输出：true
------------------------------------------------------------------------------
function utils.is_inside_polygon(px, py, coords)
    local n = #coords
    -- 检查并自动闭合多边形
    if coords[1].x ~= coords[n].x or coords[1].y ~= coords[n].y then
        coords[n+1] = {x = coords[1].x, y = coords[1].y}
        n = n + 1
    end
    local inside = false
    local xj, yj = coords[n].x, coords[n].y
    local not_inside = true
    for i = 1, n do
        local xi, yi = coords[i].x, coords[i].y
        local py_yi = py - yi
        local py_yj = py - yj
        if ((yi > py) ~= (yj > py)) and
                (px - xi < (xj - xi) * py_yi / (py_yj - py_yi)) then
            inside = not_inside
            not_inside = not not_inside
        end
        xj, yj = xi, yi
    end
    return inside
end

------------------------------------------------------------------------------
-- 检查点是否在四边形内。
--
-- @tparam       number    px               点的 x 坐标。
-- @tparam       number    py               点的 y 坐标。
-- @tparam       table     coords           包含矩形顶点坐标的表。
-- @treturn      boolean                    如果点在四边形内，则返回 true，否则返回 false。
-- @usage
-- local quad_coords = {
--     {x = 100, y = 100},
--     {x = 200, y = 100},
--     {x = 200, y = 300},
--     {x = 100, y = 300},
-- }
-- local result = utils.is_inside_quad(150, 150, quad_coords)
-- print(result)  -- 输出：true
------------------------------------------------------------------------------
function utils.is_inside_quad(px, py, coords)
    return this.is_inside_polygon(px, py, coords)
end

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function utils.__tostring()
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
function utils.__newindex(t, k, v)
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
utils.__index = utils

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function utils:new(args)
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
    return setmetatable(new, utils)
end

------------------------------------------------------------------------------------
-- 返回实例对象
------------------------------------------------------------------------------------
return utils:new()

------------------------------------------------------------------------------------
