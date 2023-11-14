------------------------------------------------------------------------------------
-- game/modules/login.lua
--
-- 这个是处理登陆的功能模块，模块名称用中文。
--
-- @module      login
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local login = import('game/modules/login')
------------------------------------------------------------------------------------

-- 模块定义
-- @class
local login = {
	-- 模块版本 (主版本.次版本.修订版本)
	VERSION                 = '1.0.0',
	-- 作者备注 (更新日期 - 更新内容简述)
	AUTHOR_NOTE             = '2023-03-22 - Initial release',
	-- 模块名称
	MODULE_NAME             = '登陆模块',
	-- 只读模式
	READ_ONLY               = false,
}

-- 自身模块
local this = login
-- 配置模块
local settings = settings
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
-- 登陆资源
local login_res = import('game/resources/login_res')
-- 登陆单元
local login_ent = import('game/entities/login_ent')

-------------------------------------------------------------------------------------

-- 运行前置条件
login.eval_ifs = {
	-- [启用] 游戏状态列表
	yes_game_state = {},
	-- [禁用] 游戏状态列表
	not_game_state = {login_res.STATUS_IN_GAME},
	-- [启用] 配置开关列表
	yes_config     = {},
	-- [禁用] 配置开关列表
	not_config     = {},
	-- [时间] 模块超时设置(可选)
	time_out 	   = 0,
	-- [其它] 特殊情况才用(可选)
	is_working     = function() return true end,
	-- [其它] 功能函数条件(可选)
	is_execute     = function() return true	end,
}

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function login.super_preload()
	-- table.insert(this.poll_functions, 1000)
end

-------------------------------------------------------------------------------------
-- [事件] 预载处理(运行脚本)
------------------------------------------------------------------------------------
function login.preload()
	--
end

-------------------------------------------------------------------------------------
-- 前置处理(进入模块)
-------------------------------------------------------------------------------------
function login.pre_enter()
	xxmsg('login.pre_enter')
	settimer(2000, 5000)
end

-------------------------------------------------------------------------------------
-- 轮循入口(循环前置)
--
-- @usage
-- while decider.is_working() 
-- do
-- 	-- 执行轮循
-- 	decider.looping()
-- 	-- 功能处理
-- 	-- 适当延时
-- 	decider.sleep(2000)
-- end
-------------------------------------------------------------------------------------
function login.looping()
	xxxmsg(3, 'aaaaaaaaaaaa')
end

-------------------------------------------------------------------------------------
-- 模块入口
-------------------------------------------------------------------------------------
function login.entry()
    local action_list = {
        -- [login_res.STATUS_INTRO_PAGE] = login_ent.start_game,
        -- [login_res.STATUS_LOGIN_PAGE | login_res.STATUS_THIRDPARTY_LOGIN_PAGE] = login_ent.open_third_login,
        -- [login_res.STATUS_LOGIN_PAGE | login_res.STATUS_GOOGLE_LOGIN_PAGE] = login_ent.login_google_account,
        -- [login_res.STATUS_LOGIN_PAGE | login_res.STATUS_TERMS_AGREEMENT_PAGE] = login_ent.accept_user_agreement,
        -- [login_res.STATUS_LOGIN_PAGE | login_res.STATUS_SERVER_SELECT_PAGE] = login_ent.enter_select_character,
        -- [login_res.STATUS_LOGIN_PAGE] = login_ent.enter_select_character,
        -- [login_res.STATUS_CREATE_CHARACTER] = login_ent.create_character,
        -- [login_res.STATUS_CHARACTER_SELECT] = login_ent.enter_game,
    }
	
	decider.sleep(2000)
	while decider.is_working() 
	do
		-- 执行轮循任务
		decider.looping()
		-- 根据状态执行相应功能
		local status = game_unit.game_status()
		local action = action_list[status]
		if action ~= nil then
			action()
		end
		-- 适当延时(切片)
		decider.sleep(2500)
	end
end

-------------------------------------------------------------------------------------
-- 后置处理(退出模块)
-------------------------------------------------------------------------------------
function login.post_enter()
	xxmsg('login.post_enter')
	killtimer(2000)
end

-------------------------------------------------------------------------------------
-- [事件] 模块超时
-------------------------------------------------------------------------------------
function login.on_timeout()
	xxxmsg(3, '。。。。。登陆模块处理超时。。。。。')
end

-------------------------------------------------------------------------------------
-- [事件] 定时回调
--
-- @param       timer_id     integer   定时器id
-- @usage
-- settimer(1, 1000) -- 设置定时器  
-------------------------------------------------------------------------------------
function login.on_timer(timer_id)
	local id = coroutine.running()
    xxmsg('login.on_timer -> '..timer_id.. '  ' .. tostring(id))
end

-------------------------------------------------------------------------------------
-- [事件] 卸载处理(脚本退出)
-------------------------------------------------------------------------------------
function login.unload()
	--xxmsg('login.unload')
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function login.__tostring()
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
function login.__newindex(t, k, v)
    if this.READ_ONLY then
        error('attempt to modify read-only table')
        return
    end
    rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置item的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
login.__index = login

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local 
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function login:new(args)
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
	return setmetatable(new, login)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return login:new()

-------------------------------------------------------------------------------------