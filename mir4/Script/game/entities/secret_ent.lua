------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   secret_ent
--- @describe: 秘境峰模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class secret_ent
local secret_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'secret_ent module',
    -- 只读模式
    READ_ONLY = false,
}
-- 地图跑点序号
-- local map_point_index = 1 
-- 地图跑点信息
local map_point_info = nil
-- 实例对象
local this = secret_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local mail_unit = mail_unit
local main_ctx = main_ctx
local local_player = local_player
local quest_unit = quest_unit
local actor_unit = actor_unit
---@type secret_res
local secret_res = import('game/resources/secret_res')
---@type map_ent
local map_ent = import('game/entities/map_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function secret_ent.super_preload()
    map_point_info = nil
end

-- 是否可进入秘境峰 没检测背包是否存在门票
--@param id:层数 为空检测是否可以进入一层
function secret_ent.check_qualification(id)
    id = id or 0x3E9
    return quest_unit.secret_can_enter(id)
end

-- 进入秘境峰
function secret_ent.enter_secret(id)
    local map_name = actor_unit.map_name()
    local fight_list = secret_res.FIGHT_LIST[map_name]
    -- 判断当前是否在秘境峰里 为空则不在 不重复进入秘境
    if not table.is_empty(fight_list) then
        return false
    end

    -- 判断最高可以进入的层数
    if id == nil then
        for i = 10, 0, -1 do
            -- xxmsg(string.format('秘境峰几层可以进入%s',secret_ent.check_qualification(0x3E9+i)))
            if secret_ent.check_qualification(0x3E9+i) then
                quest_unit.enter_secret(0x3E9+i)
                break
            end
        end
    elseif secret_ent.check_qualification(id) then
        id = id and id or 0x3E9
        quest_unit.enter_secret(id)
    end
end

-- 跑到指定位置开启自动战斗
function secret_ent.run_fight()
    local map_name = actor_unit.map_name()
    local fight_list = secret_res.FIGHT_LIST[map_name]
    -- 判断当前是否在秘境峰里 为空则不在
    if table.is_empty(fight_list) then
        return false
    end

    -- 逃跑回血 血量70%跳出循环或者60s后
    map_ent.escape_for_recovery() 
    -- 地图标不为空，没在移动，自动战斗没开启
    if not table.is_empty(fight_list) and not map_ent.is_move() and local_player:auto_type() ~= 2 then
        local map_info = fight_list[math.random(#fight_list)]
        map_point_info = map_info
        map_ent.auto_move(nil, map_info.x, map_info.y, map_info.z, '寻路到指定位置', 100, nil, secret_ent.begin_fight)
        this.begin_fight()
    end
end

-- 到指定位置后开启自动战斗
function secret_ent.begin_fight()
    -- 逃跑回血 血量70%跳出循环或者60s后
    map_ent.escape_for_recovery()
    local within = func.is_rang_by_point(local_player:cx(), local_player:cy(), map_point_info.x, map_point_info.y, 300)
    if not map_ent.is_move() and within then
        if local_player:auto_type() ~= 2 then
            trace.output('自动打怪中')
            actor_unit.set_auto_type(2)
            return true
        else
            trace.output('[秘境峰] 自动打怪中')
        end
    end
    decider.sleep(100)
    return false
end




------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function secret_ent.__tostring()
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
function secret_ent.__newindex(t, k, v)
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
secret_ent.__index = secret_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function secret_ent:new(args)
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
    return setmetatable(new, secret_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return secret_ent:new()

-------------------------------------------------------------------------------------
