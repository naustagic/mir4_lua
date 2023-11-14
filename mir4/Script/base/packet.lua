-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
--- @author:   ZhengHao
--- @email:    88888@qq.com
--- @date:     2023-2-10
--- @module:   packet
--- @describe: 封包模块
--- @version:  v1.0
-------------------------------------------------------------------------------------
local VERSION = '20211017' -- version history at end of file
local AUTHOR_NOTE = '-[20211017]-'
---@class packet
local packet = {
    VERSION = VERSION,
    AUTHOR_NOTE = AUTHOR_NOTE,


}
local this = packet

local func = import('base/func')

------------------------------------------------------------------------------------
---发包封装
---参数1：封包字符串【剔除前面2个字节字符】
---参数2：发送命令
packet.SendPacket = function(str, sen)
    local sT = func.split(str, ' ')
    local packet_ = packet_unit:new(#sT) -- 初使化申表空间大小
    for i = 1, #sT do
        if sT[i] ~= '' then
            packet_:push_byte(tonumber(sT[i], 16))
        end
    end
    -- xxmsg(packet_:to_string())
    if type(sen) == 'number' then
        packet_:send(sen)
    end
    packet_:delete()
end

-------------------------------------------------------------------------------------------------------
---格式化封包
---返回 4字节字符
packet.FormatPacket = function(args)
    local packet_ = packet_unit:new(4) -- 初使化申表空间大小
    packet_:push_dword(args)
    local str = packet_:to_string()
    packet_:delete()
    return str
end

-------------------------------------------------------------------------------------------------------
---将64位的ID分拆成 2个32位ID
packet.get_id32_by_64id = function(id64)
    local ids = string.format('%16X', id64)
    local ids_str1 = string.sub(ids, 0, 8)
    local ids_str2 = string.sub(ids, 9, 16)
    local ids1 = tonumber(ids_str1, 16)
    local ids2 = tonumber(ids_str2, 16)
    return ids2, ids1
end

-------------------------------------------------------------------------------------------------------
---打开礼包
---参数1：物品ID
packet.open_gift = function(id64)
    local id1, id2 = this.get_id32_by_64id(id64)
    local sendstr = '00 00 ' .. this.FormatPacket(id1) .. ' ' .. this.FormatPacket(id2) .. ' 00 00 01 00'
    this.SendPacket(sendstr, 0x024F)
end

------------------------------------------------------------------------------------
-- 实例化新对象

function packet.__tostring()
    return "Mirm packet package"
end

packet.__index = packet

function packet:new(args)
    local new = { }

    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end

    -- 设置元表
    return setmetatable(new, packet)
end

-------------------------------------------------------------------------------------
-- 返回对象
return packet:new()

-------------------------------------------------------------------------------------