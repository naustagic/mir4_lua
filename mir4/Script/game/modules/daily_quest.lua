-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   daily_quest
-- @describe: 测试模块
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local daily_quest = {
    VERSION = '202015.1',
    AUTHOR_NOTE = "-[daily_quest module - 202015.1]-",
    MODULE_NAME = '重复任务',
    -- 设置脚本版本
    SCRIPT_UPDATE = 'v1.0.0',
}

-- 自身模块
local this = daily_quest
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
---@type daily_quest_ent
local daily_quest_ent = import('game/entities/daily_quest_ent')

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
---@type quest_ent
local quest_ent = import('game/entities/quest_ent')
---@type map_res
local map_res = import('game/resources/map_res')
---@type pet_ent
local pet_ent = import('game/entities/pet_ent')
---@type mail_ent
local mail_ent = import('game/entities/mail_ent')
---@type weiye_ent
local weiye_ent = import('game/entities/weiye_ent')
---@type quest_res
local quest_res = import('game/resources/quest_res')


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
daily_quest.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
daily_quest.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
daily_quest.preload = function()


end

-------------------------------------------------------------------------------------
-- 轮循功能入口
daily_quest.looping = function()


end

-------------------------------------------------------------------------------------
-- 功能入口函数
daily_quest.entry = function()
    local ret_b = false

    -- 加载前延迟

    while decider.is_working()
    do
        -- 执行轮循任务
        daily_quest.looping()


 --       example:daily_quest_great_unit()


        --    if guild_unit.has_support() then
        --        guild_unit.guild_support()
        --        decider.sleep(1000)
        --    end
        --if guild_unit.has_gift() then
        --    -- 领取补给
        --    guild_unit.get_gift_recv()
        --    decider.sleep(1000)
        --end
        --if guild_unit.get_guild_leader_name() ~= local_player:name() then
        --    return
        --end
        --
        --local 可协助ID = {0x18A89,0x18A90,0x18A91,0x18A92,0x18E71,0x18E72,0x18E73,0x18E74}
        --for i = 1,#可协助ID do
        --    -- 查询技能信息
        --
        --        local 技能ID = 可协助ID[i]
        --
        --        local list = guild_skill_unit.skill_list()
        --        local guild_skill_obj = guild_skill_unit:new()
        --        local obj = guild_skill_unit.get_guild_devinfo_data(技能ID)
        --        if guild_skill_obj:init(obj) then
        --            if guild_skill_obj:can_up_level() or guild_skill_obj:cur_exp() == guild_skill_obj:up_level_exp() then
        --                if guild_skill_obj:up_level_remain_time() == 0 then
        --                    xxmsg('升级门派技能['..guild_skill_obj:name()..']')
        --                    guild_skill_unit.up_skill(guild_skill_obj:id())
        --                    decider.sleep(1000)
        --                end
        --            end
        --        end
        --        guild_skill_obj:delete()
        --
        --        -- 关闭升级门派窗口
        --        if ui_unit.get_parent_widget('Popup_GuildDevInfo_C' , true) ~= 0 then
        --            main_ctx:do_skey(0x1B)
        --        end
        --
        --end
        --if not guild_unit.has_guild() then
        --    return
        --end
        --local can_not_list = {}
        ----0x18A89 武术管
        --local can_assist_list = {0x18A89,0x18A90,0x18A91,0x18A92,0x18E71,0x18E72,0x18E73,0x18E74}
        --for i = 1, #can_assist_list do
        --        local can_assist = true
        --    if i <= 4 then
        --        if actor_unit.get_cost_data(2) < 10*10000 then
        --            can_assist = false
        --        end
        --    end
        --    local assist_id = can_assist_list[i]
        --    if can_not_list[assist_id] then
        --        can_assist = false
        --    end
        --    if can_assist then
        --        local assist_count = guild_unit.get_assist_count()
        --        if assist_count <= 0 then
        --            return
        --        end
        --        for ii = 1,assist_count do
        --            local assist_count_q = guild_unit.get_assist_count()
        --            xxmsg('协助'..assist_id)
        --            guild_unit.guild_assist(assist_id)
        --            decider.sleep(1000)
        --            if assist_count_q == guild_unit.get_assist_count() then
        --                can_not_list[assist_id] = true
        --                break
        --            end
        --        end
        --    end
        --
        --
        --end

        local side_quest_name_list = quest_res.get_side_name_list()
        for i, v in pairs(side_quest_name_list) do
            xxmsg(i)
        end
        if quest_ent.have_side_quest(side_quest_name_list) then
            xxmsg(1)
        else
            xxmsg(2)
        end



        --241BEDA1100   241A6E94660  167D062F35260000  高级 	 657582C1 	0001 	 0  0  0000   00  true    false 	嗜魂镐头
        --2418C1B6C00   241A6E94300  16820C0B35220000  高级 	 657582C4 	0001 	 0  0  0000   00  true    false 	猪雕像
        --241BEDA3C00   241A2344540  167D299335260002  普通 	 1ED3D9AD 	0022 	 0  0  0000   00  true    false 	少阳丹
        --local quest_obj = quest_unit:new()
        ------ -1 所有任务（不包阔委托），0当前任务，1可接任务 2 委托任务
        --local list = quest_unit.list(2)
        ----[     288FD7D9E80] ID[003D0964] TYPE[0] DAILYNUM[0] STATUS[3] COMBATPOWER[3681]  TRATYPE[1] TAR[0-100] POS[4840.0-8150.0-2360.0] ISOVER[false ]  ISFINISH[false ]  MAP[06052F02-银杏谷           ] NAME[临危的银杏谷] [00000000]
        --xxmsg(string.format('任务总数：%u', #list))
        --
        --for i = 1, #list
        --do
        --    local obj = list[i]
        --    if quest_obj:init(obj)  and quest_obj:can_accept() then
        --        xxmsg(string.format('[%16X] ID[%08X] TYPE[%u] DAILYNUM[%u] STATUS[%u] COMBATPOWER[%u]  TRATYPE[%u] TAR[%u-%u] POS[%0.1f-%0.1f-%0.1f] ISOVER[%-6s]  ISFINISH[%-6s]  MAP[%08X-%-20s] NAME[%s] [%08X]',
        --                obj,
        --                quest_obj:id(),
        --                quest_obj:type(),
        --                quest_obj:daily_num(),
        --                quest_obj:status(),
        --                quest_obj:combat_power(),
        --                quest_obj:tar_type(),
        --                quest_obj:tar_num(),
        --                quest_obj:tar_max_num(),
        --                quest_obj:tx(),
        --                quest_obj:ty(),
        --                quest_obj:tz(),
        --                quest_obj:is_over(),
        --                quest_obj:is_finish(),
        --                quest_obj:map_id(),
        --                quest_obj:map_name(),
        --                quest_obj:name(),
        --                quest_obj:entrust_gather_resid()
        --        ))
        --    end
        --
        --end
        --quest_obj:delete()

        --equip_ent.auto_build_equip()
     --   quest_ent.do_side_task()
        --local str = string.format('[\'%s\'] = {x = %s, y = %s, z = %s},--%s',actor_unit.map_name(),local_player:cx(),local_player:cy(),local_player:cz(),actor_unit.map_id())
        -- 周边NPC

      --  example:daily_quest_map_unit()
   --     equip_ent.auto_equip()
    local    str = string.format('{ map_id = %s, map_name = \'%s\', npc_pos = { x = %s, y = %s, z = %s } },',actor_unit.map_id(),actor_unit.map_name(),local_player:cx(),local_player:cy(),local_player:cz())
        xxmsg(str)
        --str = '测试移动'

  --      ['【秋药东】的杂物箱'] = { id = 0x1312ED0, shop_id = 0x83C },

        --local list = shop_unit.list()
        --xxmsg(#list)
        --for i = 1, #list
        --do
        --    local obj = list[i]
        --    if shop_ctx:init(obj) then
        --        xxmsg(string.format('%X  %X %u %u %s',
        --                obj,
        --                shop_ctx:id(),
        --                shop_ctx:price(),
        --                shop_ctx:limit_buy_num(),
        --                shop_ctx:name()
        --        ))
        --    end
        --end

      --  shop_unit.buy_npc_item_ex(int shop_id, int npc_id, uint64_t item_id, int buy_num)

        --shop_ent.buy_item('中型魔力恢复药水', 100, 1000, 50)

   --     shop_ent.buy_item('花酒', 1, 1, 1)



--DC 02 10 A6 27 18 B1 DD C4 09 20 01
      --  example:daily_quest_item_unit()
  --    shop_unit.buy_npc_item_ex(0x2718B1DD, 0xC4092001,0xDC0210A6, 1)


     --   example:daily_quest_map_unit()
      --  example:daily_quest_map_unit()
    --    example:daily_quest_actor_unit()
--1F697837E80  107C5B 29B92AEE  秋药东  -16819.3  10876.7  997.0

        --1F6B42073C0  29B92AEE  MMFixedNPC_BP_C_9_4 	秋药东  1  	-16534.000000 10784.000000 992.558594  299.999481
    --    shop_unit.open_npc_shop_byid(0x29B92AEE)
     --   shop_unit.open_npc_shop_byname('秋药东')
--        map_ent.auto_move('比奇城', -1414, -10179, 628, str,200  )
      --  equip_ent.get_two_equip_sys_id('')
       -- unsealing_unit.use_box(0x165E50DB35260003)
        --equip_ent.daily_quest_make_res_unit()
    --    xxmsg(string.format('[\'%s\'] = { x = %0.0f, y = %0.0f, z = %0.0f },',actor_unit.map_name(),local_player:cx(),local_player:cy(),local_player:cz()))
    --    xxmsg(local_player:name())
        --obj[2991426C200] sys_id[165E50DB35260003] 品质[英雄] id[23F41B93] num[0001] 类型[0] 强化[0] 战力[0000] 职业[00] 绑定[true  ] 使用中[false] name[英雄封印宝箱]
  --   daily_quest_ent.daily_quest_item_unit()
    --    equip_ent.auto_use_equip()
       -- map_ent.cur_map_move(nil, -2383.8723144531,-10093.008789062,618.89508056641, 2, str)
   --     xxmsg(string.format())

        --[EA78--0000] 1B 00 00 00 00 78 EA 00 00 00 00 00 00 00 00 00 00 08 E6 DA 80 CA 07 10 03 18 64
        --[EA78--0000] 1C 00 00 00 00 78 EA 00 00 00 00 00 00 00 00 00 00 08 E6 DA 80 CA 07 10 03 18 EE 07

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

   --    quest_ent.do_side_task()





        --褪色的白虎珠
        --褪色的玄武珠






        --猪雕像
        --触龙神皮
        --摧毁结晶残片
        --蛇妖族长的逆鳞

        --药草叶


--

        decider.sleep(100)
       return false
    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 模块超时处理
daily_quest.on_timeout = function()

end



-------------------------------------------------------------------------------------
-- 卸载处理
daily_quest.unload = function()
    --xxmsg('daily_quest.unload')
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
daily_quest.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function daily_quest.__tostring()
    return this.MODULE_NAME
end

daily_quest.__index = daily_quest

function daily_quest:new(args)
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
    return setmetatable(new, daily_quest)
end

-------------------------------------------------------------------------------------
-- 返回对象
return daily_quest:new()

-------------------------------------------------------------------------------------