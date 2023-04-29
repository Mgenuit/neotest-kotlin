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
                id = vim.fn.getcwd()
                    ..
                    "/tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenDemoApplicationTests.kt::MavenDemoApplicationTests::contextLoads2",
                name = "contextLoads2",
                path = vim.fn.getcwd()
                    ..
                    "/tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenDemoApplicationTests.kt",
                range = { 14, 1, 17, 2 },
                type = "test",
            },
        }, function(pos)
            return pos.id
        end)

		local result = builder.set_builder("maven").build_spec(tree)

        local regex = "mvn test %-l .+.trx %-f .+ %-Dtest%=MavenDemoApplicationTests%#contextLoads2"

        assert.match(regex, result[1].command)
    end)
end)
