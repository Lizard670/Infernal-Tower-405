if (#arg < 1) then escrever("[§K2]Uso correto: /forjarItem <Dificuldade item> [nome]"); return 1 end

nivelDeOficio = tonumber(sheet.nivelDeOficio)
if not(nivelDeOficio     ) then escrever("[§K4]Nivel de oficio invalido"); return 2
elseif(nivelDeOficio <= 0) then nivelDeOficio = 0.1 end
sheet.macroForjaPosicao    =  0.5
sheet.macroForjaProgresso  =  0
sheet.macroForjaNome       = string.sub(parameter, #arg[1] + 2, -1) or ""

totalNecessario = tonumber(arg[1] or "")
while not(totalNecessario and totalNecessario > 0) do totalNecessario = tonumber(inputQuery("Necessário: ")) end

sheet.macroForjaTotalNecessario = totalNecessario / nivelDeOficio
invoke("enviarImagemForja")