------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   stone_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class stone_ent
local stone_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'stone_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = stone_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local item_unit = item_unit
---@type item_ent
local item_ent = import('game/entities/item_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function stone_ent.super_preload()

end

-- 镶嵌魔石
function stone_ent.set_magic_stone()

    local stone_list = {


        ['英雄活力魔石'] = {level = 10},
        ['英雄专注魔石'] = {level = 9},
        ['英雄摧毁魔石'] = {level = 8},
        ['英雄武力魔石'] = {level = 7},
        ['稀有活力魔石'] = {level = 6},
        ['稀有专注魔石'] = {level = 5},
        ['稀有摧毁魔石'] = {level = 4},
        ['稀有武力魔石'] = {level = 3},
        ['高级活力魔石'] = {level = 2},
        ['高级专注魔石'] = {level = 1},
    }
    for idx = 0, item_unit.get_magic_stone_unlocal_slot_num() - 1 do
        local my_stone_level = 0
        local stone_sys_id = item_unit.get_magic_stone_byidx(idx)
        local my_stone_info = item_ent.get_item_info_by_sys_id(stone_sys_id)
        if not table.is_empty(my_stone_info) then
            if stone_list[my_stone_info.name] then
                my_stone_level = stone_list[my_stone_info.name].level
            end
        end
        for name, info in pairs(stone_list) do
            if info.level > my_stone_level then
                local item_info = item_ent.get_can_use_stone_info_by_name(name)
                if not table.is_empty(item_info) then
                    local set = false
                    item_unit.inlay_magic_stone(item_info.sys_id, idx)
                    decider.sleep(1000)
                    for i = 1, 10 do
                        if item_ent.get_item_info_by_obj(item_info.obj).equip_is_use then
                            set = true
                            break
                        end
                        trace.output('镶嵌['..item_info.name..']>到'..idx..'号位'..i)
                        decider.sleep(1000)
                    end
                    if set then
                        break
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
function stone_ent.__tostring()
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
function stone_ent.__newindex(t, k, v)
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
stone_ent.__index = stone_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function stone_ent:new(args)
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
    return setmetatable(new, stone_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return stone_ent:new()

-------------------------------------------------------------------------------------
