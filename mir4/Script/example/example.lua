-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   core
-- @email:    88888@qq.com 
-- @date:     2021-07-05
-- @module:   example
-- @describe: 示例代码模块
-- @version:  v1.0
-------------------------------------------------------------------------------------

local VERSION = '20210705' -- version history at end of file
local AUTHOR_NOTE = "-[20210705]-"

---@class example
local example = {
    VERSION = VERSION,
    AUTHOR_NOTE = AUTHOR_NOTE,
}

local this = example
-------------------------------------------------------------------------------------

--环境单元
function example:test_actor_unit()
    -- 物资读取
    for i = 0, 32
    do
        local value = actor_unit.get_cost_data(i)
        if value ~= 0 then
            xxmsg(
                    string.format('%08X  %u', i, value)
            )
        end
    end

    -- 周边玩家
    local actor_list = actor_unit.list(1)
    xxmsg(string.format('玩家数量： %u', #actor_list))
    local actor_obj = actor_unit:new()
    for i = 1, #actor_list
    do
        local obj = actor_list[i]
        if actor_obj:init(obj) and  actor_obj:cx() ~= 0 then
            xxmsg( string.format('%X %s  %X\t  %s %-6s  %u  \t%u/%u \t%u/%u \t%f %f %f  %f',
                    obj,
                    actor_obj:cls_name(),
                    actor_obj:sys_id(),
                    actor_obj:name(),
                    actor_obj:dead(),
                    actor_obj:level(),
                    actor_obj:hp(),
                    actor_obj:max_hp(),
                    actor_obj:mp(),
                    actor_obj:max_mp(),
                    actor_obj:cx(),
                    actor_obj:cy(),
                    actor_obj:cz(),
                    actor_obj:dist()
            )
            )
        end
    end

    -- 周边NPC
    local actor_list = actor_unit.list(2)
    xxmsg(string.format('NPC数量 %u', #actor_list))
    for i = 1, #actor_list
    do
        local obj = actor_list[i]

        if actor_obj:init(obj) then
            xxmsg( string.format('%X  %X  %s \t%s  %u  \t%f %f %f  %f',
                    obj,
                    actor_obj:res_id(),
                    actor_obj:cls_name(),
                    actor_obj:name(),
                    actor_obj:level(),
                    actor_obj:cx(),
                    actor_obj:cy(),
                    actor_obj:cz(),
                    actor_obj:dist()
            )
            )
        end
    end

    -- 周边怪物
    local actor_list = actor_unit.list(3)
    xxmsg(string.format('怪物数量 %u', #actor_list))
    for i = 1, #actor_list
    do
        local obj = actor_list[i]
        if actor_obj:init(obj)  then --and  actor_obj:cx() ~= 0
            xxmsg( string.format('%X %s  %08X \t%s %-6s  %u \t%u/%u \t%u/%u \t%f %f %f  %f',
                    obj,
                    actor_obj:cls_name(),
                    actor_obj:sys_id(),
                    actor_obj:name(),
                    actor_obj:dead(),
                    actor_obj:level(),
                    actor_obj:hp(),
                    actor_obj:max_hp(),
                    actor_obj:mp(),
                    actor_obj:max_mp(),
                    actor_obj:cx(),
                    actor_obj:cy(),
                    actor_obj:cz(),
                    actor_obj:dist()
            )
            )
        end
    end

    -- 采集物品
    local actor_obj = actor_unit:new()
    local actor_list = actor_unit.list(4)
    xxmsg(string.format('矿产数量 %u', #actor_list))
    for i = 1, #actor_list
    do
        local obj = actor_list[i]
        if actor_obj:init(obj) and  actor_obj:cx() ~= 0  then
            xxmsg( string.format('%X   %X   %s  %04u    %-6s  %-6s  %08X  %08X----%08X   %08X   %02X   %02X   %02X   %02X   %02X   %04X   %04X   %-16s   [%0.2f, %0.2f, %0.2f]   %0.2f   %0.2f' ,

                    obj,
                    actor_obj:cls_id(),
                    actor_obj:cls_name(),
                    actor_obj:gather_item_life(), -- 可采数（大）
                    actor_obj:can_moveto(true),
                    actor_obj:can_gather(),          -- 可采集（true）
                    actor_obj:gather_player_id(),
                    actor_obj:sys_id(),           -- 采集时用到的Id (小)
                    actor_obj:res_id(),
                    actor_obj:mine_status(),
                    mem_unit.rm_byte(mem_unit.rm_dword64(obj + 0x478) + 0x10),
                    mem_unit.rm_byte(mem_unit.rm_dword64(obj + 0x478) + 0x11),
                    mem_unit.rm_byte( obj + 0x434 ),
                    mem_unit.rm_byte(obj+0x435),
                    mem_unit.rm_dword(obj+0x4B8),
                    mem_unit.rm_dword(obj+0x438),
                    mem_unit.rm_dword(mem_unit.rm_dword64(obj + 0x10) + 0x38),
                    actor_obj:name(),
                    actor_obj:cx(),
                    actor_obj:cy(),
                    actor_obj:cz(),
                    actor_obj:dist(),
                    mem_unit.rm_float(obj + 0x510)
            )
            )
        end
    end
    actor_obj:delete()

    --说明：遍历环境(-1(所有), 0(本人), 1(玩家), 2(NPC), 3(怪物), 4(矿物))
    --参数：nType
    --返回：int
    --函数：actor_unit.list(int nType)
    --说明：开启或关闭剧情中无敌
    --参数：enable
    --返回：bool
    --函数：actor_unit.enable_super_man(bool enable)
    --说明：自动寻路
    --参数1：x坐标
    --参数2：y坐标
    --参数3：z坐标
    --参数4：地图ID
    --返回：bool
    --函数：actor_unit.move_to(float x, float y, float z, int map_id)
    --说明：空中移动
    --参数1：x坐标
    --参数2：y坐标
    --参数3：z坐标
    --返回：bool
    --函数：actor_unit.air_walk(float x, float y, float z)
    --说明：地面移动
    --参数1：x坐标
    --参数2：y坐标
    --参数3：z坐标
    --返回：bool
    --函数：actor_unit.walk(float x, float y, float z)
    --说明：地面移动
    --参数1：x坐标
    --参数2：y坐标
    --参数3：z坐标
    --参数4：stop
    --返回：bool
    --函数：actor_unit.walk_ex(float x, float y, float z, bool stop)
    --说明：瞬移
    --参数1：x坐标
    --参数2：y坐标
    --参数3：z坐标
    --参数4：stop
    --返回：bool
    --函数：actor_unit.fast_move_ex(float x, float y, float z, bool stop = true)
    --说明：瞬移
    --参数1：x坐标
    --参数2：y坐标
    --参数3：z坐标
    --返回：bool
    --函数：actor_unit.fast_move(float x, float y, float z)
    --说明：远程攻击
    --参数1：系统ID
    --参数2：技能类型
    --参数3：技能ID
    --参数4：动作ID
    --返回：bool
    --函数：actor_unit.remote_attack_ex(uint64_t sys_id, int skill_type, int skill_id, int action_id)
    --说明：群体攻击(type , 1 玩家 2 怪物)
    --参数1：环境ID列表
    --参数2：是否怪物
    --参数3：技能类型
    --参数4：技能ID
    --参数5：动作ID
    --返回：bool
    --函数：actor_unit.mul_attack_ex(actor_id_list, bool bMonster, int skill_type, int skill_id, int action_id)
    --说明：远程攻击（当前地图）
    --参数1：系统ID
    --参数2：技能类型
    --参数3：技能ID
    --参数4：x坐标
    --参数5：y坐标
    --参数6：z坐标
    --返回：bool
    --函数：actor_unit.remote_attack3_ex(uint64_t sys_id, int skill_type, int skill_id, float x, float y, float z)
    --说明：抢矿攻击
    --参数1：系统ID
    --参数2：技能类型
    --参数3：技能ID
    --参数4：动作ID
    --返回：bool
    --函数：actor_unit.plunder_attack_ex(uint64_t gather_sysid, int skill_type, int skill_id, int action_id)
    --说明：退出未知劇情（鎖血）
    --参数1：无
    --返回：无
    --函数：actor_unit.exit_smite()
    --说明：原地复活
    --参数1：无
    --返回：bool
    --函数：actor_unit.local_rise_man()
    --说明：发送死亡玩家信息到帮会
    --参数1：角色ID
    --返回：bool
    --函数：actor_unit.send_dead_player_id(uint64_t player_id)
    --说明：检测玩家ID是否在已死列表
    --参数1：角色ID
    --返回：bool
    --函数：actor_unit.is_dead_player(uint64_t player_id)
    --说明：设置发送死亡玩家ID开关
    --参数：enable
    --返回：无
    --函数：actor_unit.set_send_dead_player_id(bool enable)
    --说明：设置自动处理
    --参数：类型
    --返回：bool
    --函数：actor_unit.set_auto_type(int nType)
    --说明：远程采集
    --参数1：系统ID
    --参数2：x坐标
    --参数3：y坐标
    --参数4：z坐标
    --参数5：延迟
    --返回：bool
    --函数：actor_unit.gather_ex(uint64_t SysId, float hx, float hy, float hz, int delay)
    --说明：终止采集
    --参数1：无
    --返回：bool
    --函数：actor_unit.cancel_gather()
    --说明：取复活剩余时间
    --参数1：无
    --返回：float
    --函数：actor_unit.get_can_rise_time()
    --说明：复活(1 回城复活)
    --参数1：nAction
    --返回：bool
    --函数：actor_unit.rise_man(int nAction)
    --说明：取复活剩余时间
    --参数1：无
    --返回：float
    --函数：actor_unit.get_can_rise_time()
    --说明：读取游戏OPTION 选项状态（反击ID7）
    --参数1：无
    --返回：int
    --函数：actor_unit.get_game_option_status(int nId)
    --说明：设置游戏选择（反击ID7）
    --参数1：nId
    --参数2：nStatus
    --返回：bool
    --函数：actor_unit.set_game_option(int nId, int  nStatus)
    --说明：取双倍经验时间
    --参数：无
    --返回：double
    --函数：actor_unit.get_double_exp_time()
    --说明：坐标加密
    --参数1：str
    --参数2：len
    --参数3：buffer
    --返回：double
    --函数：actor_unit.enc_location(const char* str, int len, ULONG_PTR buffer)
    --说明：读取指定Actor Buff指针
    --参数1：actor
    --参数2：buff_id
    --返回：double
    --函数：actor_unit.get_buff_ptr_byid(ULONG_PTR actor, int buff_id)
    --说明：判断指定玩家buff时间
    --参数1：sys_id
    --参数2：buff_id
    --返回：float
    --函数：actor_unit.get_actor_buff_time(uint64_t sys_id, int buff_id)
    --说明：取当前角色信息 MyCharinfo
    --参数1：id
    --返回：int
    --函数：actor_unit.get_my_char_info(int id)
    --说明：取物资数据 CostData
    --参数1：id
    --返回：int
    --函数：actor_unit.get_cost_data(int id)
    --说明：用户本地数据
    --参数：无
    --返回:string
    --函数：actor_unit.get_char_local_save(void)
    --说明：当角色职业
    --参数：无
    --返回:int
    --函数：actor_unit.get_char_race(void)
    --说明：读取Pk模式
    --参数：无
    --返回:int
    --函数：actor_unit.get_pk_mode(void)
    --说明：设置Pk模式
    --参数：模式
    --返回:bool
    --函数：actor_unit.set_pk_mode(int nMode)
    --说明：当前地图ID(实际上是场景ID 可用于判断是否在游戏中)
    --参数：无
    --返回:int
    --函数：actor_unit.map_id(void)
    --说明：当前地图名称
    --参数：无
    --返回:string
    --函数：actor_unit.map_name(void)
    --说明：当前角色等级
    --参数：无
    --返回:int
    --函数：actor_unit.char_level(void)
    --说明：当前角色战力
    --参数：无
    --返回:int
    --函数：actor_unit.char_combat_power(void)
    --说明：读取当前角色系统ID
    --参数：无
    --返回:int
    --函数：actor_unit.get_local_player_sys_id(void)
    --说明：当前角色选择对象
    --参数：无
    --返回:int
    --函数：actor_unit.get_cur_select_actor_obj(void)
    --说明：选择对象
    --参数：ActorObject
    --返回:bool
    --函数：actor_unit.select_actor(ULONG_PTR ActorObject)

end

--拍卖单元
function example:test_auction_unit()

    -- 取拍卖所有物品资源
    auction_unit.refresh_auction_item()
    sleep(1500)

    local auction_obj = auction_unit:new()
    local item_res_list = auction_unit.item_res_list()
    for i = 1, #item_res_list do
        local obj = item_res_list[i]
        -- 第二个参数是不是细节也就是最后的物品列表
        if auction_obj:init(obj, false) then
            xxmsg(string.format('%16X   %08X   %s',
                    obj,
                    auction_obj:id(),
                    auction_obj:name()
            )
            )
        end

    end

    ------------------------------------------------------
    -- 取指定物品出售列表  (参数Id)（请求这个前也要请求上一步）
    auction_unit.refresh_item_detail(0x5383182C)  -- 查讯的是哪个钱币
    sleep(1500)
    local item_list = auction_unit.item_list()
    for i = 1, #item_list do
        local obj = item_list[i]
        -- 第二个参数是不是细节也就是最后的物品列)
        if auction_obj:init(obj, true) then
            xxmsg(string.format('%16X   %08X   %08X   %06u   %u   %s ',
                    obj,
                    auction_obj:id(),
                    auction_obj:buy_id(),
                    auction_obj:num(),
                    auction_obj:price(),   -- 如果要单价（price / num）
                    auction_obj:name()
            )
            )
        end

    end

    --说明：刷新拍卖物品
    --参数：无
    --返回：bool
    --函数：auction_unit.refresh_auction_item()
    --说明：刷新指定物品细节
    --参数：物品序号
    --返回：bool
    --函数：auction_unit.refresh_item_detail(int nId)
    --说明：刷新出售物品
    --参数：无
    --返回：bool
    --函数：auction_unit.refresh_sell_item()
    --说明：购买物品
    --参数：物品ID
    --返回：bool
    --函数：auction_unit.buy_item(int nBuyId)
    --说明：上架物品
    --参数1：物品资源ID
    --参数2：数量
    --参数3：单价
    --返回：bool
    --函数：auction_unit.sell_item(uint64_t nItemResId, int num, int nPrice)
    --说明：结算
    --参数：无
    --返回：bool
    --函数：auction_unit.settlement()
    --说明：出售物品数量
    --参数：无
    --返回：int
    --函数：auction_unit.get_auction_sell_num()
    --说明：取消出售
    --参数1：出售物品ID
    --返回：bool
    --函数：auction_unit.cancel_sell(uint64_t uSellId)
    --说明：序号取出售 ID
    --参数1：序号
    --返回：int
    --函数：auction_unit.get_sell_id(int nIdx)
    --说明：取出售物品名称
    --参数1：序号
    --返回：string
    --函数：auction_unit.get_sell_item_name(int nIdx)
    --说明：物品出售状态 0 1 3(上架中 1 出售中  3 已出售)
    --参数1：序号
    --返回：int
    --函数：auction_unit.get_item_sell_status(int nIdx)
    --说明：出售物品数量
    --参数1：序号
    --返回：int
    --函数：auction_unit.get_item_num(int nIdx)
    --说明：出售价格
    --参数1：序号
    --返回：int
    --函数：auction_unit.get_sell_price(int nIdx)
    --说明：结算价格
    --参数1：序号
    --返回：int
    --函数：auction_unit.get_result_price(int nIdx)
    --说明：是否可以结算(+ 38 = 2 是在结算中)
    --参数1：序号
    --返回：int
    --函数：auction_unit.can_settlement(int nIdx)
    --说明：交易物品资源列表
    --参数：无
    --返回：int
    --函数：auction_unit.item_res_list()
    --说明：交易物品细节列表
    --参数：无
    --返回：int
    --函数：auction_unit.item_list()

end

--内功单元
function example:test_force_unit()
    -- 内功
    local num = force_unit.get_inner_skill_num()
    for i = 0, num -1
    do
        xxmsg(string.format('%X   %X  %-6s  %-6s  %s',
                force_unit.get_inner_skill_obj(i),
                force_unit.get_inner_skill_id(i),
                force_unit.inner_skill_is_study(i),
                force_unit.inner_skill_can_study(i),
                force_unit.get_inner_skill_name(i)
        ))
    end
    -- 解锁内功
    --force_unit.unlock_inner_skill(id)
    -- 修练内功(序号是几项属性从上往下 0 开始)
    --force_unit.train_inner_skill(id, idx)
    --说明：解锁内功
    --参数：nId
    --返回：bool
    --函数：force_unit.unlock_inner_skill(int nId)
    --说明：修练内功
    --参数1：nId
    --参数2：idx
    --返回：bool
    --函数：force_unit.train_inner_skill(int nId, int idx)
    --说明：内功升阶
    --参数1：nId
    --返回：bool
    --函数：force_unit.inner_update(int nId)
    --说明：内功升阶刷新
    --参数1：nId
    --返回：bool
    --函数：force_unit.inner_refresh(int nId)
    --说明：体质升阶
    --参数1：无
    --返回：bool
    --函数：force_unit.mastery_update(void)
    --说明：取体质指针（ID  1 - 7）
    --参数1：nId
    --返回：int
    --函数：force_unit.get_mastery_data(int nId)
    --说明：体质是否可升级
    --参数1：nId
    --返回：bool
    --函数：force_unit.mastery_can_update(int nId)
    --说明：取体质等级
    --参数1：nId
    --返回：int
    --函数：force_unit.get_mastery_level_byid(int nId)
    --说明：取体质等阶
    --参数1：无
    --返回：int
    --函数：force_unit.get_mastery_main_level(void)
    --说明：取内功数量
    --参数1：无
    --返回：int
    --函数：force_unit.get_inner_skill_num(void)
    --说明：序号取内G对象
    --参数1：Idx
    --返回：int
    --函数：force_unit.get_inner_skill_obj(int Idx)
    --说明：id
    --参数1：Idx
    --返回：int
    --函数：force_unit.get_inner_skill_id(int Idx)
    --说明：取内功名称
    --参数1：Idx
    --返回：string
    --函数：force_unit.get_inner_skill_name(int Idx)
    --说明：内功是否已学
    --参数1：Idx
    --返回：bool
    --函数：force_unit.inner_skill_is_study(int Idx)
    --说明：是否可学
    --参数1：Idx
    --返回：bool
    --函数：force_unit.inner_skill_can_study(int Idx)
    --说明：取内功等级
    --参数1：nInnerSkillId
    --返回：int
    --函数：force_unit.get_inner_level(int nInnerSkillId)
    --说明：判断是否可以升级
    --参数1：nInnerSkillId
    --参数2：nIdx
    --返回：bool
    --函数：force_unit.force_can_update(int nInnerSkillId, int nIdx)
    --说明： 取子项等级
    --参数1：nInnerSkillId
    --参数2：nIdx
    --返回：int
    --函数：force_unit.get_force_child_level(int nInnerSkillId, int nIdx)
end

-- 控制台单元
function example:test_main_unit()

    --说明：自动重启
    --参数1：bAutoRestart
    --返回：void
    --函数：main_unit.monitor_luathread(bool bAutoRestart)
    --说明：自动重启
    --参数1：bAutoRestart
    --返回：void
    --函数：main_unit.auto_restart(bool bAutoRestart)
    --说明：设置帐号完成状态
    --参数1：nState
    --返回：void
    --函数：main_unit.set_ex_state(int nState)
    --说明：标记封号状态
    --参数1：时间
    --返回：void
    --函数：main_unit.set_ban_time(DWORD dwBanTime)
    --说明：标记封号状态
    --参数1：时间
    --参数2：封号提示
    --返回：void
    --函数：main_unit.set_ban_time_ex(DWORD dwBanTime, std::string reason)
    --说明：同步白名单
    --参数1：存在时间
    --返回：int
    --函数：main_unit.syn_white_list_ex(bool real_time)
    --说明：添加白名单到服务器
    --参数1：角色名称
    --返回：bool
    --函数：main_unit.add_white_list(std::string sName)
    --说明：效验名称是否在白名单
    --参数1：角色名称
    --返回：bool
    --函数：main_unit.in_white_list(std::string sName)
    --说明：添加击杀任务
    --参数1：优先处理等级
    --参数2：目标ID
    --参数3：等级
    --参数4：地图ID
    --参数5：x
    --参数6：y
    --参数7：z
    --返回：bool
    --函数：main_unit.add_kill_task(int priority_level, uint64_t target_id, int level, int map_id, float cx, float cy, float cz)
    --说明：读取帐号状态
    --参数1：无
    --返回：int
    --函数：main_unit.get_ex_state()
    --说明：设置行为
    --参数1：sBuffer
    --返回：无
    --函数：main_unit.set_action(string sBuffer)
    --说明：设置行为
    --参数1：sBuffer
    --返回：无
    --函数：main_unit.set_action(string sBuffer)
    --说明：终止进程
    --参数1：无
    --返回：无
    --函数：main_unit.end_game()
    --说明：读取游戏窗口
    --参数1：无
    --返回：int
    --函数：main_unit.game_window()
    --说明：隐藏游戏
    --参数1：无
    --返回：无
    --函数：main_unit.show_game()
    --说明：隐藏玩家
    --参数1：hide
    --返回：无
    --函数：main_unit.hide_player(bool hide)
    --说明：开启优化
    --参数1：opt
    --返回：无
    --函数：main_unit.opt_game(bool opt)
    --说明：大退重登陆
    --参数1：无
    --返回：无
    --函数：main_unit.restart()
    --说明：读取FZ帐号
    --参数1：无
    --返回：string
    --函数：main_unit.c_fz_account()
    --说明：读取FZ帐号
    --参数1：无
    --返回：string
    --函数：main_unit.c_fz_account2()
    --说明：读取FZ帐号ID
    --参数1：无
    --返回：int
    --函数：main_unit.c_fz_user_id()
    --说明：帐号
    --参数1：无
    --返回：string
    --函数：main_unit.c_account()
    --说明：密码
    --参数1：无
    --返回：string
    --函数：main_unit.c_password()
    --说明：服务器
    --参数1：无
    --返回：string
    --函数：main_unit.c_server_name()
    --说明：线路
    --参数1：无
    --返回：string
    --函数：main_unit.c_server_line()
    --说明：职业
    --参数1：无
    --返回：string
    --函数：main_unit.c_job()
    --说明：发送消息
    --参数1：Msg
    --参数2：wParam
    --参数3：lParam
    --返回：bool
    --函数：main_unit.post_msg(UINT Msg, DWORD_PTR wParam, DWORD_PTR lParam)
    --说明：设置焦点
    --参数1：无
    --返回：无
    --函数：main_unit.set_focus()
    --说明：移动光标
    --参数1：x
    --参数2：y
    --返回：bool
    --函数：main_unit.move_cursor(LONG x, LONG y)
    --说明：鼠标左键点击
    --参数1：x
    --参数2：y
    --返回：bool
    --函数：main_unit.lclick(LONG x, LONG y)
    --说明：鼠标右键点击
    --参数1：x
    --参数2：y
    --返回：bool
    --函数：main_unit.rclick(LONG x, LONG y)
    --说明：模拟按键
    --参数1：nKey
    --返回：bool
    --函数：main_unit.do_skey(UINT nKey)
    --说明：模拟按键
    --参数1：nKey
    --参数2：nActiorn
    --返回：bool
    --函数：main_unit.post_key(UINT nKey, int nActiorn)
    --说明：模拟按键(alt+?)
    --参数1：nKey
    --返回：bool
    --函数：main_unit.do_alt_key(UINT nKey)
    --说明：模拟按键(ctrl+?)
    --参数1：nKey
    --返回：bool
    --函数：main_unit.do_ctrl_key(UINT nKey)
    --说明：清空光标位置
    --参数1：无
    --返回：无
    --函数：main_unit.reset_pos()
    --说明：资格验证(手动)
    --参数1：website_url
    --返回：bool
    --函数：main_unit.human_verify(string website_url)
    --说明：资格验证2(自动)
    --参数1：website_url
    --参数2：client_key
    --返回：bool
    --函数：main_unit.human_verify2(string website_url, std::string client_key)
    --说明：读取次格到期时间
    --参数1：无
    --返回：int
    --函数：main_unit.get_human_expire_time()
    --说明：在线请求资格认证
    --参数1：无
    --返回：bool
    --函数：main_unit.req_auth_verify()
    --说明：取游戏启动时间
    --参数1：无
    --返回：int
    --函数：main_unit.get_ticket_count()
    --说明：读取脚本用户名称
    --参数1：无
    --返回：string
    --函数：main_unit.se_u_name()
    --说明：读取脚本用户邮箱
    --参数1：无
    --返回：string
    --函数：main_unit.se_u_email()
    --说明：读取脚本到期时间
    --参数1：无
    --返回：int
    --函数：main_unit.se_e_time()
    --说明：效验服务器是否在绑定列表
    --参数1：in_game
    --返回：bool
    --函数：main_unit.se_v_server(bool in_game)
    --说明：效验当前地图是否在绑定列表
    --参数1：无
    --返回：bool
    --函数：main_unit.se_v_map()
    --说明：鼠标
    --参数1：无
    --返回：bool
    --函数：main_unit.enable_mouse_hook()
    --说明：ansi转Utf8
    --参数1：无
    --返回：string
    --函数：main_unit.ansi_to_utf8(string msg)
    --说明：Utf8转ansi
    --参数1：无
    --返回：string
    --函数：main_unit.utf8_to_ansi(string msg)
end

--ui单元
function example.test_ui_unit()
    --说明：ID转名称
    --参数：ID
    --返回：string
    --函数：ui_unit.get_control_name_byid(int id)
    --说明：ID转路径
    --参数：ID
    --返回：string
    --函数：ui_unit.get_control_path_byid(int id)
    --说明：名称取ID
    --参数：pName
    --返回：int
    --函数：ui_unit.get_control_id_byname(string pName)
    --说明：ID 转对象
    --参数：ID
    --返回：int
    --函数：ui_unit.get_control_byid(int id)
    --说明：路径转对象
    --参数：路径
    --返回：int
    --函数：ui_unit.get_control_byname(string pPath)
    --说明：读取当前有焦点控件ID
    --参数：无
    --返回：int
    --函数：ui_unit.get_focus_control_id()
    --说明：控件类型
    --参数：dwControl
    --返回：int
    --函数：ui_unit.get_type(int dwControl)
    --说明：是否显示
    --参数：dwControl
    --返回：int
    --函数：ui_unit.is_visible(int dwControl)
    --说明：显示隐藏
    --参数1：dwControl
    --参数2：bShow
    --返回：bool
    --函数：ui_unit.show(int dwControl, BOOL bShow)
    --说明：按钮点击
    --参数1：dwControl
    --返回：bool
    --函数：ui_unit.btn_click(int dwControl)


end

-- 游戏单元
function example.test_game_unit()
    --说明：ID转类名
    --参数1：类ID
    --返回：string
    --函数：game_unit.get_class_name_byid(int class_id)
    --说明：对象转类名
    --参数1：对象
    --返回：string
    --函数：game_unit.get_obj_class_name(ULONG_PTR object)
    --说明：地图Id取地图名称U8
    --参数1：地图ID
    --返回：string
    --函数：game_unit.get_map_name_byid(int nMapId)
    --说明：根据ID取对象
    --参数1：ID
    --返回：int
    --函数：game_unit.get_object_byid(int ID)
    --说明：资源ID取字串
    --参数1：资源ID
    --返回：string
    --函数：game_unit.get_res_name(int nResId)
    --说明：UI上的名称字串U8
    --参数1：资源ID
    --返回：string
    --函数：game_unit.get_ui_string(int nResId)
    --说明：游戏状态
    --参数1：无
    --返回：int
    --函数：game_unit.game_status()
    --说明：是否连接服务器
    --参数1：无
    --返回：int
    --函数：game_unit.connect_status()
    --说明：读取当前连接服务器地址
    --参数1：无
    --返回：string
    --函数：game_unit.connect_server()
    --说明：读取加载状态
    --参数1：无
    --返回：int
    --函数：game_unit.is_loding()
    --说明：选择服务器
    --参数1：无
    --返回：string
    --函数：game_unit.get_cur_server_name()
    --说明：点击Btn_Screen
    --参数1：无
    --返回：bool
    --函数：game_unit.click_btn_screen()
    --说明： 跳过剧情
    --参数1：无
    --返回：bool
    --函数：game_unit.skip_seq()
    --说明： 结束教学
    --参数1：无
    --返回：bool
    --函数：game_unit.end_tutorial()
    --说明： 点击下一步
    --参数1：无
    --返回：bool
    --函数：game_unit.next_dialg()
    --说明： 跳过电影播放
    --参数1：无
    --返回：bool
    --函数：game_unit.skip_movie()
    --说明： 设置快捷建使用物品
    --参数1：物品ID
    --参数1：快捷栏序号
    --返回：bool
    --函数：game_unit.set_quick_slot(int nItemId, int nSlotIdx)
    --说明： 过地图排队反回目标地图ID
    --参数1：无
    --返回：int
    --函数：game_unit.wait_to_map()
    --说明： 进入地图排队人数
    --参数1：无
    --返回：int
    --函数：game_unit.wait_map_player_num()
    --说明： 确认进入地图
    --参数1：无
    --返回：bool
    --函数：game_unit.confirm_to_map()
    --说明： 确认进入地图
    --参数1：门ID
    --返回：bool
    --函数：game_unit.req_to_map(int nPortal)
    --说明： 排队门Id
    --参数1：无
    --返回：int
    --函数：game_unit.get_wait_portal_id()
    --说明：设置FPS
    --参数1：fps
    --返回：bool
    --函数：game_unit.set_fps(int fps)
    --说明：是否省电模式
    --参数1：无
    --返回：bool
    --函数：game_unit.is_sleep_mode()
    --说明：进入省电模式
    --参数1：无
    --返回：无
    --函数：game_unit.enter_sleep_mode()
    --说明：退出省电模式
    --参数1：无
    --返回：无
    --函数：game_unit.leave_sleep_mode()
    --说明：设置自动进入省电模式时间 秒
    --参数1：fSecond
    --返回：无
    --函数：game_unit.set_enter_sleep_mode_time(float fSecond)
    --说明：优化设置
    --参数1：无
    --返回：bool
    --函数：game_unit.optmize_setting()
    --说明：发送聊天（帮会2， 全部3）
    --参数1：nType
    --参数2：内容
    --返回：bool
    --函数：game_unit.send_chat(int nType, std::string sContext)
    --说明：发送聊天（帮会2， 全部3）（加密发送）
    --参数1：nType
    --参数2：内容
    --返回：bool
    --函数：game_unit.send_enc_chat(int nType, std::string sContext)
    --说明：私聊
    --参数1：玩家ID
    --参数2：玩家名称
    --参数3：私聊内容
    --返回：bool
    --函数：game_unit.private_talk(uint64_t uPlayerID, std::string sPlayerName, std::string sContext)
    --说明：私聊（加密发送）
    --参数1：玩家ID
    --参数2：玩家名称
    --参数3：私聊内容
    --返回：bool
    --函数：game_unit.private_enc_talk(uint64_t uPlayerID, std::string sPlayerName, std::string sContext)
    --说明：收到聊天信息处理（回调）
    --参数1：data
    --参数2：len
    --返回：bool
    --函数：game_unit.black_screen(PBYTE data, int len)
end

--伟业单元
function example:test_great_unit()
    local great_obj = great_unit:new()
    local list = great_unit.list()
    for i = 1, #list
    do
        local obj = list[i]
        if great_obj:init(obj) then
            xxmsg(string.format('%X   %X - %X  %u  %u  %u  %-6s  %-6s  %s ',
                    obj,
                    great_obj:id(),
                    great_obj:sub_id(),
                    great_obj:level(),
                    great_obj:tar_num(),
                    great_obj:tar_build_num(),
                    great_obj:can_update(),
                    great_obj:is_finish_update(),
                    great_obj:name()
            ))


            local tar_num = great_obj:tar_num()
            for i = 0, tar_num - 1
            do
                xxmsg(string.format(' 成就目标:%u    %X   %s    %s',
                        i,
                        great_obj:tar_id(i),
                        great_obj:tar_is_finish(i),
                        great_obj:tar_name(i)
                ))
            end


            local tar_build_num = great_obj:tar_build_num()
            for i = 0, tar_build_num - 1
            do
                xxmsg(string.format(' 建筑目标:%u    %X - %X    %u    %s    %s',
                        i,
                        great_obj:tar_build_id(i),
                        great_obj:tar_build_main_id(i),
                        great_obj:tar_build_need_level(i),
                        great_obj:build_meet_requirements(i),
                        great_obj:tar_build_name(i)
                ))
            end

        end

    end
    --说明：请求升级建筑
    --参数1：建筑ID
    --返回：bool
    --函数：great_unit.req_up_build(int nBuildId)
    --说明：完成建筑升级
    --参数1：建筑ID
    --返回：bool
    --函数：great_unit.complate_build_up(int nBuildId)
    --说明： 解锁建筑
    --参数1：建筑ID
    --返回：bool
    --函数：great_unit.unlock_build(int nBuildId)
    --说明： 取伟业主资源指针
    --参数1：nMainId
    --返回：int
    --函数：great_unit.get_build_main_res_ptr(int nMainId)
    --说明： 取伟业SUB资源指针
    --参数1：nSubId
    --返回：int
    --函数：great_unit.get_build_sub_res_ptr(int nSubId)
    --说明：主ID取对象
    --参数1：nMainId
    --返回：int
    --函数：great_unit.get_build_object(int nMainId)
    --说明：建筑是否可以升阶
    --参数1：nMainId
    --返回：bool
    --函数：great_unit.build_can_update(int nMainId)
    --说明：指定任务成就是否完成
    --参数1：AchievementId
    --返回：bool
    --函数：great_unit.achievement_is_finish(int AchievementId)
    --说明：伟业建筑列表
    --参数1：无
    --返回：int
    --函数：great_unit.list()

end

--门派单元
function example:test_guild_unit()
    local guild_obj = guild_unit:new()
    local list = guild_unit.guild_list()
    for i = 1, #list
    do
        local obj = list[i]
        if guild_obj:init(obj) then
            xxmsg(string.format('%X  %X  %u  %u - %u  %u  %-6s  %s',
                    obj,
                    guild_obj:id(),
                    guild_obj:mode(),
                    guild_obj:member_num(),
                    guild_obj:max_member_num(),
                    guild_obj:need_combat_power(),
                    guild_obj:is_full(),
                    guild_obj:name()
            ))

        end
    end

    --guild_unit.guild_support()
    --guild_unit.guild_assist(0x18a89)

    --  xxmsg(guild_unit.can_support_remedy())  -- 是否可以请求支援
    --  xxmsg(guild_unit.is_req_support_remedy()) -- 是否已请求支援过
    --  if guild_unit.can_support_remedy() and not guild_unit.is_req_support_remedy() then
    --      guild_unit.req_support_remedy()
    --  end

    --guild_unit.set_mode(模式, 战力)  -- 1自动 0审  战力0是默认5000
    --guild_unit.create('帮会名') -- 创建
    --guile_unit.refresh()  -- 刷新信息
    --sleep(2500)
    --guild_unit.guild_is_full() --自己帮会是否已满 用这前要先刷新帮会信息

    --说明：请求门派列表
    --参数1：页数
    --返回：bool
    --函数：guild_unit.req_guild_list(int nPage)
    --说明：请求查看门派信息（这步可以不用。只是正常操作有）
    --参数1：nGuildId
    --返回：bool
    --函数：guild_unit.req_guild_info(int nGuildId)
    --说明：加入门派
    --参数1：nGuildId
    --返回：bool
    --函数：guild_unit.join_guild(int nGuildId)
    --说明：请求支援列表
    --参数1：无
    --返回：bool
    --函数：guild_unit.req_support_list()
    --说明：支援
    --参数1：无
    --返回：bool
    --函数：guild_unit.guild_support()
    --说明：门派协助(ID 武术馆18A89 金库18A90)
    --参数1：nId
    --返回：bool
    --函数：guild_unit.guild_assist(int nId)
    --说明：请求支援治伤
    --参数1：无
    --返回：bool
    --函数：guild_unit.req_support_remedy()
    --说明：刷新门派信息
    --参数1：无
    --返回：bool
    --函数：guild_unit.refresh()
    --说明：刷新门派信息
    --参数1：sName
    --返回：bool
    --函数：guild_unit.create(string sName)
    --说明：设置战力和加入模式（模式1 自动， 0审核）
    --参数1：nMode
    --参数2：nCombatPower
    --返回：bool
    --函数：guild_unit.set_mode(int nMode, int nCombatPower)
    --说明：领取补给
    --参数1：无
    --返回：bool
    --函数：guild_unit.get_gift_recv()
    --说明： 取门派DataSet
    --参数1：无
    --返回：int
    --函数：guild_unit.get_guild_data_set()
    --说明： 取自己门派data
    --参数1：无
    --返回：int
    --函数：guild_unit.get_char_guild_data()
    --说明： 取自己门派ID
    --参数1：无
    --返回：int
    --函数：guild_unit.get_char_guild_id()
    --说明：是否有门派
    --参数1：无
    --返回：bool
    --函数：guild_unit.has_guild()
    --说明：门派掌门ID
    --参数1：无
    --返回：int
    --函数：guild_unit.get_guild_leader_id()
    --说明：门派掌门名称
    --参数1：无
    --返回：string
    --函数：guild_unit.get_guild_leader_name()
    --说明：取门派名称
    --参数1：无
    --返回：string
    --函数：guild_unit.get_guild_name()
    --说明：取门派模式
    --参数1：无
    --返回：int
    --函数：guild_unit.get_guild_mode()
    --说明：取可协助次数
    --参数1：无
    --返回：int
    --函数：guild_unit.get_assist_count()
    --说明：是否有支援
    --参数1：无
    --返回：bool
    --函数：guild_unit.has_support()
    --说明：是否可以请支援治伤
    --参数1：无
    --返回：bool
    --函数：guild_unit.can_support_remedy()
    --说明：是请已请求支援
    --参数1：无
    --返回：bool
    --函数：guild_unit.is_req_support_remedy()
    --说明：门派是否已满
    --参数1：无
    --返回：bool
    --函数：guild_unit.guild_is_full()
    --说明：是否有门派补给
    --参数1：无
    --返回：bool
    --函数：guild_unit.has_gift()
    --说明：取门派列表
    --参数1：无
    --返回：int
    --函数：guild_unit.guild_list()
end

-- 物品单元
function example:test_item_unit()
    local item_list = item_unit.list(0)
    xxmsg(#item_list)
    local item_obj = item_unit:new()
    for i = 1, #item_list
    do
        local obj = item_list[i]
        if item_obj:init(obj) then
            xxmsg( string.format('%X   %X  %X  %s \t %08X \t%04u \t %u  %u  %04u   %02u  %-6s  %-6s\t%s',
                    obj,
                    item_obj:res_ptr(),
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



    -- 嵌套魔石 (序号从0开始)
    --item_unit.inlay_magic_stone(item_sys_id, idx)
    -- 取解锁魔石 孔槽数量
    -- item_unit.get_magic_stone_unlocal_slot_num()
    -- 取已嵌套魔石 数量
    -- item_unit.get_magic_stone_num()
    -- 序号取嵌套魔石 ID(0 1 2 3 4 5)
    -- item_unit.get_magic_stone_byidx(0-?)
    --说明：制作装备
    --参数1：nEquipId
    --参数2：uItem1Id
    --参数3：uItem2Id
    --参数4：uItem3Id
    --参数5：uItem4Id
    --返回：bool
    --函数：item_unit.make_equip(int nEquipId, uint64_t uItem1Id,  uint64_t uItem2Id, uint64_t uItem3Id, uint64_t uItem4Id)
    --说明：制作物品
    --参数1：nItemMakeId
    --参数2：nNum
    --返回：bool
    --函数：item_unit.make_item(int nItemMakeId, int nNum)
    --说明：强化装备
    --参数1：uEquniSysID
    --参数2：uItemSysId
    --返回：bool
    --函数：item_unit.enhanced_equip(uint64_t uEquniSysID, uint64_t uItemSysId)
    --说明：使用装备
    --参数1：uEquniSysID
    --参数2：nType
    --返回：bool
    --函数：item_unit.use_equip(uint64_t uEquniSysID, int nType)
    --说明：使用物品
    --参数1：uSysId
    --参数2：num
    --返回：bool
    --函数：item_unit.use_item(uint64_t uSysId, int num)
    --说明：测式药品
    --参数1：uSysId
    --参数2：num
    --返回：bool
    --函数：item_unit.use_dury(uint64_t sys_id, int num)
    --说明：合成物品
    --参数1：uItemSysId1
    --参数2：uItemSysId2
    --参数3：uItemSysId3
    --参数4：uItemSysId4
    --返回：bool
    --函数：item_unit.compose(uint64_t uItemSysId1, uint64_t uItemSysId2, uint64_t uItemSysId3, uint64_t uItemSysId4)
    --说明：召唤卷轴 nId  精灵 0， 武功1， 神龙材料 5   type 0 1次， 1 10次
    --参数1：nId
    --参数2：type
    --返回：bool
    --函数：item_unit.call_item(int nId, int type)
    --说明：镶嵌魔石
    --参数1：uItemSysId
    --参数2：Idx
    --返回：bool
    --函数：item_unit.inlay_magic_stone(uint64_t uItemSysId, int Idx)
    --说明：取已解锁孔槽数
    --参数1：无
    --返回：int
    --函数：item_unit.get_magic_stone_unlocal_slot_num()
    --说明：已放收魔石数
    --参数1：无
    --返回：int
    --函数：item_unit.get_magic_stone_num()
    --说明：序号取放入魔石系统ID
    --参数1：nIdx
    --返回：int
    --函数：item_unit.get_magic_stone_byidx(int nIdx)
    --说明：读取物品对象
    --参数1：item_id
    --返回：int
    --函数：item_unit.get_item_ptr_byid(int item_id)
    --说明：取背包最大空间
    --参数1：无
    --返回：int
    --函数：item_unit.get_bag_max_space()
    --说明：取背包空间
    --参数1：无
    --返回：int
    --函数：item_unit.get_bag_space()
    --说明：物品是否冷确
    --参数1：nId
    --返回：bool
    --函数：item_unit.item_is_cool(int nId)
    --说明：物品资源ID取物品数量
    --参数1：ItemResId
    --返回：int
    --函数：item_unit.get_item_num_by_resid(int ItemResId)
    --说明：遍历环境(-1(所有), 0(装备), 1(材料), 2(魔石), 3(精灵), 4(杂货))
    --参数1：nType
    --返回：int
    --函数：item_unit.list(int nType)
end

--登录单元
function example:test_login_unit()
    --说明：打开谷歌登陆
    --参数1：无
    --返回：bool
    --函数：login_unit.open_google_login()
    --说明：同一大区选择服务器
    --参数1：nWorldId
    --返回：bool
    --函数：login_unit.select_world(int nWorldId)
    --说明：设置登陆大区
    --参数1：sServerName
    --返回：bool
    --函数：login_unit.set_server(string sServerName)
    --说明：连接游戏大区
    --参数1：sServerName
    --返回：bool
    --函数：login_unit.connect_server(string sServerName)
    --说明：服务器名称取服务器ID
    --参数1：sWorldName
    --返回：int
    --函数：login_unit.get_world_id_byname(string sWorldName)
    --说明：帐号保存对象
    --参数1：无
    --返回：int
    --函数：login_unit.get_account_local_save()
    --说明： 取登陆管理
    --参数1：无
    --返回：int
    --函数：login_unit.get_login_manager()
    --说明： 取当前选择登陆服务器ID
    --参数1：无
    --返回：int
    --函数：login_unit.get_cur_world_id()
    --说明： 取当前连接大区U8
    --参数1：无
    --返回：string
    --函数：login_unit.get_last_server()
    --说明： 读取当前服务器名称
    --参数1：无
    --返回：string
    --函数：login_unit.get_cur_server()
end

--邮箱单元
function example:test_mail_unit()
    --说明： 删除邮件(从上往下 1 - 5)
    --参数：nIdx
    --返回：bool
    --函数：mail_unit.del_mail(int nIdx)
    --说明：领取并阅读邮件（从上往下 1 - 5）
    --参数：nIdx
    --返回：bool
    --函数：mail_unit.read_mail(int nIdx)
    --说明：取序号取邮件数量（从上往下1 - 5）
    --参数：nIdx
    --返回：bool
    --函数：mail_unit.get_mail_num_byidx(int nIdx)
end

--制作单元
function example:test_make_res_unit()

    local make_res_obj = make_res_unit:new()
    local list = make_res_unit.list()
    for i = 1, #list do
        local obj = list[i]
        if make_res_obj:init(obj) then
            xxmsg(string.format('%16X    %08X    %08X   %08X   %s',
                    obj,
                    make_res_obj:id(),
                    make_res_obj:make_id(),
                    make_res_obj:make_pos_type(),    -- 随身制作装备为0x7D0   随身制作材料为0x7D1    青龙装备13EC(所有NPC制作 类装备只有青龙在制)（其他在NPC的制作的材料 可以取封包第二个就是ID手动作成资源）
                    make_res_obj:name()
            ))

        end

    end

    -- 制作物品  （制作装备数量为1）
    -- item_unit.make_item(make_id, num) --

end

--宠物单元
function example:test_pet_unit()
    local pet_obj = pet_unit:new()
    local item_obj = item_unit:new()

    local list = pet_unit.list()
    xxmsg('精灵数量：'..#list)
    for i = 1, #list
    do
        local obj = list[i]
        if pet_obj:init(obj) then
            xxmsg(string.format('[%16X]  [%16X]  ID[%08x] ISUNLOCK[%-6s] CANSUMMON[%-6s] NAME[%s]',
                    obj,
                    pet_obj:res_ptr(),
                    pet_obj:id(),
                    pet_obj:is_unlock(),    -- 是否解锁
                    pet_obj:can_summon(),    -- 是否可召唤
                    pet_obj:name()
            ))

            -- 授予宝物
            local item_list = pet_obj:pet_item_list()
            xxmsg("授予宝物数:"..#item_list)

            for j = 1, #item_list do
                local obj = item_list[j]
                if item_obj:init(obj) then
                    xxmsg( string.format('%16X  %16X  %s  %s',
                            obj,
                            item_obj:sys_id(),
                            item_obj:quality(),
                            item_obj:name()
                    )
                    )
                end

            end

        end

    end



    xxmsg('------------------------------------出战精灵-----------------------------------------')
    for i = 0, 4
    do
        local obj = pet_unit.get_warpet_obj_byidx(i)
        if pet_obj:init(obj) then
            xxmsg(string.format('[%16X] POS[%u] ID[%08X]  NAME[%s]',
                    obj,
                    i,
                    pet_obj:id(),
                    pet_obj:name()
            ))

            -- 授予宝物
            local item_list = pet_obj:pet_item_list()
            xxmsg("授予宝物数:"..#item_list)

            for j = 1, #item_list do
                local obj = item_list[j]
                if item_obj:init(obj) then
                    xxmsg( string.format('%X  %X  %s  %s',
                            obj,
                            item_obj:sys_id(),
                            item_obj:quality(),
                            item_obj:name()
                    )
                    )
                end

            end
        end
    end

    pet_obj:delete()
    item_obj:delete()
    --说明：出战精灵(出战槽序号 0-4)
    --参数1：精灵ID
    --参数2：位置
    --返回：bool
    --函数：pet_unit.go_war_pet(int nId, int nPos)
    --说明：取消出精灵(出战槽序号 0-4)
    --参数1：精灵ID
    --参数2：位置
    --返回：bool
    --函数：pet_unit.cancel_war_pet(int nId, int nPos)
    --说明：召唤精灵
    --参数1：精灵ID
    --返回：bool
    --函数：pet_unit.summon_pet(int nId)
    --说明：授予宝物
    --参数1：精灵ID
    --参数2：物品系统ID
    --参数3：位置
    --返回：bool
    --函数：pet_unit.grant_item(int nPetId, uint64_t ItemSysId, int nPos)
    --说明： 出战精灵序号取出战精灵Id idx = 0-4（-1 为没有出战精灵）
    --参数1：序号
    --返回：int
    --函数：pet_unit.get_warpet_id_byidx(int nIdx)
    --说明： 出战精灵序号取出战精灵对象
    --参数1：序号
    --返回：int
    --函数：pet_unit.get_warpet_obj_byidx(int nIdx)
    --说明： ID取对象
    --参数1：nId
    --返回：int
    --函数：pet_unit.get_pet_object_byid(int nId)
    --说明： 取精灵列表
    --参数1：无
    --返回：int
    --函数：pet_unit.list()

end

-- 任务单元
function example:test_quest_unit(quest_type)
    local quest_obj = quest_unit:new()
    -- -1 所有任务（不包阔委托），0当前任务，1可接任务 2 委托任务
    local list = quest_unit.list(quest_type)
    xxmsg(string.format('任务总数：%u', #list))

    for i = 1, #list
    do
        local obj = list[i]
        if quest_obj:init(obj) then
            xxmsg(string.format('[%16X] ID[%08X] TYPE[%u] DAILYNUM[%u] STATUS[%u] COMBATPOWER[%u]  TRATYPE[%u] TAR[%u-%u] POS[%0.1f-%0.1f-%0.1f] ISOVER[%-6s]  ISFINISH[%-6s]  MAP[%08X-%-20s] NAME[%s] [%08X]',
                    obj,
                    quest_obj:id(),
                    quest_obj:type(),
                    quest_obj:daily_num(),
                    quest_obj:status(),
                    quest_obj:combat_power(),
                    quest_obj:tar_type(),
                    quest_obj:tar_num(),
                    quest_obj:tar_max_num(),
                    quest_obj:tx(),
                    quest_obj:ty(),
                    quest_obj:tz(),
                    quest_obj:is_over(),
                    quest_obj:is_finish(),
                    quest_obj:map_id(),
                    quest_obj:map_name(),
                    quest_obj:name(),
                    quest_obj:entrust_gather_resid()
            ))
        end

    end
    quest_obj:delete()

    -- 接受任务
    --quest_unit.accept(quest_id)
    -- 提交任务
    -- quest_unit.up(quest_id))

    -- 主线读取
    -- 主线任务ID
    -- xxmsg(quest_unit.get_main_quest_id())
    -- 主线任务名称
    -- xxmsg(quest_unit.get_main_quest_name())
    -- 主线任务序号
    -- xxmsg(quest_unit.get_main_quest_idx())
    -- 自动主线
    -- quest_unit.auto_main_quest()

    -- 任务是否是自动
    -- xxmsg(quest_unit.quest_is_auto(questid))
    -- 开启自动任务(1 开0关)
    -- xxmsg(quest_unit.auto(questid, 1))
    -- 任务是否完结（指的是任务列表里完成了）
    -- quest_unit.has_quest_over(questid)
    -- 当前任务是否完成
    -- quest_unit.quest_is_finish(questid)
    -- 任务Id取任务指针(该指针可以直接用作上面的初使化)
    -- quest_unit.get_quest_byid(questid)

    --说明：接受任务
    --参数1：任务ID
    --返回：bool
    --函数：quest_unit.accept(int nQuestId)
    --说明：上交任务
    --参数1：任务ID
    --返回：bool
    --函数：quest_unit.completed(int nQuestId)
    --说明：删除任务
    --参数1：任务ID
    --返回：bool
    --函数：quest_unit.delete(int nQuestId)
    --说明：开始自动任务（游戏里面Q建同时好像只能开一个 On = 1开，0关）
    --参数1：任务ID
    --参数2：On = 1开，0关
    --返回：bool
    --函数：quest_unit.auto(nt nQuestId, int On)
    --说明：过任务剧情
    --参数1：无
    --返回：bool
    --函数：quest_unit.pass_monster_smite()
    --说明：进入魔方阵 一层0x65
    --参数1：nId
    --返回：bool
    --函数：quest_unit.enter_mofang(int nId)
    --说明：退出魔方阵
    --参数1：无
    --返回：bool
    --函数：quest_unit.exit_mofang()
    --说明：魔方阵换地图
    --参数1：无
    --返回：bool
    --函数：quest_unit.mofang_next_map()
    --说明：魔方阵加时间
    --参数1：无
    --返回：bool
    --函数：quest_unit.mofang_add_time()
    --说明： 进入秘境峰
    --参数1：nId
    --返回：bool
    --函数：quest_unit.enter_secret(int nId)
    --说明： 退出秘境峰
    --参数1：无
    --返回：bool
    --函数：quest_unit.exit_secret()
    --说明： 秘境峰加时间
    --参数1：无
    --返回：bool
    --函数：quest_unit.secret_add_time()
    --说明： 魔防阵是否可以进入（1层 0x65）
    --参数1：nId
    --返回：bool
    --函数：quest_unit.square_can_enter(int nId)
    --说明： 魔方阵是否可以换地图
    --参数1：无
    --返回：bool
    --函数：quest_unit.aquare_can_next_map()
    --说明： 秘境封是否可以进入（1层ID 0x3E9）
    --参数1：nId
    --返回：bool
    --函数：quest_unit.secret_can_enter(int nId)

    --说明： 取主线任务资源指针
    --参数1：无
    --返回：int
    --函数：quest_unit.get_main_quest_res_ptr()
    --说明： 取主线任务ID
    --参数1：无
    --返回：int
    --函数：quest_unit.get_main_quest_id()
    --说明： 当前主线任务名称
    --参数1：无
    --返回：string
    --函数：quest_unit.get_main_quest_name()
    --说明： 主线任务序号
    --参数1：无
    --返回：int
    --函数：quest_unit.get_main_quest_idx()
    --说明： 自动主线
    --参数1：无
    --返回：bool
    --函数：quest_unit.auto_main_quest()
    --说明： 主线是否开启自动
    --参数1：无
    --返回：bool
    --函数：quest_unit.main_is_auto()
    --说明： 当前主线任务地图
    --参数1：无
    --返回：int
    --函数：quest_unit.main_quest_map_id()
    --说明： 取主线任务类型  0 一般，1杀怪， >10 采集的资源ID
    --参数1：无
    --返回：int
    --函数：quest_unit.main_quest_type()
    --说明：当前主线任务座标X
    --参数1：无
    --返回：float
    --函数：quest_unit.main_quest_tx()
    --说明： 当前主线任务座标Y
    --参数1：无
    --返回：float
    --函数：quest_unit.main_quest_ty()
    --说明：当前主线任务座标Z
    --参数1：无
    --返回：float
    --函数：quest_unit.main_quest_tz()
    --说明：主类型（主线1，支线2，委托是6）
    --参数1：无
    --返回：int
    --函数：quest_unit.get_quest_type()
    --说明：判断完结
    --参数1：id
    --返回：bool
    --函数：quest_unit.has_quest_over(int id)
    --说明：任务是否自动
    --参数1：nId
    --返回：bool
    --函数：quest_unit.quest_is_auto(int nId)
    --说明：任务是否完成
    --参数1：nId
    --返回：bool
    --函数：quest_unit.has_quest_finish(int nId)
    --说明：任务ID取任务指针
    --参数1：nQuestId
    --返回：int
    --函数：quest_unit.get_quest_byid(int nQuestId)
    --说明：任务ID当取前任务指针
    --参数1：nId
    --返回：int
    --函数：quest_unit.get_cur_quest_byid(int nId)
    --说明：任务ID取任务主类型
    --参数1：nId
    --返回：int
    --函数：quest_unit.get_quest_type(int nId)
    --说明：在动画剧情场景
    --参数1： 无
    --返回：bool
    --函数：quest_unit.is_in_monster_smite()
    --说明：读取剧情ID
    --参数1： 无
    --返回：int
    --函数：quest_unit.get_monster_smite_id()
    --说明：取日常总完成次数
    --参数1： 无
    --返回：int
    --函数：quest_unit.get_daily_over_count()
    --说明：读取任务列表(-1(所有任务) 0(当前任务) 1(可接任务))（2委托任务）
    --参数1：nType
    --返回：int
    --函数：quest_unit.list(int nType)
end

--奇缘单元
function example.test_relation_unit()
    local relation_obj = relation_unit:new()
    local list = relation_unit.list()
    xxmsg('奇缘数量：'..#list)

    for i = 1, #list
    do
        local obj = list[i]
        if relation_obj:init(obj) then
            xxmsg(string.format('%X   %08X - %08X   %03u  %-6s   %08X - %-16s  %0.1f - %0.1f - %0.1f   %-24s   %24s   %s',
                    obj,
                    relation_obj:id(),
                    relation_obj:sub_id(),
                    relation_obj:idx(),
                    relation_obj:is_kill_monster(),
                    relation_obj:map_id(),
                    relation_obj:map_name(),
                    relation_obj:tx(),
                    relation_obj:ty(),
                    relation_obj:tz(),
                    relation_obj:main_name(),
                    relation_obj:name(),
                    relation_obj:desc()

            ))

        end

    end

    --说明：领取奇缘任务奖历
    --参数1：nId
    --返回：bool
    --函数：relation_unit.get_relation_reward(int nId)
    --说明：领取完成奖历(半兽人角迪1)
    --参数1：idx
    --返回：bool
    --函数：relation_unit.get_over_reward(int idx)
    --说明：奇缘对话
    --参数1：nRelationId
    --参数2：nIdx
    --返回：bool
    --函数：relation_unit.relation_talk(int nRelationId, int nIdx)
    --说明：获取下一个奇缘序号
    --参数1：nId
    --返回：int
    --函数：relation_unit.get_next_relation_idx(int nId)
    --说明：奇缘衣服染色
    --参数1：nId
    --返回：bool
    --函数：relation_unit.ran_se(int nId)
    --说明：使用服鉓
    --参数1：nId
    --返回：bool
    --函数：relation_unit.use_costume(int nId)
    --说明：服饰ID取对象
    --参数1：nId
    --返回：int
    --函数：relation_unit.get_costume_data(int nId)
    --说明：服饰是否解锁
    --参数1：nId
    --返回：bool
    --函数：relation_unit.costume_is_unlock(int nId)
    --说明：服饰是否使用
    --参数1：nId
    --返回：bool
    --函数：relation_unit.costume_is_use(int nId)
    --说明：奇缘主ID取进行对象
    --参数1：nId
    --返回：int
    --函数：relation_unit.get_under_way_ptr(int nId)
    --说明：奇缘ID取进度序号
    --参数1：nId
    --返回：int
    --函数：relation_unit.get_under_way_idx(int nId)
    --说明：奇缘ID奇缘序号 取奇缘指针
    --参数1：nId
    --参数2：nIdx
    --返回：int
    --函数：relation_unit.get_relation_ptr_byid(int nId, int nIdx)
    --说明：奇缘子任务是否完成
    --参数1：nId
    --返回：int
    --函数：relation_unit.relation_is_finish(int nId)
    --说明：检测任务奖历是否已领
    --参数1：nId
    --返回：bool
    --函数：relation_unit.reward_is_receive(int nId)
    --说明：是否完成当前任务任务
    --参数1：nId
    --返回：bool
    --函数：relation_unit.relation_is_over(int nId)
    --说明：判断奇缘主奖励是否已领(半兽人角迪1，往下到5)
    --参数1：nId
    --返回：bool
    --函数：relation_unit.is_receive_main_reward(int nId)
    --说明：取奇缘列列
    --参数1：无
    --返回：int
    --函数：relation_unit.list()

end

-- 复活单元
function example.test_revival_unit()
    --说明：领取丢失经验
    --参数：id
    --返回：bool
    --函数：revival_unit.get_revival_exp(int id)
    --说明：删除丢失经验
    --参数：id
    --返回：bool
    --函数：revival_unit.del_revival_exp(int id)
    --说明：免费找回经验次数
    --参数：无
    --返回：int
    --函数：revival_unit.get_free_reviva_num()
    --说明：取丢失经验数量
    --参数：无
    --返回：int
    --函数：revival_unit.get_exp_num()
    --说明：序号取恢复经验id()
    --参数：nIdx
    --返回：int
    --函数：revival_unit.get_exp_id(int nIdx)
    --说明：序号取经验值
    --参数：nIdx
    --返回：int
    --函数：revival_unit.get_exp(int nIdx)
end

--角色单元
function example:test_role_unit()
    local role_list = role_unit.list()
    xxmsg(#role_list)
    local role_obj = role_unit:new()
    for i = 1, #role_list
    do
        local obj = role_list[i]
        if role_obj:init(obj) then
            xxmsg( string.format('%X \t%X \t%04u \t%04u \t%s',
                    obj,
                    role_obj:id(),
                    role_obj:level(),
                    role_obj:race(),
                    role_obj:name()
            )
            )
        end
    end

    role_obj:delete()

    --说明：读取登陆管理对象
    --参数：无
    --返回：int
    --函数：role_unit.GetLoginManager()
    --说明：读取 AccountLocalSave
    --参数：无
    --返回：int
    --函数：role_unit.GetAccountLocalSave()
    --说明：读取当前大区名称
    --参数：无
    --返回：string
    --函数：role_unit.get_global_server_name()
    --说明：读取当前世界ID
    --参数：无
    --返回：int
    --函数：role_unit.get_cur_world_id()
    --说明：选择世界
    --参数：world_id
    --返回：bool
    --函数：role_unit.select_world(int world_id)
    --说明：选择职业
    --参数：class_id
    --返回：bool
    --函数：role_unit.select_class(int class_id)
    --说明：进入创建角色
    --参数：无
    --返回：bool
    --函数：role_unit.enter_create_page()
    --说明：选择角色
    --参数：idx
    --返回：bool
    --函数：role_unit.select_char(int idx)
    --说明：创建角色
    --参数1：name
    --参数2：class_id
    --返回：bool
    --函数：role_unit.create_char(string name, int class_id)
    --说明：创建角色
    --参数1：name
    --参数2：class_name
    --返回：bool
    --函数：role_unit.create_role(string name, string class_name)
    --说明：进入游戏
    --参数：idx
    --返回：bool
    --函数：role_unit.enter(int idx)
    --说明：进入选择职业界面
    --参数：无
    --返回：bool
    --函数：role_unit.enter_select_class_page()
    --说明：大退到登陆界面
    --参数：无
    --返回：bool
    --函数：role_unit.return_to_login()
    --说明：读取当前选择职业
    --参数：无
    --返回：bool
    --函数：role_unit.get_cur_select_race()
    --说明：获取列表
    --参数：无
    --返回：int
    --函数：role_unit.list()
end

--商店单元
function example:test_shop_unit()
    local shop_obj = shop_unit.new()
    local list = shop_unit.list()
    xxmsg(#list)
    for i = 1, #list
    do
        local obj = list[i]
        if shop_obj:init(obj) then
            xxmsg(string.format('%X  %X %u %u %s',
                    obj,
                    shop_obj:id(),
                    shop_obj:price(),
                    shop_obj:limit_buy_num(),
                    shop_obj:name()
            ))

        end


    end

    --1F6ABC20920  BC2 1700229600 0

    --说明：打开商店
    --参数1：商店ID
    --参数2：npc_id
    --返回：bool
    --函数：shop_unit.open_npc_shop(int shop_id, int npc_id)
    --说明：打开商店
    --参数1：npc_id
    --返回：bool
    --函数：shop_unit.open_npc_shop_byid(int npc_id)
    --说明： 打开商店
    --参数1：sName
    --返回：bool
    --函数：shop_unit.open_npc_shop_byname(string sName)
    --说明： 购买物品(忽视打开商店状态)
    --参数1：shop_id
    --参数2：npc_id
    --参数3：item_id
    --参数4：buy_num
    --返回：bool
    --函数：shop_unit.buy_npc_item_ex(int shop_id, int npc_id, uint64_t item_id, int buy_num)
    --说明： 购买物品
    --参数1：item_id
    --参数2：buy_num
    --返回：bool
    --函数：shop_unit.buy_npc_item(uint64_t item_id, int buy_num)
    --说明： 出售物品
    --参数1：item_id
    --参数2：buy_num
    --返回：bool
    --函数：shop_unit.sell_item(uint64_t item_id, int num)
    --说明： 购买商城物品
    --参数1：nId
    --返回：bool
    --函数：shop_unit.buy_uishop_item(int nId)
    --说明： 购买时空商店物品
    --参数1：nId
    --参数2：数量
    --返回：bool
    --函数：shop_unit.buy_shikong_item(int nId, int num)
    --说明： 取物品已购买次数
    --参数1：nId
    --返回：int
    --函数：shop_unit.get_uishop_item_count(int nId)
    --说明： 商品列表
    --参数1：无
    --返回：int
    --函数：shop_unit.list()
end

-- 签到单元
function example:test_sign_unit()
    --说明：签到（成长支援0x404,七日签到0x401, 上线纪念七日 0x3EA, 奇缘达成 0x7D1, 等级达成0x7D2）
    --参数1：nId
    --返回：bool
    --函数：sign_unit.sign(int nId)
    --说明：一建领取课题
    --参数1：无
    --返回：bool
    --函数：sign_unit.daily_work_receive_all()
    --说明：领取课题完成奖历（1  五次奖历， 2 完成10次奖历）
    --参数1：nIdx
    --返回：bool
    --函数：sign_unit.daily_work_plus_reward(int nIdx)
    --说明：一建领取成就
    --参数1：无
    --返回：bool
    --函数：sign_unit.achievement_receive_all()
    --说明：取课题奖历状态（参数1  五次奖，2 10次奖历）（反回 0 未完成， 1 完成可领取 2 已领取）
    --参数1：nIdx
    --返回：int
    --函数：sign_unit.get_dailyword_reward_status(int nIdx)
    --说明：判断是否可以签到
    --参数1：nIdx
    --返回：bool
    --函数：sign_unit.can_sign(int nIdx)
    --说明：判断是否有可领取课题
    --参数1：无
    --返回：bool
    --函数：sign_unit.can_daily_work()
    --说明：是否有可领取成功
    --参数1：无
    --返回：bool
    --函数：sign_unit.can_achievement_receive()
end

--技能单元
function example:test_skill_unit()
    local skill_obj = skill_unit:new()
    -- 类型 - 1所有技能，0 已学技能
    local list = skill_unit.list(0)
    xxmsg(string.format('技能数量：%u', #list))

    for i = 1, #list
    do
        local obj = list[i]

        if skill_obj:init(obj) then
            xxmsg(string.format('[%16X] ID[%08X] LEVEL[%u] STUDY[%u] ACTIONNUM[%u]  FIRSTACTION[%08X]  NAME[%s]',
                    obj,
                    skill_obj:id(),
                    skill_obj:level(),
                    skill_obj:study_level(),
                    skill_obj:action_num(),
                    skill_obj:get_action_byidx(0),
                    skill_obj:name()
            ))

        end
    end


    skill_obj:delete()

    --说明：学习技能
    --参数1：nId
    --返回：bool
    --函数：skill_unit.study(int nId)
    --说明：升级技能
    --参数1：nId
    --返回：bool
    --函数：skill_unit.up(int nId)
    --说明：修练体质(id 1 -9)
    --参数1：nId
    --返回：bool
    --函数：skill_unit.sta_training(int nId)
    --说明：设置技能快捷栏
    --参数1：nSkillId
    --参数2：DeckId
    --参数3：nIdx
    --返回：bool
    --函数：skill_unit.set_skill_deck(int nSkillId, int DeckId, int nIdx)
    --说明：配置技能
    --参数1：nSkillId
    --返回：bool
    --函数：skill_unit.set_skill_deck_ex(int nSkillId)
    --说明：设置技能快捷栏
    --参数1：nSkillId
    --参数2：DeckId
    --参数3：nIdx
    --返回：bool
    --函数：skill_unit.set_skill_deck(int nSkillId, int DeckId, int nIdx)
    --说明：技能ID取技能对象
    --参数1：nSkillId
    --返回：int
    --函数：skill_unit.get_skill_obj_byid(int nSkillId)
    --说明：技能ID取已学技能对象
    --参数1：nSkillId
    --返回：int
    --函数：skill_unit.get_study_skill_obj_byid(int nSkillId)
    --说明：技能ID取行为数量
    --参数1：nSkillId
    --返回：int
    --函数：skill_unit.get_skill_action_num_byid(int nSkillId)
    --说明：技能ID取技能action(行为往后是依次加1)
    --参数1：nSkillId
    --参数2：nIdx
    --返回：int
    --函数：skill_unit.get_skill_action_byid(int nSkillId, int nIdx)
    --说明：快捷栏主序号取DATA(快捷栏一  1 快捷栏2 2)
    --参数1：nIdx
    --返回：int
    --函数：skill_unit.get_skill_deck_data(int nIdx)
    --说明：技能是否已配置
    --参数1：nSkillId
    --返回：bool
    --函数：skill_unit.skill_is_config(int nSkillId)
    --说明：取技能列表（-1 所有 0 已学技能）
    --参数1：nType
    --返回：int
    --函数：skill_unit.list(int nType)

end

-- 队伍单元
function example:test_team_unit()
    local team_obj = team_unit:new()
    local list = team_unit.list()
    for i = 1, #list
    do
        local obj = list[i]
        if team_obj:init(obj) then
            xxmsg(string.format('[%16X]  ID[%08X] RACE[%u] LEVEL[%u] COMBATPOWER[%u] HP[%u - %u] POS[%0.1f - %0.1f - %0.1f]      ISLEADER[%-6s] MAP[%08X - %s] NAME[%s]     ',
                    obj,
                    team_obj:id(),
                    team_obj:race(),
                    team_obj:level(),
                    team_obj:combat_power(),
                    team_obj:hp(),
                    team_obj:max_hp(),
                    team_obj:cx(),
                    team_obj:cy(),
                    team_obj:cz(),
                    team_obj:is_leader(),
                    team_obj:map_id(),
                    team_obj:map_name(),
                    team_obj:name()
            ))

        end
    end

    -- 邀请组队
    -- team_unit.invite(player_id)
    -- 接受组队
    -- team_unit.accept(team_id, invite_player_id)
    -- 离开队伍
    -- team_unit.leave()
    -- 解散队伍
    -- team_unit.disband()

    -- 取队伍id
    -- team_unit.team_id()
    -- 是否有组队
    -- team_unit.Has_team()
    -- 取队伍人数（包括自己）
    -- team_unit.member_num()
    -- 自己是否为队长
    -- team_unit.hero_is_leader()

    -- 购买时空商店物品(ID 可以截取封包获得。。封包解析出来第二个就是ID)
    --shop_unit.buy_shikong_item(id, num)
    -- 合成物品（四个一合的比如精灵，魔石）
    --item_unit.compose(item1_sysid, item2_sysid, item3_sys_id, item4_sysid)
    --xxmsg(item_unit.compose(0x88348A431240003, 0x88348A431240003,0x88348A431240003,0x88348A431240003))
    -- 召唤物品 nId  精灵 = 0， 武功 =1， 神龙材料 =5 ,  type = 0 1次，  =1 10次
    --item_unit.call_item(nid, type)

    -- 静态函数
    -- 刷新讨伐队伍（taofa_type  = 首领 0x65  普通：0x66）
    --team_unit.update_team_list(taofa_type)
    -- 是否有讨伐门票 （taofa_type  = 首领 0x65  普通：0x66）
    -- team_unit.can_taofa_ticket(taofa_type)
    -- 申请进入讨伐队伍
    -- team_unit.join_team(team_id, taofa_type, taofa_id)
    -- 队长开始讨伐
    -- team_unit.start_taofa(taofa_id)
    -- 讨伐完成退出
    -- team_unit.finish_taofa(taofa_type)
    -- 创建讨伐队伍
    -- team_unit.create_taofa(taofa_type, taofa_id)
    -- 取队伍列表
    -- team_unit.party_list(taofa_type, taofa_id)

    -- 动态函数
    -- 队伍ID
    -- team_obj:party_id()
    -- 队伍类型
    -- team_obj：party_tyep()
    -- 讨伐Id
    -- team_obj:taofa_id()
    -- 所需要战力
    -- team_obj:have_combat_power()

    --（taofa_type  = 首领 0x65  普通：0x66）
    -- team_unit.update_team_list(0x65)
    -- sleep(2000)
    -- -- 地牢ID0x65 双门迷宫ID0x66   黑血僧将 0xC9
    -- local party_list = team_unit.party_list(0x65, 0xC9)
    -- local team_obj = team_unit:new()
    -- xxmsg(#party_list)
    -- for i = 1, #party_list do
    --     local obj = party_list[i]
    --     if team_obj:init(obj) then
    --         xxmsg(string.format('%16X     %08X    %08X    %08X   %08X',
    --         obj,
    --         team_obj:party_id(),
    --         team_obj:party_type(),
    --         team_obj:taofa_id(),
    --         team_obj:have_combat_power()

    --     ))

    --     end
    -- end



    team_obj:delete()

end

--封印宝箱单元
function example:test_unsealing_unit()
    --说明：使用封印宝箱
    --参数1：nSysId
    --返回：bool
    --函数：unsealing_unit.use_box(int nSysId)
    --说明：领取封印宝箱奖历
    --参数1：nIdx
    --返回：bool
    --函数：unsealing_unit.get_box_reward(int nIdx)
    --说明：解封dataset
    --参数1：无
    --返回：int
    --函数：unsealing_unit.get_unsealing_data_set()
    --说明：解封DATA（ID 1 - 15）
    --参数1：nId
    --返回：int
    --函数：unsealing_unit.get_unsealing_data(int nId)
    --说明：取当前解封物品数量
    --参数1：无
    --返回：int
    --函数：unsealing_unit.get_unsealing_num()
    --说明：取解封槽数量
    --参数1：无
    --返回：int
    --函数：unsealing_unit.get_unsealing_solt_num()
    --说明：判断是否解封完成
    --参数1：nId
    --返回：bool
    --函数：unsealing_unit.is_finish_unsealing(int nId)
    --说明：取空于的解封ID
    --参数1：nItemSysId
    --返回：int
    --函数：unsealing_unit.get_empty_solt(int nItemSysId)
end

--地图单元
function example:test_map_unit()
    local map_obj = map_unit:new()
    -- map_unit.list(map_id) 0 当前地图
    local list = map_unit.list(0)
    for i = 1, #list
    do
        local obj = list[i]
        if map_obj:init(obj) then
            xxmsg(string.format('%X  %X %X  %s  %0.1f  %0.1f  %0.1f',
                    obj,
                    map_obj:id(),  -- 传送ID，，和环境里的Id不同
                    map_obj:sys_id(), -- 对话Id
                    map_obj:name(),
                    map_obj:cx(),
                    map_obj:cy(),
                    map_obj:cz()
            ))
        end
    end

    xxmsg('-----------------------------可瞬移地图-------------------------------')
    local teleport_map_num = map_unit.teleport_map_num()
    for i = 0, teleport_map_num - 1
    do
        xxmsg(string.format('%X   %X   %s',
                map_unit.get_teleport_mapid(i),
                map_unit.get_teleport_id(i),
                map_unit.get_teleport_name(i)

        ))
    end

--6052732   64   比奇城

    -- 使用瞬移卷传到NPC
    -- map_unit.teleport(id,false)
    -- 使用瞬移卷传到地图
    -- map_unit.teleport(id,true)
    -- 地图Id取瞬移Id
    -- map_unit.get_teleport_id_by_map_id(map_id)


    map_obj:delete()
    --说明：瞬移到NPC R8 2 R9 0  0 0
    --参数1：id
    --参数2：bToMap
    --返回：bool
    --函数：map_unit.teleport(int id, bool bToMap)
    --说明：地图Id取地图指针
    --参数1：nMapId
    --返回：int
    --函数：map_unit.get_map_ptr_byid(int nMapId)
    --说明：取可瞬移地图数量
    --参数1：无
    --返回：int
    --函数：map_unit.teleport_map_num()
    --说明：序号可瞬移地图ID
    --参数1：nIdx
    --返回：int
    --函数：map_unit.get_teleport_mapid(int nIdx)
    --说明：序号取传送地图名称
    --参数1：nIdx
    --返回：string
    --函数：map_unit.get_teleport_name(int nIdx)
    --说明：序号取瞬移ID
    --参数1：nIdx
    --返回：int
    --函数：map_unit.get_teleport_id(int nIdx)
    --说明：地图ID取瞬移ID
    --参数1：nMapId
    --返回：int
    --函数：map_unit.get_teleport_id_by_map_id(int nMapId)
    --说明：地图ID取瞬移ID
    --参数1：nMapId
    --返回：int
    --函数：map_unit.get_map_teleport_id(int nMapId)
    --说明：取地图NPC列表
    --参数1：nMapId
    --返回：int
    --函数：map_unit.list(int nMapId)
end

-- W币钱包单元
function example:test_wemix_unit()
    --说明：GetFTExchangeDataSet
    --参数1：无
    --返回：int
    --函数：wemix_unit.GetFTExchangeDataSet()
    --说明：读取绑定wemix钱包ID
    --参数1：无
    --返回：string
    --函数：wemix_unit.get_wemix_wallet()
    --说明：刷新钱包
    --参数1：无
    --返回：bool
    --函数：wemix_unit.refresh_wallet()
    --说明：代币数量
    --参数1：无
    --返回：int
    --函数：wemix_unit.get_draco_num()
    --说明：读取冶练和交换汇率
    --参数1：Exchange
    --返回：int
    --函数：wemix_unit.get_exchange_rate(bool Exchange)
    --说明：读取可冶练数量
    --参数1：无
    --返回：int
    --函数：wemix_unit.get_ft_limit_num()
    --说明：取治D币所需要黑铁
    --参数1：无
    --返回：int
    --函数：wemix_unit.get_make_draco_black_irorn_num()
    --说明：开始冶炼或交换
    --参数1：exchange
    --参数2：num
    --返回：bool
    --函数：wemix_unit.begin_exchange(bool exchange, int num)
    --说明：结束冶炼或交换
    --参数1：无
    --返回：bool
    --函数：wemix_unit.end_exchange()
    --说明：登陆状态 0 1(登陆成功) 2(登陆成功?) 3(准备跳转) 4(输入密码) 5(输入密码完成)
    --参数1：无
    --返回：int
    --函数：wemix_unit.get_status()
    --说明： 输入密码
    --参数1：password
    --返回：bool
    --函数：wemix_unit.input_wallet_pwd(string password)
end

-------------------------------------------------------------------------------------
-- 实例化新对象

function example.__tostring()
    return "mir4 example package"
end

example.__index = example

function example:new(args)
    local new = { }

    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end

    -- 设置元表
    return setmetatable(new, example)
end

-------------------------------------------------------------------------------------
-- 返回对象
return example:new()

-------------------------------------------------------------------------------------