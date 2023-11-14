------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   map_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class map_ent
local map_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'map_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = map_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local skill_unit = skill_unit
local main_ctx = main_ctx
local local_player = local_player
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function map_ent.super_preload()

end

function map_ent.is_move()
    local status = local_player:status()
    if status ~= 4 and status ~= 24 and status ~= 27 then
        return false
    end
    return true
end

-- 当前地图移动
function map_ent.cur_map_move(mpa_name, x, y, z, dist, str,ride, break_func)
    mpa_name = mpa_name or actor_unit.map_name()
    -- TODO:上下马
    -- TODO:关闭挂机
    while decider.is_working() do
        if local_player:dist_xy(x, y) < dist then
            break
        end
        if mpa_name ~= actor_unit.map_name() then
            break
        end
        if break_func and break_func() then
            break
        end
        if not map_ent.is_move() then
            actor_unit.move_to(x, y, z,actor_unit.map_id())
            decider.sleep(500)
        end
        if not ride then
            -- TODO：下马
        end
        trace.output(str)
        if map_ent.move_lag(600) then
            -- 卡图了
        end
        decider.sleep(100)
    end
end


--------------------------------------------------------------------------------
-- [判断] 判断是否卡位置
--
-- @static
-- @tparam      integer      num    在同一位置范围的次数
-- @treturn     boolean
-- @usage
-- if move_ent.move_lag() then main_ctx:end_game() end
--------------------------------------------------------------------------------
map_ent.move_lag = function(num)
    local ret_b = false
    num = num or 120
    this.check_auto = this.check_auto or 0
    if not this.last_x or this.last_x == 0 then
        this.last_x = local_player:cx()
        this.last_y = local_player:cy()
    else
        if local_player:dist_xy(this.last_x, this.last_y) < 2 then
            this.check_auto = this.check_auto + 1
        else
            this.last_x = 0
            this.last_y = 0
            this.check_auto = 0
        end
        if this.check_auto > num then
            this.check_auto = 0
            ret_b = true
        end
    end
    return ret_b
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function map_ent.__tostring()
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
function map_ent.__newindex(t, k, v)
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
map_ent.__index = map_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function map_ent:new(args)
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
    return setmetatable(new, map_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return map_ent:new()

-------------------------------------------------------------------------------------
