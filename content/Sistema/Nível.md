Conforme o jogador completa feitos no mundo, ele recebe experiência e com essa experiência ele é capaz de subir de nível.
A experiência necessária para chegar ao próximo nível sempre é 10, independente do nível.

A experiência total possuída pode ser facilmente calculada usando a seguinte fórmula:
$$
T = (N-1)*10 + E
$$
N = Nível atual
E = experiência na barra
T = Total
Sendo possível inverter o cálculo e receber o nível atual usando o xp total:
$$
N = \lfloor \frac{T}{10} \rfloor + 1
$$
$$
E = T - (N-1)*10
$$

Tabela de experiência ganha ao completar um feito:

| Dificuldade | XP ganho | Classe |
|-------------|----------|--------|
|Cotidiana    |001       |  F     |
|Fácil        |002       |  E     |
|Mediana      |005       |  D     |
|Difícil      |025       |  C     |
|Épica        |050       |  B     |
|Extrema      |100       |  A     |
|Lendária     |200       |  S     |
|Divina       |400       | SS     |
|Impossível   |690       |SSS     |