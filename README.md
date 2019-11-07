Projeto desenvolvido para a disciplina de PCS3446 - Organização e Arquitetura de Computadores II 

Consiste numa implementação do subconjunto LEGv8 do arquitetura ARMv8, descrito por Patterson e Hennessy em Computer Organization and Design ARM Edition: The Hardware Software Interface.

É um processador RISC, do formato Load/Store.

A pasta exp1 consiste na implementação de um subconjunto bem reduzido de instruções, numa organização monociclo.
A pasta exp2 transforma essa implementação monociclo numa implementação pipeline, com os 5 estágios descritos no livro.
A pasta exp3, finalmente, contém a expansão do conjunto da instruções para as 37 descritas para o LEGv8.

Detalhes das decisões de projeto tomadas estão descritos no relatório.pdf (em redação).

Todas as entidades foram compiladas e simuladas utilizando o ModelSim, com a entidade processor (arquivo processador,vhd) como top_level.
