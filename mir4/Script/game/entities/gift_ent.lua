------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   gift_ent
--- @describe: 通用模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class gift_ent
local gift_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'gift_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = gift_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local sign_unit = sign_unit
local main_ctx = main_ctx
local local_player = local_player
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function gift_ent.super_preload()
    this.wi_daily_work = decider.run_interval_wrapper('领取每日课题', this.daily_work, 1000 * 60 * 60 * 1)
    this.wi_sign = decider.run_interval_wrapper('领取成就', this.sign, 1000 * 60 * 60 * 1)
    this.wi_achievement = decider.run_interval_wrapper('每日签到', this.achievement, 1000 * 60 * 60 * 5)
end


-- 领取每日课题
function gift_ent.daily_work()
    if sign_unit.can_daily_work() then
        sign_unit.daily_work_receive_all()
        trace.output('[课题] - 一键领取所有课题')
    end
    local daily_work_list = {
        ['每日课题五次奖历'] = { idx = 1 },
        ['每日课题十次奖历'] = { idx = 2 },
    }
    for i, v in pairs(daily_work_list) do
        --0 未完成， 1 完成可领取 2 已领取
        if sign_unit.get_dailyword_reward_status(v.idx) == 1 then
            trace.output('[课题] - 领取>'..i)
            sign_unit.daily_work_plus_reward(v.idx)
            decider.sleep(3000)
        end
    end
end

-- 领取成就
function gift_ent.sign()
    if sign_unit.can_achievement_receive() then
        sign_unit.achievement_receive_all()
        trace.output('[成就] - 一键领取所有成就')
        decider.sleep(3000)
    end
end

-- 签到
function gift_ent.achievement()
    local sign_list = {
        ['成长支援'] = { id = 0x404 },


        ['奇缘达成'] = { id = 0x7D1 },
        ['等级达成'] = { id = 0x7D2 },
        ['七日签到'] = { id = 0x401 },
    }

    for i, v in pairs(sign_list) do
        if sign_unit.can_sign(v.id) then
            sign_unit.sign(v.id)
            trace.output('[签到] - 领取' .. i)
            decider.sleep(2000)
        end
    end
    -- 收集肖像画
    -- 神龙的祝福
    -- 七日签到
    -- 十四日签到
    -- 大师聚会
    -- 月卡
    -- 招财猫
    -- 大师试炼
    -- 等级达成
    -- 奇缘达成

end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function gift_ent.__tostring()
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
function gift_ent.__newindex(t, k, v)
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
gift_ent.__index = gift_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function gift_ent:new(args)
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
    return setmetatable(new, gift_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return gift_ent:new()

-------------------------------------------------------------------------------------
