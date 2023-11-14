------------------------------------------------------------------------------------
-- game/entities/item_ent.lua
--
-- 这个模块主要是项目内物品相关功能操作。
--
-- @module      item_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local item_ent = import('game/entities/item_ent')
------------------------------------------------------------------------------------

-- 模块定义
local item_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION                 = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE             = '2023-03-22 - Initial release',
    -- 模块名称
    MODULE_NAME             = 'item_ent module',
    -- 只读模式
    READ_ONLY               = false,
}

-- 实例对象
local this = item_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function item_ent.super_preload()
    this.delete_item = decider.run_action_wrapper('丢弃物品', this.delete_item)
end


------
-- 物品信息
-- @tfield    integer   obj              物品实例对象
-- @tfield    string    name             物品名称
-- @tfield    integer   res_ptr          物品资源指针
-- @tfield    integer   id               物品ID
-- @tfield    integer   type             物品类型
-- @tfield    integer   num              物品数量
-- @tfield    integer   race             物品种族
-- @tfield    integer   level            物品等级
-- @tfield    integer   quality          物品品质
-- @tfield    integer   res_id           物品资源ID
-- @tfield    integer   equip_type       物品装备类型
-- @tfield    integer   equip_pos        物品装备位置
-- @tfield    integer   durability       物品耐久度
-- @tfield    integer   max_durability   物品最大耐久度
-- @table item_info

--------------------------------------------------------------------------------
-- [读取] 根据物品名称获取物品信息
--
-- @static
-- @tparam       string    name             物品名称
-- @treturn      t                          包含物品信息的 table，包括：
-- @tfield[t]    integer   obj              物品实例对象
-- @tfield[t]    string    name             物品名称
-- @tfield[t]    integer   res_ptr          物品资源指针
-- @tfield[t]    integer   id               物品ID
-- @tfield[t]    integer   type             物品类型
-- @tfield[t]    integer   num              物品数量
-- @tfield[t]    integer   race             物品种族
-- @tfield[t]    integer   level            物品等级
-- @tfield[t]    integer   quality          物品品质
-- @tfield[t]    integer   res_id           物品资源ID
-- @tfield[t]    integer   equip_type       物品装备类型
-- @tfield[t]    integer   equip_pos        物品装备位置
-- @tfield[t]    integer   durability       物品耐久度
-- @tfield[t]    integer   max_durability   物品最大耐久度
-- @usage
-- local info = item_ent.get_item_info_by_name('物品名称')
-- print_r(info)
--------------------------------------------------------------------------------
function item_ent.get_item_info_by_name(name)
    local result = {}
    for _, v in ipairs(item_unit.list(0)) do
        if item_ctx:init(v, 0) and item_ctx:name() == name then 
            result = {
                obj = v,
                name = name,
                res_ptr = item_ctx:res_ptr(),
                id = item_ctx:id(),
                type = item_ctx:type(),
                num = item_ctx:num(),
                race = item_ctx:race(),
                level = item_ctx:level(),
                quality = item_ctx:quality(),
                res_id = item_ctx:res_id(),
                equip_type = item_ctx:equip_type(),
                equip_pos = item_ctx:equip_pos(),
                durability = item_ctx:durability(),
                max_durability = item_ctx:max_durability()
            }
            break
        end
    end
    return result
end

-------------------------------------------------------------------------------
-- [行为] 丢弃背包中的物品
--
-- @static
-- @tparam       integer   ...              可变参数，需要丢弃的物品列表
-- @treturn      boolean                    丢弃成功 true, 否则 false 和错误信息
-- @usage
-- local success, msg = item_ent.delete_item(id1, id2, ...)
-------------------------------------------------------------------------------
function item_ent.delete_item(...)
    return true
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
