local lib = require("neotest.lib")
local logger = require("neotest.logging")

local M = {}

function M.get_outcome(result_value)
	if result_value.skipped then
		return { result = "skipped", message = "Test was skipped", stack = nil }
	end

	if result_value.error then
		return { result = "failed", message = result_value.error._attr.type, stack = result_value.error[1] }
	end

	if result_value.failure then
		return { result = "failed", message = result_value.failure._attr.message, stack = result_value.failure[1] }
	end
	if result_value._attr then
		return { result = "passed", message = nil, stack = nil }
	end
	error("Result could not be parsed")
end

local function remove_bom(str)
	if string.byte(str, 1) == 239 and string.byte(str, 2) == 187 and string.byte(str, 3) == 191 then
		str = string.sub(str, 4)
	end
	return str
end

M.parse_report = function(output_file)
	logger.info("Parsing surefire xml report: " .. output_file)
	local success, xml = pcall(lib.files.read, output_file)

	if not success then
		-- logger.error("No test output file found ")
		error("No test output file found: " .. output_file)
		return {}
	end

	local no_bom_xml = remove_bom(xml)

	local ok, parsed_data = pcall(lib.xml.parse, no_bom_xml)
	if not ok then
		-- logger.error("Failed to parse test output:", output_file)
		error("Failed to parse test output:", output_file)
		return {}
	end

	return parsed_data
end

---Creates a table of intermediate results from the parsed xml result data
---@param test_results table
---@return DotnetResult[]
function M.create_intermediate_results(test_results)
	---@type DotnetResult[]
	local intermediate_results = {}

	if #test_results > 1 then
		for _, value in pairs(test_results) do
			addToResults(intermediate_results, value)
		end
	else
		addToResults(intermediate_results, test_results)
	end
	return intermediate_results
end

function addToResults(intermediate_results, test_results)
	if test_results._attr.name ~= nil then
		local outcome = M.get_outcome(test_results) -- This does not work as easy here. have to check for skip/error/failure

		local intermediate_result = {
			status = outcome.result,
			raw_output = outcome.stack,
			test_name = test_results._attr.name,
			error_info = outcome.message,
		}
		table.insert(intermediate_results, intermediate_result)
	end
end

---Converts and adds the results of the test_results list to the neotest_results table.
---@param intermediate_results DotnetResult[] The marshalled dotnet console outputs
---@param test_nodes neotest.Tree
---@return neotest.Result[]
function M.convert_intermediate_results(intermediate_results, test_nodes)
	local neotest_results = {}

	for _, intermediate_result in ipairs(intermediate_results) do
		for _, node in ipairs(test_nodes) do
			local node_data = node:data()
			-- The test name from the trx file uses the namespace to fully qualify the test name
			-- To simplify the comparison, it's good enough to just ensure that the last part of the test_name matches the node name (the unqualified display name of the test)

			local result_test_name = intermediate_result.test_name

			local is_dynamically_parameterized = #node:children() == 0 and not string.find(node_data.name, "%(.*%)")

			if is_dynamically_parameterized then
				-- Remove dynamically generated arguments as they are not in node_data
				result_test_name = string.gsub(result_test_name, "%(.*%)", "")
			end

			local is_match = #result_test_name == #node_data.name
					and string.find(result_test_name, node_data.name, 0, true)
				or string.find(result_test_name, node_data.name, -#node_data.name, true)

			if is_match then
				neotest_results[node_data.id] = {
					status = intermediate_result.status,
					short = node_data.name .. ":" .. intermediate_result.status,
					errors = {},
				}

				if intermediate_result.error_info then
					table.insert(neotest_results[node_data.id].errors, {
						message = intermediate_result.error_info,
					})
				end

				break
			end
		end
	end

	return neotest_results
end

return M
