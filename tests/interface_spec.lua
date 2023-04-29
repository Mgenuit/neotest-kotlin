local async = require("nio").tests

describe("root with Maven", function()
    require("neotest").setup({
        adapters = {
            require("neotest-kotlin").Adapter,
        },
    })

    async.it("Should return path in maven mode when it contains pom.xml", function()
        local plugin = require("neotest-kotlin")
        local dir = "./tests/projects/mvn/maven-demo"
        local root = plugin.Adapter.root(dir)

        assert.equal(dir, root)
        assert.equal(plugin._Internals.mode, "maven")
    end)

    async.it("Should return parent when it contains pom.xml", function()
        local plugin = require("neotest-kotlin")

        local dir = "./tests/projects/mvn/maven-demo/src"
        local parent_sln_dir = "/tests/projects/mvn/maven%-demo$"
        local root = plugin.Adapter.root(dir)

        -- Check the end of the root matches the test dir as the function
        -- in neotest will use the fully qualified path (which will vary)
        assert.is.True(string.find(root, parent_sln_dir) ~= nil)
    end)
end)

describe("root with Gradle", function()
    require("neotest").setup({
        adapters = {
            require("neotest-kotlin").Adapter,
        },
    })

    async.it("Should return path in gradle mode when it contains build file", function()
        local plugin = require("neotest-kotlin")
        local dir = "./tests/projects/gradle/gradle-demo"
        local root = plugin.Adapter.root(dir)

        assert.equal(dir, root)
        assert.equal(plugin._Internals.mode, "gradle")
    end)

    async.it("Should return parent when it contains pom.xml", function()
        local plugin = require("neotest-kotlin")

        local dir = "./tests/projects/gradle/gradle-demo/src"
        local parent_sln_dir = "/tests/projects/gradle/gradle%-demo$"
        local root = plugin.Adapter.root(dir)

        -- Check the end of the root matches the test dir as the function
        -- in neotest will use the fully qualified path (which will vary)
        assert.is.True(string.find(root, parent_sln_dir) ~= nil)
    end)
end)

describe("root without project", function()
    require("neotest").setup({
        adapters = {
            require("neotest-kotlin").Adapter,
        },
    })
    async.it("Should return nil", function()
        local plugin = require("neotest-kotlin")
        local dir = "./tests/projects/"
        local root = plugin.Adapter.root(dir)

        assert.equal(root, nil)
    end)
end)

describe("Test positions", function()
    assert:set_parameter("TableFormatLevel", 5)

    require("neotest").setup({
        adapters = {
            require("neotest-kotlin").Adapter,
        },
    })
    async.it("Should return nil", function()
        local plugin = require("neotest-kotlin")
        local path = "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt"
        local root = plugin.Adapter.discover_positions(path)

        local expected_positions = {
            {
                id = "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt",
                name = "MavenTestLocationTests.kt",
                path = "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt",
                range = { 0, 0, 27, 0 },
                type = "file",
            },
            {
                {
                    id =
                    "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt::MavenTestLocationTests",
                    name = "MavenTestLocationTests",
                    path =
                    "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt",
                    range = { 6, 0, 26, 1 },
                    type = "namespace",
                },
                {
                    {
                        id =
                        "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt::MavenTestLocationTests::contextLoads1",
                        name = "contextLoads1",
                        path =
                        "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt",
                        range = { 8, 4, 11, 2 },
                        type = "test",
                    },
                },
                {
                    {
                        id =
                        "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt::MavenTestLocationTests::contextLoads2",
                        name = "contextLoads2",
                        path =
                        "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt",
                        range = { 13, 1, 16, 2 },
                        type = "test",
                    },
                },
                {
                    {
                        id =
                        "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt::MavenTestLocationTests::contextLoads",
                        name = "contextLoads",
                        path =
                        "./tests/projects/mvn/maven-demo/src/test/kotlin/io/genuit/mavendemo/MavenTestLocationTests.kt",
                        range = { 18, 1, 21, 2 },
                        type = "test",
                    },
                },
            },
        }
        assert.same(root:to_list(), expected_positions)
    end)
end)
