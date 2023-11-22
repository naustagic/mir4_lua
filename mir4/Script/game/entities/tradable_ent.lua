------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   tradable_ent
--- @describe: 背包可交易写入数据库模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class tradable_ent
local tradable_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'tradable_ent module',
    -- 只读模式
    READ_ONLY = false,
    -- 单个账户数据库路径
    REDIS_PATH = 'mir4:背包可交易物品统计:服务器[' .. main_ctx:c_server_name() .. ']:机器[%s]:序号[%s]',
    -- 总账户数据库路径
    REDIS_ALL_MATERIAL_PATH = 'mir4:背包可交易物品统计:服务器[' .. main_ctx:c_server_name() .. ']:机器[%s]:可交易材料总计',
}

-- 实例对象
local this = tradable_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local mail_unit = mail_unit
local main_ctx = main_ctx
local local_player = local_player
---@type item_ent
local item_ent = import("game/entities/item_ent")
---@type item_res
local item_res = import('game/resources/item_res')
---@type redis_ent
local redis_ent = import('game/entities/redis_ent')
---@type user_ent
local user_ent = import('game/entities/user_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function tradable_ent.super_preload()
    
end


-- 背包可交易数据转换为key：物品名 value：数量
function tradable_ent.get_materials_data_to_tab()
    local tab = {}
    local tradable_list = item_ent.get_bag_info_tradable_materials()
    local show_name_tab = this.get_show_material_name()
    for i = 1, #tradable_list do
        
        if show_name_tab[tradable_list[i].name] ~= nil then
            tab[tradable_list[i].name] = tradable_list[i].num
        end
    end
    tab['用户名'] = local_player:name() -- 加入用户名
    return tab
end

-- 写入背包中可交易的材料（判断路径是否存在相同用户名的文件，相同写入，不存在找空写下)
function tradable_ent.traversal_bag_path_set_string()
    local empty_index = 0
    local save_state = false
    for i = 1, 999 do
        local path = string.format(this.REDIS_PATH, redis_ent.COMPUTER_ID, i)
        local data = redis_ent.get_json_data(path)

        -- 相同名字加入数据
        if not table.is_empty(data) and data['用户名']==local_player:name() then
            this.set_bag_json_data(path)
            save_state = true

        
        elseif table.is_empty(data) and empty_index == 0 then
            empty_index = i
        end

    end

    -- 遍历完没取到相同用户名找第一个空位加入
    if save_state == false then
        local path = string.format(this.REDIS_PATH, redis_ent.COMPUTER_ID, empty_index)
        this.set_bag_json_data(path)
    end

    -- 更新总统计
    this.cal_all_tradable_materials()
end

--- 写入背包数据
function tradable_ent.set_bag_json_data(path)
    -- 获得背包可交易材料列表
    local tradable_list = this.get_materials_data_to_tab()
    redis_ent.set_json_data(path, tradable_list)
end

--- 统计机器中所有账户的可交易材料
function tradable_ent.cal_all_tradable_materials()
    local tab = {}
    local show_name_tab = this.get_show_material_name()
    for i = 1, 999 do
        local path = string.format(this.REDIS_PATH, redis_ent.COMPUTER_ID, i)
        local data = redis_ent.get_json_data(path)
        for key, value in pairs(data) do

            -- xxmsg(string.format("%s.%s",key,value))
            if type(value) == "number" and show_name_tab[key] ~= nil then
                
                if tab[key] ~= nil then
                    tab[key]=tab[key]+value
                else
                    tab[key]=value
                end
            end
        end
    end
    -- 写入数据
    local path = string.format(this.REDIS_ALL_MATERIAL_PATH, redis_ent.COMPUTER_ID)
    redis_ent.set_json_data(path, tab)
end

-- 检测是否需要展示可交易材料名字
function tradable_ent.get_show_material_name()
    local str = user_ent['统计物品']
    local parts = utils.split_string(str,'|')
    local tab = {}
    for i = 1, #parts do
        tab[parts[i]] = parts[i]
    end
    return tab
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function tradable_ent.__tostring()
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
function tradable_ent.__newindex(t, k, v)
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
tradable_ent.__index = tradable_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function tradable_ent:new(args)
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
    return setmetatable(new, tradable_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return tradable_ent:new()

-------------------------------------------------------------------------------------
