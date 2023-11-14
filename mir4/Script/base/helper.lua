------------------------------------------------------------------------------------
-- base/helper.lua
--
-- 本模块是脚本生成辅助模块。
--
-- @module      helper
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
------------------------------------------------------------------------------------

-- 模块定义
local helper = {
	-- 模块版本 (主版本.次版本.修订版本)
	VERSION                   = '1.0.0',
	-- 作者备注 (更新日期 - 更新内容简述)
	AUTHOR_NOTE               = '2023-03-22 - Initial release',
    -- 模块名称
    MODULE_NAME               = "helper module",
    -- 只读模式
    READ_ONLY                 = false
}

-- 自身模块
local this = helper

------------------------------------------------------------------------------------
-- 加密并打包脚本
--
-- @local
------------------------------------------------------------------------------------
function helper.encrypt_and_pack()
    -- 文件列表
    local files = {
        -- 需要加密文件列表
        "helper.lua",
        "trace.lua",
        "decider.lua"
    }
    local directorys = {"base", "game"}
    -- 生成路径
    local path = main_ctx:c_fz_path()
    -- 复制目录
    for _, v in ipairs(directorys) do
        local source = path .. [[Script\]] .. v
        local destination = path .. [[RScript\]] .. v
        local success, err =
            pcall(
            function()
                utils.copy_directory(source, destination)
            end
        )
        if success then
            xxxmsg(2, "复制目录成功: " .. source)
        else
            xxxmsg(2, "复制目录成功: " .. source)
        end
    end
    -- 加密文件
    local dest_path = path .. [[RScript\\base\]]
    for _, v in ipairs(files) do
        local success = _encrypt_script(dest_path .. v)
        if success then
            xxxmsg(2, "加密文件成功: " .. v)
        else
            xxxmsg(4, "加密文件失败: " .. v)
        end
    end
end

------------------------------------------------------------------------------------
--- 生成脚本文件
-- @tparam       table     config           脚本配置信息
-- @tparam       int       config.type      脚本类型，1:资源, 2:实体, 4:模块
-- @tparam       string    config.module    脚本名称(不要加后缀)
-- @tparam       string    config.brief     脚本简要说明
-- @tparam       string    config.author    脚本作者信息
-- @tparam[opt]  string    config.license   脚本许可信息(default MIT)
-- @tparam[opt]  string    config.version   脚本版本信息(default 1.0.0)
-- @tparam[opt]  string    config.copyright 脚本版权信息(default current year)
-- @tparam[opt]  string    config.date      脚本日期(default current date)
-- @treturn      boolean                    是否生成脚本文件
-- @treturn      string|nil                 错误信息，如果生成成功则为nil
-- @usage
-- -- 模板占位符
-- -- 模块名称 ${module}
-- -- 简要说明 ${brief}
-- -- 作者信息 ${author}
-- -- 许可信息 ${license}
-- -- 版本信息 ${version}
-- -- 版权信息 ${copyright}
-- -- 当前日期 ${date}
-- @usage
-- -- 示例一
-- local helper = import('base/helper')
-- local success, errmsg =
--     helper.build_script(
--     {
--         type = 1,
--         module = 'example',
--         brief = '这是一个示例资源脚本',
--         author = 'John Doe'
--     }
-- )
-- print(success, errmsg)
-- @usage
-- -- 示例二
-- local helper = import('base/helper')
-- local success, errmsg =
--     helper.build_script(
--     {
--         type = 2,
--         module = 'example',
--         brief = '这是一个示例实体脚本',
--         author = 'John Doe',
--         license = 'MIT',
--         version = '1.0.0',
--         copyright = '2022',
--         date = '2022-03-22'
--     }
-- )
-- print(success, errmsg)
------------------------------------------------------------------------------------
function helper.build_script(config, overwrite)
    -- 初始化参数
    overwrite = overwrite == nil and false or overwrite
    -- 效验名称
    if not config.module or string.len(config.module) == 0 then
        return false, "脚本名称错误"
    end
    -- 脚本类型
    if not config.type or config.type == 0 then
        return false, "脚本类型错误(1:资源, 2:实体, 4:模块)"
    end
    -- 效验类型
    local type_map = {[1] = "_res", [2] = "_ent", [4] = ""}
    local m_type = config.type
    if not type_map[m_type] then
        return false, "脚本类型错误(1:资源, 2:实体, 4:模块)"
    end
    -- 新模块名
    local m_name = config.module .. type_map[m_type]
    config.module = m_name
    -- 简要说明
    if not config.brief or string.len(config.brief) == 0 then
        return false, "简要信息错误"
    end
    -- 作者信息
    if not config.author or string.len(config.author) == 0 then
        return false, "作者信息错误"
    end
    -- 许可信息
    if not config.license or string.len(config.license) == 0 then
        config.license = "MIT"
    end
    -- 版本信息
    if not config.version or string.len(config.version) == 0 then
        config.version = "1.0.0"
    end
    -- 版权信息
    if not config.copyright or string.len(config.copyright) == 0 then
        config.copyright = os.date("%Y")
    end
    -- 当前日期
    if not config.date or string.len(config.date) == 0 then
        config.date = os.date("%Y-%m-%d")
    end
    -- 当前路径
    local path = main_ctx:c_fz_path()
    -- 文件模板列表
    local file_templates = {
        [1] = {
            -- 类型 1: 资源文件
            name = "resource",
            file = [[script\base\template\resource.lua]],
            dir = [[script\base\template\resources\]],
            target_dir = [[script\game\resources\]]
        },
        [2] = {
            -- 类型 2: 实体文件
            name = "entity",
            file = [[script\base\template\entity.lua]],
            dir = [[script\base\template\entities\]],
            target_dir = [[script\game\entities\]]
        },
        [4] = {
            -- 类型 4: 模块文件
            name = "module",
            file = [[script\base\template\module.lua]],
            dir = [[script\base\template\modules\]],
            target_dir = [[script\game\modules\]]
        }
    }
    -- 简化使用
    local file_template = file_templates[m_type]
    -- 检测存在
    local target_file = path .. file_template.target_dir .. m_name .. ".lua"
    if not overwrite and utils.file_exists(target_file) then
        return false, "目标文件已经存在，请先删除后重试"
    end
    -- 生成路径
    local temp = path .. file_template.dir .. m_name .. ".lua"
    local content = utils.read_binary_file(temp)
    if not content then
        content = utils.read_binary_file(path .. file_template.file)
    end
    -- 效验内容
    if not content or #content == 0 then
        return false, "读取模板文件错误"
    end
    -- 替换占位符函数
    local function replace_placeholders(data, template)
        local result = template
        for k, v in pairs(data) do
            result = result:gsub("${" .. k .. "}", v)
        end
        return result
    end
    -- 替换模板
    local result = replace_placeholders(config, content)
    if #result == 0 then
        return false, "替换模板错误"
    end
    -- 写入文件
    local success, err = utils.write_binary_file(target_file, result)
    if not success then
        return false, err
    end
    -- 返回成功
    return success, "OK"
end

------------------------------------------------------------------------------------
-- 根据给定的配置列表批量构建脚本文件。
-- @tparam       table     configs          包含多个配置表的数组
-- @tparam[opt]  boolean   overwrite        如果目标文件已存在，是否覆盖
-- @treturn      t                          结果数组，其中每个元素为一个 table
-- @tfield[t]    boolean   success          表示操作是否成功
-- @tfield[t]    string    result           成功时返回文件名，失败时返回错误信息
-- @usage
-- local helper = import('base/helper')
-- local configs = {
--     {
--         module = 'example',
--         type = 1,
--         brief = '资源示例',
--         author = 'Author1',
--     },
--     {
--         module = 'example',
--         type = 2,
--         brief = '实体示例',
--         author = 'Author2',
--     },
--     {
--         module = 'example',
--         type = 4,
--         brief = '模块示例',
--         author = 'Author3',
--     },
-- }
-- local results = helper.build_scripts(configs)
-- for _, result in ipairs(results) do
--     if result.success then
--         print('成功生成脚本：' .. result.result)
--     else
--         print('生成脚本失败：' .. result.result)
--     end
-- end
-- @usage
-- local helper = import('base/helper')
-- local configs = {
--     {
--         module = 'example2',
--         type = 1,
--         brief = '资源示例',
--         author = 'Author3',
--         license = 'GPL',
--         version = '2.0.0',
--     },
--     {
--         module = 'example',
--         type = 2,
--         brief = '实体示例',
--         author = 'Author4',
--         copyright = '2023',
--         date = '2023-03-26',
--     },
--     {
--         module = 'example',
--         type = 4,
--         brief = '模块示例',
--         author = 'Author5',
--         copyright = '2023',
--         date = '2023-03-26',
--     },
-- }
-- local results = helper.build_scripts(configs, true) -- 设置 overwrite 为 true
-- for _, result in ipairs(results) do
--     if result.success then
--         print('成功生成脚本：' .. result.result)
--     else
--         print('生成脚本失败：' .. result.result)
--     end
-- end
------------------------------------------------------------------------------------
function helper.build_scripts(configs, overwrite)
    local results = {}
    for _, config in ipairs(configs) do
        local success, result = helper.build_script(config, overwrite)
        result = config.module .. " -> " .. result
        table.insert(results, {success = success, result = result})
    end
    return results
end

------------------------------------------------------------------------------------
-- 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function helper.__tostring()
    return this.MODULE_NAME
end

------------------------------------------------------------------------------------
-- 防止动态修改(this.READ_ONLY值控制)
--
-- @local
-- @tparam       table     t                被修改的表
-- @tparam       any       k                要修改的键
-- @tparam       any       v                要修改的值
------------------------------------------------------------------------------------
function helper.__newindex(t, k, v)
    if this.READ_ONLY then
        error("attempt to modify read-only table")
        return
    end
    rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置core的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
helper.__index = helper

------------------------------------------------------------------------------------
-- 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function helper:new(args)
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
    return setmetatable(new, helper)
end

------------------------------------------------------------------------------------
-- 返回实例对象
------------------------------------------------------------------------------------
return helper:new()

------------------------------------------------------------------------------------
