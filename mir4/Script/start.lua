-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   admin
-- @email:    88888@qq.com
-- @date:     2023-02-14
-- @module:   start
-- @describe: 入口文件
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
local import = import

local is_exit = is_exit
local sleep = sleep
-- 引入管理对象
local core = import('base/core')

-------------------------------------------------------------------------------------
-- LUA入口函数(正式 CTRL+F5)
function main()

    -- 预载处理
    core.preload()
    -- 主循环
    while not is_exit()
    do
        core.entry() -- 入口调用
        sleep(1000)
    end
    -- 卸载处理
    core.unload()

end

function main_test()
    local module_list = {
    	import('game/modules/test')
    }
    core.set_module_list(module_list)
    core.entry() -- 入口调用
    local str = string.format('%s：测试脚本已停止',os.date("%H-%M"))
    main_ctx:set_action(str)

end
