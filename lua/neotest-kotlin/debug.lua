function Perr(v)
    error(P(v))
end

function P(v)
    local g = vim.inspect(v)
    print(vim.inspect(v))
    return g
end
