local surefire = require("neotest-kotlin.result_parsers.surefire-parser")
local M = {}

function M.get_result_parser(mode)
	if mode == "maven" then
		return surefire
	end
	if mode == "gradle" then
		return surefire
	end

	error("No builder found for this mode")
end

return M
