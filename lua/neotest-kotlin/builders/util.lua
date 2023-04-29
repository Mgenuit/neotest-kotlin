local util = require("neotest-kotlin.util")
local lib = require("neotest.lib")
local tquery = require("neotest-kotlin.treesitter.junit-queries")

local M = {}

function M._get_test_ref(position_type, split)
    if position_type == "test" then
        return {
            test_id = split[#split - 1] .. "#" .. split[#split],
            report = "TEST-" .. util.get_package(split[1]) .. "." .. split[#split - 1] .. ".xml",
        }
    end
    if position_type == "namespace" then
        return {
            test_id = split[#split],
            report = "TEST-" .. util.get_package(split[1]) .. "." .. split[#split] .. ".xml",
        }
    end
    if position_type == "file" then
        local query = tquery.NameSpace .. tquery.TestCase

        local tree = lib.treesitter.parse_positions(split[1], query, {})
        return {
            test_id = tree:to_list()[2][1].name,
            report = "TEST-" .. M.get_package(split[1]) .. "." .. tree:to_list()[2][1].name .. ".xml",
        }
    end
end

return M
