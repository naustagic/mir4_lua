------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   transfer_ent
--- @describe: 转金模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class transfer_ent
local transfer_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'transfer_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = transfer_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local func = func
local game_unit = game_unit

---@type item_ent
local item_ent = import('game/entities/item_ent')
---@type redis_ent
local redis_ent = import('game/entities/redis_ent')
---@type user_ent
local user_ent = import('game/entities/user_ent')

local actor_unit = actor_unit
local local_player = local_player
local main_ctx = main_ctx
local auction_unit = auction_unit

------------------------------------------------------------------------------------
function transfer_ent.output(str)
    main_ctx:set_action(os.date("%H-%M") .. str)
end

function transfer_ent.server_name()
    local server_name_list = {
        ['ASIA011'] = '亚服跨区一',
        ['ASIA012'] = '亚服跨区一',
        ['ASIA013'] = '亚服跨区一',
        ['ASIA014'] = '亚服跨区一',
        ['ASIA021'] = '亚服跨区一',
        ['ASIA022'] = '亚服跨区一',
        ['ASIA023'] = '亚服跨区一',
        ['ASIA024'] = '亚服跨区一',
        ['ASIA031'] = '亚服跨区一',
        ['ASIA032'] = '亚服跨区一',
        ['ASIA033'] = '亚服跨区一',
        ['ASIA041'] = '亚服跨区一',
        ['ASIA042'] = '亚服跨区一',
        ['ASIA043'] = '亚服跨区一',


        ['ASIA051'] = '亚服跨区二',
        ['ASIA052'] = '亚服跨区二',
        ['ASIA053'] = '亚服跨区二',
        ['ASIA054'] = '亚服跨区二',
        ['ASIA061'] = '亚服跨区二',
        ['ASIA062'] = '亚服跨区二',
        ['ASIA063'] = '亚服跨区二',
        ['ASIA064'] = '亚服跨区二',
        ['ASIA071'] = '亚服跨区二',
        ['ASIA072'] = '亚服跨区二',
        ['ASIA073'] = '亚服跨区二',
        ['ASIA081'] = '亚服跨区二',
        ['ASIA082'] = '亚服跨区二',
        ['ASIA083'] = '亚服跨区二',

        ['ASIA311'] = '亚服跨区三',
        ['ASIA312'] = '亚服跨区三',
        ['ASIA313'] = '亚服跨区三',
        ['ASIA314'] = '亚服跨区三',
        ['ASIA321'] = '亚服跨区三',
        ['ASIA322'] = '亚服跨区三',
        ['ASIA323'] = '亚服跨区三',
        ['ASIA324'] = '亚服跨区三',
        ['ASIA331'] = '亚服跨区三',
        ['ASIA332'] = '亚服跨区三',
        ['ASIA333'] = '亚服跨区三',
        ['ASIA341'] = '亚服跨区三',
        ['ASIA342'] = '亚服跨区三',
        ['ASIA343'] = '亚服跨区三',


        ['ASIA351'] = '亚服跨区四',
        ['ASIA352'] = '亚服跨区四',
        ['ASIA353'] = '亚服跨区四',
        ['ASIA354'] = '亚服跨区四',
        ['ASIA361'] = '亚服跨区四',
        ['ASIA362'] = '亚服跨区四',
        ['ASIA363'] = '亚服跨区四',
        ['ASIA364'] = '亚服跨区四',
        ['ASIA371'] = '亚服跨区四',
        ['ASIA372'] = '亚服跨区四',
        ['ASIA373'] = '亚服跨区四',

        ['INMENA011'] = '泰服跨区一',
        ['INMENA012'] = '泰服跨区一',
        ['INMENA013'] = '泰服跨区一',
        ['INMENA014'] = '泰服跨区一',
        ['INMENA021'] = '泰服跨区一',
        ['INMENA022'] = '泰服跨区一',
        ['INMENA023'] = '泰服跨区一',
        ['INMENA024'] = '泰服跨区一',

        ['EU043'] = '欧服跨区一',
        ['EU011'] = '欧服跨区一',
        ['EU021'] = '欧服跨区一',
        ['EU041'] = '欧服跨区一',
        ['EU012'] = '欧服跨区一',
        ['EU013'] = '欧服跨区一',
        ['EU014'] = '欧服跨区一',
        ['EU022'] = '欧服跨区一',
        ['EU023'] = '欧服跨区一',
        ['EU024'] = '欧服跨区一',
        ['EU031'] = '欧服跨区一',
        ['EU032'] = '欧服跨区一',
        ['EU033'] = '欧服跨区一',
        ['EU034'] = '欧服跨区一',
        ['EU042'] = '欧服跨区一',

        ['SA011'] = '南美服跨区一',
        ['SA012'] = '南美服跨区一',
        ['SA013'] = '南美服跨区一',
        ['SA014'] = '南美服跨区一',
        ['SA021'] = '南美服跨区一',
        ['SA022'] = '南美服跨区一',
        ['SA023'] = '南美服跨区一',
        ['SA031'] = '南美服跨区一',
        ['SA032'] = '南美服跨区一',
        ['SA033'] = '南美服跨区一',
        ['SA034'] = '南美服跨区一',
        ['SA041'] = '南美服跨区一',
        ['SA043'] = '南美服跨区一',
        ['SA044'] = '南美服跨区一',

        ['SA051'] = '南美服跨区二',
        ['SA052'] = '南美服跨区二',
        ['SA053'] = '南美服跨区二',
        ['SA054'] = '南美服跨区二',
        ['SA061'] = '南美服跨区二',
        ['SA071'] = '南美服跨区二',
        ['SA072'] = '南美服跨区二',
        ['SA081'] = '南美服跨区二',
        ['SA082'] = '南美服跨区二',
        ['SA083'] = '南美服跨区二',
        ['SA062'] = '南美服跨区二',
        ['SA063'] = '南美服跨区二',
        ['SA064'] = '南美服跨区二',
        ['SA073'] = '南美服跨区二',

        ['NA011'] = '北美服跨区一',
        ['NA012'] = '北美服跨区一',
        ['NA021'] = '北美服跨区一',
        ['NA022'] = '北美服跨区一',
        ['NA023'] = '北美服跨区一',
        ['NA031'] = '北美服跨区一',
        ['NA032'] = '北美服跨区一',
        ['NA033'] = '北美服跨区一',
        ['NA034'] = '北美服跨区一',
        ['NA042'] = '北美服跨区一',
        ['NA043'] = '北美服跨区一',
        ['NA044'] = '北美服跨区一',
        ['NA013'] = '北美服跨区一',
        ['NA014'] = '北美服跨区一',

        ['NA051'] = '北美服跨区二',
        ['NA054'] = '北美服跨区二',
        ['NA064'] = '北美服跨区二',
        ['NA083'] = '北美服跨区二',
        ['NA052'] = '北美服跨区二',
        ['NA053'] = '北美服跨区二',
        ['NA061'] = '北美服跨区二',
        ['NA062'] = '北美服跨区二',
        ['NA071'] = '北美服跨区二',
        ['NA072'] = '北美服跨区二',
        ['NA073'] = '北美服跨区二',
        ['NA074'] = '北美服跨区二',
        ['NA081'] = '北美服跨区二',
        ['NA082'] = '北美服跨区二',
    }

    return server_name_list[main_ctx:c_server_name()] or main_ctx:c_server_name()
end

transfer_ent.PATH1 = '传奇4:内置数据:转金数据:服务器:' .. transfer_ent.server_name() .. ':仓库:' --仓库记录路径
transfer_ent.PATH2 = '传奇4:内置数据:转金数据:服务器:' .. transfer_ent.server_name() .. ':转移:' --转移记录路径
transfer_ent.PATH3 = '传奇4:内置数据:服务器:' .. transfer_ent.server_name() .. ':出售信息:'




-------------------------------------------------------------------------------------
-- 转移功能整合
transfer_ent.do_transfer_ent_for_warehouse = function()
    if local_player:level() < 40 then
        trace.output('角色低于40')
        decider.sleep(10000)
        return
    end

    if game_unit.is_sleep_mode() then
        game_unit.leave_sleep_mode()
        decider.sleep(1000)
    end

    if transfer_ent.is_warehouse_player() then
        local sale_money = actor_unit.get_cost_data(2)
        if sale_money >= 10000 then
            trace.output('收金号操作')
            this.refresh_upload_warehouse_in_redis()
            local need_num = transfer_ent.do_exchanges_shelves_item()
            -- 下架物品
            transfer_ent.do_up_down_exchanges_item()
            -- 更新数据
            transfer_ent.up_data()

            -- 物品回购
            transfer_ent.buy_item_in_redis()

            local auction_item = item_ent.get_can_auction_item('高级钢铁')
            local have_num = auction_item.num or 0
            have_num = have_num or 0
            need_num = need_num or 0
            if have_num < need_num then
                -- 拍卖行购买
                transfer_ent.buy_item_num()
            end
            -- 金币结算
            transfer_ent.settlement()
        else
            trace.output('收金号铜钱过低[' .. sale_money .. ']')
        end
    end


end



-------------------------------------------------------------------------------------
-- [条件]判断是否为收金号
-- 返回：bool
transfer_ent.is_warehouse_player = function()
    local my_name = local_player:name()
    local warehouse = user_ent['收金号']
    warehouse = func.split(warehouse, '|')
    for k, v in pairs(warehouse) do
        --角色名与用户设置收金号名相同判断为收金号
        if v == my_name then
            return true
        end
        ----ip与设置ip相同判断为收金号
        --if v == main_ctx:get_local_ip() then
        --    return true
        --end
    end
    return false
end

--收金号操作-----------------------------------收金号操作----------------------------------------------------收金号操作
-------------------------------------------------------------------------------------
-- 收金号 刷新仓库记录(如果是收金号 则调用)[收金号]
transfer_ent.refresh_upload_warehouse_in_redis = function()
    --收金号 清除在转金的记录
    transfer_ent.warehouse_clear_transfer_gold_in_redis()
    local name = local_player:name()                -- 角色名称
    local ret = {}                                  -- 保存从redis读取到的数据
    local can_idx = 0                               -- 记录所在位置
    local out_time = 900                            -- 活跃超时时间  记录仓库名 是否在活跃超时  默认15分钟
    local is_my_cord = false                        -- 记录是否已存在
    local count = 30     -- 转金号数
    --向redis读取仓库记录
    for i = 1, count do
        local ret_client = redis_ent.get_json_data(transfer_ent.PATH1 .. i)
        table.insert(ret, ret_client)
    end
    --查询是否存在记录
    for i = 1, #ret do
        local ret_client = ret[i]
        if table.is_empty(ret_client) then
            if can_idx == 0 then
                can_idx = i
            end
        else
            if ret_client['收金号'] == name then
                can_idx = i
                is_my_cord = true
                break
            end
        end
    end
    --查询是否存在超时记录
    if not is_my_cord and can_idx == 0 then
        for i = 1, #ret do
            local ret_client = ret[i]
            if not table.is_empty(ret_client) then
                local brisk_time = ret_client['活跃时间']
                if type(brisk_time) == 'number' then
                    if os.time() - brisk_time > out_time then
                        can_idx = i
                        break
                    end
                end
            end
        end
    end
    --设置收金默认记录
    if can_idx > 0 then
        local PATH = transfer_ent.PATH1 .. can_idx
        local data = {}
        data['活跃时间'] = os.time()
        data['收金号'] = name
        redis_ent.set_json_data(PATH, data)
    end
end

-------------------------------------------------------------------------------------
-- 收金号 清除在转金的记录
transfer_ent.warehouse_clear_transfer_gold_in_redis = function()
    local can_idx_name, can_idx2, data_r, is_my_cord = transfer_ent.refresh_upload_transfer_gold_in_redis(true)
    if is_my_cord then
        redis_ent.set_json_data(transfer_ent.PATH2 .. can_idx_name .. ':' .. can_idx2, '')
    end
end

-------------------------------------------------------------------------------------
-- 获取需要转金的记录 data (收金号上架时使用)
transfer_ent.get_need_transfer_gold_data_in_redis = function(is_only_status)
    local ret = transfer_ent.get_transfer_data_by_warehouse_name_in_redis()
    local return_ret = {} --保存需要上架的数据
    for i = 1, #ret do
        local ret_client = ret[i]
        local name = ret_client['转金号']
        local n_transfer_gold = ret_client['可转金币']
        if name and name ~= '' then
            if n_transfer_gold and n_transfer_gold >= 50 then
                table.insert(return_ret, ret_client)
            end
        end
    end
    return return_ret
end

-------------------------------------------------------------------------------------
-- 交易行上架物品[收金号]
transfer_ent.do_exchanges_shelves_item = function()
    local need_num = 0
    -- 获取存在需要转金的记录( 不存在出售ID的数据  和存在 出售状态为0的数据)
    local data = transfer_ent.get_need_transfer_gold_data_in_redis()

    if table.is_empty(data) then
        return need_num
    end
    local ret_sale = this.get_sell_list()
    local can_put_away = 30 - #ret_sale --可上架的物品数
    if can_put_away == 0 then
        return need_num
    end
    local is_up_num = 0 --保存已上架次数
    for i = 1, #data do
        if is_up_num >= can_put_away then
            break
        end
        local data_r = data[i]
        local c_gold = data_r['可转金币']
        local is_has_up = true -- 是否上架
        --检测当前金币对应的交易行 是否存在上架未使用的物品
        for j = 1, #ret_sale do
            if ret_sale[j].price == c_gold then
                if ret_sale[j].num == data_r['物品数量'] then
                    is_has_up = false
                    break
                end
            end
        end
        if is_has_up then
            need_num = transfer_ent.do_exchanges_shelves_item_3(c_gold, data_r, data) + need_num
            is_up_num = is_up_num + 1

        end
    end
    return need_num
end

-- 更新数据
function transfer_ent.up_data()
    local data = transfer_ent.get_transfer_data_by_warehouse_name_in_redis()
    if table.is_empty(data) then
        return false
    end
    local ret_sale = this.get_sell_list()

    if table.is_empty(ret_sale) then
        return false
    end
    for i = 1, #data do
        local data_r = data[i]
        if not table.is_empty(data_r) and data_r['可转金币'] then
            local c_gold = data_r['可转金币']
            --检测当前金币对应的交易行 是否存在上架未使用的物品
            for j = 1, #ret_sale do
                if ret_sale[j].price == c_gold then
                    if tonumber(ret_sale[j].num) == tonumber(data_r['物品数量']) then
                        local can_idx2 = data_r['can_idx2']
                        local can_idx_name = data_r['warehouse_name']
                        local data_1 = data_r
                        data_1['物品状态'] = ret_sale[j].status
                        redis_ent.set_json_data(this.PATH2 .. can_idx_name .. ':' .. can_idx2, data_1)
                    end
                end
            end
        end
    end
end



-------------------------------------------------------------------------------------
-- 执行上架物品[收金号]
-- @tparam     number               c_gold              上架的金币数
-- @tparam     table                data_r              当前需上架目标
-- @tparam     table                data                所有需上架目标记录
-------------------------------------------------------------------------------------
transfer_ent.do_exchanges_shelves_item_3 = function(c_gold, data_r, data)
    local need_monney = c_gold * 10
    if actor_unit.get_cost_data(2) < need_monney then
        return need_monney
    end
    local need_num = c_gold / 0.025
    -- 获取可上架的装备
    local item_info = item_ent.get_can_auction_item('高级钢铁')
    -- 存在可上架的物品
    if not table.is_empty(item_info) and item_info.num >= need_num then
        local sell_num = need_num
        local money = actor_unit.get_cost_data(2)
        local str = '上架[' .. item_info.name .. ']' .. sell_num .. '个,' .. c_gold .. '金'
        auction_unit.sell_item(item_info.sys_id, sell_num, c_gold)
        decider.sleep(2000)
        for i = 1, 10 do
            trace.output(str .. '--' .. i .. '/20')
            if money > actor_unit.get_cost_data(2) then
                transfer_ent.write_shelves_data(data, data_r, c_gold, item_info.id, sell_num)
                break
            end
            decider.sleep(2000)
        end
        need_num = 0
    else
        xxmsg('最少上架数量' .. need_num)
        need_num = c_gold / 0.025
        trace.output('没有可上架的物品')
        decider.sleep(3000)
    end
    return need_num
end

-------------------------------------------------------------------------------------
-- 筛选最佳的上架物品
transfer_ent.get_shelves_item_info = function(sell_num)
    local can_shelves = {}
    local item_ = item_ent.get_can_auction_item('高级钢铁')
    if not table.is_empty(item_) and item_.num >= sell_num then
        can_shelves = item_
    end
    -- 返回可出售信息
    return can_shelves
end

-------------------------------------------------------------------------------------
-- 记录上架的数据[收金号]
-- @tparam     table                data                所有需上架目标记录
-- @tparam     table                data_1              当前需上架目标
-- @tparam     number               sell_price          出售价格
-- @tparam     number               item_type           物品类型[0非装备 1装备]
-- @tparam     number               item_level          装备等级
-------------------------------------------------------------------------------------
transfer_ent.write_shelves_data = function(data, data_1, sell_price, item_res_id, sell_num)
    local ret_sale = this.get_sell_list()
    for i = 1, #ret_sale do
        if sell_price == ret_sale[i].price and ret_sale[i].num == sell_num then
            local can_idx2 = data_1['can_idx2']
            local can_idx_name = data_1['warehouse_name']
            --物品出售状态 0 1 3(上架中 1 出售中  3 已出售)
            if ret_sale[i].status == 0 or ret_sale[i].status == 1 then
                data_1['物品名字'] = ret_sale[i].name
                data_1['物品ID'] = tostring(item_res_id)
                data_1['物品总价'] = ret_sale[i].price
                data_1['物品数量'] = ret_sale[i].num
                data_1['物品状态'] = ret_sale[i].status
                redis_ent.set_json_data(this.PATH2 .. can_idx_name .. ':' .. can_idx2, data_1)
                break
            elseif ret_sale[i].status == 3 then
                auction_unit.settlement()
                trace.output('结算' .. ret_sale[i].name)
                decider.sleep(2000)
            else
                xxmsg('1.下架' .. ret_sale[i].status)
                auction_unit.cancel_sell(ret_sale[i].id)
                trace.output('下架' .. ret_sale[i].name)
                decider.sleep(2000)
            end
        end
    end
end

-------------------------------------------------------------------------------------
-- 交易行下架物品[收金号]
transfer_ent.do_up_down_exchanges_item = function()
    -- 获取存在需要转金的记录( 不存在出售ID的数据  和存在 出售状态为0的数据)
    local data = transfer_ent.get_need_transfer_gold_data_in_redis()
    if table.is_empty(data) then
        return false
    end
    local ret_sale = this.get_sell_list()
    local ret = {}
    for j = 1, #ret_sale do
        local is_up_down = true
        for i = 1, #data do

            if data[i]['物品数量'] == ret_sale[j].num and data[i]['可转金币'] == ret_sale[j].price then
                is_up_down = false
                break
            end
        end
        if is_up_down then
            table.insert(ret, ret_sale[j].id)
        end
    end
    for i = 1, #ret do

        auction_unit.cancel_sell(ret[i])
        decider.sleep(2000)
    end
end


--转金号操作-----------------------------------转金号操作----------------------------------------------------转金号操作
-------------------------------------------------------------------------------------
-- 交易行购买物品[转金号]
transfer_ent.do_exchanges_buy_item_for_transfer = function()
    --当前上架仓库名,上架记录位置,当前位置所有数据,是否存在记录
    local can_idx_name, can_idx2, data_r, is_my_cord = transfer_ent.refresh_upload_transfer_gold_in_redis()
    local gold = transfer_ent.get_can_transfer_gold()
    local is_clear = false
    if gold < transfer_ent.get_trigger_min_gold() then
        if can_idx2 > 0 and can_idx_name ~= '' then
            --清空转金记录
            is_clear = true
            xxmsg('没有可转的金币')
            -- show_str('没有可转的金币.')
        end
    end
    if not table.is_empty(data_r) and not is_clear then
        local res_id = tonumber(data_r['物品ID'])
        if res_id ~= 0 then
            local item_status = tonumber(data_r['物品状态'])
            if item_status == 1 then
                --  show_str('已上架物品,执行购买')
                -- 没有查询到交易物品  也删除上架的数据
                local num = tonumber(data_r['物品数量'])
                local can_gold = tonumber(data_r['可转金币'])
                if transfer_ent.do_exchanges_buy_goods_by_resid_and_sale_player_id(res_id, num, can_gold) then
                    is_clear = true

                end
            else
            --    xxmsg('已上架,等待交易行显示')
                ---     show_str('已上架,等待交易行显示')
            end
        else
         --   xxmsg('仓库暂未上架物品')
            --   show_str('仓库暂未上架物品')
        end
    elseif gold > transfer_ent.get_trigger_min_gold() then
        --xxmsg('未获取到仓库号')
        --show_str('未获取到仓库号')
    end
    if is_clear and is_my_cord then
        redis_ent.set_json_data(transfer_ent.PATH2 .. can_idx_name .. ':' .. can_idx2, '')
    end
    --if gold < transfer_ent.get_trigger_min_gold() then
    --show_str('交易完成')
    --if redis['交易后下线'] == 1 and not is_terminated() then
    --    main_ctx:set_ex_state(1)
    --    sleep(3000)
    --    main_ctx:end_game()
    --end
    --end
end


-------------------------------------------------------------------------------------
-- 出金号 刷新转金位置 记录[转金号]
-- 返回：当前上架仓库名,上架记录位置,当前位置所有数据,是否存在记录
transfer_ent.refresh_upload_transfer_gold_in_redis = function(is_clear)
    local name = local_player:name()                --角色名称
    local ret = {}                                  --保存从redis读取到的数据
    local ret2 = {}                                 --保存所有活跃仓库  所有上架记录数
    local can_idx_name = ''                         --记录 仓库
    local can_idx2 = 0                              --记录指定仓库名下所在位置
    local out_time = 1800                           --活跃超时时间 当前仓库名 转金记录 最大超时时间  默认 半小时
    local is_my_cord = false                        --记录是否已存在
    local count = 30     --收金号数
    local gold = transfer_ent.get_can_transfer_gold() --读取当前可转金币数
    --保存所有 的仓库数据 到ret
    for i = 1, count do
        local ret_client = redis_ent.get_json_data(transfer_ent.PATH1 .. i)
        table.insert(ret, ret_client)
    end
    --保存 所有活跃的仓库  仓库 名下对应 转金记录 数据 到 ret2
    for i = 1, #ret do
        local ret_client = ret[i]
        if not table.is_empty(ret_client) then
            local brisk_time = ret_client['活跃时间']
            if brisk_time ~= nil then
                if os.time() - brisk_time < out_time then
                    local warehouse_name = ret_client['收金号']
                    local ret_client1 = transfer_ent.get_transfer_data_by_warehouse_name_in_redis(warehouse_name)
                    for j = 1, #ret_client1 do
                        ret_client1[j].can_idx_name = warehouse_name
                        table.insert(ret2, ret_client1[j])
                    end
                end
            end
        end
    end
    --读取 本角色  可刷新的位置
    for i = 1, #ret2 do
        local ret_client1 = ret2[i]
        if ret_client1['转金号'] == nil then
            if can_idx2 == 0 then
                can_idx_name = ret_client1.can_idx_name
                can_idx2 = ret_client1.can_idx2 --can_idx2
            end
        else
            if ret_client1['转金号'] == name then
                can_idx_name = ret_client1.can_idx_name
                can_idx2 = ret_client1.can_idx2
                is_my_cord = true
                break
            end
        end
    end
    --读取本角色可刷新的位置
    if not is_my_cord and can_idx2 == 0 then
        for i = 1, #ret2 do
            local ret_client1 = ret2[i]
            if ret_client1['转金号'] ~= nil then
                local brisk_time = ret_client1['活跃时间']
                if type(brisk_time) == 'number' then
                    if os.time() - brisk_time > out_time then
                        can_idx_name = ret_client1.can_idx_name
                        can_idx2 = ret_client1.can_idx2
                        break
                    end
                end
            end
        end
    end
    local data_r = {} --当前位置所有key 数据
    if can_idx2 > 0 and can_idx_name ~= '' and gold >= transfer_ent.get_trigger_min_gold() and not is_clear then
        local data = {}
        if is_my_cord then
            data = redis_ent.get_json_data(transfer_ent.PATH2 .. can_idx_name .. ':' .. can_idx2)
            if data['物品数量'] == 0 or data['可转金币'] == 0 then
                data['可转金币'] = gold
            end
        else
            data['转金号'] = name
            data['物品数量'] = 0
            data['物品ID'] = 0
            data['物品状态'] = 0
            data['可转金币'] = gold
        end
        data['活跃时间'] = os.time()
        data_r = data
        redis_ent.set_json_data(transfer_ent.PATH2 .. can_idx_name .. ':' .. can_idx2, data)
    end
    return can_idx_name, can_idx2, data_r, is_my_cord
end

-------------------------------------------------------------------------------------
-- 获取可转金币[转金号]
transfer_ent.get_can_transfer_gold = function()
    return actor_unit.get_cost_data(5)
end

-------------------------------------------------------------------------------------
-- 获取最低转移金币[转金号]
transfer_ent.get_trigger_min_gold = function()
    return 50
end

-------------------------------------------------------------------------------------
-- 获取指定仓库名 转金记录数据(此命令 可供收金号读取)
-- 参数1：仓库收金名
transfer_ent.get_transfer_data_by_warehouse_name_in_redis = function(warehouse_name)
    local ret = {} --保存redis读取的数据
    warehouse_name = warehouse_name or local_player:name() --读取指定名 或本身 名下 转金总记录
    for i = 1, 30 do
        local ret_client = redis_ent.get_json_data(transfer_ent.PATH2 .. warehouse_name .. ':' .. i)
        ret_client.can_idx2 = i --当前存在记录
        ret_client.warehouse_name = warehouse_name
        table.insert(ret, ret_client)
    end

    return ret
end

---------------------------------------------------------------------------------------------------------
--通过数量、价格为参数购买指定物品
--参数1：物品资源ID
--参数2：购买数量
--参数3：购买金币
transfer_ent.do_exchanges_buy_goods_by_resid_and_sale_player_id = function(res_id, num, can_gold)
    local ret = false
    -- 判断是否获取到资源id
    if not res_id or tonumber(res_id) == 0 then
        xxmsg('red_id为0')
        return ret
    end
    -- 刷新物品信息
    auction_unit.refresh_item_detail(tonumber(res_id))  -- 查讯的是哪个钱币
    decider.sleep(1500)
    local auction_obj = auction_unit:new()
    local item_list = auction_unit.item_list()
    for i = 1, #item_list do
        local obj = item_list[i]
        if auction_obj:init(obj, true) then
            -- 判断物品价格及数量是否对应
            if num == auction_obj:num() and auction_obj:price() == can_gold then
                -- 判断金币是否足够
                if actor_unit.get_cost_data(5) >= can_gold then
                    -- 获取金币数量
                    local gold = actor_unit.get_cost_data(5)
                    trace.output('转金购买' .. auction_obj:name())
                    decider.sleep(1000)
                    -- 购买物品
                    auction_unit.buy_item(auction_obj:buy_id())
                    decider.sleep(3000)
                    -- 通过金币变化判断是否购买成功
                    for ii = 1, 300 do
                        if actor_unit.get_cost_data(5) ~= gold then
                            ret = true
                            break
                        end
                        trace.output('[' .. ii .. ']正在购买' .. auction_obj:name())
                        decider.sleep(100)
                    end
                else
                    trace.output('金币不够')
                end
                break
            end
        end
    end
    auction_obj:delete()
    return ret
end

------------------------------------------------------------------------------------
-- [读取] 获取正在出售的信息
--
-- @treturn     t
-- @tfield[t]    integer    obj                 物品实例对象
-- @tfield[t]    integer    id                  物品ID
-- @tfield[t]    integer    sale_player_id      卖家Id
-- @tfield[t]    integer    res_ptr             物品资源指针
-- @tfield[t]    integer    total_price         总价
-- @tfield[t]    integer    num                 物品数量
-- @tfield[t]    integer    price               单价
-- @tfield[t]    integer    expire_time         到期时间
-- @usage
-- local info = exchange_ent.get_sell_list()
-- print_r(info)
------------------------------------------------------------------------------------
transfer_ent.get_sell_list = function()
    local ret = {}
    -- 自己出售列表
    local list = auction_unit.get_auction_sell_num()
    for i = 0, list - 1 do
        local tmp_t = {
            id = auction_unit.get_sell_id(i), --id
            price = auction_unit.get_sell_price(i), -- 总价
            num = auction_unit.get_item_num(i), --数量
            status = auction_unit.get_item_sell_status(i), -- 0 等待出售
            name = auction_unit.get_sell_item_name(i) --名字
        }
        table.insert(ret, tmp_t)
    end
    return ret
end








-------------------------------------------------------------------------------------
-- 转移装备[转金号]
transfer_ent.transfer_item_to_return = function()
    if true then
        return false
    end
    local item_info = item_ent.get_can_auction_item('高级钢铁')
    if not table.is_empty(item_info) and item_info.num and item_info.num >= 1 then
        if transfer_ent.get_item_info_up_item(item_info) then
            transfer_ent.set_sale_record_in_redis_by_sale_info(item_info.name, math.floor(0.00025 * item_info.num), item_info.num, item_info.id)
        end
    end

    this.refresh_sale_record()
end

------------------------------------------------------------------------------------
-- [行为] 通过物品信息上架物品
--
-- @tparam      table       item_info       物品信息
-- @tparam      boolean     is_equip        是否装备
-- @tparam      integer     level           物品等级
-- @treturn     boolean
-- @usage
-- exchange_ent.get_item_info_up_item(物品信息,是否装备,物品等级)
------------------------------------------------------------------------------------
function transfer_ent.get_item_info_up_item(item_info, money)
    local ret_b = false
    local price_t = math.floor(0.00025 * item_info.num)
    if price_t >= 10 then
        auction_unit.sell_item(item_info.sys_id, item_info.num, price_t)-- 上架
        decider.sleep(1000)
        for i = 1, 8 do
            decider.sleep(2000)
            local new_item_info = item_ent.get_can_auction_item(item_info.name)
            if not new_item_info.num or new_item_info.num <= 0 then
                ret_b = true
                break
            end
        end
    end
    return ret_b
end

------------------------------------------------------------------------------------
-- 刷新指定物品已记录上架记录[转金号]
--
transfer_ent.set_sale_record_in_redis_by_sale_info = function(name, price, num, res_id)
    local my_name = local_player:name()
    -- 获取上架类别记录路径
    local path = this.PATH3 .. '上架:上架数据'
    -- 获取已上架数据
    local my_sell_list = this.get_sell_list()
    -- 遍历上架数据
    for i = 1, #my_sell_list do
        if my_sell_list[i].price == price and my_sell_list[i].num == num and my_sell_list[i].name == name then
            local idx, idx2, data, is_exist = redis_ent.get_idx_in_redis_table_list_path(tostring(my_sell_list[i].id), 'sale_id', path, 24 * 3600, 30, 30)
            if not is_exist then
                -- 需要记录的数据
                local data_w = {
                    -- 出售ID
                    sale_id = tostring(my_sell_list[i].id),
                    -- 出售金币
                    gold = my_sell_list[i].price,
                    -- 出售人
                    sale_name = local_player:name(),
                    -- 记录时间
                    status = my_sell_list[i].status,
                    -- 物品资源id
                    res_id = res_id,
                    -- 物品名字
                    equip_name = my_sell_list[i].name,
                    -- 数量
                    num = my_sell_list[i].num
                }
                redis_ent.set_data_in_redis_table_list_path(data_w, tostring(my_sell_list[i].id), 'sale_id', path, 24 * 3600, 30, 30)
                break
            end
        end
    end
end

transfer_ent.refresh_sale_record = function()
    -- 获取上架类别记录路径
    local path = transfer_ent.PATH3 .. '上架:上架数据'
    -- 获取已上架数据
    local my_sell_list = this.get_sell_list()
    -- 遍历上架数据
    for i = 1, #my_sell_list do
        local idx, idx2, data, is_exist = redis_ent.get_idx_in_redis_table_list_path(tostring(my_sell_list[i].id), 'sale_id', path, 24 * 3600, 30, 30)
        if is_exist then
            if data[idx2] and data[idx2].status ~= my_sell_list[i].status then
                data[idx2].status = my_sell_list[i].status
                redis_ent.set_data_in_redis_table_list_path(data[idx2], tostring(my_sell_list[i].id), 'sale_id', path, 24 * 3600, 30, 30)
            end
        end
    end
    this.clear_sale_record_in_redis(my_sell_list)
end

------------------------------------------------------------------------------------
-- 清除出售的记录[转金号]
transfer_ent.clear_sale_record_in_redis = function(my_sell_list)
    local name = local_player:name()
    local path_list = {
        this.PATH3 .. '上架:上架数据',
    }
    -- 保存标记是否结算
    local is_account = false
    for _, v_path in pairs(path_list) do
        -- 移除数据
        for i = 1, 30 do
            local path = v_path .. i
            local data = redis_ent.get_json_data(path)
            local is_update = false
            for j = #data, 1, -1 do
                if data[j].sale_name == name then
                    is_account = true
                    local is_del = true
                    -- 对比出售ID 是否不存在
                    for _, v in pairs(my_sell_list) do
                        if v.id == tonumber(data[j].sale_id) then
                            is_del = false
                            break
                        end
                    end
                    -- 需要移除记录
                    if is_del then
                        is_update = true
                        table.remove(data, j)
                    end
                end
            end
            if is_update then
                redis_ent.set_json_data(path, data)
            end
        end
    end
    -- 结算
    if is_account then
        this.settlement()
    end
end



------------------------------------------------------------------------------------
-- 购买上架的物品【redis记录】[收金号]
transfer_ent.buy_item_in_redis = function()
    if true then
        return false
    end
    -- 获取上架记录路径
    local v_path = this.PATH3 .. '上架:上架数据'
    -- 保存可购买列表
    local can_buy_data = {}
    -- 保存需要装备的金币
    local need_good = 0
    -- 保存累计加入购买的数
    local buy_count = 0
    -- 自身名称
    local my_name = local_player:name()
    for i = 1, 30 do
        -- 需要装备大于身上金币数时退出
        if need_good > actor_unit.get_cost_data(5) then
            break
        end
        -- 每次购买量不超过30个
        if buy_count > 30 then
            break
        end
        local path = v_path .. i
        local data = redis_ent.get_json_data(path)
        if not table.is_empty(data) then
            for k, v in pairs(data) do
                if v.status and v.status == 1 then
                    if v.sale_name ~= my_name then
                        local q_gold = actor_unit.get_cost_data(5)
                        need_good = need_good + v.gold
                        if q_gold >= need_good then
                            can_buy_data[v.sale_id] = can_buy_data[v.sale_id] or v
                            buy_count = buy_count + 1
                        end
                        break
                    end
                end
            end
        end
    end
    -- 获取可购买的数据
    for k, v in pairs(can_buy_data) do
        local res_id = 0
        transfer_ent.do_exchanges_buy_goods_by_resid_and_sale_player_id(v.res_id, v.num, v.gold)
        decider.sleep(2000)
    end
end

function transfer_ent.buy_item_num()
    auction_unit.refresh_item_detail(tonumber(0x35C4F4EA))  -- 高级钢铁
    decider.sleep(1500)
    local min_price = transfer_ent.get_price()

    if min_price == 0 then
        return
    end
    local auction_obj = auction_unit:new()
    local item_list = auction_unit.item_list()
    for i = 1, #item_list do
        local obj = item_list[i]
        if auction_obj:init(obj, true) then
            local item_num = auction_obj:num()
            local price = auction_obj:price()
            if min_price >= price / item_num and price < 500 then
                if actor_unit.get_cost_data(5) >= price then
                    -- 获取金币数量
                    local gold = actor_unit.get_cost_data(5)
                    trace.output('转金大号购买高级钢铁')
                    decider.sleep(1000)
                    -- 购买物品
                    auction_unit.buy_item(auction_obj:buy_id())
                    decider.sleep(3000)
                    -- 通过金币变化判断是否购买成功
                    for ii = 1, 300 do
                        if actor_unit.get_cost_data(5) ~= gold then
                            break
                        end
                        trace.output('[' .. ii .. ']正在购买' .. auction_obj:name())
                        decider.sleep(100)
                    end
                    break
                end
            end
        end
    end
    auction_obj:delete()
end

function transfer_ent.settlement()
    auction_unit.refresh_sell_item()--刷新出售物品
    decider.sleep(2000)
    local num = auction_unit.get_auction_sell_num()--出售物品总数量
    for i = 0, num - 1 do
        if auction_unit.can_settlement(i) and auction_unit.get_item_sell_status(i) == 3 then
            auction_unit.settlement()-- 结算
            decider.sleep(2000)
        end
    end
end

function transfer_ent.get_price()
    local min_price = 0
    local auction_obj = auction_unit:new()
    local item_list = auction_unit.item_list()
    for i = 1, #item_list do
        local obj = item_list[i]
        if auction_obj:init(obj, true) then
            local price = auction_obj:price() / auction_obj:num()
            if min_price == 0 then
                min_price = price
            elseif min_price > price then
                min_price = price
            end
        end
    end
    auction_obj:delete()

    if min_price >= 0.0005 then
        min_price = 0
    end
    return min_price
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function transfer_ent.__tostring()
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
function transfer_ent.__newindex(t, k, v)
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
transfer_ent.__index = transfer_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function transfer_ent:new(args)
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
    return setmetatable(new, transfer_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return transfer_ent:new()

-------------------------------------------------------------------------------------
