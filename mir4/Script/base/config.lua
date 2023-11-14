-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
-- 
-- @author:   core
-- @email:    88888@qq.com 
-- @date:     2021-07-05
-- @module:   config
-- @describe: 远程配置文件读写
-- @version:  v1.0
--
-- 私有配置路径建议: 项目:IP或分组:帐号:XX
-- 公有配置路径建议: 项目:IP或分组:XX
-- 全局配置路径建议: 项目:XX 
--

local version = '20210705' -- version history at end of file
local author_note = "-[20210705]-"

local config = {
    version = version,
    author_note = author_note,
    server_ip = '127.0.0.1',
    server_port = 6379,
}

local this = config

local JSON = import('base/json')

-------------------------------------------------------------------------------------
-- 设置服务器
function config:set_server(ip, port)
    this.server_ip = ip
    this.server_port = port
end

-------------------------------------------------------------------------------------
-- 加载配置
function config:load(path)
    local data = {}
    if string.len(path) > 0 then
        local client = redis_unit.new()
        if client:connect(this.server_ip, this.server_port) then
            local json_text = client:get_string(path)
            if string.len(json_text) > 0 then
                --data = JSON:decode(json_text)
                data = json_unit.decode(json_text)
            end
        end  
        client:delete()
    end

    return data
end

-------------------------------------------------------------------------------------
-- 保存配置
function config:save(path, data)
    local save_ok = false
    local json_text = ""
    if string.len(path) > 0 then
        --json_text = JSON:encode(data)  
        json_text = json_unit.encode(data)          
    end
    if string.len(json_text) > 0 then
        local client = redis_unit.new()
        if client:connect(this.server_ip, this.server_port) then
            save_ok = client:set_string(path, json_text)
        end  
        client:delete()
    end

    return save_ok
end

-------------------------------------------------------------------------------------
-- 实例化新对象

function config.__tostring()
    return "config package"
 end

config.__index = config

function config:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   -- 设置元表
   return setmetatable(new, config)
end

-------------------------------------------------------------------------------------
-- 返回对象
return config:new()

-------------------------------------------------------------------------------------