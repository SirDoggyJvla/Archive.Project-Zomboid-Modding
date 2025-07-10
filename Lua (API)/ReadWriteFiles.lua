writeSettingsFile = function(tbl, filename)
    local file = getFileWriter(filename, true, false)
    if not file then
        return
    end
    for key, value in pairs(tbl) do
        file:write(key .. " = ".. tostring(value) .. "\r\n")
    end
    file:close()
end

readSettingsFile = function(tbl, filename)
    local file = getFileReader(filename, true)
    if not file then return end
    while true do repeat
        local line = file:readLine()
        if line == nil then
            file:close()
            return
        end
        line = string.gsub(line, "^ +(.+) +$", "%1", 1)
        if line == "" then break end
        for key, value in string.gmatch(line, "(%w+) *= *(.+)") do
            tbl[key] = value -- note that value will be a string, you may need to convert to number or w/e
        end
    until true end
    return tbl
end