-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-16
-- @module:   user_res
-- @describe: 用户设置用到的资源
-- @version:  v1.0


-------------------------------------------------------------------------------------
-- 任务模块资源
---@class user_res
local user_res = {
    GLOBAL_SET = {
        { session = '基本设置', key = '主线开关', value = 0 },
        { session = '基本设置', key = '采集开关', value = 0 },
        { session = '基本设置', key = '主线等级', value = 40 },
        { session = '基本设置', key = '采集物品', value = '黑铁' },
        { session = '基本设置', key = '统计物品', value = '高级武魂' },
        { session = '基本设置', key = '采集地图分配', value = '沃玛森林_1|银杏谷_1|比奇县_1|半兽古墓1层_1' },
    }
}

local this = user_res

return user_res
