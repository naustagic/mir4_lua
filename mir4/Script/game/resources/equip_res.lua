-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-16
-- @module:   equip_res 
-- @describe: 物品资源
-- @version:  v1.0


-------------------------------------------------------------------------------------
-- 任务模块资源
---@class equip_res
local equip_res = {
    EQUIP_INFO = {
        ['武器'] = { pos = 1, [2] = '龙角弓', [3] = '月光弩' },
        ['副手'] = { pos = 9,[2] = '金刚木箭筒', [3] = '月光箭筒' },

        ['上衣'] = { pos = 5,[2] = '密影衣上衣', [3] = '镇魂巫服上衣' },
        ['下装'] = { pos = 6, [2] = '密影衣下衣', [3] = '镇魂巫服下衣' },

        ['手套'] = { pos = 7, [2] = '密影衣手套', [3] = '镇魂巫服手套' },
        ['鞋子'] = { pos = 8, [2] = '密影衣鞋靴', [3] = '镇魂巫服鞋靴' },

        ['项链'] = { pos = 2, [2] = '神灵项链', [3] = '月光项链' },
        ['手环'] = { pos = 3, [2] = '神灵手环', [3] = '月光手环' },

        ['指环'] = { pos = 4, [2] = '神灵指环', [3] = '月光指环' },
        ['耳环'] = { pos = 10,[2] = '神灵耳环', [3] = '月光耳环' },

    },
    BUILD_EQUIP_LIST = {
        -- 武器  角弓 牛角弓 铁角弓 龙角弓    迷离弓 八极迷离弓 赤月弩 月光弩
        -- 箭筒 竹箭筒 铁木箭筒 金刚木箭筒    迷离箭筒 八极箭筒 赤月箭筒 月光箭筒

        -- 丝绸衣上衣 残影衣上衣 阴影衣上衣 密影衣上衣 鬼灵巫服上衣 鬼魂巫服上衣 白莲巫服上衣 镇魂巫服上衣
        -- 丝绸衣下衣 残影衣下衣 阴影衣下衣 密影衣下衣 鬼灵巫服下衣 鬼魂巫服下衣 白莲巫服下衣 镇魂巫服下衣

        -- 丝绸衣手套 残影衣手套 阴影衣手套 密影衣手套 鬼灵巫服手套 鬼魂巫服手套 白莲巫服手套 镇魂巫服手套
        -- 丝绸衣鞋靴 残影衣鞋靴 阴影衣鞋靴 密影衣鞋靴 鬼灵巫服鞋靴 鬼魂巫服鞋靴 白莲巫服鞋靴 镇魂巫服鞋靴

        -- 无我项链 无心项链 罗汉项链 神灵项链 猛攻项链 护身项链 金刚项链 月光项链
        -- 无我手环 无心手环 罗汉手环 神灵手环 猛攻手环 护身手环 金刚手环 月光手环

        -- 无我指环 无心指环 罗汉指环 神灵指环 猛攻指环 护身指环 金刚指环 月光指环
        -- 无我耳环 无心耳环 罗汉耳环 神灵耳环 猛攻耳环 护身耳环 金刚耳环 月光耳环


        -- 武器
        ['月光弩'] = { equip_name = '赤月弩', money = 200000, heitie = 25000, make_id = 0x00DBBA10 },
        ['赤月弩'] = { equip_name = '八极迷离弓', money = 150000, heitie = 20000, make_id = 0x00DBBA0E },
        ['八极迷离弓'] = { equip_name = '迷离弓', money = 100000, heitie = 15000, make_id = 0x00DBBA0C },
        ['迷离弓'] = { stuff1 = { name = '稀有钢铁', num = 75 }, stuff2 = { name = '稀有邪念珠', num = 25 }, stuff3 = { name = '稀有月阴石', num = 25 }, stuff4 = { name = '稀有龙鳞', num = 1 }, money = 50000, heitie = 10000, make_id = 0xDBBA0A, make_type = 2 },
        ['龙角弓'] = { equip_name = '铁角弓', money = 15000, heitie = 4000, make_id = 0xDBBA07 },
        ['铁角弓'] = { equip_name = '牛角弓', money = 10000, heitie = 3000, make_id = 0xDBBA05 },
        ['牛角弓'] = { equip_name = '角弓', money = 5000, heitie = 2000, make_id = 0xDBBA03 },
        ['角弓'] = { stuff1 = { name = '高级钢铁', num = 40 }, stuff2 = { name = '高级邪念珠', num = 4 }, stuff3 = { name = '高级月阴石', num = 1 }, stuff4 = { name = '高级龙鳞', num = 1 }, money = 1000, heitie = 1000, make_id = 0xD72621, make_type = 1 },

        -- 箭筒
        ['箭筒'] = { stuff1 = { name = '高级钢铁', num = 40 }, stuff2 = { name = '高级邪念珠', num = 4 }, stuff3 = { name = '高级月阴石', num = 1 }, stuff4 = { name = '高级龙爪', num = 1 }, money = 1000, heitie = 1000, make_id = 0x00D72A09, make_type = 1 },
        ['竹箭筒'] = { equip_name = '箭筒', money = 5000, heitie = 2000, make_id = 0x00DBBDEB },
        ['铁木箭筒'] = { equip_name = '竹箭筒', money = 10000, heitie = 10000, make_id = 0x00DBBDED },
        ['金刚木箭筒'] = { equip_name = '铁木箭筒', money = 15000, heitie = 15000, make_id = 0x00DBBDEF },
        ['迷离箭筒'] = { stuff1 = { name = '稀有钢铁', num = 75 }, stuff2 = { name = '稀有邪念珠', num = 25 }, stuff3 = { name = '稀有月阴石', num = 25 }, stuff4 = { name = '稀有龙爪', num = 1 }, money = 50000, heitie = 50000, make_id = 0x00DBBDF1, make_type = 2 },
        ['八极箭筒'] = { equip_name = '迷离箭筒', money = 100000, heitie = 100000, make_id = 0x00DBBDF3 },
        ['赤月箭筒'] = { equip_name = '八极箭筒', money = 150000, heitie = 150000, make_id = 0x00DBBDF5 },
        ['月光箭筒'] = { equip_name = '赤月箭筒', money = 200000, heitie = 200000, make_id = 0x00DBBDF7 },
        --上衣
        ['丝绸衣上衣'] = { stuff1 = { name = '高级钢铁', num = 20 }, stuff2 = { name = '高级武魂', num = 2 }, stuff3 = { name = '高级伏魔神珠', num = 1 }, stuff4 = { name = '高级龙皮', num = 1 }, money = 500, heitie = 500, make_id = 0x0174509F, make_type = 1 },
        ['残影衣上衣'] = { equip_name = '丝绸衣上衣', money = 2500, heitie = 1000, make_id = 0x017450A1 },
        ['阴影衣上衣'] = { equip_name = '残影衣上衣', money = 5000, heitie = 1500, make_id = 0x017450A3 },
        ['密影衣上衣'] = { equip_name = '阴影衣上衣', money = 7500, heitie = 2000, make_id = 0x017450A5 },
        ['鬼灵巫服上衣'] = { stuff1 = { name = '稀有钢铁', num = 75 }, stuff2 = { name = '稀有武魂', num = 4 }, stuff3 = { name = '稀有伏魔神珠', num = 1 }, stuff4 = { name = '稀有龙皮', num = 1 }, money = 25000, heitie = 5000, make_id = 0X017450A8, make_type = 2 },
        ['鬼魂巫服上衣'] = { equip_name = '鬼灵巫服上衣', money = 50000, heitie = 7500, make_id = 0x017450AA },
        ['白莲巫服上衣'] = { equip_name = '鬼魂巫服上衣', money = 75000, heitie = 10000, make_id = 0x017450AC },
        ['镇魂巫服上衣'] = { equip_name = '白莲巫服上衣', money = 100000, heitie = 12500, make_id = 0x017450AE },
        --下衣
        ['丝绸衣下衣'] = { stuff1 = { name = '高级钢铁', num = 20 }, stuff2 = { name = '高级武魂', num = 2 }, stuff3 = { name = '高级伏魔神珠', num = 1 }, stuff4 = { name = '高级龙皮', num = 1 }, money = 500, heitie = 500, make_id = 0x017450BD, make_type = 1 },
        ['残影衣下衣'] = { equip_name = '丝绸衣下衣', money = 2500, heitie = 1000, make_id = 0x017450BF },
        ['阴影衣下衣'] = { equip_name = '残影衣下衣', money = 5000, heitie = 1500, make_id = 0x017450C1 },
        ['密影衣下衣'] = { equip_name = '阴影衣下衣', money = 7500, heitie = 2000, make_id = 0x017450C3 },
        ['鬼灵巫服下衣'] = { stuff1 = { name = '稀有钢铁', num = 75 }, stuff2 = { name = '稀有武魂', num = 4 }, stuff3 = { name = '稀有伏魔神珠', num = 1 }, stuff4 = { name = '稀有龙皮', num = 1 }, money = 25000, heitie = 5000, make_id = 0x017450C6, make_type = 2 },
        ['鬼魂巫服下衣'] = { equip_name = '鬼灵巫服下衣', money = 50000, heitie = 7500, make_id = 0x017450C8 },
        ['白莲巫服下衣'] = { equip_name = '鬼魂巫服下衣', money = 75000, heitie = 10000, make_id = 0x017450CA },
        ['镇魂巫服下衣'] = { equip_name = '白莲巫服下衣', money = 100000, heitie = 12500, make_id = 0x017450CC },
        -- 手套
        ['丝绸衣手套'] = { stuff1 = { name = '高级钢铁', num = 20 }, stuff2 = { name = '高级武魂', num = 2 }, stuff3 = { name = '高级伏魔神珠', num = 1 }, stuff4 = { name = '高级龙皮', num = 1 }, money = 500, heitie = 500, make_id = 0x020CE75B, make_type = 1 },
        ['残影衣手套'] = { equip_name = '丝绸衣手套', money = 2500, heitie = 1000, make_id = 0x020CE75D },
        ['阴影衣手套'] = { equip_name = '残影衣手套', money = 5000, heitie = 1500, make_id = 0x020CE75F },
        ['密影衣手套'] = { equip_name = '阴影衣手套', money = 7500, heitie = 2000, make_id = 0x020CE761 },
        ['鬼灵巫服手套'] = { stuff1 = { name = '稀有钢铁', num = 75 }, stuff2 = { name = '稀有武魂', num = 4 }, stuff3 = { name = '稀有伏魔神珠', num = 1 }, stuff4 = { name = '稀有龙皮', num = 1 }, money = 25000, heitie = 5000, make_id = 0x020CE764, make_type = 2 },
        ['鬼魂巫服手套'] = { equip_name = '鬼灵巫服手套', money = 50000, heitie = 7500, make_id = 0x020CE766 },
        ['白莲巫服手套'] = { equip_name = '鬼魂巫服手套', money = 75000, heitie = 10000, make_id = 0x020CE768 },
        ['镇魂巫服手套'] = { equip_name = '白莲巫服手套', money = 100000, heitie = 12500, make_id = 0x020CE76A },
        -- 鞋靴
        ['丝绸衣鞋靴'] = { stuff1 = { name = '高级钢铁', num = 20 }, stuff2 = { name = '高级武魂', num = 2 }, stuff3 = { name = '高级伏魔神珠', num = 1 }, stuff4 = { name = '高级龙皮', num = 1 }, money = 500, heitie = 500, make_id = 0x020CE779, make_type = 1 },
        ['残影衣鞋靴'] = { equip_name = '丝绸衣鞋靴', money = 2500, heitie = 1000, make_id = 0x020CE77B },
        ['阴影衣鞋靴'] = { equip_name = '残影衣鞋靴', money = 5000, heitie = 1500, make_id = 0x020CE77D },
        ['密影衣鞋靴'] = { equip_name = '阴影衣鞋靴', money = 7500, heitie = 2000, make_id = 0x020CE77F },
        ['鬼灵巫服鞋靴'] = { stuff1 = { name = '稀有钢铁', num = 75 }, stuff2 = { name = '稀有武魂', num = 4 }, stuff3 = { name = '稀有伏魔神珠', num = 1 }, stuff4 = { name = '稀有龙皮', num = 1 }, money = 25000, heitie = 5000, make_id = 0x020CE782, make_type = 2 },
        ['鬼魂巫服鞋靴'] = { equip_name = '鬼灵巫服鞋靴', money = 50000, heitie = 7500, make_id = 0x020CE784 },
        ['白莲巫服鞋靴'] = { equip_name = '鬼魂巫服鞋靴', money = 75000, heitie = 10000, make_id = 0x020CE786 },
        ['镇魂巫服鞋靴'] = { equip_name = '白莲巫服鞋靴', money = 100000, heitie = 12500, make_id = 0x020CE788 },
        --项链
        ['无我项链'] = { stuff1 = { name = '高级白金', num = 40 }, stuff2 = { name = '高级矿片', num = 4 }, stuff3 = { name = '高级灵石', num = 1 }, stuff4 = { name = '高级龙角', num = 1 }, money = 1000, heitie = 1000, make_id = 0x02687481, make_type = 1 },
        ['无心项链'] = { equip_name = '无我项链', money = 5000, heitie = 2000, make_id = 0x02687483 },
        ['罗汉项链'] = { equip_name = '无心项链', money = 10000, heitie = 3000, make_id = 0x02687485 },
        ['神灵项链'] = { equip_name = '罗汉项链', money = 15000, heitie = 4000, make_id = 0x02687487 },
        ['猛攻项链'] = { stuff1 = { name = '稀有白金', num = 75 }, stuff2 = { name = '稀有矿片', num = 25 }, stuff3 = { name = '稀有灵石', num = 25 }, stuff4 = { name = '稀有龙角', num = 1 }, money = 50000, heitie = 10000, make_id = 0x0268748A, make_type = 2 },
        ['护身项链'] = { equip_name = '猛攻项链', money = 100000, heitie = 15000, make_id = 0x0268748C },
        ['金刚项链'] = { equip_name = '护身项链', money = 150000, heitie = 20000, make_id = 0x0268748E },
        ['月光项链'] = { equip_name = '金刚项链', money = 200000, heitie = 25000, make_id = 0x02687490 },
        --手环
        ['无我手环'] = { stuff1 = { name = '高级白金', num = 40 }, stuff2 = { name = '高级矿片', num = 4 }, stuff3 = { name = '高级灵石', num = 1 }, stuff4 = { name = '高级龙角', num = 1 }, money = 1000, heitie = 1000, make_id = 0x0268749F, make_type = 1 },
        ['无心手环'] = { equip_name = '无我手环', money = 5000, heitie = 2000, make_id = 0x026874A1 },
        ['罗汉手环'] = { equip_name = '无心手环', money = 10000, heitie = 3000, make_id = 0x026874A3 },
        ['神灵手环'] = { equip_name = '罗汉手环', money = 15000, heitie = 4000, make_id = 0x026874A5 },
        ['猛攻手环'] = { stuff1 = { name = '稀有白金', num = 75 }, stuff2 = { name = '稀有矿片', num = 25 }, stuff3 = { name = '稀有灵石', num = 25 }, stuff4 = { name = '稀有龙角', num = 1 }, money = 50000, heitie = 10000, make_id = 0x026874A8, make_type = 2 },
        ['护身手环'] = { equip_name = '猛攻手环', money = 100000, heitie = 15000, make_id = 0x026874AA },
        ['金刚手环'] = { equip_name = '护身手环', money = 150000, heitie = 20000, make_id = 0x026874AC },
        ['月光手环'] = { equip_name = '金刚手环', money = 200000, heitie = 25000, make_id = 0x026874AE },
        --指环
        ['无我指环'] = { stuff1 = { name = '高级白金', num = 40 }, stuff2 = { name = '高级矿片', num = 4 }, stuff3 = { name = '高级灵石', num = 1 }, stuff4 = { name = '高级龙角', num = 1 }, money = 1000, heitie = 1000, make_id = 0x03010B3D, make_type = 1 },
        ['无心指环'] = { equip_name = '无我指环', money = 5000, heitie = 2000, make_id = 0x03010B3F },
        ['罗汉指环'] = { equip_name = '无心指环', money = 10000, heitie = 3000, make_id = 0x03010B41 },
        ['神灵指环'] = { equip_name = '罗汉指环', money = 15000, heitie = 4000, make_id = 0x03010B43 },
        ['猛攻指环'] = { stuff1 = { name = '稀有白金', num = 75 }, stuff2 = { name = '稀有矿片', num = 25 }, stuff3 = { name = '稀有灵石', num = 25 }, stuff4 = { name = '稀有龙角', num = 1 }, money = 50000, heitie = 10000, make_id = 0x03010B46, make_type = 2 },
        ['护身指环'] = { equip_name = '猛攻指环', money = 100000, heitie = 15000, make_id = 0x03010B48 },
        ['金刚指环'] = { equip_name = '护身指环', money = 150000, heitie = 20000, make_id = 0x03010B4A },
        ['月光指环'] = { equip_name = '金刚指环', money = 200000, heitie = 25000, make_id = 0x03010B4C },
        --耳环
        ['无我耳环'] = { stuff1 = { name = '高级白金', num = 40 }, stuff2 = { name = '高级矿片', num = 4 }, stuff3 = { name = '高级灵石', num = 1 }, stuff4 = { name = '高级龙眼', num = 1 }, money = 1000, heitie = 1000, make_id = 0x03010EE9, make_type = 1 },
        ['无心耳环'] = { equip_name = '无我耳环', money = 5000, heitie = 5000, make_id = 0x03010EEB },
        ['罗汉耳环'] = { equip_name = '无心耳环', money = 10000, heitie = 10000, make_id = 0x03010EED },
        ['神灵耳环'] = { equip_name = '罗汉耳环', money = 15000, heitie = 15000, make_id = 0x03010EEF },
        ['猛攻耳环'] = { stuff1 = { name = '稀有白金', num = 75 }, stuff2 = { name = '稀有矿片', num = 25 }, stuff3 = { name = '稀有灵石', num = 25 }, stuff4 = { name = '稀有龙眼', num = 1 }, money = 50000, heitie = 50000, make_id = 0x03010EF1, make_type = 2 },
        ['护身耳环'] = { equip_name = '猛攻耳环', money = 100000, heitie = 100000, make_id = 0x03010EF3 },
        ['金刚耳环'] = { equip_name = '护身耳环', money = 150000, heitie = 150000, make_id = 0x03010EF5 },
        ['月光耳环'] = { equip_name = '金刚耳环', money = 200000, heitie = 200000, make_id = 0x03010EF7 },
    },
}

local this = equip_res



-------------------------------------------------------------------------------------
-- 返回对象
return equip_res

-------------------------------------------------------------------------------------