-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   ZhengHao
--- @email:    88888@qq.com
--- @date:     2023-2-10
--- @module:   revive_ent
--- @describe: 复活模块
--- @version:  v1.0
-------------------------------------------------------------------------------------
local VERSION = '20211017' -- version history at end of file
local AUTHOR_NOTE = '-[20211017]-'
---@class revive_ent
local revive_ent = {  
	VERSION      = VERSION,
	AUTHOR_NOTE  = AUTHOR_NOTE,
	LAST_CHECK_MAIL = 0,


}
local this = revive_ent
local decider = decider
local ui_unit = ui_unit
local actor_unit = actor_unit
local main_ctx = main_ctx
local revival_unit = revival_unit
local game_unit = game_unit
local trace = trace
---@type game_ent
local game_ent = import('game/entities/game_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function revive_ent.super_preload()
	this.wi_recovery = decider.run_interval_wrapper('恢复经验', this.recovery, 1000 * 60 * 60)

end


------------------------------------------------------------------------------------
-- 复活角色 1 就近 2 回城复活 （在副本类地图只能就近复活）
revive_ent.revive_player = function(action)
	local retB = false
	local last_time = 0
	local count = 0
	if action == nil then
		action = 2
	end

	-- 恢复经验
	if not this.local_player_is_dead() and not game_unit.is_loding() then
		revive_ent.wi_recovery()
		return retB
	end

	while decider.is_working() do

		if not this.local_player_is_dead() then
			-- 关闭省电
			game_unit.leave_sleep_mode()
			break
		else
			local rise_time = actor_unit.get_can_rise_time() -- 复活剩余时间 有延时
			trace.output(string.format("角色还需要%d秒复活",math.floor(rise_time)))
			if rise_time <= 0 then
				
				local cur_time = os.time()
				if cur_time - last_time > 10 then
					actor_unit.rise_man(1) -- 1回城复活
					last_time = cur_time
					count = count + 1
				end
				if count > 4 then
					main_ctx:end_game()
				end
			end
		end
		decider.sleep(2000)
	end

	return true
end

------------------------------------------------------------------------------------
--判断角色是否死亡
revive_ent.local_player_is_dead = function()
	local b_ret = false
	local win = ui_unit.get_parent_widget('MM_Popup_Revival_C',true)
	if game_ent.player_is_dead() and win ~= 0 then
		b_ret = true
	end
	return b_ret
end

------------------------------------------------------------------------------------
--恢复经验
revive_ent.recovery = function()


	local recovery_num = revival_unit.get_free_reviva_num() -- 免费找回经验次数

	local lost_exp_num = revival_unit.get_exp_num() -- 取丢失经验数量

	local tab = {}
	for i = 0, lost_exp_num-1 do
		local id = revival_unit.get_exp_id(i)
		local lost_exp = revival_unit.get_exp(i)
		table.insert(tab,{id = id,lost_exp= lost_exp})
	end
	table.sort(tab, this.max_lost_exp)

	local max_num = recovery_num > lost_exp_num and lost_exp_num or recovery_num
	for i = 1, max_num do
		if tab[i].id ~= -1 then
			-- 关闭省电
			game_unit.leave_sleep_mode()
			revival_unit.get_revival_exp(tab[i].id)
			decider.sleep(1000)
		end
	end

end

--经验从大到小排序
revive_ent.max_lost_exp = function(x, y)
	return x.lost_exp > y.lost_exp
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function revive_ent.__tostring()
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
function revive_ent.__newindex(t, k, v)
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
revive_ent.__index = revive_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function revive_ent:new(args)
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
	return setmetatable(new, revive_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return revive_ent:new()

-------------------------------------------------------------------------------------
