-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   core
-- @email:    88888@qq.com 
-- @date:     2021-10-31
-- @module:   call_back
-- @describe: 精灵
-- @version:  v1.0
--

local VERSION = '20211031323' -- version history at end of file
local AUTHOR_NOTE = "-[20211031]-"

local call_back = {  
	VERSION      = VERSION,
	AUTHOR_NOTE  = AUTHOR_NOTE,
	cur_hp_ex = ''
}
local this = call_back
--local login = import("game/modules/login")
-------------------------------------------------------------------------------------
-- 代币登陆OnUrlChanged
call_back.OnWemixUrlChanged = function(url, step)
	xxmsg(url)

end
-------------------------------------------------------------------------------------
-- 真人验证回调
call_back.OnHumanVerify = function(url)
	local co = coroutine.create(function()
		--	if gather_ex.clientKey == nil then
		--		gather_ex.interIni()
		--	end
		--	xxmsg(url)
		--	if gather_ex.clientKey == nil or gather_ex.clientKey == 'clientKey' then
		--		ShowMsg('没有设置验证 clientKey')
		--		return
		--	end
		xxmsg(url)
		if not call_back.oTime then
			call_back.oTime = 0
		end
		if os.time() - call_back.oTime < 15 then
			return
		end
		call_back.oTime = os.time()

		--	--url = common.change_lang(url)
		--	xxmsg('clientKey:'..gather_ex.clientKey)
		xxmsg('正在资格验证...'..url)
		--正在资格验证...https://humanverify.mir4global.com/web/captcha/auth?VerifyID=NWZkNGQ0ODljMTBkOWMyYjBhN2FlOTJmODJmN2QwZjZlYmU4ZmY2YjA3YzYwY2Q1NzIyYWE5NWQ2YWM5MDUwZA==&lang=zh-Hans
		--gather_ex.WriteString('资格验证','开始验证',os.time())
		--if main_ctx:human_verify2(url, gather_ex.clientKey) then
		if main_ctx:human_verify2(url, "a97afee3eb0cbe0245118691b00fd899c35f15a62438") then
			xxmsg('正在资格验证中')
			--if main_ctx:human_verify(url) then
			sleep(3000)
			ui_unit.common_widget_confirm()-- 公共挂件确认
			--gather_ex.WriteString('资格验证','完成',os.time())

		end
	end)
	coroutine.resume(co)
end
-- 采集物品被占用回调
-- 参数1 采集对象ID
-- 参数2 采集者ID
call_back.OnGatherOccupied = function(gather_sys_id, gather_player_id)

end
-------------------------------------------------------------------------------------
-- 新采集物品刷新回调
-- 参数1 采集Id
-- 参数2 采集对象名称
-- 参数3 采集刷新X坐标
-- 参数4 采集刷新y坐标
-- 参数5 采集刷新z坐标
call_back.OnGatherUpdate = function(gather_sys_id, gather_name, x, y, z)

end
-------------------------------------------------------------------------------------
-- 中断采集回调
-- gather_sys_id 采集ID
-- player_sys_id 断开者ID
call_back.OnGatherBreak = function(gather_sys_id, player_sys_id)

end
-- 血量更新回调（update_type = 1 自然回血， 2 吃药，3被打悼血）
lost_send_exit_smite = 0
call_back.OnUpdateHP = function(cur_hp, update_type)

end
-------------------------------------------------------------------------------------
-- 被攻击回调
-- attack_type  1 玩家 2 怪物
-- attack_id   攻击者ID
call_back.OnAttackedLocalPlayer = function(attack_type, attack_id, cur_hp)

end

-------------------------------------------------------------------------------------
-- 收到组队邀请
-- attack_type  1 玩家 2 怪物
-- attack_id   攻击者ID
call_back.OnInviteTeam = function(team_id, invite_player_id, invite_player_name)

end
-------------------------------------------------------------------------------------
-- UI显示回调
--（widget_id = 0x10  可以识别 非法。。 弹窗， 游戏异常等等 PopUp_Common_Outgame_C 类的弹窗）
call_back.OnShowWidget = function(widget_id)
	local co = coroutine.create(function()
		--  widget_id = 0x10 是弹出PopUp_Common_Outgame_C 挂件
		local ui_state = {
			{text = '修改',set_name = '【封禁】修改/程序',do_func = function() main_ctx:set_ban_time_ex(os.time(),'修改/程序') sleep(4000) main_ctx:end_game()  end},
			{text = '在相同与',set_name = '【封禁】临近/IP',do_func = function() main_ctx:set_ban_time_ex(os.time(),'临近/IP') sleep(4000) main_ctx:end_game()  end},
			{text = '变造',set_name = '【封禁】变造/改造',do_func = function() main_ctx:set_ban_time_ex(os.time(),'变造/改造') sleep(4000) main_ctx:end_game()  end},
			{text = '网络状态不佳',set_name = '【异常】网络状态不佳',do_func = function() main_ctx:end_game() end},
			{text = '维护中。',set_name = '【异常】维护中。',do_func = function() main_ctx:end_game() end},
			{text = '连接失败',set_name = '【异常】连接失败',do_func = function() main_ctx:end_game() end},
			{text = '登录请求失败',set_name = '【异常】登录请求失败',do_func = function() main_ctx:end_game() end},
			{text = '验证代币失败',set_name = '【异常】验证代币失败',do_func = function() main_ctx:end_game() end},
			{text = '无法连接',set_name = '【异常】无法连接',do_func = function() main_ctx:end_game() end},
			{text = '重新尝试',set_name = '【异常】重新尝试',do_func = function() main_ctx:end_game() end},
			{text = '游戏结束',set_name = '【异常】游戏结束',do_func = function() main_ctx:end_game() end},
			{text = '发生严重错误',set_name = '【异常】发生严重错误',do_func = function() main_ctx:end_game() end},
			{text = '重新登陆',set_name = '【异常】重新登陆',do_func = function() main_ctx:end_game() end},
			{text = '将退出游戏登录',set_name = '【异常】将退出游戏登录',do_func = function() main_ctx:end_game() end},
			{text = '已完成合服',set_name = '关闭合服UI',do_func = function() ui_unit.common_widget_confirm() end},
			{text = '使用条款',set_name = '关闭使用条款',do_func = function() ui_unit.common_widget_cancel() end},
			{text = '资格的证明',set_name = '资格的证明',do_func = function() main_ctx:end_game() end},
			--{text = '添加个人信息',set_name = '选择日期',do_func = function() game_unit.set_personal_info(1990 + math.random(1,10)) sleep(2000) end},
		}
		--16.0----2023-5-26
		--同意服务使用条款、收集及使用个人信息。
		if widget_id == 0x10 then
			sleep(1000)
			-- ui_unit.get_popup_info_text() PopUp_Common_Outgame_C 挂件里的内容
			local strTxt = ui_unit.get_popup_info_text()
			xxmsg(widget_id..'----'..strTxt)
			for k,v in pairs(ui_state) do
				local text = v.text
				if string.find(strTxt,text) ~= nil then
					local set_name = v.set_name
					--common.ShowMsg(set_name)
					v.do_func()
				end
			end
		end
	end)
	coroutine.resume(co)
end

-- UI显示回调 （widget_id = 0x10  可以识别 非法。。 弹窗， 游戏异常等等 PopUp_Common_Outgame_C 类的弹窗）
--[[call_back.OnShowWidget = function(widget_id)

	local co = coroutine.create(function()
		--  widget_id = 0x10 是弹出PopUp_Common_Outgame_C 挂件
		xxmsg(widget_id)
		if widget_id == 0x10 then
			sleep(100)  -- 必须要延时
			
			-- ui_unit.get_popup_info_text() PopUp_Common_Outgame_C 挂件里的内容
			local strTxt = ui_unit.get_popup_info_text()
			xxmsg(widget_id..'----'..strTxt)
			--16.0----由于登录时间超过24小时已自动退出登录。
			--为进行资格的证明，请重新登录。
			local PopUp_Common_Outgame_C = ui_unit.get_parent_widget('PopUp_Common_Outgame_C', true)
			local num = 0
			sleep(3000)
			while not is_terminated() do
				if PopUp_Common_Outgame_C ~= 0 then
					local CB_Close = ui_unit.get_child_widget(PopUp_Common_Outgame_C, 'CB_Close')
					if CB_Close ~= 0 then
						--ui_unit.common_widget_confirm()
						--ui_unit.btn_click(CB_Close)
						sleep(2000)
					end
					num = num + 1
					if num >= 20 then
						--main_ctx:end_game()
						break
					end
				else
					break
				end
				sleep(1000)
			end
			if string.find(strTxt ,'资格的证明') then
				main_ctx:end_game()
			end
			--处理同意条款 同意
			--if this.is_common_outgame("同意条款") then
			--	xxmsg("需要处理同意条款 确认")  --等待技术处理
			--
			--	local PopUp_Common_Outgame_C = ui_unit.get_parent_widget('PopUp_Common_Outgame_C', true)
			--	local num = 0
			--	sleep(3000)
			--	while decider.is_working() do
			--		if PopUp_Common_Outgame_C ~= 0 then
			--			local CB_Close = ui_unit.get_child_widget(PopUp_Common_Outgame_C, 'CB_Close')
			--
			--			if CB_Close ~= 0 then
			--				ui_unit.btn_click(CB_Close)
			--				sleep(2000)
			--			end
			--
			--			num = num + 1
			--			if num >= 20 then
			--				--main_ctx:end_game()
			--				break
			--			end
			--		else
			--			break
			--		end
			--		sleep(1000)
			--	end
			--	sleep(1000)
			--end

		end

	end)

	coroutine.resume(co)
end]]

-- 判断指定标题窗口
this.is_common_outgame = function(title)
	local ret = false

	--ui_unit.debug(0)
	local PopUp_Common_Outgame_C = ui_unit.get_parent_widget('PopUp_Common_Outgame_C', true)
	if PopUp_Common_Outgame_C ~= 0 then
		local Txt_Title = ui_unit.get_child_widget(PopUp_Common_Outgame_C, 'Txt_Title')
		local readTxt = ui_unit.get_txt_control_text(Txt_Title)
		xxmsg(readTxt)
		if readTxt == title then
			ret = true
		end
	end

	return ret

end
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
-- 实例化新对象

function call_back.__tostring()
    return "mir4 call_back package"
end

call_back.__index = call_back

function call_back:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   -- 设置元表
   return setmetatable(new, call_back)
end

-------------------------------------------------------------------------------------
-- 返回对象
return call_back:new()

-------------------------------------------------------------------------------------