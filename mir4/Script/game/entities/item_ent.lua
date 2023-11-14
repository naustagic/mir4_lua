------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   item_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class item_ent
local item_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'item_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = item_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local shop_unit = shop_unit
local item_ctx = item_ctx
local item_unit = item_unit
local pet_ctx = pet_ctx
local unsealing_unit = unsealing_unit
local pet_unit = pet_unit
---@type item_res
local item_res = import('game/resources/item_res')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function item_ent.super_preload()

end

-- 通过物品名物品数量获取物品sys_id
function item_ent.get_item_sys_id_by_name_and_num(item_name, item_num)
    local item_sys_id = 0
    local item_list = item_unit.list(-1)
    for _, obj in pairs(item_list) do
        if item_ctx:init(obj) then
            local num = item_ctx:num()
            if num >= item_num and item_name == item_ctx:name() then
                item_sys_id = item_ctx:sys_id()
                break
            end
        end
    end
    return item_sys_id
end

-- 通过物品名获取物品数量
function item_ent.get_item_num_by_name(item_name)
    local item_num = 0
    local item_list = item_unit.list(-1)
    for _, obj in pairs(item_list) do
        if item_ctx:init(obj) then
            local num = item_ctx:num()
            if num > 0 and item_name == item_ctx:name() then
                item_num = item_num + num
                break
            end
        end
    end
    return item_num
end

-- 通过物品名物品数量获取物品信息
function item_ent.get_can_use_stone_info_by_name(item_name)
    local item_info = {}
    local item_list = item_unit.list(-1)
    for _, obj in pairs(item_list) do
        if item_ctx:init(obj) then
            local num = item_ctx:num()
            if num > 0 and item_name == item_ctx:name() and not item_ctx:equip_is_use() then
                item_info = {
                    -- 指针
                    obj = obj,
                    --资源指针
                    res_ptr = item_ctx:res_ptr(),
                    -- 系统id
                    sys_id = item_ctx:sys_id(),
                    -- 品质
                    quality = item_res.QUALITY[item_ctx:quality()],
                    -- id
                    id = item_ctx:id(),
                    -- 数量
                    num = item_ctx:num(),
                    -- 装备部位
                    equip_type = item_ctx:equip_type(),
                    -- 强化等级
                    equip_enhanced_level = item_ctx:equip_enhanced_level(),
                    -- 战力
                    equip_combat_power = item_ctx:equip_combat_power(),
                    -- 装备职业
                    equip_job = item_ctx:equip_job(),
                    -- 是否绑定
                    is_bind = item_ctx:is_bind(),
                    -- 是否使用中
                    equip_is_use = item_ctx:equip_is_use(),
                    -- 装备名字
                    name = item_ctx:name()
                }
                break
            end
        end
    end
    return item_info
end

-- 通过物品名物品数量获取物品信息
function item_ent.get_item_info_by_sys_id(sys_id)
    local item_info = {}
    local item_list = item_unit.list(-1)
    for _, obj in pairs(item_list) do
        if item_ctx:init(obj) then
            local num = item_ctx:num()
            if num > 0 and sys_id == item_ctx:sys_id() then
                item_info = {
                    -- 指针
                    obj = obj,
                    --资源指针
                    res_ptr = item_ctx:res_ptr(),
                    -- 系统id
                    sys_id = sys_id,
                    -- 品质
                    quality = item_res.QUALITY[item_ctx:quality()],
                    -- id
                    id = item_ctx:id(),
                    -- 数量
                    num = item_ctx:num(),
                    -- 装备部位
                    equip_type = item_ctx:equip_type(),
                    -- 强化等级
                    equip_enhanced_level = item_ctx:equip_enhanced_level(),
                    -- 战力
                    equip_combat_power = item_ctx:equip_combat_power(),
                    -- 装备职业
                    equip_job = item_ctx:equip_job(),
                    -- 是否绑定
                    is_bind = item_ctx:is_bind(),
                    -- 是否使用中
                    equip_is_use = item_ctx:equip_is_use(),
                    -- 装备名字
                    name = item_ctx:name()
                }
                break
            end
        end
    end
    return item_info
end

-- 通过物品指针获取物品信息
function item_ent.get_item_info_by_obj(item_obj)
    local item_info = {}
    if item_ctx:init(item_obj) then
        item_info = {
            -- 指针
            obj = item_obj,
            --资源指针
            res_ptr = item_ctx:res_ptr(),
            -- 系统id
            sys_id = item_ctx:sys_id(),
            -- 品质
            quality = item_res.QUALITY[item_ctx:quality()],
            -- id
            id = item_ctx:id(),
            -- 数量
            num = item_ctx:num(),
            -- 装备部位
            equip_type = item_ctx:equip_type(),
            -- 强化等级
            equip_enhanced_level = item_ctx:equip_enhanced_level(),
            -- 战力
            equip_combat_power = item_ctx:equip_combat_power(),
            -- 装备职业
            equip_job = item_ctx:equip_job(),
            -- 是否绑定
            is_bind = item_ctx:is_bind(),
            -- 是否使用中
            equip_is_use = item_ctx:equip_is_use(),
            -- 装备名字
            name = item_ctx:name()
        }
    end
    return item_info
end

-- 获取背包剩余空间
function item_ent.get_can_use_space()
    local use_space = 0
    local item_list = item_unit.list(-1)
    for _, obj in pairs(item_list) do
        if item_ctx:init(obj) then
            local num = item_ctx:num()
            if num > 0 then

                use_space = use_space + 1
            end
        end
    end
    local use_pet_equip_num = item_ent.pet_equip_num()
    use_space = use_space - use_pet_equip_num



    return item_unit.get_bag_max_space() - use_space
end

-- 获取宠物使用装备数量
function item_ent.pet_equip_num()
    local list = pet_unit.list()
    local num = 0
    for i = 1, #list do
        local obj = list[i]
        if pet_ctx:init(obj) then
            local item_list = pet_ctx:pet_item_list()
            for j = 1, #item_list do
                local item_obj = item_list[j]
                if item_ctx:init(item_obj) then
                    num = num + 1
                end
            end
        end
    end
    return num
end
-- 获取背包所有物品信息
function item_ent.get_all_bag_item_info()
    local item_info_list = {}
    local item_list = item_unit.list(-1)
    for _, obj in pairs(item_list) do
        if item_ctx:init(obj) then
            local num = item_ctx:num()
            if num > 0 then
                local item_info = {
                    -- 指针
                    obj = obj,
                    --资源指针
                    res_ptr = item_ctx:res_ptr(),
                    -- 系统id
                    sys_id = item_ctx:sys_id(),
                    -- 品质
                    quality = item_res.QUALITY[item_ctx:quality()],
                    -- id
                    id = item_ctx:id(),
                    -- 数量
                    num = num,
                    -- 装备部位
                    equip_type = item_ctx:equip_type(),
                    -- 强化等级
                    equip_enhanced_level = item_ctx:equip_enhanced_level(),
                    -- 战力
                    equip_combat_power = item_ctx:equip_combat_power(),
                    -- 装备职业
                    equip_job = item_ctx:equip_job(),
                    -- 是否绑定
                    is_bind = item_ctx:is_bind(),
                    -- 是否使用中
                    equip_is_use = item_ctx:equip_is_use(),
                    -- 装备名字
                    name = item_ctx:name()
                }
                table.insert(item_info_list, item_info)
            end
        end
    end
    return item_info_list
end

-- 使用封印宝箱
function item_ent.use_unsealing_box()
    -- 取解封槽数量
    for i = 0, unsealing_unit.get_unsealing_solt_num() - 1 do
        -- 判断是否解封完成
        if unsealing_unit.is_finish_unsealing(i) then
            -- 领取封印宝箱奖历
            unsealing_unit.get_box_reward(i)
            decider.sleep(1000)

        end
    end
    if unsealing_unit.get_unsealing_num() >= unsealing_unit.get_unsealing_solt_num() then
        return
    end
    local all_item_info = item_ent.get_all_bag_item_info()
    for i = 1, #all_item_info do
        local item_info = all_item_info[i]
        if string.find(item_info.name, '封印宝箱') then
            -- 使用封印宝箱
            unsealing_unit.use_box(item_info.sys_id)
            decider.sleep(1000)
            if unsealing_unit.get_unsealing_num() >= unsealing_unit.get_unsealing_solt_num() then
                break
            end
        end
    end
end

-- 出售物品
function item_ent.sell_item()
    local all_bag_item_info = item_ent.get_all_bag_item_info()
    local sell_quan = item_res.SELL_ITEM.QUAN
    local sell_mohu = item_res.SELL_ITEM.MOHU
    for i = 1, #all_bag_item_info do
        if all_bag_item_info[i].is_bind then
            local item_name = all_bag_item_info[i].name
            local sell = false
            for j = 1, #sell_quan do
                if sell_quan[j] == item_name then
                    sell = true
                    break
                end
            end
            if not sell then
                for j = 1, #sell_mohu do
                    if string.find(item_name, sell_mohu[j]) then
                        sell = true
                        break
                    end
                end
            end
            if sell then
                trace.output('出售' .. all_bag_item_info[i].name .. '>数量:' .. all_bag_item_info[i].num)
                shop_unit.sell_item(all_bag_item_info[i].sys_id, all_bag_item_info[i].num)
                decider.sleep(500)
            end
        end
    end
end



function item_ent.auto_use_item()
    local use_quan = item_res.USE_ITEM.QUAN
    local use_mohu = item_res.USE_ITEM.MOHU
    local all_bag_item_info = item_ent.get_all_bag_item_info()
    for i = 1, #all_bag_item_info do
        if all_bag_item_info[i].is_bind then
            local item_name = all_bag_item_info[i].name
            local use_item = false
            for j = 1, #use_quan do
                if use_quan[j] == item_name then
                    use_item = true
                    break
                end
            end
            if not use_item then
                for j = 1, #use_mohu do
                    if string.find(item_name, use_mohu[j]) then
                        use_item = true
                        break
                    end
                end
            end
            if use_item then
                trace.output('使用物品' .. all_bag_item_info[i].name .. '>数量:' .. all_bag_item_info[i].num)
                xxmsg('使用物品' .. all_bag_item_info[i].name .. '>数量:' .. all_bag_item_info[i].num)
                item_unit.use_item(all_bag_item_info[i].sys_id, all_bag_item_info[i].num)
                decider.sleep(500)
            end
        end
    end
end

-- 使用召唤券
function item_ent.use_zhaohuan_item()
    local zhaohuan_nid = item_res.ZHAOHUAN
    local all_bag_item_info = item_ent.get_all_bag_item_info()
    for i = 1, #all_bag_item_info do
        local item_name = all_bag_item_info[i].name
        if zhaohuan_nid[item_name] and zhaohuan_nid[item_name].nid ~= -1 then

            --得到可使用的召唤券
            local item_num = all_bag_item_info[i].num
            if item_ent.get_can_use_space() >= item_num then
                if item_num >= 10 then
                    item_unit.call_item(zhaohuan_nid[item_name].nid, 1)
                    decider.sleep(1000)
                    for k = 1, 10 do
                        trace.output('十次使用' .. item_name .. '[' .. k .. ']')
                        local item_info = item_ent.get_item_info_by_obj(all_bag_item_info[i].obj)
                        if table.is_empty(item_info) then
                            break
                        else
                            if item_info.num ~= item_num then
                                break
                            end
                        end
                        decider.sleep(1000)
                    end
                else
                    for j = 1, item_num do
                        item_unit.call_item(zhaohuan_nid[item_name].nid, 0)
                        decider.sleep(1000)
                        for k = 1, 10 do
                            trace.output('第次[' .. j .. '/' .. item_num .. ']单次使用' .. item_name .. '[' .. k .. ']')
                            local item_info = item_ent.get_item_info_by_obj(all_bag_item_info[i].obj)
                            if table.is_empty(item_info) then
                                break
                            else
                                if item_info.num ~= item_num then
                                    break
                                end
                            end
                            decider.sleep(1000)
                        end
                    end
                end
            end

        end
    end
end




------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function item_ent.__tostring()
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
function item_ent.__newindex(t, k, v)
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
item_ent.__index = item_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function item_ent:new(args)
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
    return setmetatable(new, item_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return item_ent:new()

-------------------------------------------------------------------------------------
