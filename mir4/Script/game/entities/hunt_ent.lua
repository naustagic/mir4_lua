------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   hunt_ent
--- @describe: 用户设置模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class hunt_ent
local hunt_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'hunt_ent module',
    -- 只读模式
    READ_ONLY = false,

    REDIS_PATH = '传奇4:游戏设置:机器[%s]:服务器[' .. main_ctx:c_server_name() .. ']用户设置',

}

local this = hunt_ent
local main_ctx = main_ctx
local skill_ctx = skill_ctx
local decider = decider
local actor_unit = actor_unit
local skill_unit = skill_unit
local func = func
local trace = trace
local local_player = local_player
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type skill_res
local skill_res = import('game/resources/skill_res')
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function hunt_ent.super_preload()
   

end

-- 自动刷怪
function hunt_ent.auto_hunt(map_name, map_id, x, y, z, str)
    if map_name == actor_unit.map_name() then
        if local_player:dist_xy(x, y) < 1000 then
            if local_player:auto_type() ~= 2 then
                actor_unit.set_auto_type(2)
                decider.sleep(1000)
            end
        else
            if local_player:auto_type() == 2 then
                if local_player:dist_xy(x, y) > 10000 then
                    map_ent.auto_move(map_id, x, y, z, str)
                end
            else
                map_ent.auto_move(map_id, x, y, z, str)
            end
        end
    else
        map_ent.auto_move(map_id, x, y, z, str)
    end
end




-- 攻击周围的敌人

function hunt_ent.move_hunt_pos_up_level(map_info)
    local x, y, z = map_info.x, map_info.y, map_info.z
    local map_id, map_name = map_info.map_id, map_info.map_name
    local str = '移动到'..map_name..'挂机刷怪'
    if map_name == actor_unit.map_name() then
        if func.is_rang_by_point(local_player:cx(), local_player:cy(), x, y, 5000) then
            hunt_ent.normal_kill_near_5mon()
            trace.output('自动刷怪中')
            if local_player:auto_type() ~= 2 then
                actor_unit.set_auto_type(2)
                decider.sleep(1000)
            end
        else
            map_ent.auto_move(map_id, x, y, z, str)
        end
    else
        map_ent.auto_move(map_id, x, y, z, str)
    end
end

-- 使用普通群体攻击怪物
function hunt_ent.normal_kill_near_5mon()
    local kill_dist = 1600
    local max_level_mon = 100
    local actor_list = actor_ent.get_near_mon_5list(kill_dist, max_level_mon)
    if #actor_list < 1 then
        return false
    end
    hunt_ent.use_skill(actor_list)

end



--圆点坐标x,y,范围R, 在范围内怪物坐标范围R2,怪物最大等级 monmaxlv
function hunt_ent.use_skill2()
    this.last_use_skill = this.last_use_skill or {}
    local race = actor_unit.get_char_race()
    local skill_list = skill_res.SKILL_INFO[race]
    local use_skill = false
    local killNum = 2
    local kill_dist = 1600
    local max_level_mon = 100
    local actor_list = actor_ent.get_near_mon_5list(kill_dist, max_level_mon)
    killNum = #actor_list
    if killNum == 0 then
        return false
    end
    for i = 1, #skill_list do
        local skill_name = skill_list[i].name
        local skill_cd = skill_list[i].cd
        local need_mp = skill_list[i].mp
        if local_player:mp() >= need_mp then
            --是否足够蓝量
            local yes_use_skill = true
            if this.last_use_skill[skill_name] then
                if os.time() - this.last_use_skill[skill_name] < skill_cd then
                    yes_use_skill = false
                end
            end
            if yes_use_skill then
                local skill_id,action_list = skill_ent.get_skill_id_and_action_by_name(skill_name)
                if skill_id ~= 0 then
                    yes_use_skill = false
                    for j = 1, #action_list do
                        local skill_action = action_list[j]
                        if  skill_action ~= 0 then
                            yes_use_skill = true
                            actor_unit.mul_attack_ex(actor_list, true, 0xC, skill_id, skill_action)
                            use_skill = true
                        end
                    end
                    if yes_use_skill then
                        this.last_use_skill[skill_name] = os.time()
                        break
                    end
                end
            end
        end
        if use_skill then
            break
        end
    end
    if not use_skill then
        hunt_ent.use_skill(actor_list)
    end
    return true
end





function hunt_ent.use_skill(actor_list,skill_id)--actor_unit.remote_attack

    local ticket_count = main_ctx:get_ticket_count()
    local race = actor_unit.get_char_race()
    local skill_ticket = skill_res.NORMAL_SKILL[race].skill_ticket
    this.LAST_USE_SKILL_TIME = this.LAST_USE_SKILL_TIME or 0
    if ticket_count - this.LAST_USE_SKILL_TIME > skill_ticket then
        skill_id = skill_id or skill_res.NORMAL_SKILL[race].skill_id
        local list = skill_unit.list(-1)
        for i = 1, #list
        do
            local obj = list[i]
            if skill_ctx:init(obj) and skill_ctx:id() == skill_id then
                for idx = 0,skill_ctx:action_num() - 1 do
                    local skill_action = skill_ctx:get_action_byidx(idx)
                    if skill_action ~= 0 then
                        if #actor_list > 0 then
                            actor_unit.mul_attack_ex(actor_list,true, 0xB, skill_id, skill_action)
                        end
                    end
                end
                break
            end
        end
        this.LAST_USE_SKILL_TIME = main_ctx:get_ticket_count()
    end
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function hunt_ent.__tostring()
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
function hunt_ent.__newindex(t, k, v)
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
hunt_ent.__index = hunt_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function hunt_ent:new(args)
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
    return setmetatable(new, hunt_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return hunt_ent:new()

-------------------------------------------------------------------------------------