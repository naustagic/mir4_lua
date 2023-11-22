------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   shop_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class shop_ent
local shop_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'shop_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = shop_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local actor_unit = actor_unit
local shop_unit = shop_unit
local quest_unit = quest_unit
---@type shop_res
local shop_res = import('game/resources/shop_res')
---@type item_ent
local item_ent = import('game/entities/item_ent')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type game_ent
local game_ent = import('game/entities/game_ent')

local local_player = local_player
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function shop_ent.super_preload()
    this.wi_auto_buy_item = decider.run_interval_wrapper('自动购买物品', this.auto_buy_item, 1000 * 60 * 10)

    this.wi_mf_map_auto_buy_item = decider.run_interval_wrapper('魔方自动购买物品', this.mf_map_auto_buy_item, 1000 * 60 * 10)


end

function shop_ent.auto_buy_item()
    local buy_list = {
        ['小型生命值恢复药水'] = {min_num  = 20,max_num = 200,buy_min_num = 100},
        ['中型生命值恢复药水'] = {min_num  = 200,max_num = 2000,buy_min_num = 200},
        ['大型生命值恢复药水'] = {min_num  = 200,max_num = 1000,buy_min_num = 200},
        ['小型魔力恢复药水'] = {min_num  = 20,max_num = 200,buy_min_num = 100},
        ['中型魔力恢复药水'] ={min_num  = 200,max_num = 2000,buy_min_num = 200},
        ['大型魔力恢复药水'] ={min_num  = 200,max_num = 1000,buy_min_num = 200},
    }

    local hp_name, map_name = game_ent.use_hp_type()
    if hp_name == '中型生命值恢复药水' then
        shop_ent.buy_item(hp_name, buy_list[hp_name].min_num, buy_list[hp_name].max_num, buy_list[hp_name].buy_min_num)
        shop_ent.buy_item(map_name, buy_list[map_name].min_num, buy_list[map_name].max_num, buy_list[map_name].buy_min_num)
    end



    shop_ent.buy_item('瞬移卷轴', 10, 50, 20)
end


function shop_ent.mf_map_auto_buy_item()
    local buy_list = {
        ['小型生命值恢复药水'] = {min_num  = 20,max_num = 200,buy_min_num = 100},
        ['中型生命值恢复药水'] = {min_num  = 200,max_num = 1000,buy_min_num = 200},
        ['大型生命值恢复药水'] = {min_num  = 200,max_num = 1000,buy_min_num = 200},
        ['小型魔力恢复药水'] = {min_num  = 20,max_num = 200,buy_min_num = 100},
        ['中型魔力恢复药水'] ={min_num  = 200,max_num = 1000,buy_min_num = 200},
        ['大型魔力恢复药水'] ={min_num  = 200,max_num = 1000,buy_min_num = 200},
    }
    local hp_name, map_name = game_ent.use_hp_type()
    if hp_name == '中型生命值恢复药水' then
        shop_ent.mf_auto_buy_item(hp_name, buy_list[hp_name].min_num, buy_list[hp_name].max_num, buy_list[hp_name].buy_min_num)
        shop_ent.mf_auto_buy_item(map_name, buy_list[map_name].min_num, buy_list[map_name].max_num, buy_list[map_name].buy_min_num)
    end
end




-- 去买回城卷轴
function shop_ent.buy_item(item_name, min_num, max_num, buy_min_num)
    local map_name = actor_unit.map_name()
    local merchant_type = '药水商人'
    if item_name == '花酒' then
        merchant_type = '酒商'
    elseif item_name == '【秋药东】的杂物箱' then
        merchant_type = '包袱商人'
    elseif item_name == '瞬移卷轴' then
        merchant_type = '杂货商人'
    end

    local npc_info = shop_res.get_near_npc_info(map_name, merchant_type)
    if table.is_empty(npc_info) then
        xxmsg('该地图附近没有商人npc')
        return false, '该地图附近没有商人npc'
    end
    local npc_map_name = npc_info.map_name
    local npc_x, npc_y, npc_z = npc_info.npc_pos.x, npc_info.npc_pos.y, npc_info.npc_pos.z
    local price = npc_info.items[item_name].price
    local item_id = npc_info.items[item_name].item_id
    local shop_id = npc_info.items[item_name].shop_id
    local npc_name = npc_info.npc_name
    while decider.is_working() do
        local my_item_num = item_ent.get_item_num_by_name(item_name)
        if my_item_num > min_num then
            --return false, '背包内' .. item_name .. '物品数量足够'
            xxmsg('背包内' .. item_name .. '物品数量足够')
            break
        end
        local buy_num = max_num - my_item_num
        buy_num = shop_ent.calc_num(buy_num, price, 10000)
        if buy_num < buy_min_num then
            xxmsg('购买' .. item_name .. '物品数量低于最小值')
            break
        end

        if local_player:hp() > 0 then
            local str = '去买' .. item_name .. ' - 移动中'
            if actor_unit.map_name() == npc_map_name then
                if local_player:dist_xy(npc_x, npc_y) < 100 then
                    -- 获取npc信息
                    local npc_data = actor_ent.get_npc_id_by_name(npc_name)
                    if npc_data ~= 0 then
                        local money = actor_unit.get_cost_data(2)
                        shop_unit.buy_npc_item_ex(shop_id, npc_data, item_id, buy_num)
                        decider.sleep(1000)
                        for i = 1, 10 do
                            trace.output(string.format('购买[%s] %s个 中...%s/10', item_name, buy_num, i))
                            if actor_unit.get_cost_data(2) ~= money then
                                break
                            end
                            decider.sleep(1000)
                        end
                    else
                        str = '买' .. item_name .. ' - 等待NPC：' .. npc_name .. ''
                        trace.output()
                    end
                else
                    map_ent.auto_move(npc_map_name, npc_x, npc_y, npc_z, str, 100)
                end
            else
                map_ent.auto_move(npc_map_name, npc_x, npc_y, npc_z, str, 100)
            end
        else
            -- TODO：复活
        end
        decider.sleep(1000)
    end
end


-- 去买回城卷轴
function shop_ent.mf_auto_buy_item(item_name, min_num, max_num, buy_min_num)
    local map_name = actor_unit.map_name()
    local merchant_type = '药水商人'
    if item_name == '花酒' then
        merchant_type = '酒商'
    elseif item_name == '【秋药东】的杂物箱' then
        merchant_type = '包袱商人'
    elseif item_name == '瞬移卷轴' then
        merchant_type = '杂货商人'
    end

    local npc_info = shop_res.MERCHANT['魔方阵'][merchant_type]
    if table.is_empty(npc_info) then
        return false, '该地图附近没有商人npc'
    end
    local npc_map_name = npc_info.map_name
    local npc_x, npc_y, npc_z = npc_info.npc_pos.x, npc_info.npc_pos.y, npc_info.npc_pos.z
    local price = npc_info.items[item_name].price
    local item_id = npc_info.items[item_name].item_id
    local shop_id = npc_info.items[item_name].shop_id
    local npc_name = npc_info.npc_name
    while decider.is_working() do
        local my_item_num = item_ent.get_item_num_by_name(item_name)
        if my_item_num > min_num then
            xxmsg('背包内' .. item_name .. '物品数量足够')
            break
        end
        local buy_num = max_num - my_item_num
        buy_num = shop_ent.calc_num(buy_num, price, 10000)
        if buy_num < buy_min_num then
            break
        end

        if local_player:hp() > 0 then
            local str = '去买' .. item_name .. ' - 移动中'

            if string.find(actor_unit.map_name(),'魔方阵') then
                if local_player:dist_xy(npc_x, npc_y) < 100 then
                    -- 获取npc信息
                    local npc_data = actor_ent.get_npc_id_by_name(npc_name)
                    if npc_data ~= 0 then
                        local money = actor_unit.get_cost_data(2)
                        shop_unit.buy_npc_item_ex(shop_id, npc_data, item_id, buy_num)
                        decider.sleep(1000)
                        for i = 1, 10 do
                            trace.output(string.format('购买[%s] %s个 中...%s/10', item_name, buy_num, i))
                            if actor_unit.get_cost_data(2) ~= money then
                                break
                            end
                            decider.sleep(1000)
                        end
                    else
                        str = '买' .. item_name .. ' - 等待NPC：' .. npc_name .. ''
                        trace.output(str)
                    end
                else
                    if not map_ent.is_move() then
                        map_ent.auto_move_to(npc_x, npc_y, npc_z, actor_unit.map_id())
                    end
                end
            else
                if quest_unit.aquare_can_next_map() then
                    quest_unit.mofang_next_map()
                    decider.sleep(1000)
                    trace.output(str..'魔方换图')
                else
                    trace.output(str..'等待魔方换图中...')
                end
            end
        else
            -- TODO：复活
        end
        decider.sleep(1000)
    end
end

------------------------------------------------------------------------------------
-- [功能] 计算最大购买数
--
-- @tparam      int		max_num		最大值
-- @tparam      int		price		单价
-- @tparam      int		save        保留金额
-- @return      int		num   		最大购买数
-- @usage
-- local num = common_unt.calc_num(最大值,单价,最大购买数)
--------------------------------------------------------------------------------
shop_ent.calc_num = function(max_num, price, save)
    if max_num <= 0 then
        return 0
    end
    save = save or 12000
    local money = actor_unit.get_cost_data(2) - save
    if money <= price then
        return 0
    end
    if money < (max_num * price) then
        max_num = money / price
    end
    return math.floor(max_num)
end


-- 去买药水







------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function shop_ent.__tostring()
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
function shop_ent.__newindex(t, k, v)
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
shop_ent.__index = shop_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function shop_ent:new(args)
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
    return setmetatable(new, shop_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return shop_ent:new()

-------------------------------------------------------------------------------------
