function round(num) return math.floor(num + 4/9) end
------------------------------
--                          --
--        DEFINIÇÕES        --
--                          --
------------------------------

-- Corresponde a largura que aparecerá no chat, funcionalidade apenas visual
  -- Não inclúi a borda
  tamanhoChat = 141
-- Distância max em que se o ponteiro estiver quando acabar o processo, é considerado crítico
  -- Distância em porcentagem
  faixaErroCritico = math.floor(0.10)
faixaAcertoCritico = math.floor(0.05)
posicaoCentro = math.floor(tamanhoChat / 2)

if (#arg < 1) then escrever("[§K2]Uso correto: /forjar <forca> [direção]") end

posicao       = (sheet.macroForjaPosicao    or  0.5) -- Posição em porcentagem
posicaoAntiga = posicao
progresso     =  sheet.macroForjaProgresso  or  0 -- Progresso em porcentagem
-- Não sei um nome bom pra colocar aqui ainda, esse é o número é o total necessario pra forjar o item
totalNecessario =  sheet.macroForjatotalNecessario or 20 

forcas = {["fraco"] =   6,
		  ["medio"] =  20,
		  ["forte"] = 100}
forca = forcas[string.lower(arg[1])] or forcas.medio

------------------------------
--                          --
--          FUNÇÕES         --
--                          --
------------------------------

-- Checa se um número A está uma faixa de distância D do número B
function checarProximidade(A, B, D)
	return ((A >= B - d) and (A <= B + d))
end

------------------------------
--                          --
--           MAIN           --
--                          --
------------------------------

-- Checa se a direção é esquerda, se não move para direita
direcao = (string.lower(arg[2] or "") == "e" and -1) or 1

-- Rolagens
local progressoMudanca = rolar("1d" .. (forca), "Progresso")
local posicaoMudanca   = rolar("1d" .. (forca), "Tanto que move")

-- Se foi um erro crítico, na rolagem de posição, move pro outro lado
if (progressoMudanca == 1) then direcao = direcao * -1 end

-- Converte a mudança de inteiro para porcentagem
posicaoMudanca = posicaoMudanca / totalNecessario
	
-- Atualiza a posição
posicao = posicao + posicaoMudanca
    if (posicao < 0) then posicao = 0
elseif (posicao > 1) then posicao = 1 end
sheet.macroForjaPosicao = posicao -- Salva a posição atual na ficha

-- Atualiza o progresso
                progresso = progresso + (progressoMudanca / totalNecessario)
sheet.macroForjaProgresso = progresso -- Salva o progresso atual na ficha

invoke("enviarImagemForja")

-- Checa se terminou de forjar
if (progresso >= 1) then
	escrever(posicao)
	local mensagem = "[§K2]Item criado"
	    if (checarProximidade(posicao, 0.5, 0.01)) then
		mensagem = "[§K7]Item ótimo criado"
	elseif (checarProximidade(posicao, 0.5, acertoCritico)) then
		mensagem = "[§K3]Item bom criado"
	end
	
	enviar("[§K15]<[ " .. mensagem .. "[§K15] ]>")
-- Checa se está na faixa do erro crítico
elseif((posicao <= erroCritico) or (posicao >= 1 - erroCritico)) then
	enviar("[§K15]<[ [§K4]Falha na criação do item[§K15] ]>")
end