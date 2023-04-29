local M = {}

M.testMarkers = {
    "Test",
}

M.NameSpace = [[
;; Default Class Name
(class_declaration
    (type_identifier) @namespace.name
  ) @namespace.definition
]]

M.TestCase = [[
;; Default Test Case
   (function_declaration
    (modifiers) @mod (#match? @mod "Test$")
    (simple_identifier) @test.name
    ) @test.definition

]]

return M
