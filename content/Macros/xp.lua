-- xp <valor> [L para editar diretamento dos níveis]

local target = 1 -- em que linha o xp vai ficar
local jogador = meuJogador

-- se o objeto jogador não existe, retorna 1
if jogador == nil then 
    escrever("Jogador não encontrado")
    return 1
end

if (jogador:getEditableLine(target) == nil) then
    escrever("Barrinha não encontrada")
    return 2
end



-- VALORES
local valor = tonumber(arg[1])

while (valor == nil) do
    valor = tonumber(inputQuery("Valor: ", 0))
end

-- OPERAÇÃO
local op = arg[2]

if (op) then
    op = string.upper(op)
    if (op ~= "L") then _, op = choose("Qual a operação?", {"L", "Normal"},1) end
end



-- ACTION
local lineRaw = jogador:getEditableLine(target)

if (string.find(lineRaw, "%[%d+/%d+%]") == nil) then
    escrever("Você não possuí xp na barrinha")
    return 3
end

local bufferInicio, bufferFim = string.find(lineRaw, "%b[/")
local currentValue = tonumber(string.sub(lineRaw, bufferInicio + 1, bufferFim - 1))

bufferInicio, bufferFim = string.find(lineRaw, "%b/]")
local level = math.floor(tonumber(string.sub(lineRaw, bufferInicio + 1, bufferFim - 1)) / 100)

escrever("---------- \nNível inicial:    [§K2]" .. level .. "\n[§K1]xp inicial:    [§K2]" .. currentValue)

if (op == "L") then
    level = level + valor
else
    currentValue = currentValue + valor
    local levelsGained = 0
    if (valor > 0) then
        while (true) do
            if (currentValue < (level * 100) or level == 0) then
                escrever("\nNíveis ganhos: [§K2]" .. levelsGained)
                break
            end
            currentValue = currentValue - level * 100
            level = level + 1
            levelsGained = levelsGained + 1
        end
    elseif (valor < 0) then
        while (true) do
            if (currentValue >= 0 or level == 0) then
                escrever("\nNíveis perdidos: [§K2]" .. levelsGained)
                break
            end
            level = level - 1
            currentValue = currentValue + level * 100
            levelsGained = levelsGained + 1
        end
    end
end


escrever("\nNível final:    [§K2]" .. level .. "\n[§K1]xp final:    [§K2]" .. currentValue .. "\n[§K1]---------- ")

-- Coloca na barrinha
jogador:requestSetEditableLine(target, "Nível " .. level .. ": [" .. currentValue .. "/" .. level * 100 .. "]")

-- Coloca na ficha
sheet.nivelPersonagem = level or sheet.nivelPersonagem or 1
sheet.xpAtual = currentValue or sheet.xpAtual or 0