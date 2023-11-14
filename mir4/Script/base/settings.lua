------------------------------------------------------------------------------------
-- base/settings.lua
--
-- 本模块提供了一些通用的配置选项，包括日志级别、超时设置、调试器设置等。
--
-- @module      settings
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- -- 日志级别
-- -- 0 代表 trace 级别，最低的调试级别。
-- -- 1 代表 debug 级别，用于输出一些比较详细的调试信息。
-- -- 2 代表 info 级别，一般用于输出程序运行的关键信息。
-- -- 3 代表 warn 级别，表示程序运行遇到了一些警告。
-- -- 4 代表 error 级别，表示程序运行出现了一些错误，但不会导致程序崩溃。
-- -- 5 代表 critical 级别，表示程序运行遇到了严重错误，可能导致程序崩溃或者无法继续运
-- -- 日志通道
-- -- 1 代表 调试器
-- -- 2 代表 日志文件
-- -- 3 代表 调试器和日志文件
-- @usage
-- -- 设置方法
-- settings.log_level = 0
-- settings.log_type_channel = 3
------------------------------------------------------------------------------------

-- 模块定义
local settings = {
	-- 模块版本 (主版本.次版本.修订版本)
	VERSION                   = '1.0.0',
	-- 作者备注 (更新日期 - 更新内容简述)
	AUTHOR_NOTE               = '2023-03-22 - Initial release',
   -- 模块名称
   MODULE_NAME               = "settings module",
   -- 只读模式
   READ_ONLY                 = false,
   -- 日志记录级别(trace(0)、debug(1)、info(2)、warn(3)、error(4)、critical(5))
   log_level                 = 0,
   -- 日志类型记录的通道(调试器(1)、日志文件(2)、两者(3))
   log_type_channel          = 3,
   -- 记录函数参数(暂时未使用)
   log_function_params       = false,
   -- 记录函数返回值(暂时未使用)
   log_function_return       = false,
   -- 记灵函数运行次数(暂时未使用)
   log_function_call_count   = true,
   -- 异常后继续运行脚本(暂时未使用)
   continue_on_error         = false
}

-- 模块实例
local this = settings

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function settings.__tostring()
   return this.MODULE_NAME
end

------------------------------------------------------------------------------------
-- 防止动态修改(this.READ_ONLY值控制)
--
-- @local
-- @tparam       table     t                被修改的表
-- @tparam       any       k                要修改的键
-- @tparam       any       v                要修改的值
------------------------------------------------------------------------------------
function settings.__newindex(t, k, v)
   if this.READ_ONLY then
      xxxmsg(5, "attempt to modify read-only table")
      return
   end
   rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置settings的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
settings.__index = settings

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function settings:new(args)
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
   return setmetatable(new, settings)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return settings:new()

-------------------------------------------------------------------------------------
