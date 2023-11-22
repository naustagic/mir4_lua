-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-16
-- @module:   map_res 
-- @describe: 物品资源
-- @version:  v1.0


-------------------------------------------------------------------------------------
-- 任务模块资源
---@class map_res
local map_res = {
    MAP_LIST = {
        ['桃花谷'] = {
            ['海岸悬崖'] = { x = -7121, y = 9635, z = 8547 },

        },
        ['海岸悬崖'] = {
            ['桃花谷'] = { x = 1425, y = -12083, z = 1835 },
            ['银杏谷'] = { x = 6904, y = 11410, z = 1770 },
        },

        ['银杏谷'] = {
            ['海岸悬崖'] = { x = -18269, y = 21699, z = 1465 },
            ['虫洞'] = { x = -6064, y = -4731, z = 2372 },
            ['比奇城'] = { x = -16970, y = -19328, z = 3602 },
        },
        ['虫洞'] = {
            ['银杏谷'] = { x = -276, y = 5908, z = 3523 },
        },

        ['虫洞'] = {
            ['银杏谷'] = { x = -276, y = 5908, z = 3523 },
        },

        ['比奇城'] = {
            ['比奇城后巷'] = { x = -8077, y = 1436, z = 619 },
            ['比奇城龙会楼'] = { x = 3009, y = 4043, z = 664 },
            ['银杏谷'] = { x = -1360, y = 6273, z = 634 },
            ['对练场'] = { x = -7744, y = -10126, z = 619 },
            ['比奇县'] = { x = 5245, y = -10160, z = 619 },
        },
        ['对练场'] = {
            ['比奇城'] = { x = -10, y = -9143, z = 1390 },
        },
        ['比奇城龙会楼'] = {
            ['比奇城'] = { x = -391, y = 2715, z = 190 },
        },
        ['比奇城后巷'] = {
            ['比奇城城墙'] = { x = -1731, y = -25500, z = 134 },
            ['比奇城'] = { x = 8525, y = -67, z = 121 },
        },
        ['比奇城城墙'] = {
            ['比奇城后巷'] = { x = 5448, y = -7058, z = 2263 },
        },
        ['比奇县'] = {
            ['比奇城'] = { x = -16193, y = 3253, z = -20402 },
            ['半兽古墓1层'] = { x = 12357, y = -33725, z = -22263 },
            ['比奇迷宫1层'] = { x = 7420, y = -17778, z = -18350 },
            ['半兽人遗迹1层'] = { x = 7752, y = -6532, z = -19719 },
            ['比奇秘谷1层'] = { x = -28, y = -3084, z = -19373 },
            ['沃玛森林'] = { x = -32981, y = -24757, z = -18337 },
            ['蛇谷'] = { x = -14950, y = -33765, z = -18246 },
        },
        ['半兽古墓1层'] = {
            ['比奇县'] = { x = -42158, y = -7460, z = 1373 },
            ['半兽古墓2层'] = { x = -278, y = -19720, z = 2927 },
        },
        ['半兽古墓2层'] = {
            ['半兽古墓1层'] = { x = -17234, y = 11429, z = 900 },
            ['隐藏的悬崖路'] = { x = 21747, y = -6322, z = 2027 },
        },
        ['隐藏的悬崖路'] = {
            ['半兽古墓2层'] = { x = 9626, y = -388, z = 2049 },
            ['半兽人遗迹2层'] = { x = -6308, y = 1177, z = 1989 },
        },
        ['半兽人遗迹1层'] = {
            ['比奇县'] = { x = -17427, y = 9433, z = 2634 },
            ['半兽人遗迹2层'] = { x = 849, y = -10658, z = 6345 },

        },
        ['半兽人遗迹2层'] = {
            ['半兽人遗迹1层'] = { x = -12748, y = 11040, z = 1614 },
            ['隐藏的悬崖路'] = { x = 18043, y = -8218, z = 4180 },
        },

    },

    ESCAPE_POS = {
        ['银杏谷'] = { x = -707.82165527344, y = 16609.2265625, z = 2793.9150390625 }, --101003010.0
        ['【精英】比奇城后巷'] = { x = 7087.1684570312, y = 364.30081176758, z = 120.50633239746 }, --200022010.0
        ['比奇城后巷'] = { x = 5186.3310546875, y = 18.653163909912, z = 119.78861236572 }, --101003020.0
        ['比奇县'] = { x = -6891.7080078125, y = -18821.46484375, z = -20578.751953125 }, --101003030.0
        ['半兽古墓1层'] = { x = -39940.0, y = -7559.9921875, z = 1396.5418701172 }, --101004010.0
        ['【精英】半兽古墓1层'] = { x = -38944.65234375, y = -7525.0795898438, z = 1406.8366699219 }, --200022020.0
        ['半兽古墓2层'] = { x = -17492.66015625, y = 10365.904296875, z = 1098.7601318359 }, --101004020.0
        ['【精英】半兽古墓2层'] = { x = -16875.681640625, y = 10916.279296875, z = 978.07757568359 }, --200022021.0
        ['半兽人遗迹1层'] = { x = -14568.005859375, y = 5023.8505859375, z = 2694.5739746094 }, --101004030.0
        ['【精英】半兽人遗迹1层'] = { x = 1457.1284179688, y = -9252.9892578125, z = 6348.244140625 }, --200022030.0
        ['半兽人遗迹2层'] = { x = -12504.3203125, y = 9764.8330078125, z = 1604.6741943359 }, --101004040.0
        ['【精英】半兽人遗迹2层'] = { x = -12607.036132812, y = 9636.205078125, z = 1604.5798339844 }, --200022031.0
        ['沃玛森林'] = { x = -1692.5361328125, y = -20872.095703125, z = 6113.1220703125 }, --102003010.0
        ['牛魔神殿1层'] = { x = -17571.35546875, y = -4.7057991027832, z = 125.5525894165 }, --102004010.0
        ['牛魔神殿2层'] = { x = -903.79473876953, y = -17955.4765625, z = -1129.9959716797 }, --102004040.0
        ['牛魔神殿3层'] = { x = 25271.158203125, y = 18025.40234375, z = 343.12063598633 }, --102004070.0
        ['沃玛教主圣所'] = { x = -6533.8505859375, y = 1362.0697021484, z = -366.54193115234 }, --102005020.0
        ['【精英】牛魔神殿1层'] = { x = -17462.927734375, y = -125.68353271484, z = 125.5525894165 }, --200022040.0
        ['【精英】牛魔神殿2层'] = { x = 9147.55859375, y = 13702.62109375, z = 2137.0834960938 }, --200022041.0
        ['【精英】牛魔神殿3层'] = { x = -3528.689453125, y = 24.206792831421, z = 186.07928466797 }, --200022042.0

        ['蛇妖平原'] = { x = -19731.505859375, y = 20019.634765625, z = 803.52795410156 }, --103003070.0
        ['蛇谷'] = { x = -2330.7016601562, y = 8597.6689453125, z = -547.90203857422 }, --103003010.0
        ['绝命谷上方'] = { x = -14823.438476562, y = -2151.6364746094, z = 654.86553955078 }, --103003020.0
        ['绝命谷下方'] = { x = -16595.5234375, y = -11323.965820312, z = 2364.7604980469 }, --103003030.0

        ['比奇迷宫1层'] = { x = -100.28043365479, y = 19890.140625, z = 228.56121826172 }, --10010.0
        ['比奇迷宫2层'] = { x = -19490.447265625, y = 8025.8588867188, z = 777.17565917969 }, --10011.0
        ['比奇迷宫3层'] = { x = 194.58529663086, y = 19615.529296875, z = 228.44401550293 }, --10012.0
        ['比奇迷宫4层'] = { x = -18957.43359375, y = 107.61282348633, z = -462.41415405273 }, --10013.0

        ['牛魔迷宫1层'] = { x = 18663.916015625, y = 39.998485565186, z = 122.2772064209 }, --10020.0
        ['牛魔迷宫2层'] = { x = 7290.7001953125, y = -16343.588867188, z = 1639.2626953125 }, --10021.0
        ['牛魔迷宫3层'] = { x = 18586.09375, y = -6.1124086380005, z = 122.2772064209 }, --10022.0
        ['牛魔迷宫4层'] = { x = 55.861804962158, y = -18723.61328125, z = 922.27728271484 }, --10023.0

        ['比奇秘谷1层'] = { x = 24145.939453125, y = -3318.560546875, z = 2422.9387207031 }, --201003010.0
        ['比奇秘谷2层'] = { x = -13394.487304688, y = -11669.7265625, z = 1776.3208007812 }, --201003011.0
        ['比奇秘谷3层'] = { x = -15866.608398438, y = -12680.68359375, z = 2649.3439941406 }, --201003012.0
        ['比奇秘谷4层'] = { x = -12902.149414062, y = 21467.044921875, z = 542.52545166016 }, --201003013.0

        ['蛇谷迷宫1层'] = { x = 154.71792602539, y = -18666.220703125, z = 1011.6005249023 }, --10030.0
        ['蛇谷迷宫2层'] = { x = 20424.4765625, y = -3732.7836914062, z = 3144.8330078125 }, --10031.0
        ['蛇谷迷宫3层'] = { x = 65.482360839844, y = -18895.171875, z = 1011.6005249023 }, --10032.0
        ['蛇谷迷宫4层'] = { x = 19212.060546875, y = -67.004981994629, z = 122.27722930908 }, --10033.0

        ['桃花谷'] = { x = -1043.0399169922, y = -675.87884521484, z = 10047.016601562 }, --100002010.0
        ['海岸悬崖'] = { x = -1080.0, y = 1889.9995117188, z = 940.95904541016 }, --100002020.0
        ['仙界精灵村'] = { x = 554.78918457031, y = -965.17102050781, z = 4545.2275390625 }, --101003060.0

        ['比奇城龙会楼'] = { x = -470.75552368164, y = 553.83837890625, z = 118.2172164917 }, --101005020.0
        ['比奇城城墙'] = { x = 4215.3388671875, y = -7008.078125, z = 2260.3054199219 }, --101005040.0
        ['对练场'] = { x = -30.953508377075, y = -4625.2358398438, z = 1122.2772216797 }, --2021.0
        ['比奇城'] = { x = -1414.89453125, y = -10179.484375, z = 628.40277099609 }, --101001010.0
        ['虫洞'] = { x = 60.213436126709, y = 5374.541015625, z = 3525.5388183594 }, --101005010.0
        ['隐士谷'] = { x = -2679.6794433594, y = -1006.7475585938, z = 268.59796142578 }, --103003040.0
        ['沃玛山'] = { x = 275.21569824219, y = -7841.4213867188, z = 361.93692016602 }, --102004050.0
        ['修炼洞穴'] = { x = 7183.529296875, y = -4169.158203125, z = 2941.2680664062 }, --103003060.0
        ['蛇洞'] = { x = 155.36917114258, y = -843.37646484375, z = 1983.7839355469 }, --103004010.0
    },
    -- 通过地图ID获取地图名称
    GET_MAP_NAME = {
        [101003010.0] = '银杏谷',
        [200022010] = '【精英】比奇城后巷',
        [101003020] = '比奇城后巷',
        [101003030] = '比奇县',
        [101004010] = '半兽古墓1层',
        [200022020] = '【精英】半兽古墓1层',
        [101004020] = '半兽古墓2层',
        [200022021] = '【精英】半兽古墓2层',
        [101004030] = '半兽人遗迹1层',
        [200022030] = '【精英】半兽人遗迹1层',
        [101004040] = '半兽人遗迹2层',
        [200022031] = '【精英】半兽人遗迹2层',
        [102003010] = '沃玛森林',
        [102004010] = '牛魔神殿1层',
        [102004040] = '牛魔神殿2层',
        [102004070] = '牛魔神殿3层',
        [102005020] = '沃玛教主圣所',
        [200022040] = '【精英】牛魔神殿1层',
        [200022041] = '【精英】牛魔神殿2层',
        [200022042] = '【精英】牛魔神殿3层',
        [103003070] = '蛇妖平原',
        [103003010] = '蛇谷',
        [103003020] = '绝命谷上方',
        [103003030] = '绝命谷下方',
        [10010] = '比奇迷宫1层',
        [10011] = '比奇迷宫2层',
        [10012] = '比奇迷宫3层',
        [10013] = '比奇迷宫4层',
        [10020] = '牛魔迷宫1层',
        [10021] = '牛魔迷宫2层',
        [10022] = '牛魔迷宫3层',
        [10023] = '牛魔迷宫4层',
        [201003010.0] = '比奇秘谷1层',
        [201003011.0] = '比奇秘谷2层',
        [201003012.0] = '比奇秘谷3层',
        [201003013.0] = '比奇秘谷4层',
        [10030.0] = '蛇谷迷宫1层',
        [10031.0] = '蛇谷迷宫2层',
        [10032.0] = '蛇谷迷宫3层',
        [10033.0] = '蛇谷迷宫4层',
        [100002010.0] = '桃花谷',
        [100002020.0] = '海岸悬崖',
        [101003060.0] = '仙界精灵村',
        [101005020.0] = '比奇城龙会楼',
        [101005040.0] = '比奇城城墙',
        [2021.0] = '对练场',
        [101001010.0] = '比奇城',
        [101005010.0] = '虫洞',
        [103003040.0] = '隐士谷',
        [102004050.0] = '沃玛山',
        [103003060.0] = '修炼洞穴',
        [103004010.0] = '蛇洞',
    },
    -- 通过地图名称获取地图ID
    GET_MAP_ID = {
        ['银杏谷'] = 101003010.0,
        ['【精英】比奇城后巷'] = 200022010.0,
        ['比奇城后巷'] = 101003020.0,
        ['比奇县'] = 101003030.0,
        ['半兽古墓1层'] = 101004010.0,
        ['【精英】半兽古墓1层'] = 200022020.0,
        ['半兽古墓2层'] = 101004020.0,
        ['【精英】半兽古墓2层'] = 200022021.0,
        ['半兽人遗迹1层'] = 101004030.0,
        ['【精英】半兽人遗迹1层'] = 200022030.0,
        ['半兽人遗迹2层'] = 101004040.0,
        ['【精英】半兽人遗迹2层'] = 200022031.0,
        ['沃玛森林'] = 102003010.0,
        ['牛魔神殿1层'] = 102004010.0,
        ['牛魔神殿2层'] = 102004040.0,
        ['牛魔神殿3层'] = 102004070.0,
        ['沃玛教主圣所'] = 102005020.0,
        ['【精英】牛魔神殿1层'] = 200022040.0,
        ['【精英】牛魔神殿2层'] = 200022041.0,
        ['【精英】牛魔神殿3层'] = 200022042.0,
        ['蛇妖平原'] = 103003070.0,
        ['蛇谷'] = 103003010.0,
        ['绝命谷上方'] = 103003020.0,
        ['绝命谷下方'] = 103003030.0,
        ['比奇迷宫1层'] = 10010.0,
        ['比奇迷宫2层'] = 10011.0,
        ['比奇迷宫3层'] = 10012.0,
        ['比奇迷宫4层'] = 10013.0,
        ['牛魔迷宫1层'] = 10020.0,
        ['牛魔迷宫2层'] = 10021.0,
        ['牛魔迷宫3层'] = 10022.0,
        ['牛魔迷宫4层'] = 10023.0,
        ['比奇秘谷1层'] = 201003010.0,
        ['比奇秘谷2层'] = 201003011.0,
        ['比奇秘谷3层'] = 201003012.0,
        ['比奇秘谷4层'] = 201003013.0,
        ['蛇谷迷宫1层'] = 10030.0,
        ['蛇谷迷宫2层'] = 10031.0,
        ['蛇谷迷宫3层'] = 10032.0,
        ['蛇谷迷宫4层'] = 10033.0,
        ['桃花谷'] = 100002010.0,
        ['海岸悬崖'] = 100002020.0,
        ['仙界精灵村'] = 101003060.0,
        ['比奇城龙会楼'] = 101005020.0,
        ['比奇城城墙'] = 101005040.0,
        ['对练场'] = 2021.0,
        ['比奇城'] = 101001010.0,
        ['虫洞'] = 101005010.0,
        ['隐士谷'] = 103003040.0,
        ['沃玛山'] = 102004050.0,
        ['修炼洞穴'] = 103003060.0,
        ['蛇洞'] = 103004010.0,
    },
    -- 地图逃跑点
    ESCAPE_POS_LIST = {
        ['秘境峰1层'] = {
            ['官兵军营'] = { x = 10988.930664062, y = 13864.989257812, z = 167.99411010742 },
            ['讨伐队的野营地'] = { x = 10606.796875, y = -13038.228515625, z = 163.28619384766 },
            ['追踪队的野营地'] = { x = -13877.546875, y = -12834.091796875, z = 173.31210327148 },
            ['官兵哨所'] = { x = -5292.4858398438, y = 14427.268554688, z = 76.233024597168 },
        },
    }

}

local this = map_res





-------------------------------------------------------------------------------------
-- 返回对象
return map_res

-------------------------------------------------------------------------------------