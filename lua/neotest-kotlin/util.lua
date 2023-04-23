local M = {}

function M.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function M.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function M.get_package(file)
    local x = vim.fn.fnamemodify(file, ":p:h")
    local pathTable = M.split(x, "/")

    local cutof = M.indexOf(pathTable, "kotlin")
    local size1 = 0
    for _ in pairs(pathTable) do
        size1 = size1 + 1
    end
    for i = cutof, 1, -1 do
        table.remove(pathTable, 1)
    end

    return table.concat(pathTable, ".")
end


return M
