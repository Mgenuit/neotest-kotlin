local maven = require("neotest-kotlin.builders.maven_builder")
local gradle = require("neotest-kotlin.builders.gradle_builder")

local M = {}

function M.get_builder(mode)
    if mode == "maven" then
        return maven
    end
    if mode == "gradle" then
        return gradle
    end

    error("No builder found for this mode")
end

return M
