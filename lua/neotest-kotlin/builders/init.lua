local lib = require("neotest.lib")
local maven = require("neotest-kotlin.builders.maven_builder")
local gradle = require("neotest-kotlin.builders.gradle_builder")

local M = {}

function M.set_builder(mode)
    if mode == "maven" then
        M._Builder = maven
    end
    if mode == "gradle" then
        M._Builder = gradle
    end
    return M
end

function M.build_spec(tree, specs)
    if M._Builder == nil then
        error("No valid builder set")
    end

    local position = tree:data()
    local proj_root = lib.files.match_root_pattern(M._Builder.rootIndicator)(position.path)
    specs = specs or {}

    -- Adapted from https://github.com/nvim-neotest/neotest/blob/392808a91d6ee28d27cbfb93c9fd9781759b5d00/lua/neotest/lib/file/init.lua#L341
    if position.type == "dir" then
        error("Dir not Implemented yet")
    elseif position.type == "namespace" or position.type == "test" then
        local extra_args = ""
        local spec = M._Builder.create_single_spec(position, proj_root, extra_args)
        table.insert(specs, spec)
    elseif position.type == "file" then
        local spec = M._Builder.create_single_spec(position, proj_root, "")
        table.insert(specs, spec)
    end

    return #specs < 0 and nil or specs
end

return M
