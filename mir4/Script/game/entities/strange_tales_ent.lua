------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   strange_tales_ent
--- @describe: 奇缘模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class strange_tales_ent
local strange_tales_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'strange_tales_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = strange_tales_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local mail_unit = mail_unit
local main_ctx = main_ctx
local local_player = local_player
local relation_unit =  relation_unit
local actor_unit = actor_unit
local relation_ctx = relation_ctx
local ui_unit = ui_unit

---@type quest_ent
local quest_ent = import('game/entities/quest_ent')
---@type map_ent
local map_ent = import('game/entities/map_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function strange_tales_ent.super_preload()
    --strange_tales_ent.get_mail()
end

--  奇缘数据
function strange_tales_ent.test_relation_unit()
    local relation_obj = relation_unit:new()
    local list = relation_unit.list()
    xxmsg('奇缘数量：'..#list)

    for i = 1, #list
    do 
        local obj = list[i]
        if relation_obj:init(obj) then 
            xxmsg(string.format('%X   %08X - %08X   %03u  %-6s   %08X - %-16s  %0.1f - %0.1f - %0.1f   %-24s   %24s   %s',
                obj,
                relation_obj:id(),
                relation_obj:sub_id(),
                relation_obj:idx(),
                relation_obj:is_kill_monster(),
                relation_obj:map_id(),
                relation_obj:map_name(),
                relation_obj:tx(),
                relation_obj:ty(),
                relation_obj:tz(),
                relation_obj:main_name(),
                relation_obj:name(),
                relation_obj:desc()
    
        ))

        end

    end
end

-- 获取奇缘任务信息
function strange_tales_ent.get_all_strange_tales_task_info()
    local strange_tales_task_list = {}
    local relation_list = relation_unit.list(-1)
    for _, obj in pairs(relation_list) do
        if relation_ctx:init(obj) then
            local relation = {
                -- 指针
                obj = obj,
                --大任务id
                id = relation_ctx:id(),
                --子任务id
                sub_id = relation_ctx:sub_id(),
                -- 子任务序号
                idx = relation_ctx:idx(),
                -- 是否需要杀怪
                is_kill_monster = relation_ctx:is_kill_monster(),
                -- 地图id
                map_id = relation_ctx:map_id(),
                -- 地图名字
                map_name = relation_ctx:map_name(),
                -- x
                tx = relation_ctx:tx(),
                -- y
                ty = relation_ctx:ty(),
                -- z
                tz = relation_ctx:tz(),
                -- 人物名字
                main_name = relation_ctx:main_name(),
                -- 子任务名字
                name = relation_ctx:name(),
                -- 任务描述
                desc = relation_ctx:desc(),
            }
            table.insert(strange_tales_task_list, relation)
        end
    end
    return strange_tales_task_list
end

-- 做奇缘任务
function strange_tales_ent.do_task()

    local task_list = strange_tales_ent.get_all_strange_tales_task_info()
    local out_dis = 100

    -- xxmsg(string.format("%s,%s,%s,%s",task_list[3].tx, task_list[3].ty, task_list[3].tz, task_list[3].map_id))
    -- map_ent.auto_move_to(task_list[3].tx, task_list[3].ty, task_list[3].tz, task_list[3].map_id) 
    -- xxmsg(ui_unit.debug(0))
    for i = 4, #task_list do
        local task_info = task_list[i]
        xxmsg(string.format("%s,%s,%s",relation_unit.relation_is_finish(task_info.sub_id),relation_unit.relation_is_finish(task_info.id),relation_unit.relation_is_finish(task_info.idx)))
        xxmsg(string.format("%s,%s,%s",relation_unit.relation_is_over(task_info.sub_id),relation_unit.relation_is_over(task_info.id),relation_unit.relation_is_over(task_info.idx)))
        xxmsg(string.format("%s,%s,%s",task_info.sub_id,task_info.id,task_info.idx))
        xxmsg(string.format("%s,%s,%s",relation_unit.get_under_way_ptr(task_info.sub_id),relation_unit.get_under_way_ptr(task_info.id),relation_unit.get_under_way_ptr(task_info.idx) ))
        xxmsg(task_info.sub_id)
        xxmsg(task_info.tx)
        xxmsg(task_info.ty)
        xxmsg(task_info.tz)
        -- 子任务是否已完成
        if not relation_unit.relation_is_finish(task_info.sub_id) then
            local order_x = task_info.tx
            local order_y = task_info.ty
            local order_z = task_info.tz
            xxmsg(string.format("%s,%s,%s,%s",order_x,order_y,order_z,task_info.map_id))
            map_ent.auto_move_to(order_x, order_y, order_z, task_info.map_id) 
            decider.sleep(1000)

            while decider.is_working() do
                
                -- 走不过去的情况瞬移
                local ScreenMsg_C = ui_unit.get_parent_widget('ScreenMsg_C', true)
                if ScreenMsg_C ~= 0 then
                    xxmsg("瞬移")
                    actor_unit.fast_move(order_x, order_y, order_z) 
                end

                -- 奇缘专门的地图需要自己写资源路径跳转

                -- 走到进行对话，没考虑杀怪任务后续任务完成函数修改后再添加
                if not map_ent.is_move() and local_player:dist_xy(order_x, order_y) < out_dis then
                    xxmsg("说话")
                    relation_unit.relation_talk(task_info.id, task_info.idx) 
                    quest_ent.skip_game()
                    break
                end

                decider.sleep(1000)

            end
        end

        if not decider.is_working() then
            break
        end

        -- xxmsg(relation_unit.is_receive_main_reward(i)) -- 主奖励是否领取
        -- relation_unit.relation_is_finish(int nId)

    end
end

-- 检测是否到目标地点
function strange_tales_ent.check_arrive_order(x, y, z)
    xxmsg(string.format("%s,%s,%s,%s,%s,%s",local_player:cx(),x,local_player:cy(),y,local_player:cz(),z))

    if local_player:cx() == x and local_player:cy() == y and local_player:cz() == z then
        return true
    else
        return false
    end
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function strange_tales_ent.__tostring()
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
function strange_tales_ent.__newindex(t, k, v)
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
strange_tales_ent.__index = strange_tales_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function strange_tales_ent:new(args)
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
    return setmetatable(new, strange_tales_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return strange_tales_ent:new()

-------------------------------------------------------------------------------------

