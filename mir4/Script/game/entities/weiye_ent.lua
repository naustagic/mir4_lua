------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   weiye_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class weiye_ent
local weiye_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'weiye_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = weiye_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local map_unit = map_unit
local actor_unit = actor_unit
local great_unit = great_unit
local great_ctx = great_ctx
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function weiye_ent.super_preload()
    this.wi_auto_great = decider.run_interval_wrapper('自动伟业', this.auto_great, 1000 * 10 * 60)
end

-- 自动伟业
function weiye_ent.auto_great()
    local list = great_unit.list()

    for i = 1, #list
    do
        local obj = list[i]
        if great_ctx:init(obj) then
            if great_ctx:is_finish_update() then
                great_unit.complate_build_up(great_ctx:id())
                xxmsg('升级伟业'..great_ctx:name()..'完成')
                decider.sleep(1000)
            elseif great_ctx:can_update() then
                local can_update = true
                if '圣域寺院' == great_ctx:name() then
                    if actor_unit.char_level() < 36 then
                        can_update = false
                    end
                end
                if can_update then
                    if  great_ctx:level() == 0 then
                        great_unit.unlock_build(great_ctx:id())
                        xxmsg('解锁伟业'..great_ctx:name())
                        xxmsg( great_unit.build_can_update(great_ctx:id()))
                        decider.sleep(1000)
                    else
                        great_unit.req_up_build(great_ctx:id())
                        xxmsg('请求升级伟业'..great_ctx:name())
                        decider.sleep(1000)
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
function weiye_ent.__tostring()
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
function weiye_ent.__newindex(t, k, v)
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
weiye_ent.__index = weiye_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function weiye_ent:new(args)
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
    return setmetatable(new, weiye_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return weiye_ent:new()

-------------------------------------------------------------------------------------
