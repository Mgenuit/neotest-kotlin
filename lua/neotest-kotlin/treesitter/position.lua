require("neotest-kotlin.debug")

local M = {}

function M.get_match_type(captured_nodes)
    if captured_nodes["namespace.name"] then
        return "namespace"
    end
    if captured_nodes["test.name"] then
        return "test"
    end
end

---@param file_path string
---@param source string
---@param captured_nodes table<string, userdata>
function M._build_position(file_path, source, captured_nodes)
    local match_type = M.get_match_type(captured_nodes)
    local name = vim.treesitter.get_node_text(captured_nodes[match_type .. ".name"], source)
    local definition = captured_nodes[match_type .. ".definition"]
    local node = {
        type = match_type,
        path = file_path,
        name = name,
        range = { definition:range() }, -- Line right before the captured node starts
    }
    return node
end

-- Given the position of a tests it generates a position_id.
-- position_id seems to be a string looking like "/path/to/test_file.kt::TestNamespace::TestClassName::ParentTestName::ParentTestName(TestName)"
function M._position_id(position, parents)
    local original_id = table.concat(
        vim.tbl_flatten({
            position.path,
            vim.tbl_map(function(pos)
                return pos.name
            end, parents),
            position.name,
        }),
        "::"
    )
    -- Check to see if the position is a test case and contains parentheses (meaning it is parameterized)
    -- If it is, remove the duplicated parent test name from the ID, so that when reading the trx test name
    -- it will be the same as the test name in the test explorer
    -- Example:
    --  When ID is "/path/to/test_file.cs::TestNamespace::TestClassName::ParentTestName::ParentTestName(TestName)"
    --  Then we need it to be converted to "/path/to/test_file.cs::TestNamespace::TestClassName::ParentTestName(TestName)"
    -- if position.type == "test" and position.name:find("%(") then
    --     local id_segments = {}
    --     for _, segment in ipairs(vim.split(original_id, "::")) do
    --         table.insert(id_segments, segment)
    --     end
    --
    --     table.remove(id_segments, #id_segments - 1)
    --     return table.concat(id_segments, "::")
    -- end
    --
    return original_id
end

return M
