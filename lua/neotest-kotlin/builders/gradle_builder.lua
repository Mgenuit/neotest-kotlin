local async = require("neotest.async")
local logger = require("neotest.logging")
local lib = require("neotest.lib")
local util = require("neotest-kotlin.util")
local tquery = require("neotest-kotlin.treesitter.junit-queries")

require("neotest-kotlin.debug")

local M = {}

local function get_test_ref(position_type, split)
	if position_type == "test" then
		return {
			test_id = split[#split - 1] .. "." .. split[#split],
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
			report = "TEST-" .. util.get_package(split[1]) .. "." .. tree:to_list()[2][1].name .. ".xml",
		}
	end
end

---Creates a single spec for neotest to run
---@param position table The position value of the neotest tree node
---@param proj_root string The path of the project root for this particular position
---@param filter_arg string The filter argument to pass to the dotnet test command
---@return
function M.create_single_spec(position, proj_root, filter_arg)
	local results_path = async.fn.tempname() .. ".trx"
	filter_arg = filter_arg or ""

	local split = util.split(position.id, "::")
	local test_ref = get_test_ref(position.type, split)

	vim.fn.fnamemodify(require("neotest.async").fn.tempname(), ":h")

	local command = {
		"gradle",
		"test",
		-- "-l " .. results_path,
		-- "-f " .. proj_root,
		"--tests " .. test_ref.test_id,
	}

	local command_string = table.concat(command, " ")

	logger.debug("neotest-dotnet: Running tests using command: " .. command_string)

	return {
		command = command_string,
		context = {
			results_path = proj_root .. "/build/test-results/test" .. test_ref.report,
			file = position.path,
			id = position.id,
		},
	}
end

function M.build_spec(tree, specs)
	local position = tree:data()
	local proj_root = lib.files.match_root_pattern("build.gradle.kts")(position.path)
	specs = specs or {}

	-- Adapted from https://github.com/nvim-neotest/neotest/blob/392808a91d6ee28d27cbfb93c9fd9781759b5d00/lua/neotest/lib/file/init.lua#L341
	if position.type == "dir" then
		error("Dir not Implemented yet")
	elseif position.type == "namespace" or position.type == "test" then
		local extra_args = ""
		local spec = M.create_single_spec(position, proj_root, extra_args)
		table.insert(specs, spec)
	elseif position.type == "file" then
		local spec = M.create_single_spec(position, proj_root, "")
		table.insert(specs, spec)
	end

	return #specs < 0 and nil or specs
end

return M
