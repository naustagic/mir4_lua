------------------------------------------------------------------------------------
-- game/entities/${module}.lua
--
-- ${brief}
--
-- @module      ${module}
-- @author      ${author}
-- @license     ${license}
-- @release     v${version} - ${date}
-- @copyright   ${copyright}
-- @usage
-- local ${module} = import('game/entities/${module}.lua')
------------------------------------------------------------------------------------

-- 模块定义
local ${module} = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION                 = '${version}',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE             = '${date} - Initial release',
    -- 模块名称
    MODULE_NAME             = '${module} module',
    -- 只读模式
    READ_ONLY               = false,
}

-- 实例对象
local this                  = ${module}
-- 日志模块
local trace                 = trace
-- 决策模块
local decider               = decider

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function ${module}.super_preload()

end

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
-- local info = ${module}.get_item_info_by_name('物品名称')
-- print_r(info)
--------------------------------------------------------------------------------
${module}.get_item_info_by_name = function(name)
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
-- local success, msg = ${module}.delete_item(id1, id2, ...)
-------------------------------------------------------------------------------
${module}.delete_item = function(...)
    return true
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function ${module}.__tostring()
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
function ${module}.__newindex(t, k, v)
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
${module}.__index = ${module}

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local 
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function ${module}:new(args)
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
    return setmetatable(new, ${module})
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return ${module}:new()

-------------------------------------------------------------------------------------
