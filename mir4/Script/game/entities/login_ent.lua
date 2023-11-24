------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   zengluolu
--- @email:    1819@qq.com
--- @date:     2023-10-16
--- @module:   login_ent
--- @describe: 登录模块
--- @version:  v1.0
------------------------------------------------------------------------------------
local VERSION = '20231016' -- version history at end of file
local AUTHOR_NOTE = '-[20231016]-'
-- 模块定义
---@class login_ent
local login_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = VERSION,
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = AUTHOR_NOTE,
    -- 模块名称
    MODULE_NAME = 'login_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = login_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local login_unit = login_unit
local game_unit = game_unit
local ui_unit = ui_unit
local role_unit = role_unit
local main_ctx = main_ctx
---@type login_res
local login_res = import('game/resources/login_res')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function login_ent.super_preload()

end

-- 谷歌登录
function login_ent.google_login()
    local Popup_NewAccount_C = ui_unit.get_parent_widget('Popup_NewAccount_C', true)
    --在登录后选择服务器界面 不再进入google登录
    if Popup_NewAccount_C ~= 0 then
        login_unit.open_google_login()
        decider.sleep(5000)  --避免重复进入google账户登入界面 此时status 仍为-1
        for i = 1, 100 do
            local Popup_TermsOfService_C = ui_unit.get_parent_widget('Popup_TermsOfService_C', true)
            if Popup_TermsOfService_C ~= 0 then
                break
            end
            trace.output("[登录] - 等待google登录：[" .. i .. "/100]秒")
            decider.sleep(1000)
        end
    end
end

------------------------------------------------------------------------------------
---全选协议
function login_ent.select_all()
    while decider.is_working() do
        local Popup_TermsOfService_C = ui_unit.get_parent_widget('Popup_TermsOfService_C', true)
        if Popup_TermsOfService_C ~= 0 then
            local Btn_SelectAll = ui_unit.get_child_widget(Popup_TermsOfService_C, 'Btn_SelectAll')
            if Btn_SelectAll ~= 0 then
                trace.output("[登录] - 协议>点击全选按钮")
                ui_unit.btn_click(Btn_SelectAll)--按钮点击
                decider.sleep(2000)
            end
            local Btn_Agree = ui_unit.get_child_widget(Popup_TermsOfService_C, 'Btn_Agree')
            if Btn_Agree ~= 0 then
                trace.output("[登录] - 协议>点击确认按钮")
                ui_unit.btn_click(Btn_Agree)
                decider.sleep(2000)
            end
        else
            break
        end
        decider.sleep(1000)
    end
end

------------------------------------------------------------------------------------
---选择日期
function login_ent.select_date()
    while decider.is_working() do
        local Popup_PersonalInfo_C = ui_unit.get_parent_widget('Popup_PersonalInfo_C', true)
        if Popup_PersonalInfo_C ~= 0 then
            trace.output("[登录] - 生日>生日日期验证中...")
            game_unit.set_personal_info(1990 + math.random(1, 10))
            decider.sleep(2000)
            ui_unit.common_widget_confirm()
            decider.sleep(2000)
        else
            break
        end
        decider.sleep(2000)
    end
end

------------------------------------------------------------------------------------
---选择服务器
function login_ent.select_server()
    local server_line = main_ctx:c_server_line()
    local server_name = main_ctx:c_server_name()
    if server_name == 'EU72' then
        server_line = 'EU1'
    elseif server_name == 'NA122' then
        server_line = 'NA1'
    elseif server_name == 'SA93' then
        server_line = 'SA2'
    end
    while decider.is_working() do
        if game_unit.get_cur_server_name() == server_name then
            -- 选择服务器
            break
        end
        if ui_unit.get_parent_widget('Popup_NewAccount_C', true) ~= 0 then
            break
        end
        local server_id = login_unit.get_world_id_byname(server_name)-- 服务器名称取服务器ID
        if server_id ~= -1 then
            login_unit.select_world(server_id)-- 同一大区选择服务器
            decider.sleep(3000)
        else
            if login_unit.get_last_server() ~= server_line then
                -- 取当前连接大区U8
                login_unit.connect_server(server_line)-- 连接游戏大区
                decider.sleep(3000)
                this.wait_connect_server()
            end
        end
        decider.sleep(2000)
    end
    game_unit.click_btn_screen()--点击画面
end

------------------------------------------------------------------------------------
---等待服务器连接完成
function login_ent.wait_connect_server()
    while decider.is_working() do
        if ui_unit.get_parent_widget('Connecting_Login_C', true) == 0 then
            break
        end
        if ui_unit.get_parent_widget('Popup_NewAccount_C', true) ~= 0 then
            break
        end
        decider.sleep(3000)
    end
end

------------------------------------------------------------------------------------
---选择角色
function login_ent.select_char()
    local job = 4
    local num = 0
    local name = ""
    while decider.is_working() do
        num = num + 1
        if login_res.STATUS_CHARACTER_SELECT == game_unit.game_status_ex() then
            break
        end
        if num >= 3 then
            break
        end
        name = login_res.get_player_name()
        if this.select_race(job) then
            role_unit.enter_create_page()-- 进入创建角色
        end
        if this.create_char() then
            role_unit.create_char(name, job)-- 创建角色
            decider.sleep(2000)
        end
        decider.sleep(1000)
    end
end

------------------------------------------------------------------------------------
---选择角色
function login_ent.select_char_in_game()
    role_unit.enter(0)--选择角色，进入游戏
    decider.sleep(3000)
end

------------------------------------------------------------------------------------
---选择职业
function login_ent.select_race(job)
    local retB = true
    while decider.is_working() do
        if role_unit.get_cur_select_race() == job then
            break
        end
        if game_unit.game_status() ~= 2 then
            retB = false
        end
        role_unit.select_class(job)
        decider.sleep(1000)
    end
    return retB
end


------------------------------------------------------------------------------------
---创建角色
function login_ent.create_char()
    while decider.is_working() do
        if game_unit.game_status() == 4 then
            break
        end
        decider.sleep(1000)
    end
    return true
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function login_ent.__tostring()
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
function login_ent.__newindex(t, k, v)
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
login_ent.__index = login_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function login_ent:new(args)
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
    return setmetatable(new, login_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return login_ent:new()

-------------------------------------------------------------------------------------
