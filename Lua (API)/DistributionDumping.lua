function RTP_indent(n) local text = "" for i=0, n do text = text.."   " end return text end
function RecursiveTablePrint(object,nesting,every_other)
    nesting = nesting or 0
    local text = ""..RTP_indent(nesting)
    if type(object) == 'table' then
        local s = '{ \n'
        for k,v in pairs(object) do
            local items_print = false
            if k == "items" then items_print = true end
            if type(k) ~= 'number' then k = '"'..k..'"' end
            if (not every_other) or (every_other and (not (k % 2 == 0))) then s = s..RTP_indent(nesting+1) end
            s = s..'['..k..'] = '..RecursiveTablePrint(v,nesting+1,items_print)..", "
            if (not every_other) or (every_other and (k % 2 == 0)) then s = s.."\n" end
        end text = s.."\n"..RTP_indent(nesting).."}"
    else text = tostring(object) end
    return text
end
function PrintProceduralDistributions() print("ProceduralDistributions:"..RecursiveTablePrint(ProceduralDistributions).."\nEnd Of ProceduralDistributions") end
Events.OnKeyPressed.Add(function(key) if getDebug() and key == Keyboard.KEY_0 then PrintProceduralDistributions() end end)