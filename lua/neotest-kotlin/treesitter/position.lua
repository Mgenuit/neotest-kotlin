local M = {}

function M.get_match_type(captured_nodes)
    if captured_nodes["namespace.name"] then
        return "namespace"
    end
    if captured_nodes["test.name"] then
        return "test"
    end
end

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
    return original_id
end

return M
