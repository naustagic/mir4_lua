------------------------------------------------------------------------------------
-- base/trace.lua
--
-- 此模块提供了 trace 日志记录工具，可用于记录日志、跟踪函数调用、输出调试信息等功能。
--
-- @module      trace
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- 0 代表 trace 级别，最低的调试级别。
-- 1 代表 debug 级别，用于输出一些比较详细的调试信息。
-- 2 代表 info 级别，一般用于输出程序运行的关键信息。
-- 3 代表 warn 级别，表示程序运行遇到了一些警告。
-- 4 代表 error 级别，表示程序运行出现了一些错误，但不会导致程序崩溃。
-- 5 代表 critical 级别，表示程序运行遇到了严重错误，可能导致程序崩溃或者无法继续运
------------------------------------------------------------------------------------

-- 模块定义
---@class trace
local trace = {
	-- 模块版本 (主版本.次版本.修订版本)
	VERSION                   = '1.0.0',
	-- 作者备注 (更新日期 - 更新内容简述)
	AUTHOR_NOTE               = '2023-03-22 - Initial release',
   -- 模块名称
   MODULE_NAME               = "trace module",
   -- 只读模式
   READ_ONLY                 = false,
   -- 堆栈函数列表
   co_stack_funcs            = {},
    --设置角色当前序号
    ROLE_IDX                 = 1
}

-- 模块实例
local this = trace
-- 设置模块
local settings = settings
-- 优化列表
local math = math
local string = string
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local setmetatable = setmetatable
local error = error
local rawset = rawset
local xxxmsg = xxxmsg
local main_ctx = main_ctx

------------------------------------------------------------------------------------
-- trace.concat
--
-- @tparam       table     t                要连接的表
-- @tparam       string    sep              分隔符
-- @tparam       boolean   hex              如果为 true，则数字类型的值将以十六进制格式输出
-- @treturn      string                     连接后的字符串
------------------------------------------------------------------------------------
function trace.concat(t, sep, hex)
   local result = ''
   local temp = ''
   for i, v in ipairs(t) do
       if i > 1 then
           result = result .. sep
       end
       if hex and type(v) == 'number' then
           if math.floor(v) ~= v then
               temp = string.format('%0.3f', v)
           else
               temp = string.format('0x%X', v)
           end
       else
           temp = tostring(v)
       end
       result = result .. temp
   end
   return result
end

-------------------------------------------------------------------------------------
-- 将信息输出到调试器
--
-- @local
-- @tparam       integer   level            日志输出级别
-- @tparam       any       ...              需要输出的变量列表，使用逗号隔开
-- @usage
-- trace.print(0, ...)
-------------------------------------------------------------------------------------
function trace.print(level, ...)
   -- 日志输出级别效验
   if level < settings.log_level then
      return
   end
   -- 输出到调试器
   xxxmsg(level, this.concat({...}, ", "))
end

------------------------------------------------------------------------------------
-- 将消息输出到控制台
--
-- @local
-- @tparam       string    msg              输出的消息
-- @usage
-- trace.output(...)
------------------------------------------------------------------------------------
function trace.output(...)
   local msg = ''
   for k,v in pairs({ ... }) do
      msg = msg..v
   end
   msg = string.format('【%s】%s：%s',this.ROLE_IDX,os.date("%H-%M"),msg)
   main_ctx:set_action(msg)
end

------------------------------------------------------------------------------------
-- 设置角色序号
function trace.set_role_idx(idx)
   this.ROLE_IDX = idx
end

------------------------------------------------------------------------------------
-- 记录日志信息到文件
--
-- @local
-- @tparam       integer   level            日志输出级别
-- @tparam       any       ...              输出的内容
-- @usage
-- trace.logger(0, ...)
------------------------------------------------------------------------------------
function trace.logger(level, ...)
   -- 日志输出级别效验
   if level < settings.log_level then
      return
   end
   -- 打包信息
   local msg = this.concat({...}, ", ")
   -- 输出调试器
   if settings.log_type_channel & 1 then
      xxxmsg(level, msg)
   end
   -- 输出日志文件
   if settings.log_type_channel & 2 then
   --   main_ctx:trace(msg, level)
   end
end

-------------------------------------------------------------------------------------
-- 记录跟踪信息(trace)
--
-- @tparam       any       ...              要记录的信息，多个参数将被合并成一个字符串。
-- @usage
-- trace.log_trace('Hello, world!')
-- trace.log_trace('User', 123, 'logged in')
-- local x = 5
-- local y = 10
-- trace.log_trace('The sum of x and y is:', x + y)
-------------------------------------------------------------------------------------
function trace.log_trace(...)
   this.logger(0, ...)
end

-------------------------------------------------------------------------------------
-- 记录调试信息(debug)
--
-- @tparam       any       ...              要记录的信息，多个参数将被合并成一个字符串。
-- @usage
-- trace.log_debug('Starting operation...')
-- trace.log_debug('User', 123, 'request received')
-- local x = 5
-- local y = 10
-- trace.log_debug('The value of x is:', x, 'and the value of y is:', y)
-------------------------------------------------------------------------------------
function trace.log_debug(...)
   this.logger(1, ...)
end

-------------------------------------------------------------------------------------
-- 记录关键信息(info)
--
-- @tparam       any       ...              要记录的信息，多个参数将被合并成一个字符串。
-- @usage
-- trace.log_info('Operation complete.')
-- trace.log_info('User', 123, 'request processed')
-- local x = 5
-- local y = 10
-- trace.log_info('The product of x and y is:', x * y)
-------------------------------------------------------------------------------------
function trace.log_info(...)
   this.logger(2, ...)
end

-------------------------------------------------------------------------------------
-- 记录警告信息(warn)
--
-- @tparam       any       ...              要记录的信息，多个参数将被合并成一个字符串。
-- @usage
-- trace.log_warn('Operation may have failed.')
-- trace.log_warn('User', 123, 'attempted to perform an unauthorized action')
-- local x = 5
-- local y = 10
-- trace.log_warn('The value of x is greater than y:', x > y)
-------------------------------------------------------------------------------------
function trace.log_warn(...)
   this.logger(3, ...)
end

-------------------------------------------------------------------------------------
-- 记录错误信息(error)
--
-- @tparam       any       ...              要记录的信息，多个参数将被合并成一个字符串。
-- @usage
-- trace.log_error('Error occurred.')
-- trace.log_error('Error occurred in module', 'module', 'func_name.')
-- local err_code = 500
-- local err_msg = 'Server error occurred.'
-- trace.log_error('Error', err_code, ':', err_msg)
-------------------------------------------------------------------------------------
function trace.log_error(...)
   this.logger(4, ...)
end

-------------------------------------------------------------------------------------
-- 记录严重错误信息(critical)
--
-- @tparam       any       ...              要记录的信息，多个参数将被合并成一个字符串。
-- @usage
-- trace.log_critical('Application has crashed!')
-- trace.log_critical('Invalid argument', 123, 'passed to function foo')
-- local err_code = 1001
-- trace.log_critical('Error occurred (error code: ' .. err_code .. ')')
-------------------------------------------------------------------------------------
function trace.log_critical(...)
   this.logger(5, ...)
end

-------------------------------------------------------------------------------------
-- 包装行为
--
-- @local
-- @treturn      string                     包含当前协程调用堆栈上所有行为名称的字符串
-------------------------------------------------------------------------------------
function trace.wrapper_action()
   local result = ""
   local id = coroutine.running()
   local stack_functions = this.co_stack_funcs[id]
   if stack_functions ~= nil and #stack_functions > 0 then
      for i, v in ipairs(stack_functions) do
         if i > 1 then
            result = result .. ":"
         end
         result = result .. tostring(v.action_name)
      end
   end
   return result
end

-------------------------------------------------------------------------------------
-- 包装消息
--
-- @local
-- @tparam       string    head             消息头
-- @tparam       any       ...              消息体（可变参数）
-- @treturn      string                     包装好的消息
-------------------------------------------------------------------------------------
function trace.wrapper_message(head, ...)
   local msg = this.concat({...}, "-")
   local action = this.wrapper_action()
   local result = '[' .. head .. ']'
   if settings.log_level < 3 then
      result = '[' .. head .. '] {'.. this.curr_module .. '}'
   end
   if #action > 0 then
      result = result .. " {" .. action .. "}"
   end
   if #msg > 0 then
      result = result .. " (" .. msg .. ")"
   end
   return result
end

-------------------------------------------------------------------------------------
-- 输出带上下文的普通信息(控制台)
--
-- @tparam       string    head             消息头
-- @tparam       any       ...              消息体（可变参数）
-- @usage trace.message('警告', '角色差点被删除')
-- @usage trace.message('错误', '角色已经被删除', '张三')
-------------------------------------------------------------------------------------
function trace.message(head, ...)
   this.output(this.wrapper_message(head, ...))
end

-------------------------------------------------------------------------------------
-- 输出带上下文的行为信息(控制台、日志文件)
--
-- @tparam       string    head             消息头
-- @tparam       any       ...              消息体（可变参数）
-- @usage trace.action('成功', '删除角色')
-- @usage trace.action('失败', '删除角色', '张三')
-------------------------------------------------------------------------------------
function trace.action(head, ...)
   local msg = this.wrapper_message(head, ...)
   this.log_info(msg)
   --this.output(msg)
end

-------------------------------------------------------------------------------------
-- 记录并输出模块进入信息
--
-- @local
-- @tparam       string    name             模块名称
-------------------------------------------------------------------------------------
function trace.enter_module(name)
   this.curr_module = name
   this.action("进入")
end

-------------------------------------------------------------------------------------
-- 记录并输出模块离开信息
--
-- @local
-------------------------------------------------------------------------------------
function trace.leave_module()
   this.action("离开")
   this.curr_module = ""
end

-------------------------------------------------------------------------------------
-- 记录并输出函数进入信息
--
-- 进入函数时，记录当前函数所在的协程栈，并输出带行为记录的信息
-- @local
-- @tparam       table     stack_funcs      当前协程栈
-- @tparam       table     fn_info          当前函数信息
-------------------------------------------------------------------------------------
function trace.enter_function(stack_funcs, fn_info)
   local id = coroutine.running()
   if not this.co_stack_funcs[id] then
      this.co_stack_funcs[id] = stack_funcs
   end
   if fn_info.func_type == 0 then -- 普通函数
      this.action("进入")
   end
end

-------------------------------------------------------------------------------------
-- 记录并输出函数离开信息
--
-- 离开函数时，输出带行为记录的信息，并记录日志
-- @local
-- @tparam       table     fn_info          函数信息
-------------------------------------------------------------------------------------
function trace.leave_function(fn_info)
   if fn_info.func_type == 0 then -- 普通函数
      local timeit = os.clock() - fn_info.start_time
      local temp = fn_info.is_timeout and ", 超时" or ""
      this.action("离开", string.format("耗时%.1f秒%s", timeit, temp))
   elseif fn_info.func_type == 1 then -- 行为函数
      local params = this.concat(fn_info.params, ", ", true)
      local success = false
      local count = #fn_info.result
      if count > 0 then
         success = fn_info.result[1] or false
         -- 返回失败连接错误信息
         if not success and count > 1 then
            params = params .. " : " .. fn_info.result[2]
         end
      end
      this.action((success and "成功" or "失败"), params)
   end
end

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function trace.__tostring()
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
function trace.__newindex(t, k, v)
   if this.READ_ONLY then
      error("attempt to modify read-only table")
      return
   end
   rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置trace的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
trace.__index = trace

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function trace:new(args)
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
   return setmetatable(new, trace)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return trace:new()

-------------------------------------------------------------------------------------
