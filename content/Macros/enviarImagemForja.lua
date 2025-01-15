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
  faixaErroCritico = math.floor(0.10 * tamanhoChat)
faixaAcertoCritico = math.floor(0.05 * tamanhoChat)
posicaoCentro = math.floor(tamanhoChat / 2)

if not(sheet) then return end
posicaoJogador = sheet.macroForjaPosicao    or  0.5 -- posicao do jogodaor em porcentagem
progresso      = sheet.macroForjaProgresso  or  0 -- porcentagem do progesso

posicaoJogador = round(posicaoJogador * tamanhoChat) -- Transforma de porcentagem para inteiro

-- Imagens menores
imagensNaoUsadas = {["barraEsquerda"] = "[§Ihttp://blob.firecast.com.br/blobs/ALRHUTRI_2487909/Barra_esquerda.png]",
		   ["barraDireita"]  = "[§Ihttp://blob.firecast.com.br/blobs/IJSNULFM_2487915/Barra_direita.png]",
		   ["baseX1"]        = "[§Ihttp://blob.firecast.com.br/blobs/TRHKUQHG_2487921/pixel_base.png]",
		   ["baseX5"]        = "[§Ihttp://blob.firecast.com.br/blobs/BHRLGMOO_2487962/pixel_base_x5.png]",
		   ["baseX20"]       = "[§Ihttp://blob.firecast.com.br/blobs/JHHGNVDO_2487964/pixel_base_x20.png]",
		   ["centroExato"]  = "[§Ihttp://blob.firecast.com.br/blobs/EOJPTDSF_2487911/Centro_centro.png]",
		   ["centroBorda"]   = "[§Ihttp://blob.firecast.com.br/blobs/PMRKSQFC_2487910/Centro_borda.png]",
		   ["cursorCentro"]  = "[§Ihttp://blob.firecast.com.br/blobs/HDHBWVKO_2487918/Cursor_centro.png]",
		   ["cursorBorda"]   = "[§Ihttp://blob.firecast.com.br/blobs/FHNBOAGG_2487917/Cursor_borda.png]"}

-- Imagens maiores
imagens = {["barraEsquerda"] = "[§Ihttp://blob.firecast.com.br/blobs/OOHDMREN_2488090/Barra_esquerda.png]",
		   ["barraDireita"]  = "[§Ihttp://blob.firecast.com.br/blobs/MOUPTBTW_2488095/Barra_direita.png]",
		   ["baseX1"]        = "[§Ihttp://blob.firecast.com.br/blobs/KJRIVRQE_2488101/pixel_base.png]",
		   ["baseX5"]        = "[§Ihttp://blob.firecast.com.br/blobs/NPMJOMIE_2488097/pixel_base_x5.png]",
		   ["baseX20"]       = "[§Ihttp://blob.firecast.com.br/blobs/PEGRCCKD_2488103/pixel_base_x20.png]",
		   ["centroExato"]  = "[§Ihttp://blob.firecast.com.br/blobs/TLGIFWLV_2488091/Centro_centro.png]",
		   ["centroBorda"]   = "[§Ihttp://blob.firecast.com.br/blobs/QLISFCLS_2488089/Centro_borda.png]",
		   ["cursorCentro"]  = "[§Ihttp://blob.firecast.com.br/blobs/SLTIKADC_2488104/Cursor_centro.png]",
		   ["cursorBorda"]   = "[§Ihttp://blob.firecast.com.br/blobs/UMBJPFSU_2488098/Cursor_borda.png]"}


-- Tamanahos das bases, pra poder usar um tamanho de chat maior
tamanhos = {20, 5, 1}

------------------------------
--                          --
--          FUNÇÕES         --
--                          --
------------------------------

-- Checa se um número A está uma faixa de distância D do número B
function checarProximidade(A, B, D)
	return ((A >= B - d) and (A <= B + d))
end

function pegarImagem(posicao)
	-- Cursor
	  -- Primeiro checa se está em uma posição a no máximo 1 de distância da posição do cursor
	if ((posicao >= posicaoJogador - 1) and (posicao <= posicaoJogador + 1))  then
		-- Se a posição for igual do cursor, coloca a imagem central
		if (posicaoJogador == posicao) then return "cursorCentro"
		-- Se a posição for outra, coloca a imagem da borda
		else                                return "cursorBorda" end
	-- Faixa do erro crítico
	elseif (posicao <= faixaErroCritico or posicao > (tamanhoChat - faixaErroCritico)) then
		-- Sem imagem ainda para faixa do erro crítico, por conta disso retorna a imagem centro exato
		return "centroExato"
	-- Centro exato
	elseif (posicao == posicaoCentro) then
		return "centroExato"
	-- Centro borda
	elseif ((posicao == posicaoCentro - 1) or (posicao == posicaoCentro + 1)) then
		return "centroBorda"
	-- Faixa acerto crítico
	elseif (checharProximidade(posicao, posicaoCentro, faixaAcertoCritico)) then
		-- Sem imagem ainda para faixa do acerto crítico, por conta disso retorna a imagem do centro exato
		return "centroExato"
	end
	
	return "base"
end

function passarPraTexto()
	-- Primeira coisa na imagem é a barra da esquerda
	mensagem = imagens.barraEsquerda
	
	local i = 0
	while (i <= tamanhoChat) do
		i = i + 1
		posicaoAtual = pegarImagem(i)
		
		-- No caso da imagem base, continua iterando até achar outro tipo de imagem
		-- Assim é possível reduzir a quantidade de imagens utilizando imagens que 
		-- possuí várias bases em uma só
		if (posicaoAtual == "base") then
			-- Descobre a quantidade de bases
			quantidade = 1
			while(pegarImagem(i+1) == "base") do
				if (i+1 > tamanhoChat) then break end
				quantidade = quantidade + 1
				i = i + 1
			end
			
			-- Itera sobre a lista de tamanhos, sendo ela organizada do maior para o menor
			for _, tamanho in ipairs(tamanhos) do
				-- Enquanto ainda tiver tamanho suficiente vai convertendo em imagens
				while(quantidade >= tamanho) do
					mensagem = mensagem .. imagens["baseX" .. tamanho]
					quantidade = quantidade - tamanho
				end
			end
		else
			-- Adiciona a imagem ao resto da mensagem
			mensagem = mensagem .. imagens[posicaoAtual]
		end
	end
	nome = (sheet.macroForjaNome and ("[§K14]< [§K1]" .. sheet.macroForjaNome .. " [§K14]>")) or ""
	return (nome .. "[§K14] [ [§K2]" .. round(progresso * 100) .. "%[§K14] ]\n" .. mensagem .. imagens.barraDireita)
end

------------------------------
--                          --
--           MAIN           --
--                          --
------------------------------

enviar(passarPraTexto())
