------------------------------------------------------------------------------------
-- base/core.lua
--
-- 本模块是整个框架的核心，整个脚本的入口，管理和加载所有模块、各种回调函数的调用等。
--
-- @module      core
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
------------------------------------------------------------------------------------

-- 模块定义
local core = {
   -- 模块版本 (主版本.次版本.修订版本)
   VERSION                   = '1.0.0',
   -- 作者备注 (更新日期 - 更新内容简述)
   AUTHOR_NOTE               = '2023-03-22 - Initial release',
   -- 模块名称
   MODULE_NAME               = 'core module',
   -- 只读模式
   READ_ONLY                 = false,
}

-- 实例对象
local this = core

-------------------------------------------------------------------------------------
-- 初始化其它成员

-- 轮循计时器ID
this.CIRCULAR_TIMER_ID = 88888
-- 轮循间隔10秒
this.CIRCULAR_TIMER_DELAY = 10000

-------------------------------------------------------------------------------------
-- 导入所有模块

-- 全局设置
_G.settings = import('base/settings')
-- 杂项模块
_G.utils = import('base/utils')
-- 日志模块
_G.trace = import('base/trace')
-- 决策模块
_G.decider = import('base/decider')
_G.common  = import('game/entities/common')
-- 决策模块
_G.func = import('base/func')


-- 模块列表
core.module_list = import('game/modules')

-------------------------------------------------------------------------------------
-- 优化列表

local os = os
local math = math
local xpcall = xpcall
local sleep = sleep
local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable
local is_working = is_working
local main_ctx = main_ctx
local killtimer = killtimer
local settings = settings
local trace = trace
local decider = decider
local rawset = rawset
local error = error

-------------------------------------------------------------------------------------
-- 预载处理(重载脚本)
-------------------------------------------------------------------------------------
function core.super_preload()
   -- 关闭自动重启
    main_ctx:auto_restart(false)
end

-------------------------------------------------------------------------------------
-- 设置运行模块
-------------------------------------------------------------------------------------
function core.set_module_list(set_list)
   if type(set_list) == 'table' then
      this.module_list = set_list
   end
end

-------------------------------------------------------------------------------------
-- 预载处理(脚本运行)
-------------------------------------------------------------------------------------
function core.preload()
   -- 这个必须保留
   sleep(100)
   -- 开启自动重启
   main_ctx:auto_restart(true)
   -- 初始化所有模块
   for k, v in ipairs(this.module_list) do
      -- 调用功能
      if v.preload then
         -- v.preload()
         xpcall(v.preload, this.error_handler)
      end
   end
   -- 安装轮循计时器
   -- settimer(this.CIRCULAR_TIMER_ID, this.CIRCULAR_TIMER_DELAY)
end

-------------------------------------------------------------------------------------
-- 入口函数(主循环)
-------------------------------------------------------------------------------------
function core.entry()
   -- 设置随机数种子
   math.randomseed(os.clock())
   -- 优化使用
   local decider = decider
   -- 模块调用
   for k, v in ipairs(this.module_list) do
      -- 中断检测
      if not is_working() then
         break
      end
      -- 设置当前上下文
      decider.set_curr_context(v)
      -- 调用功能入口函数
      --xxmsg(v.MODULE_NAME)
      if v.entry and decider.is_working() then
         -- 进入模块
         -- decider.entry()
         xpcall(decider.entry, this.error_handler)
      end
      -- 清空当前上下文
      decider.set_curr_context(this)
   end
end

-------------------------------------------------------------------------------------
-- 定时回调(定时回调)
--
-- @tparam       integer   timer_id         定时器id
-- @usage
-- settimer(1, 1000) -- 设置定时器
-------------------------------------------------------------------------------------
function core.on_timer(timer_id)
   for k, v in ipairs(this.module_list) do
      -- 中断检测
      if not is_working() then
         break
      end
      -- 调用功能
      if v.on_timer then
         --v.on_timer(timer_id)
         xpcall(v.on_timer, this.error_handler, timer_id)
      end
   end
end

-------------------------------------------------------------------------------------
-- 卸载处理(退出脚本)
-------------------------------------------------------------------------------------
function core.unload()
   -- 卸载轮循计时器
   killtimer(this.CIRCULAR_TIMER_ID)
   -- 关闭自动重启
   main_ctx:auto_restart(false)
   -- 卸载所有模块
   for k, v in ipairs(this.module_list) do
      -- 调用功能
      if v.unload then
         -- v.unload()
         xpcall(v.unload, this.error_handler)
      end
   end
end

-------------------------------------------------------------------------------------
-- 异常捕获函数
--
-- @local
-- @tparam       any       any              异常信息
-------------------------------------------------------------------------------------
function core.error_handler(err)
   -- 设置脚本终止标志
   if not settings.continue_on_error then
      set_exit_state(true)
   end
   trace.log_error(debug.traceback('error: ' .. tostring(err), 2))
end

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function core.__tostring()
   return this.MODULE_NAME
   -- -- 计算最大长度
   -- local max_key_length = 0
   -- for key, _ in pairs(this) do
   --    if key ~= '__tostring' then
   --       max_key_length = math.max(max_key_length, #key)
   --    end
   -- end
   -- -- 添加头部信息
   -- local fmt = '%-' .. (max_key_length + 1) .. 's: %s\n'
   -- local mode_str = this.READ_ONLY and 'Read-Only' or 'Read/Write'
   -- local str = string.format(fmt, 'Pointer', tostring(this))
   -- str = str .. string.format(fmt, 'Name', this.MODULE_NAME)
   -- str = str .. string.format(fmt, 'Version', this.VERSION)
   -- str = str .. string.format(fmt, 'Author', this.AUTHOR_NOTE)
   -- str = str .. string.format(fmt, 'Mode', mode_str)
   -- str = str .. '\nMembers:\n'
   -- -- 添加成员信息
   -- for key, value in pairs(this) do
   --    if key ~= '__tostring' then
   --       str = str .. string.format(fmt, key, tostring(value))
   --    end
   -- end
   -- -- 返回结果
   -- return str
end

------------------------------------------------------------------------------------
-- 防止动态修改(this.READ_ONLY值控制)
--
-- @local
-- @tparam       table     t                被修改的表
-- @tparam       any       k                要修改的键
-- @tparam       any       v                要修改的值
------------------------------------------------------------------------------------
function core.__newindex(t, k, v)
   if this.READ_ONLY then
      error('attempt to modify read-only table')
      return
   end
   rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置core的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
core.__index = core

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function core:new(args)
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
   return setmetatable(new, core)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return core:new()

-------------------------------------------------------------------------------------
