-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   zengluolu
-- @email:    1819@qq.com
-- @date:     2023-10-16
-- @module:   actor_res 
-- @describe: 物品资源
-- @version:  v1.0


-------------------------------------------------------------------------------------
-- 任务模块资源
---@class actor_res
local actor_res = {





}

local this = actor_res

------------------------------------------------------------------------------
-- 判断点是否在多边形内部
-- @param pointX 点的X坐标
-- @param pointY 点的Y坐标
-- @param polygon 多边形的顶点坐标表 { {x = x1, y = y1}, {x = x2, y = y2}, ... }
-- @return boolean 点是否在多边形内部
function actor_res.is_point_in_polygon(pointX, pointY, polygon)
    local isInPolygon = false
    local j = #polygon
    for i = 1, #polygon do
        local px1, py1, px2, py2 = polygon[i].x, polygon[i].y, polygon[j].x, polygon[j].y
        if (py1 < pointY and py2 >= pointY) or (py2 < pointY and py1 >= pointY) then
            if px1 + (pointY - py1) / (py2 - py1) * (px2 - px1) < pointX then
                isInPolygon = not isInPolygon
            end
        end
        j = i
    end
    return isInPolygon
end


function actor_res.is_can_gather(name,point_x, point_y)
    local ret_b =  false
    if this.CAN_GATHER_POS[name] then
        if actor_res.is_point_in_polygon(point_x, point_y, this.CAN_GATHER_POS[name]) then
            ret_b = true
        end
    else
        ret_b = true
    end

    return ret_b
end




-------------------------------------------------------------------------------------
-- 返回对象
return actor_res

-------------------------------------------------------------------------------------