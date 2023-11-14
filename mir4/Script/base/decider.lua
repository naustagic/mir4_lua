------------------------------------------------------------------------------------
-- base/decider.lua
--
-- 本模块是行为决策管理模块，运行时行为管理、函数封装器、公共函数封装等。
--
-- @module      decider
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- 本模块不能被 main_test 入口函数调用，只能在正式模块中使用。
------------------------------------------------------------------------------------

-- 模块定义
local decider = {
	-- 模块版本 (主版本.次版本.修订版本)
	VERSION                   = '1.0.0',
	-- 作者备注 (更新日期 - 更新内容简述)
	AUTHOR_NOTE               = '2023-03-22 - Initial release',
	-- 模块名称
	MODULE_NAME 			  = "decider module",
	-- 只读模式
	READ_ONLY 				  = false,
	-- 包装函数列表
	wrapped_funcs 			  = {},
	-- 堆栈函数列表
	co_stack_funcs 			  = {}
}

-- 实例对象
local this = decider
-- 设置模块
local settings = settings
-- 日志模块
local trace = trace
-- 优化列表
local sleep = sleep
local is_working = is_working
local os = os
local coroutine = coroutine
local table = table
local game_unit = game_unit
local ipairs = ipairs
local tostring = tostring
local pairs = pairs
local setmetatable = setmetatable
local assert = assert
local rawset = rawset
local error = error
local xxhash = xxhash
local get_run_signal = get_run_signal

-------------------------------------------------------------------------------------
-- 设置上下文
--
-- @local
-------------------------------------------------------------------------------------
function decider.set_curr_context(context)
	-- 设置当前模块
	this.current_context = context
	-- 清零进入时间
	context.entry_time = 0
	-- 重置超时标识
	context.timeout_state = false
end

-------------------------------------------------------------------------------------
-- 设置超时
function decider.clear_time_out(set_time)
	local context = this.current_context
	if context then
		-- 设置进入时间为当前时
		context.entry_time        = os.time()
		context.eval_ifs.time_out = set_time
		this.current_context      = context
	end
end

-------------------------------------------------------------------------------------
-- 切片延时
--
-- @tparam 		 integer   ms 			    要休眠的毫秒数
-- @tparam[opt]  number	   slice 		    切片大小，用于分割延时时间，默认为 500 毫秒
-- @usage decider.sleep(1000)
-------------------------------------------------------------------------------------
function decider.sleep(ms, slice)
	if ms == 0 then
		return
	end
	-- 分割大小
	local slice = slice and slice or 500
	-- 计算需要分割的次数
	local n = ms // slice
	-- 计算最后一次分割的时间
	local mod = ms % slice
	for i = 1, n do
		if this.is_working() then
			sleep(slice)
		end
	end
	if mod > 0 then
		sleep(mod)
	end
end

-------------------------------------------------------------------------------------
-- 是否工作
-- 各种设置、状态、其它条件效验。
-- @treturn		 boolean                    效验成功返回 true, 否则false。
-- @usage
-- while decider.is_working()
-- do
--     decider.sleep(2500)
-- end
-------------------------------------------------------------------------------------
function decider.is_working()
	-- 系统中断标志
	if not is_working() then
		return false
	end
	-- 效验函数中断
	if this.interrupt_guard() then
		return false
	end
	-- 本地化使用
	local context = this.current_context
	local eval_ifs = context.eval_ifs
	local curr_state = game_unit.game_status_ex()
	-- 效验超时
	if eval_ifs.time_out and eval_ifs.time_out ~= 0 then
		local entry_time = context.entry_time
		if entry_time ~= 0 then
			if os.time() - entry_time > eval_ifs.time_out then
				context.timeout_state = true
				return false
			end
		end
	end
	-- 效验 [启用] 游戏状态列表
	local check_ok = false
	if #eval_ifs.yes_game_state > 0 then
		for k,v in ipairs(eval_ifs.yes_game_state)
		do
			if v == curr_state then
			--if v & curr_state ~= 0 then
				check_ok = true
				break
			end
		end
		if not check_ok then return false end	
	end
	-- 效验 [禁用] 游戏状态列表
	check_ok = true
	for k,v in ipairs(eval_ifs.not_game_state)
	do	
		--if v & curr_state ~= 0 then
		if v == curr_state then
			check_ok = false
			break
		end
	end
	if not check_ok then  return false end
	-- 效验 [启用] 配置开关列表
	for k,v in ipairs(eval_ifs.yes_config)
	do
		if not ini_ctx:get_bool(v) then
			return false
		end
	end
	-- 效验 [禁用] 配置开关列表
	for k,v in ipairs(eval_ifs.not_config)
	do
		if ini_ctx:get_bool(v) then
			return false
		end
	end
	-- 其它条件
	return not eval_ifs.is_working or eval_ifs.is_working()
end

-------------------------------------------------------------------------------------
-- 执行功能函数前置效验
--
-- @local
-------------------------------------------------------------------------------------
function decider.is_execute()
	local ret = true
	local eval_ifs = this.current_context.eval_ifs
	if eval_ifs.is_execute then
		ret = eval_ifs.is_execute()
	end
	return ret
end

-------------------------------------------------------------------------------------
-- 效验函数中断
--
-- @local
-------------------------------------------------------------------------------------
function decider.interrupt_guard()
	-- 获取函数对象
	local id = coroutine.running()
	local stack_funcs = this.co_stack_funcs[id]
	if stack_funcs == nil or #stack_funcs == 0 then
		return false
	end
	-- 效验函数是否设置超时
	local fn_info = stack_funcs[#stack_funcs]
	if fn_info.timeout == 0 or fn_info.start_time == 0 then
		return false
	end
	-- 效验超时
	if os.clock() - fn_info.start_time < fn_info.timeout then
		return false
	end
	-- 确定已超时
	fn_info.is_timeout = true
	return true
end

-------------------------------------------------------------------------------------
-- 进入函数
--
-- @local
-------------------------------------------------------------------------------------
function decider.enter_function(fn_info)
	local id = coroutine.running()
	if not this.co_stack_funcs[id] then
		this.co_stack_funcs[id] = {}
	end
	local stack_funcs = this.co_stack_funcs[id]
	table.insert(stack_funcs, fn_info)
	trace.enter_function(stack_funcs, fn_info)
end

-------------------------------------------------------------------------------------
-- 离开函数
--
-- @local
-------------------------------------------------------------------------------------
function decider.leave_function()
	local id = coroutine.running()
	local stack_funcs = this.co_stack_funcs[id]
	local fn_info = stack_funcs[#stack_funcs]
	trace.leave_function(fn_info)
	table.remove(stack_funcs)
end

-------------------------------------------------------------------------------------
-- 轮循入口
-- 所有循环、子循环前置处理函数，函数会调用当前上下文模块对应的xx.looping()。
-- @usage
-- -- 所有循环的第一行必须为 decider.looping()，以此实现轮循功能。
-- while decider.is_working()
-- do
--     decider.looping()
--     decider.sleep(2500)
-- end
-------------------------------------------------------------------------------------
function decider.looping()
	local context = this.current_context
	if context.looping then
		context.looping()
	end
end

-------------------------------------------------------------------------------------
-- 进入模块
--
-- @local
-------------------------------------------------------------------------------------
function decider.entry()
	-- 本地化使用
	local context = this.current_context
	-- 记录进入时间
	context.entry_time = os.time()
	-- 日志跟踪进入
	trace.enter_module(context.MODULE_NAME)
	-- 函数进入前处理
	if context.pre_enter then
		context.pre_enter()
	end
	-- 调用目标函数
	context.entry()
	-- 函数离开处理
	if context.post_enter then
		context.post_enter()
	end
	-- 记录离开时间
	context.leave_time = os.time()
	-- 模块超时处理
	if context.on_timeout and context.timeout_state then
		context.on_timeout()
	end
	-- 日志跟踪离开
	trace.leave_module()
end

-------------------------------------------------------------------------------------
-- 函数包装器，函数属性对象。
-- @table 		 func_prop
-- @tfield 		 int 	   func_type 		函数类型
-- @tfield 		 function  cond_func        条件函数
-- @tfield 		 number    timeout 		    超时时间

-------------------------------------------------------------------------------------
-- 函数包装器(记录功能)
--
-- 封装过的函数具有日志功能及其它特殊功能。
-- @tparam 		 string    action_name      行为名称
-- @tparam 		 function  action_func      行为函数
-- @tparam[opt]  func_prop FuncProp         函数属性
-- @treturn		 function                   被封装好的新函数
-- @see          func_prop
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local function cond_func() return true end
-- local func1 = decider.function_wrapper('加法运算1', func)
-- local func2 = decider.function_wrapper('加法运算2', func, {cond_func = cond_func})
-- local func3 = decider.function_wrapper('加法运算3', func, {timeout = 10.5}))
-- local func4 = decider.function_wrapper('加法运算4', func, {func_type = 1})
-------------------------------------------------------------------------------------
function decider.function_wrapper(action_name, action_func, func_prop)
	-- 断言效验
	assert(action_name ~= nil, "行为名称不能为空")
	assert(action_func ~= nil, "行为函数不能为NIL")
	-- 函数缓存key
	local func_key = xxhash("function_wrapper_" .. action_name .. tostring(action_func))
	-- 生成函数
	if not this.wrapped_funcs[func_key] then
		-- 函数信息对象
		local fn_info = {}
		-- 函数属性对象
		local func_prop = func_prop or {}
		-- 行为名称
		fn_info.action_name = action_name
		-- 目标函数
		fn_info.action_func = action_func
		-- 前置条件函数
		fn_info.cond_func = func_prop.cond_func
		-- 超时时间
		fn_info.timeout = func_prop.timeout or 0
		-- 普通函数(0) 行为函数(1)
		fn_info.func_type = func_prop.func_type or 0
		-- 运行计次
		fn_info.call_count = 0
		-- 构建函数
		this.wrapped_funcs[func_key] = function(...)
			-- 效验工作状态
			if not this.is_working() then
				return false, "decider.is_working equal false"
			end
			-- 效验可执行状态
			if fn_info.func_type == 1 and not this.is_execute() then
				return false, "decider.is_execute equal false"
			end
			-- 重置默认返回值
			fn_info.result = {false}
			-- 效验前置条件
			if not fn_info.cond_func or fn_info.cond_func(...) then
				-- 参数列表
				fn_info.params = {...}
				-- 开始时间
				fn_info.start_time = os.clock()
				-- 重置超时
				fn_info.is_timeout = false
				-- 累加运行次数
				fn_info.call_count = fn_info.call_count + 1
				-- 记录函数进入
				this.enter_function(fn_info)
				-- 调用目标函数
				fn_info.result = {fn_info.action_func(...)}
				-- 记录函数离开
				this.leave_function()
			end
			-- 返回结果
			return table.unpack(fn_info.result)
		end
	end
	-- 返回函数
	return this.wrapped_funcs[func_key]
end

-------------------------------------------------------------------------------------
-- 函数包装器(普通函数)
--
-- @tparam 		 string    action_name      行为名称
-- @tparam 		 function  action_func      行为函数
-- @tparam[opt]  function  cond_func        条件函数
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local function cond_func() return true end
-- local func1 = decider.run_normal_wrapper('加法运算1', func)
-- local func2 = decider.run_normal_wrapper('加法运算2', func, cond_func)
-------------------------------------------------------------------------------------
function decider.run_normal_wrapper(action_name, action_func, cond_func)
	return this.function_wrapper(action_name, action_func, {cond_func = cond_func})
end

-------------------------------------------------------------------------------------
-- 函数包装器(带前置条件)
--
-- @tparam 		 string    action_name      行为名称
-- @tparam 		 function  action_func      行为函数
-- @tparam[opt]  function  cond_func        条件函数
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local function cond_func() return true end
-- local func1 = decider.run_condition_wrapper('加法运算1', func)
-- local func2 = decider.run_condition_wrapper('加法运算2', func, cond_func)
-------------------------------------------------------------------------------------
function decider.run_condition_wrapper(action_name, action_func, cond_func)
	return this.function_wrapper(action_name, action_func, {cond_func = cond_func})
end

-------------------------------------------------------------------------------------
-- 函数包装器(带超时功能)
--
-- @tparam 		 string    action_name      行为名称
-- @tparam 		 function  action_func      行为函数
-- @tparam 		 number    timeout  	    超时时间(秒)
-- @tparam[opt]  function  cond_func        条件函数
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local function cond_func() return true end
-- local func1 = decider.run_timeout_wrapper('加法运算1', func, 10.5)
-- local func2 = decider.run_timeout_wrapper('加法运算2', func, 10.5, cond_func)
-------------------------------------------------------------------------------------
function decider.run_timeout_wrapper(action_name, action_func, timeout, cond_func)
	return this.function_wrapper(action_name, action_func, {cond_func = cond_func, timeout = timeout})
end

-------------------------------------------------------------------------------------
-- 函数包装器(行为类函数)
--
-- @tparam 		 string    action_name      行为名称
-- @tparam 		 function  action_func      行为函数
-- @tparam[opt]  function  cond_func        条件函数
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local function cond_func() return true end
-- local func1 = decider.run_action_wrapper('加法运算1', func)
-- local func2 = decider.run_action_wrapper('加法运算2', func, cond_func)
-------------------------------------------------------------------------------------
function decider.run_action_wrapper(action_name, action_func, cond_func)
	return this.function_wrapper(action_name, action_func, {cond_func = cond_func, func_type = 1})
end

-------------------------------------------------------------------------------------
-- 包装间隔运行
--
-- @tparam 		 string    action_name  	行为名称
-- @tparam 		 function  action_func      行为函数
-- @tparam 	     integer   intv_time        间隔时间
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local func1 = decider.run_interval_wrapper('加法运算1', func， 1000*30)
-------------------------------------------------------------------------------------
function decider.run_interval_wrapper(action_name, action_func, intv_time)
	-- 函数缓存key
	local func_key = xxhash("run_interval_wrapper_" .. action_name .. tostring(action_func))
	-- 生成函数
	if not this.wrapped_funcs[func_key] then
		this.wrapped_funcs[func_key] = function(...)
			-- 未设置就是立即执行
			if intv_time == nil then
				intv_time = 0
			end
			-- 读取运行信号
			if not get_run_signal(action_func, intv_time) then
				return false, "no run signal"
			end
			-- 调用目标函数
			local fn = this.function_wrapper(action_name, action_func)
			return fn(...)
		end
	end
	-- 返回函数
	return this.wrapped_funcs[func_key]
end

-------------------------------------------------------------------------------------
-- 包装只运行一次
--
-- @tparam 		 string    action_name      行为名称
-- @tparam 		 function  action_func      行为函数
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local func1 = decider.run_once_wrapper('加法运算1', func)
-------------------------------------------------------------------------------------
function decider.run_once_wrapper(action_name, action_func)
	return this.run_interval_wrapper(action_name, action_func, 0xFFFFFFFF)
end

-------------------------------------------------------------------------------------
-- 包装运行到条件满足
--
-- @tparam 		 function  action_func      行为函数
-- @tparam 		 function  condition        条件函数
-- @tparam 		 number    timeout  	    超时时间(秒)
-- @treturn 	 function      	            被封装好的新函数
-- @usage
-- local function func() xxxmsg(2, 'Hello World!') end
-- local function cond_func() return true end
-- local func1 = decider.run_until_wrapper('加法运算1', func)
-- local func2 = decider.run_until_wrapper('加法运算2', func, cond_func, 60)
-------------------------------------------------------------------------------------
function decider.run_until_wrapper(action_func, condition, timeout)
	-- 函数缓存key
	local func_key = xxhash("run_until_wrapper_" .. tostring(action_func) .. tostring(condition) .. tostring(timeout))
	-- 生成函数
	if not this.wrapped_funcs[func_key] then
		this.wrapped_funcs[func_key] = function(...)
			local result = false
			local start_time = os.clock()
			while this.is_working() do
				if timeout and os.clock() - start_time > timeout then
					break
				end
				if condition(...) then
					result = true
					break
				end
				action_func(...) -- 调用目标函数
			end
			return result
		end
	end
	-- 返回函数
	return this.wrapped_funcs[func_key]
end

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function decider.__tostring()
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
function decider.__newindex(t, k, v)
	if this.READ_ONLY then
		error("attempt to modify read-only table")
		return
	end
	rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置decider的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
decider.__index = decider

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function decider:new(args)
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
	return setmetatable(new, decider)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return decider:new()

-------------------------------------------------------------------------------------
