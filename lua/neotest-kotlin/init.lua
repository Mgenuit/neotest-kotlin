local M = {}

local lib = require("neotest.lib")
local logger = require("neotest.logging")
local builders = require("neotest-kotlin.builders")
local result_parsers = require("neotest-kotlin.result_parsers")

local tquery = require("neotest-kotlin.treesitter.junit-queries")

---@class neotest_kotlin.Adapter
---@field name string
M.Adapter = {}
M._Internals = {}
---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function M.Adapter.root(dir)
    local pom = lib.files.match_root_pattern("pom.xml")(dir)
    local build = lib.files.match_root_pattern("*.gradle", "*.gradle.kts")(dir)

    if pom ~= nil and build == nil then
        M._Internals.mode = "maven"
        return pom
    end
    if build ~= nil and pom == nil then
        M._Internals.mode = "gradle"
        return build
    end

    logger.warn("Cannot determine valid project type")
    return nil
end

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean
function M.Adapter.filter_dir(name, rel_path, _)
    local blacklist = {
        "build",
        "gradle",
        ".gradle",
        ".mvn",
        "target",
    }

    for _, dir in ipairs(blacklist) do
        if dir == name then
            return false
        end
        return true
    end
end

---@async
---@param file_path string
---@return boolean
function M.Adapter.is_test_file(file_path)
    if vim.endswith(file_path, ".kt") then
        local content = lib.files.read(file_path)
        -- Combine all attribute list arrays into one
        local all_attributes = tquery.attributes

        for _, test_attribute in ipairs(all_attributes) do
            if string.find(content, "%@" .. test_attribute) then
                return true
            end
        end
    end

    return false
end

---Given a file path, parse all the tests within it.
---@async
---@param file_path string Absolute file path
---@return neotest_kotlin.Tree | nil
function M.Adapter.discover_positions(file_path)
    local query = tquery.NameSpace .. tquery.TestCase

    local tree = lib.treesitter.parse_positions(file_path, query, {
        nested_namespaces = false,
        nested_tests = false,
        build_position = "require('neotest-kotlin.treesitter.position')._build_position",
        position_id = "require('neotest-kotlin.treesitter.position')._position_id",
    })

    return tree
end

---@param args neotest_kotlin.RunArgs
---@return nil | neotest_kotlin.RunSpec | neotest.RunSpec[]
function M.Adapter.build_spec(args)
    logger.debug("neotest-dotnet: Creating specs from Tree (as list): ")
    logger.debug(args.tree:to_list())

    return builders.get_builder(M._Internals.mode).build_spec(args.tree)
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
function M.Adapter.results(spec, result, tree)
    return result_parsers.get_result_parser(M._Internals.mode).results(spec, result, tree)
end

return M
