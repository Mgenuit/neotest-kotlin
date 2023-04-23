local surefire_utils = require("neotest-kotlin.result_parsers.surefire-utils")
local logger = require("neotest.logging")

require("neotest-kotlin.debug")
local M = {}

local function get_test_nodes_data(tree)
	local test_nodes = {}
	for _, node in tree:iter_nodes() do
		if node:data().type == "test" then
			table.insert(test_nodes, node)
		end
	end

	return test_nodes
end

function M.results(spec, result, tree)
	local output_file = spec.context.results_path

	local parsed_data = surefire_utils.parse_report(output_file)

	local test_results = parsed_data.testsuite.testcase

	-- No test results. Something went wrong. Check for runtime error
	if not test_results then
		-- return result_utils.get_runtime_error(spec.context.id)
	end

	logger.info("neotest-dotnet: Found " .. #test_results .. " test results when parsing TRX file: " .. output_file)

	logger.debug("neotest-dotnet: TRX Results Output: ")
	logger.debug(test_results)

	local test_nodes = get_test_nodes_data(tree)

	logger.debug("neotest-dotnet: Test Nodes: ")
	logger.debug(test_nodes)

	local intermediate_results = surefire_utils.create_intermediate_results(test_results)

	logger.debug("neotest-dotnet: Intermediate Results: ")
	logger.debug(intermediate_results)

	local neotest_results = surefire_utils.convert_intermediate_results(intermediate_results, test_nodes)

	logger.debug("neotest-dotnet: Neotest Results after conversion of Intermediate Results: ")
	logger.debug(neotest_results)

	return neotest_results
end

return M
