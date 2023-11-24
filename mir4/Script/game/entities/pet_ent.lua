------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   pet_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class pet_ent
local pet_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'pet_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = pet_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local pet_ctx = pet_ctx
local pet_unit = pet_unit
local item_ctx = item_ctx
---@type item_res
local item_res = import('game/resources/item_res')
---@type pet_res
local pet_res = import('game/resources/pet_res')

---@type item_ent
local item_ent = import('game/entities/item_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function pet_ent.super_preload()
    this.wi_auto_pet = decider.run_interval_wrapper('自动宠物', this.auto_pet, 1000 * 10 * 60)
end
function pet_ent.auto_pet()
    pet_ent.get_can_use_pet()
    pet_ent.go_war_pet()
    pet_ent.auto_pet_equip()
end




------------------------------------------------------------------------------------
---通过名字判断是否获得精灵并返回精灵id
function pet_ent.get_can_use_pet()
    local pet_list = {}
    local list = pet_unit.list()
    for i = 1, #list do
        if pet_ctx:init(list[i]) then
            if pet_ctx:can_summon() then
                -- 是否可召唤
                trace.output('召唤宠物' .. pet_ctx:name())
                pet_unit.summon_pet(pet_ctx:id())
                decider.sleep(2000)
                local pet_info = {
                    obj = list[i],
                    id = pet_ctx:id(),
                    name = pet_ctx:name(),
                }
                table.insert(pet_list, pet_info)
            elseif pet_ctx:is_unlock() then
                -- 是否解锁
                local pet_info = {
                    obj = list[i],
                    id = pet_ctx:id(),
                    name = pet_ctx:name(),
                }
                table.insert(pet_list, pet_info)
            end
        end
    end
    return pet_list
end

function pet_ent.go_war_pet()

    local pet = {}
    local pet_list = pet_res.PET_LIST
    local can_use_pet = pet_ent.get_can_use_pet()
    for i = 1, #can_use_pet do
        local name = can_use_pet[i].name
        if pet_list[name] then
            local pet_info = {
                name = name,
                id = can_use_pet[i].id,
                name = name,
                power = pet_list[name].power,
            }
            table.insert(pet, pet_info)
        end
    end
    if #pet > 1 then
        table.sort(pet, function(a, b)
            return a.power > b.power
        end)
    end
    for pos = 0, 2 do
        if not table.is_empty(pet[pos + 1]) then
            if pet_unit.get_warpet_obj_byidx(pos) ~= pet_unit.get_pet_object_byid(pet[pos + 1].id) then
                pet_unit.go_war_pet(pet[pos + 1].id, pos)
                trace.output('设置' .. pet[pos + 1].name .. '到' .. pos + 1)
                decider.sleep(2000)
            end
        end
    end
end

function pet_ent.auto_pet_equip()
    local pet_equip = item_ent.get_all_bag_pet_equip_info()
    if table.is_empty(pet_equip) then
        return false
    end
    for i = 0, 2 do
        local obj = pet_unit.get_warpet_obj_byidx(i)
        if pet_ctx:init(obj) then
            if table.is_empty(pet_equip) then
                break
            end
            local item_list = pet_ctx:pet_item_list()
            if #item_list < pet_res.PET_LIST[pet_ctx:name()].quality then
                for j = 1, #pet_equip do
                    if pet_res.PET_EQUIP[pet_equip[j].name].name then
                        local equip = false
                        for s = 1, #pet_res.PET_EQUIP[pet_equip[j].name].name do
                            if pet_res.PET_EQUIP[pet_equip[j].name].name[s] == pet_ctx:name() then
                                equip = true
                            end
                        end
                        if equip then
                            pet_unit.grant_item(pet_ctx:id(), pet_equip[j].sys_id, #item_list)
                            decider.sleep(1000)
                            pet_equip = item_ent.get_all_bag_pet_equip_info()
                            break
                        end
                    else
                        pet_unit.grant_item(pet_ctx:id(), pet_equip[j].sys_id, #item_list)
                        decider.sleep(1000)
                        pet_equip = item_ent.get_all_bag_pet_equip_info()
                        break
                    end
                end
            else
                for j = 1, #item_list do
                    local item_obj = item_list[j]
                    if item_ctx:init(item_obj) then
                        for k = 1, #pet_equip do
                            if pet_res.PET_EQUIP[pet_equip[k].name].name then
                                local equip = false
                                for s = 1, #pet_res.PET_EQUIP[pet_equip[k].name].name do
                                    if pet_res.PET_EQUIP[pet_equip[k].name].name[s] == pet_ctx:name() then
                                        equip = true
                                    end
                                end
                                if equip then
                                    if item_res.QUALITY[item_ctx:quality()] < pet_equip[k].quality then
                                        pet_unit.grant_item(pet_ctx:id(), pet_equip[k].sys_id, j)
                                        decider.sleep(1000)
                                        pet_equip = item_ent.get_all_bag_pet_equip_info()
                                        break
                                    end
                                end
                            else
                                if item_res.QUALITY[item_ctx:quality()] < pet_equip[k].quality then
                                    pet_unit.grant_item(pet_ctx:id(), pet_equip[k].sys_id, j)
                                    decider.sleep(1000)
                                    pet_equip = item_ent.get_all_bag_pet_equip_info()
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--说明：授予宝物
--参数1：精灵ID
--参数2：物品系统ID
--参数3：位置
--返回：bool
--函数：pet_unit.grant_item(int nPetId, uint64_t ItemSysId, int nPos)

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function pet_ent.__tostring()
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
function pet_ent.__newindex(t, k, v)
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
pet_ent.__index = pet_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function pet_ent:new(args)
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
    return setmetatable(new, pet_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return pet_ent:new()

-------------------------------------------------------------------------------------
