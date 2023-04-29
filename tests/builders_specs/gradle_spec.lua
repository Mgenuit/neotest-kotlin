local async = require("nio").tests
local Tree = require("neotest.types").Tree

describe("Builder mvn", function()
	require("neotest").setup({
		adapters = {
			require("neotest-kotlin"),
		},
	})

	async.it("Should return nil", function()
		local builder = require("neotest-kotlin.builders")
		local tree = Tree.from_list({
			{
				id = vim.fn.getcwd().."/tests/projects/gradle/gradle-demo/src/test/kotlin/io/genuit/gradledemo/GradleDemoApplicationTests.kt::GradleDemoApplicationTests::simpleFailedTest",
				name = "contextLoads2",
				path = vim.fn.getcwd().."/tests/projects/gradle/gradle-demo/src/test/kotlin/io/genuit/gradledemo/GradleDemoApplicationTests.kt",
				range = { 14, 1, 17, 2 },
				type = "test",
			},
		}, function(pos)
			return pos.id
		end)

		local result = builder.set_builder("gradle").build_spec(tree)

		local regex = "gradle test %-%-tests GradleDemoApplicationTests.simpleFailedTest"

		assert.match(regex, result[1].command)
	end)
end)
