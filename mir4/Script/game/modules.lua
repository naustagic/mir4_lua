-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-15
-- @module:   modules
-- @describe: 模块列表(所有引用模块都从这个模块统一载入)
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
-- 回调模块
_G.call_back        =  import('example/call_back')

-------------------------------------------------------------------------------------
-- 功能模块
local module_list = {
   -- 登陆模块
   import('game/modules/login'),

  -- -- 主线模块
  -- import('game/modules/main_quest'),
  -- -- 支线模块
  -- import('game/modules/main_quest'),
  -- import('game/modules/side_quest'),
  -- import('game/modules/mf_fb'),
  -- import('game/modules/weituo_quest'),
  --
  --  import('game/modules/gather_quest'),
  --import('game/modules/gather'),
   import('game/modules/hunt'),
   --import('game/modules/secret'),


}

-------------------------------------------------------------------------------------
-- 返回对象
return module_list

-------------------------------------------------------------------------------------