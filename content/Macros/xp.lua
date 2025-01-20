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



-- Pega os valores da barrinha
local linhaBruta = jogador:getEditableLine(target)

if (string.find(linhaBruta, "%[%d+/%d+%]") == nil) then
    escrever("Você não possuí xp na barrinha")
    return 3
end

local bufferInicio, bufferFim = string.find(linhaBruta, "%b[/")
local xpAtual = tonumber(string.sub(linhaBruta, bufferInicio + 1, bufferFim - 1))

bufferInicio, bufferFim = string.find(linhaBruta, "%b/]")
local nivelAtual = math.floor(tonumber(string.sub(linhaBruta, bufferInicio + 1, bufferFim - 1)) / 100)

escrever("---------- \nNível inicial:    [§K2]" .. nivelAtual .. "\n[§K1]xp inicial:    [§K2]" .. xpAtual)

-- Cálculo
if (op == "L") then
    niveisGanhados = valor
else
    local niveisGanhados = math.floor(valor / 10)
	xpAtual = xpAtual + (valor - (niveisGanhados*10))
	if (xpAtual >= 10) then
		xpAtual = xpAtual - 1
		niveisGanhados = niveisGanhados + 1
	end
end

nivelAtual = nivelAtual + niveisGanhados

-- envia mudanças no chat
if     (valor > 0) then
	escrever("\nNíveis ganhos: [§K2]" .. niveisGanhados)
elseif (valor < 0) then
	escrever("\nNíveis perdidos: [§K2]" .. niveisGanhados)
end

escrever("\nNível final:    [§K2]" .. nivelAtual .. "\n[§K1]xp final:    [§K2]" .. xpAtual .. "\n[§K1]---------- ")

-- Coloca na barrinha
jogador:requestSetEditableLine(target, "Nível " .. nivelAtual .. ": [" .. xpAtual .. "/" .. 10 .. "]")

-- Coloca na ficha
sheet.nivelPersonagem = nivelAtual or sheet.nivelPersonagem or 1
sheet.xpAtual = xpAtual or sheet.xpAtual or 0