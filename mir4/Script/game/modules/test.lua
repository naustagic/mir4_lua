-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   test
-- @describe: 测试模块
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local test = {
    VERSION = '202015.1',
    AUTHOR_NOTE = "-[test module - 202015.1]-",
    MODULE_NAME = '测试模块',
    -- 设置脚本版本
    SCRIPT_UPDATE = 'v1.0.0',
}

-- 自身模块
local this = test
-- 配置模块
local settings = settings
-- 日志模块
local trace = trace
local common = common
-- 决策模块
local decider = decider
-- 优化列表
local game_unit = game_unit
local main_ctx = main_ctx
local login_unit = login_unit
local setmetatable = setmetatable
local pairs = pairs
local import = import
---@type login_res
local login_res = import('game/resources/login_res')
---@type transfer_ent
local transfer_ent = import('game/entities/transfer_ent')
---@type test_ent
local test_ent = import('game/entities/test_ent')

---@type equip_ent
local equip_ent = import('game/entities/equip_ent')
local example = import('example/example')
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
---@type shop_ent
local shop_ent = import('game/entities/shop_ent')
---@type training_ent
local training_ent = import('game/entities/training_ent')
---@type item_res
local item_res = import('game/resources/item_res')
---@type item_ent
local item_ent = import('game/entities/item_ent')
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type stone_ent
local stone_ent = import('game/entities/stone_ent')



-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- 运行前置条件
this.eval_ifs = {
    -- [启用] 游戏状态列表
    yes_game_state = { },
    -- [禁用] 游戏状态列表
    not_game_state = {  },
    -- [启用] 配置开关列表
    yes_config = {  },
    -- [禁用] 配置开关列表
    not_config = {},
    -- [时间] 模块超时设置(可选)
    time_out = 0,
    -- [其它] 特殊情况才用(可选)
    is_working = function()
        return true
    end,
    -- [其它] 功能函数条件(可选)
    is_execute = function()
        return true
    end,
}

-- 轮循函数列表
test.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
test.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
test.preload = function()


end

-------------------------------------------------------------------------------------
-- 轮循功能入口
test.looping = function()


end
-------------------------------------------------------------------------------------
-- 功能入口函数
test.entry = function()
    local ret_b = false

    -- 加载前延迟

    while decider.is_working()
    do
        -- 执行轮循任务
        test.looping()
      --  equip_ent.get_two_equip_sys_id('')
       -- unsealing_unit.use_box(0x165E50DB35260003)
        --equip_ent.test_make_res_unit()
        xxmsg(string.format('[\'%s\'] = { x = %0.0f, y = %0.0f, z = %0.0f },',actor_unit.map_name(),local_player:cx(),local_player:cy(),local_player:cz()))
    --    xxmsg(local_player:name())
        --obj[2991426C200] sys_id[165E50DB35260003] 品质[英雄] id[23F41B93] num[0001] 类型[0] 强化[0] 战力[0000] 职业[00] 绑定[true  ] 使用中[false] name[英雄封印宝箱]
  --   test_ent.test_item_unit()
    --    equip_ent.auto_use_equip()
       -- map_ent.cur_map_move(nil, -2383.8723144531,-10093.008789062,618.89508056641, 2, str)
   --     xxmsg(string.format())



 --xxmsg(       string.format('%x',  item_unit.get_magic_stone_byidx(1)))



            -- 嵌套魔石 (序号从0开始)
            --item_unit.inlay_magic_stone(item_sys_id, idx)
            -- 取解锁魔石 孔槽数量
            -- item_unit.get_magic_stone_unlocal_slot_num()
            -- 取已嵌套魔石 数量
            -- item_unit.get_magic_stone_num()
            -- 序号取嵌套魔石 ID(0 1 2 3 4 5)
            -- item_unit.get_magic_stone_byidx(0-?)

  --      stone_ent.set_magic_stone()

        --item_ent.sell_item()
        --obj[2115BEB9100] sys_id[166256AB35260001] 品质[稀有] id[23E4DA1D] num[0010] 类型[0] 强化[0] 战力[0000] 职业[00] 绑定[true  ] 使用中[false] name[武功秘籍召唤券]

       -- item_unit.use_item(0x166256AB35260001, 10)
       -- item_unit.call_item(0x166256AB35260001, 1)
--xxmsg(item_ent.get_can_use_space())
    --    item_ent.use_zhaohuan_item()


xxmsg(item_ent.auto_use_item())











        --褪色的白虎珠
        --褪色的玄武珠






        --猪雕像
        --触龙神皮
        --摧毁结晶残片
        --蛇妖族长的逆鳞

        --药草叶





        decider.sleep(100)
        return
    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 模块超时处理
test.on_timeout = function()

end



-------------------------------------------------------------------------------------
-- 卸载处理
test.unload = function()
    --xxmsg('test.unload')
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
test.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function test.__tostring()
    return this.MODULE_NAME
end

test.__index = test

function test:new(args)
    local new = { }

    -- 预载函数(重载脚本时)
    if this.super_preload then
        this.super_preload()
    end

    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end

    -- 设置元表
    return setmetatable(new, test)
end

-------------------------------------------------------------------------------------
-- 返回对象
return test:new()

-------------------------------------------------------------------------------------