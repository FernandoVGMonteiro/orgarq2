LEGv8 SUBSET Grupo E
==============
------------

Projeto desenvolvido para a disciplina de PCS3446 - Organização e Arquitetura de Computadores II 
-------------------------------------------------------------------------------------------------

> **1. Descrição**

Esse projeto consiste numa implementação do subconjunto LEGv8 do arquitetura ARMv8, descrito por Patterson e Hennessy em Computer Organization and Design ARM Edition: The Hardware Software Interface.

É um processador RISC, do formato Load/Store.

A pasta exp1 consiste na implementação de um subconjunto bem reduzido de instruções, numa organização monociclo.
A pasta exp2 transforma essa implementação monociclo numa implementação pipeline, com os 5 estágios descritos no livro.
A pasta exp3, finalmente, contém a expansão do conjunto da instruções para as 37 descritas para o LEGv8.

Detalhes das decisões de projeto tomadas estão descritos no relatório.pdf em doc/relatorio.pdf.

Todas as entidades foram compiladas e simuladas utilizando o ModelSim, com a entidade processor (arquivo processador,vhd) como top_level.

> **2. Compilação**

Para compilar e simular o projeto, existem duas possibilidades:

* No quartus, abrir o projeto *processor.qpf*, verificar se a entidade *processor* está definida como top level e iniciar a compilação. Essa forma de compilação, durante o projeto, foi utilizada apenas para verificar se o hardware descrito era sintetizável e conferir, no RTL-Viewer ser todas as ligações estavam adequadas.
<br/>O processador final, exibido nesse trabalho, foi traduzido com sucesso para portas lógicas no quartus, mas não caberia numa cyclone V por utilizar 2833 LABS. Era esperado que esse processador ficasse grande, dado as escolhas de projeto de fazê-lo o mais simples possível. Caso deseje efetivamente sintetizar esse processador, um ponto inicial para tentar reduzir o tamanho é nas ULAS. Para todo o processador foi utilizada a mesma ULA, com mais de 10 operações, embora a maioria das ULAS apenas realizem somas.<br/><br/>
* No model sim, adicionar os arquivos da pasta src/ na opção de compile na ordem:

>1. controComAlu.vhd
>2. dualregfile.vhd
>3. mux2to1.vhd
>4. ram.vhd
>5. reg.vhd
>6. rom.vhd
>7. shiftleft2.vhd
>8. signExtended.vhd
>9. fp.vhd
>10. fluxo_de_dados.vhd
>11. processador,vhd

Caso seja compilado em outra ordem, é provavel que na primeira vez dê algum erro por falta da definição de algum componente. Esse erro deve ser resolvido recompilando-se todos os componentes uma segunda vez.

Para simular um programa, deve-se popula o arquivo rom.vhd com o programa a ser simulado.

O processador gera todos os sinais necessários para a simulação ser rodada, devendo-se apenas notar que:

* A escala de tempo deve estar em ns, já que o ciclo de relógio é de 200ns (default do modelsim é ps).
* As unidades de memórias são limitadas, então acessos que caiam fora das posições de memória vão disparar exceções e a simulação é parada.

o arquivo rom.vhd tem o formato:

```

type rom_data is array (0 to 19) of bit_vector ( wordSize - 1 downto 0 );
constant rom : rom_data := (
    x"B4000040", --instrucao 1
    x"B4000040", -- instrucao 2
    .
    .
    .
    x"B4000040" -- instrucao 20

```

Cabe destacar que esse processador **não** faz antecipação de dados. Assim, conflitos do tipo RAW devem ser resolvidos em "tempo de compilação" por meio da inserção de bolhas.

> **3. Simulação**

Uma vez compilado o projeto conforme o passo 2, para a simulação pode-se utilizar o arquivo Waves/pipelinevalidation.vhd para analisar os sinais ao longo de todo o pipeline. Para mais detalhes sobre como fazer isso, ver arquivo docs/relatorio.pdf

> **4. Contato**

Em caso de eventuais problemas, contatar mateus.vendramini@usp.br (coordenador)

O repositório de desenvolvimento do projeto está disponível em:

https://github.com/FernandoVGMonteiro/orgarq2

O projeto do LEGv8 full pipeline encontra-se na pasta exp3 desse repositório. exp2 diz respeito a implementação do pipeline do livro e exp1 a implementação monociclo.
