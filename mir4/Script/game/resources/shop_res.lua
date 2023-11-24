-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-16
-- @module:   shop_res 
-- @describe: 物品资源
-- @version:  v1.0


-------------------------------------------------------------------------------------
-- 任务模块资源
---@class shop_res
local shop_res = {
    MERCHANT = {
        ['比奇城'] = {
            ['药水商人'] = { map_id = 101001010.0, map_name = '比奇城', npc_pos = { x = -4341.5791015625, y = -8515.2548828125, z = 618.89508056641 }, npc_name = '杨振方',
                             items = {
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             } },
            ['仓库'] = { map_id = 101001010.0, map_name = '比奇城', npc_pos = { x = -4880.9790039062, y = -8502.146484375, z = 618.89508056641 }, npc_name = '莫善', },
            ['杂货商人'] = { map_id = 101001010.0, map_name = '比奇城', npc_pos = { x = 2008.9112548828, y = -8465.9599609375, z = 618.89508056641 }, npc_name = '徐文锦',
                             items = {
                                 ["瞬移卷轴"] = { item_id = 0x1312EB1, shop_id = 0x13A6, price = 200 },
                             }
            },
        },

        ['银杏谷'] = {
            ['药水商人'] = { map_id = 101003010.0, map_name = '银杏谷', npc_pos = { x = -2756.7097167969, y = 16526.630859375, z = 2809.2583007812 }, npc_name = '在元',
                             items = {
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             } },
            ['杂货商人'] = { map_id = 101003010.0, map_name = '银杏谷', npc_pos = { x = -296.767578125, y = 17439.810546875, z = 2829.9118652344 }, npc_name = '木山',
                             items = {
                                 ["瞬移卷轴"] = { item_id = 0x1312EB1, shop_id = 0x13A6, price = 200 },
                             } },
        },
        ['比奇城龙会楼'] = {
            ['酒商'] = { map_id = 101005020.0, map_name = '比奇城龙会楼', npc_pos = { x = 1732.6232910156, y = 268.61938476562, z = 1074.3363037109 }, npc_name = '雪兰',
                         items = {
                             ["花酒"] = { item_id = 0x1312ECD, shop_id = 0x838, price = 1000 },
                         }
            },
        },
        ['比奇县'] = {
            ['药水商人'] = { map_id = 101003030.0, map_name = '比奇县', npc_pos = { x = -6086.8041992188, y = -18798.2421875, z = -20579.068359375,  },npc_name = '再奎',
                             items = {
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             } },
            ['杂货商人'] = { map_id = 101003030.0, map_name = '比奇县', npc_pos = { x = -7524.2182617188, y = -18662.1953125, z = -20578.818359375 }, npc_name = '万都',
                             items = {
                                 ["瞬移卷轴"] = { item_id = 0x1312EB1, shop_id = 0x13A6, price = 200 },
                             } },
        },
        ['沃玛森林'] = {
            ['药水商人'] = { map_id = 102003010.0, map_name = '沃玛森林', npc_pos = { x = -1429.0, y = -22066.19140625, z = 6160.1767578125 }, npc_name = '毛容秋',
                             items = {
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             } },
            ['杂货商人'] = { map_id = 102003010.0, map_name = '沃玛森林', npc_pos = { x = -921.66827392578, y = -21860.845703125, z = 6171.763671875 }, npc_name = '润伯',
                             items = {
                                 ["瞬移卷轴"] = { item_id = 0x1312EB1, shop_id = 0x13A6, price = 200 },
                             } },
        },
        ['蛇谷'] = {
            ['药水商人'] = { map_id = 103003010.0, map_name = '蛇谷', npc_pos = { x = -5824.0146484375, y = 9802.814453125, z = -512.80493164062 }, npc_name = '陈良宇',
                             items = {
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             } },
            ['杂货商人'] = { map_id = 103003010.0, map_name = '蛇谷', npc_pos = { x = -2400.669921875, y = 7880.65625, z = -533.92657470703 }, npc_name = '墨宪',
                             items = {
                                 ["瞬移卷轴"] = { item_id = 0x1312EB1, shop_id = 0x13A6, price = 200 },
                             } },
            ['仓库'] = { map_id = 103003010.0, map_name = '蛇谷', npc_pos = { x = -6209.0375976562, y = 9652.6689453125, z = -502.78601074219 }, npc_name = '莫善', },
        },
        ['【精英】半兽古墓2层'] = {
            ['包袱商人'] = { map_id = 200022021.0, map_name = '【精英】半兽古墓2层', npc_pos = { x = -16819.31640625, y = 10876.705078125, z = 991.71539306641 }, npc_name = '秋药东',
                             items = {
                                 ["【秋药东】的杂物箱"] = { item_id = 0x1312ED0, shop_id = 0x83C, price = 675 },
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             }
            },
        },
        ['魔方阵'] = {
            ['药水商人'] = { map_id = 201300101.0, map_name = '魔方阵', npc_pos = { x = -1047.3820800781, y = -3870.0229492188, z = -1532.7946777344 }, npc_name = '魔方阵管理人',
                             items = {
                                 ["小型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型生命值恢复药水"] = { item_id = 0x1312E9D, shop_id = 0x1388, price = 30 },
                                 ["大型生命值恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["小型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                                 ["中型魔力恢复药水"] = { item_id = 0x1312EA0, shop_id = 0x1388, price = 12 },
                                 ["大型魔力恢复药水"] = { item_id = 0, shop_id = 0, price = 0 },
                             } },


        }


    },

    -- 附近的npc
    NEAR_NPC = {
        ['药水商人'] = {
            ['银杏谷'] = '银杏谷',
            ['【精英】比奇城后巷'] = '比奇城',
            ['比奇城后巷'] = '比奇城',
            ['比奇县'] = '比奇县',
            ['半兽古墓1层'] = '【精英】半兽古墓2层',
            ['【精英】半兽古墓1层'] = '【精英】半兽古墓2层',
            ['半兽古墓2层'] = '【精英】半兽古墓2层',
            ['【精英】半兽古墓2层'] = '【精英】半兽古墓2层',
            ['半兽人遗迹1层'] = '比奇县',
            ['【精英】半兽人遗迹1层'] = '比奇县',
            ['半兽人遗迹2层'] = '比奇县',
            ['【精英】半兽人遗迹2层'] = '比奇县',
            ['沃玛森林'] = '沃玛森林',
            ['牛魔神殿1层'] = '沃玛森林',
            ['牛魔神殿2层'] = '沃玛森林',
            ['牛魔神殿3层'] = '沃玛森林',
            ['沃玛教主圣所'] = '沃玛森林',
            ['【精英】牛魔神殿1层'] = '沃玛森林',
            ['【精英】牛魔神殿2层'] = '沃玛森林',
            ['【精英】牛魔神殿3层'] = '沃玛森林',
            ['蛇妖平原'] = '蛇谷',
            ['蛇谷'] = '蛇谷',
            ['绝命谷上方'] = '蛇谷',
            ['绝命谷下方'] = '蛇谷',
            ['比奇迷宫1层'] = '比奇县',
            ['比奇迷宫2层'] = '比奇县',
            ['比奇迷宫3层'] = '比奇县',
            ['比奇迷宫4层'] = '比奇县',
            ['牛魔迷宫1层'] = '沃玛森林',
            ['牛魔迷宫2层'] = '沃玛森林',
            ['牛魔迷宫3层'] = '沃玛森林',
            ['牛魔迷宫4层'] = '沃玛森林',
            ['比奇秘谷1层'] = '比奇县',
            ['比奇秘谷2层'] = '比奇县',
            ['比奇秘谷3层'] = '比奇县',
            ['比奇秘谷4层'] = '比奇县',
            ['蛇谷迷宫1层'] = '蛇谷',
            ['蛇谷迷宫2层'] = '蛇谷',
            ['蛇谷迷宫3层'] = '蛇谷',
            ['蛇谷迷宫4层'] = '蛇谷',
            ['仙界精灵村'] = '比奇县',
            ['比奇城龙会楼'] = '比奇城',
            ['比奇城'] = '比奇城',
            ['虫洞'] = '银杏谷',
            ['隐士谷'] = '沃玛森林',
            ['沃玛山'] = '沃玛森林',
            ['修炼洞穴'] = '沃玛森林',
            ['蛇洞'] = '蛇谷',
        },
        ['杂货商人'] = {
            ['银杏谷'] = '银杏谷',
            ['【精英】比奇城后巷'] = '比奇城',
            ['比奇城后巷'] = '比奇城',
            ['比奇县'] = '比奇县',
            ['半兽古墓1层'] = '比奇县',
            ['【精英】半兽古墓1层'] = '比奇县',
            ['半兽古墓2层'] = '比奇县',
            ['【精英】半兽古墓2层'] = '比奇县',
            ['半兽人遗迹1层'] = '比奇县',
            ['【精英】半兽人遗迹1层'] = '比奇县',
            ['半兽人遗迹2层'] = '比奇县',
            ['【精英】半兽人遗迹2层'] = '比奇县',
            ['沃玛森林'] = '沃玛森林',
            ['牛魔神殿1层'] = '沃玛森林',
            ['牛魔神殿2层'] = '沃玛森林',
            ['牛魔神殿3层'] = '沃玛森林',
            ['沃玛教主圣所'] = '沃玛森林',
            ['【精英】牛魔神殿1层'] = '沃玛森林',
            ['【精英】牛魔神殿2层'] = '沃玛森林',
            ['【精英】牛魔神殿3层'] = '沃玛森林',
            ['蛇妖平原'] = '蛇谷',
            ['蛇谷'] = '蛇谷',
            ['绝命谷上方'] = '蛇谷',
            ['绝命谷下方'] = '蛇谷',
            ['比奇迷宫1层'] = '比奇县',
            ['比奇迷宫2层'] = '比奇县',
            ['比奇迷宫3层'] = '比奇县',
            ['比奇迷宫4层'] = '比奇县',
            ['牛魔迷宫1层'] = '沃玛森林',
            ['牛魔迷宫2层'] = '沃玛森林',
            ['牛魔迷宫3层'] = '沃玛森林',
            ['牛魔迷宫4层'] = '沃玛森林',
            ['比奇秘谷1层'] = '比奇县',
            ['比奇秘谷2层'] = '比奇县',
            ['比奇秘谷3层'] = '比奇县',
            ['比奇秘谷4层'] = '比奇县',
            ['蛇谷迷宫1层'] = '蛇谷',
            ['蛇谷迷宫2层'] = '蛇谷',
            ['蛇谷迷宫3层'] = '蛇谷',
            ['蛇谷迷宫4层'] = '蛇谷',
            ['仙界精灵村'] = '比奇县',
            ['比奇城龙会楼'] = '比奇城',
            ['比奇城'] = '比奇城',
            ['虫洞'] = '银杏谷',
            ['隐士谷'] = '沃玛森林',
            ['沃玛山'] = '沃玛森林',
            ['修炼洞穴'] = '沃玛森林',
            ['蛇洞'] = '蛇谷',
        },


    },


}

local this = shop_res

-- 获取最近的商人
function shop_res.get_near_npc_info(map_name, merchant_type)
    local npc_info = {}
    if merchant_type == '杂货商人' or '药水商人' == merchant_type then
        local move_map = this.NEAR_NPC[merchant_type][map_name]

        if move_map then
            if '【精英】半兽古墓2层' == move_map then
                merchant_type = '包袱商人'
            end
            npc_info = this.MERCHANT[move_map][merchant_type]
        end
    elseif merchant_type == '酒商' then
        npc_info = this.MERCHANT['比奇城龙会楼'][merchant_type]
    elseif merchant_type == '包袱商人' then
        npc_info = this.MERCHANT['【精英】半兽古墓2层'][merchant_type]
    end
    return npc_info
end


-------------------------------------------------------------------------------------
-- 返回对象
return shop_res

-------------------------------------------------------------------------------------