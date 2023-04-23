local maven = require("neotest-kotlin.result_parsers.mvn")
local M = {}

function M.get_result_parser(mode)
    if mode == "maven" then
        return maven
    end
    if mode == "gradle" then
        return {}
    end

    error("No builder found for this mode")
end

return M
