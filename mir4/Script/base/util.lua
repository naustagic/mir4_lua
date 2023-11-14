-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   util
-- @email:    88888@qq.com 
-- @date:     2021-07-05
-- @module:   example
-- @describe: 杂类函数
-- @version:  v1.0
--

local VERSION = '20210705' -- version history at end of file
local AUTHOR_NOTE = "-[20210705]-"

local util = {  
	VERSION      = VERSION,
	AUTHOR_NOTE  = AUTHOR_NOTE,
}

local this = util

-------------------------------------------------------------------------------------
-- 判断列是否为空
function util:table_is_empty(t)
	local ret_b = false

	if t == nil then 
		ret_b = true
	elseif next(t) == nil then
		ret_b = true
	end

	return ret_b
end

-------------------------------------------------------------------------------------
-- 生成随机字符串
function util:get_random(n)
	if n == nil then
	   n = 8
	end
	local t = {
		"0","1","2","3","4","5","6","7","8","9",
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	} 
	math.randomseed(os.time())   
	local s = ""
	for i = 1, n do
		s = s .. t[math.random(#t)]        
	end
	
	return s
 end

 -------------------------------------------------------------------------------------
-- 实例化新对象

function util.__tostring()
    return "util module"
 end

 util.__index = util

function util:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   -- 设置元表
   return setmetatable(new, util)
end

-------------------------------------------------------------------------------------
-- 返回对象
return util:new()

-------------------------------------------------------------------------------------