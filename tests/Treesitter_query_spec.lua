local async = require("nio").tests

describe("When checking if file is test file", function()
    require("neotest").setup({
        adapters = {
            require("neotest-kotlin"),
        },
    })

    async.it("Non-test file should return false", function()
        local plugin = require("neotest-kotlin")
        local file = "./tests/projects/mvn/maven-demo/src/main/kotlin/io/genuit/mavendemo/MavenDemoApplication.kt"

        local is_test = plugin.Adapter.is_test_file(file)

        assert.is.False(is_test)
    end)

    async.it("Test file should return true", function()
        local plugin = require("neotest-kotlin")
        local file = "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenDemoApplicationTests.kt"

        local is_test = plugin.Adapter.is_test_file(file)

        assert.is.True(is_test)
    end)
end)
