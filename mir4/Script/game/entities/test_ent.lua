------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   test_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class test_ent
local test_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'test_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = test_ent
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
function test_ent.super_preload()
    this.wi_test_read = decider.run_interval_wrapper('读取测试', this.test_read, 1000 * 5)
    test_ent.test_read()
end


function test_ent.test_read()
    return this.MODULE_NAME
end



function test_ent.test_item_unit()
    local item_list = item_unit.list(1)
    local Job = actor_unit.get_char_race()--当前角色职业
    xxmsg(Job)
    xxmsg(#item_list)
    local item_obj = item_unit:new()
    local a = 0
    for i = 1, #item_list
    do
        local obj = item_list[i]
        if item_obj:init(obj) and item_obj:num() > 0 then
            a = a + 1
            xxmsg( string.format('obj[%X] sys_id[%X] 品质[%s] id[%08X] num[%04u] 类型[%u] 强化[%u] 战力[%04u] 职业[%02u] 绑定[%-6s] 使用中[%s] name[%s]',
                    obj,
                    item_obj:sys_id(),
                    item_obj:quality(),
                    item_obj:id(),
                    item_obj:num(),
                    item_obj:equip_type(),
                    item_obj:equip_enhanced_level(),
                    item_obj:equip_combat_power(),
                    item_obj:equip_job(),
                    item_obj:is_bind(),
                    item_obj:equip_is_use(),
                    item_obj:name()
            )
            )
        end
    end

    item_obj:delete()

    xxmsg(a)



    -- 本职业的装
    -- 品质
    -- 战斗力最高的
    -- 是否佩戴
    -- 装备的类型











    -- 嵌套魔石 (序号从0开始)
    --item_unit.inlay_magic_stone(item_sys_id, idx)
    -- 取解锁魔石 孔槽数量
    -- item_unit.get_magic_stone_unlocal_slot_num()
    -- 取已嵌套魔石 数量
    -- item_unit.get_magic_stone_num()
    -- 序号取嵌套魔石 ID(0 1 2 3 4 5)
    -- item_unit.get_magic_stone_byidx(0-?)

end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function test_ent.__tostring()
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
function test_ent.__newindex(t, k, v)
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
test_ent.__index = test_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function test_ent:new(args)
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
    return setmetatable(new, test_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return test_ent:new()

-------------------------------------------------------------------------------------
