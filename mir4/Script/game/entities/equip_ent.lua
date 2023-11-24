------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   equip_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class equip_ent
local equip_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'equip_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = equip_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local item_unit = item_unit
local actor_unit = actor_unit
local item_ctx = item_ctx
local main_ctx = main_ctx
local shop_unit = shop_unit
---@type equip_res
local equip_res = import('game/resources/equip_res')
---@type item_ent
local item_ent = import('game/entities/item_ent')



------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function equip_ent.super_preload()
    this.wi_auto_equip = decider.run_interval_wrapper('自动装备', this.auto_equip, 1000 * 60 * 10)
end

function equip_ent.auto_equip()
    equip_ent.auto_use_equip()
    equip_ent.auto_build_equip()
end

-- 佩戴装备





------------------------------------------------------------------------------------
-- [行为] 自动佩带装备
------------------------------------------------------------------------------------
equip_ent.auto_use_equip = function()
    local equip_list = equip_res.EQUIP_INFO
    local my_job = actor_unit.get_char_race()
    local item_list = item_ent.get_all_bag_item_info()
    for k, v in pairs(equip_list) do
        local equip_pos = v.pos
        local best_equip = {}
        for i = 1, #item_list do
            local item_info = item_list[i]
            local is_read = true
            -- 判断是否装备
            if item_info.equip_combat_power <= 0 then
                is_read = false
            end
            -- 装备类似
            if is_read and equip_pos ~= item_info.equip_type then
                is_read = false
            end

            if is_read and item_info.equip_job ~= my_job then
                if item_info.equip_job ~= 0 then
                    is_read = false
                end
            end
            if is_read then
                if table.is_empty(best_equip) then
                    best_equip = item_info
                else
                    if item_info.quality > best_equip.quality then
                        best_equip = item_info
                    elseif item_info.quality == best_equip.quality then
                        if item_info.equip_combat_power > best_equip.equip_combat_power then
                            best_equip = item_info
                        elseif item_info.equip_combat_power == best_equip.equip_combat_power then
                            if item_info.equip_is_use then
                                best_equip = item_info
                            end
                        end
                    end
                end
            end
        end
        if not table.is_empty(best_equip) then
            if not best_equip.equip_is_use then
                item_unit.use_equip(best_equip.sys_id, best_equip.equip_type)
                decider.sleep(1000)
                for i = 1, 10 do
                    local str = string.format('正佩戴[%s]部位>%s ...%s/10', k, best_equip.name, i)
                    trace.output(str)
                    local item_info = item_ent.get_item_info_by_obj(best_equip.obj)
                    if item_info.equip_is_use then
                        break
                    end
                    decider.sleep(1000)
                end
            end
        end
    end
end

-- 自动打造装备
equip_ent.auto_build_equip = function()
    local equip_list = equip_res.EQUIP_INFO
    local item_list = item_ent.get_all_bag_item_info()
    for _, v in pairs(equip_list) do
        local equip_pos = v.pos
        local equip_info = {}
        for i = 1, #item_list do
            local item_info = item_list[i]
            if item_info.equip_is_use and equip_pos == item_info.equip_type then
                equip_info = item_info
                break
            end
        end
        local build = 1
        if equip_info.quality == 2 and v[2] == equip_info.name then
            build = 3
        elseif equip_info.quality == 2 then
            build = 2
        elseif equip_info.quality == 3 then
            build = 4
        end

        if build == 2 then
            -- 删除 白色装备
            equip_ent.auto_del_equip(equip_pos, 1)
        elseif build == 3 or build == 4 then
            -- 删除 绿色装备
            equip_ent.auto_del_equip(equip_pos, 2)
        end

        local build_equip = v[build]
        this.build_equip_2(build_equip)
        if not table.is_empty(equip_info) then
            if (v[equip_info.quality] == equip_info.name or equip_info.quality == 3) then
                this.enhanced_equip(equip_info.obj)
            end
            if v[1] == equip_info.name then
                this.enhanced_equip(equip_info.obj, 1)
            end
        end
    end
end

-- 自动删除装备
equip_ent.auto_del_equip = function(equip_pos, equip_quality)
    local my_job = actor_unit.get_char_race()
    local item_list = item_ent.get_all_bag_item_info()
    for i = 1, #item_list do
        local item_info = item_list[i]
        if not item_info.equip_is_use and item_info.equip_combat_power > 0 then
            local del = false
            if equip_pos == item_info.equip_type and equip_quality == item_info.quality then
                del = true
            end
            if item_info.equip_job ~= 0 and item_info.equip_job ~= my_job then
                del = true
            end
            if not equip_res.BUILD_EQUIP_LIST[item_info.name] then
                del = true
            end
            if del then
                trace.output('出售装备' .. item_info.name)
                shop_unit.sell_item(item_info.sys_id, item_info.num)
                decider.sleep(500)
            end
        end
    end
end

-- 打造材料类型的装备
function equip_ent.build_equip_1(make_equip_name)
    -- 获取打造信息表
    local build_info = equip_res.BUILD_EQUIP_LIST[make_equip_name]
    if not table.is_empty(build_info) then
        local stuff1 = build_info.stuff1
        local stuff2 = build_info.stuff2
        local stuff3 = build_info.stuff3
        local stuff4 = build_info.stuff4
        local need_money = build_info.money
        local need_heitie = build_info.heitie
        local make_id = build_info.make_id
        local make_type = build_info.make_type
        local not_sys_id = build_info.not_sys_id
        -- 铜钱
        if actor_unit.get_cost_data(2) < need_money then
            return false
        end
        --黑铁
        if actor_unit.get_cost_data(0xC) < need_heitie then
            return false
        end
        -- 通过物品名字获取物品信息
        local stuff1_name = stuff1.name
        local stuff1_need_num = stuff1.num

        local stuff2_name = stuff2.name
        local stuff2_need_num = stuff2.num

        local stuff3_name = stuff3.name
        local stuff3_need_num = stuff3.num

        local stuff4_name = stuff4.name
        local stuff4_need_num = stuff4.num

        local sys_id1 = item_ent.get_item_sys_id_by_name_and_num(stuff1_name, stuff1_need_num)
        if sys_id1 == 0 then
            return false
        end
        local sys_id2 = item_ent.get_item_sys_id_by_name_and_num(stuff2_name, stuff2_need_num)
        if sys_id2 == 0 then
            return false
        end
        local sys_id3 = item_ent.get_item_sys_id_by_name_and_num(stuff3_name, stuff3_need_num)
        if sys_id3 == 0 then
            return false
        end
        local sys_id4 = item_ent.get_item_sys_id_by_name_and_num(stuff4_name, stuff4_need_num)
        if sys_id4 == 0 then
            if make_type == 2 then
                make_id = build_info.qinglong_make_id
                not_sys_id = true
                if stuff4_name == '稀有龙鳞' then
                    stuff4_name = '稀有青龙鳞'
                elseif stuff4_name == '稀有龙角' then
                    stuff4_name = '稀有青龙角'
                elseif stuff4_name == '稀有龙皮' then
                    stuff4_name = '稀有青龙皮'
                elseif stuff4_name == '稀有龙眼' then
                    stuff4_name = '稀有青龙眼'
                elseif stuff4_name == '稀有龙爪' then
                    stuff4_name = '稀有青龙爪'
                end
                sys_id4 = item_ent.get_item_sys_id_by_name_and_num(stuff4_name, stuff4_need_num)
                if sys_id4 == 0 or build_info.qinglong_make_id == 0 then
                    return false
                end
            else
                return false
            end
        end
        local heitie_num = actor_unit.get_cost_data(0xC)
        if not_sys_id then
            item_unit.make_equip(make_id, 0, 0, 0, 0)
        else
            item_unit.make_equip(make_id, sys_id1, sys_id2, sys_id3, sys_id4)
        end
        decider.sleep(1000)
        for i = 1, 10 do
            trace.output('制作装备[' .. make_equip_name .. ']' .. i)
            if heitie_num ~= actor_unit.get_cost_data(0xC) then
                main_ctx:do_skey(0x1B)
                decider.sleep(1000)
                main_ctx:do_skey(0x1B)
                return true
            end
            decider.sleep(1000)
        end
    end
    return false
end

-- 制造合成装备
function equip_ent.build_equip_2(make_equip_name)
    local need_build = make_equip_name
    while decider.is_working() do

        local build_info = equip_res.BUILD_EQUIP_LIST[need_build]
        if table.is_empty(build_info) then
            break
        end
        if item_ent.get_item_sys_id_by_name_and_num(make_equip_name, 1) > 0 then
            break
        end
        if build_info.stuff4 then
            if this.build_equip_1(need_build) then
                need_build = make_equip_name
            else
                break
            end
        else
            local need_equip_name = build_info.equip_name
            local need_money = build_info.money
            local need_heitie = build_info.heitie
            local make_id = build_info.make_id
            if actor_unit.get_cost_data(2) >= need_money and actor_unit.get_cost_data(0xC) >= need_heitie then
                local equip1_sys_id, equip2_sys_id = equip_ent.get_two_equip_sys_id(need_equip_name)
                local heitie_num = actor_unit.get_cost_data(0xC)
                if equip1_sys_id ~= 0 and equip2_sys_id ~= 0 then
                    item_unit.make_equip(make_id, equip1_sys_id, equip2_sys_id, 0, 0)
                    decider.sleep(1000)
                    for i = 1, 10 do
                        trace.output('制作装备[' .. need_build .. ']' .. i)
                        if heitie_num ~= actor_unit.get_cost_data(0xC) then
                            main_ctx:do_skey(0x1B)
                            decider.sleep(1000)
                            main_ctx:do_skey(0x1B)
                            break
                        end
                        decider.sleep(1000)
                    end
                    need_build = make_equip_name
                else
                    need_build = need_equip_name
                end
            else
                break
            end
        end
        decider.sleep(30)
    end
end

-- 取两件同名称装备系统ID（主要用于取制作辅助装备）
-- 参数1：装备名
function equip_ent.get_two_equip_sys_id(equip_name)
    local equip1_sys_id = 0
    local equip2_sys_id = 0
    local list = item_unit.list(-1)
    local race = actor_unit.get_char_race()
    for i = 1, #list
    do
        local obj = list[i]
        if item_ctx:init(obj) and item_ctx:name() == equip_name and item_ctx:num() > 0 then
            local is_read = false
            local equip_job = item_ctx:equip_job()
            if equip_job == 0 then
                is_read = true
            end
            if not is_read and item_ctx:equip_job() == race then
                is_read = true
            end
            if is_read then
                if equip1_sys_id == 0 then
                    equip1_sys_id = item_ctx:sys_id()
                else
                    equip2_sys_id = item_ctx:sys_id()
                    break
                end
            end
        end
    end
    return equip1_sys_id, equip2_sys_id
end

-------------------------------------------------------------------------------------
equip_ent.enhanced_equip = function(equip_obj, enhanced_level)
    enhanced_level = enhanced_level or 5
    while decider.is_working() do
        if item_ctx:init(equip_obj) then
            local equip_enhanced_level = item_ctx:equip_enhanced_level()
            if item_ctx:equip_enhanced_level() >= enhanced_level then
                break
            end
            local quality = item_ctx:quality()
            local equip_sys_id = item_ctx:sys_id()
            local name = item_ctx:name()
            local need_money = 10000
            local need_heitie = 1000
            local stuff_name = '高级强化石'
            if quality == '稀有' then
                need_money = 12000
                need_heitie = 8000
                stuff_name = '稀有强化石'
            elseif quality == '高级' then
            else
                break
            end
            if actor_unit.get_cost_data(2) < need_money then
                break
            end

            if actor_unit.get_cost_data(0xC) < need_heitie then
                break
            end
            local sys_id = item_ent.get_item_sys_id_by_name_and_num(stuff_name, 1)
            if sys_id == 0 then
                break
            end
            local my_heitie = actor_unit.get_cost_data(0xC)
            item_unit.enhanced_equip(equip_sys_id, sys_id)
            decider.sleep(1000)
            for i = 1, 10 do
                local str = string.format('强化[%s]到[%s/5]...%s', name, equip_enhanced_level, i)
                trace.output(str)
                if my_heitie ~= actor_unit.get_cost_data(0xC) then
                    decider.sleep(1000)
                    main_ctx:do_skey(0x1B)
                    break
                end
                decider.sleep(1000)
            end
        else
            break
        end
        decider.sleep(1000)
    end
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function equip_ent.__tostring()
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
function equip_ent.__newindex(t, k, v)
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
equip_ent.__index = equip_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function equip_ent:new(args)
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
    return setmetatable(new, equip_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return equip_ent:new()

-------------------------------------------------------------------------------------
