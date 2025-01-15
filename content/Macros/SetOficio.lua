if (#arg < 1) then escrever("[§K2]Uso correto: /setOficio <nivel>"); return 1 end

sheet.nivelDeOficio = tonumber(arg[1] or "") or sheet.nivelDeOficio
escrever("[§K2]" .. (sheet.nivelDeOficio or "nil"))