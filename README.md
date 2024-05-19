# Módulos e Testbenches em Verilog
Este documento fornece uma visão geral das discussões e exemplos de código relacionados a módulos Verilog e seus testbenches. O foco está em entender escalas de tempo, operações lógicas em valores de múltiplos bits e na criação de testbenches para validar a funcionalidade dos módulos em Verilog.
## Índice 

1. [Escalas de Tempo em Verilog](#Escalas-de-Tempo-em-Verilog)
2. [Operações Lógicas em Valores de Múltiplos Bits](#Operações-Lógicas-em-Valores-de-Múltiplos-Bits)
3. [Criando Testbenches](#Criando-Testbenches)
4. [Operação OU em Verilog](#Operação-OU-em-Verilog)
5. [Resumo dos Pontos Principais](#Resumo-dos-Pontos-Principais)
6. [Portas Lógicas em Verilog](#Portas-Lógicas-em-Verilog)

# Escalas de Tempo em Verilog
Verilog usa a diretiva *timescale* para definir a unidade de tempo e a precisão de tempo para simulação.

```
`timescale 10ns/1ns
```
+ Unidade de tempo (10ns): A unidade base de tempo para atrasos.
+ Precisão de tempo (1ns): A precisão das medições de tempo.

## Exemplo: Entendendo o Tempo em Testebenchs para a formação da onda

```
initial begin
    #10;
    // Código executado após 10ns

    #30;
    // Código executado após mais 30ns (total 40ns)

    #40;
    // Código executado após mais 40ns (total 80ns)

    #50;
    // Código executado após mais 50ns (total 130ns)

    #100;
    $stop;
    // Simulação para em 230ns
end
```
Alterar a precisão do tempo pode afetar o desempenho da simulação, mas não a correção. Uma precisão mais fina resulta em simulação mais precisa, mas pode ser mais lenta. Ou seja, o valor (1ns) que está a direita, não afetará na construção da onda.

# Operações Lógicas em Valores de Múltiplos Bits

## Exemplo de XOR (OU exclusivo)

```
module eq(
    input [1:0] e0,
    input [1:0] e1,
    output s
);

assign s = !(e0 ^ e1);

endmodule
```
+ XOR('^'): Compara cada bit.
+ Negação('!'): Converte qualquer resultado não zero em 0 e resultado zero em 1.

## Exemplo de AND

```
module eq(
    input [1:0] e0,
    input [1:0] e1,
    output s
);

assign s = ~&(e0 & e1);

endmodule
```

+ AND('&'): Compara cada bit.
+ AND de Redução('&'): Combina todos os bits de um vetor.
+ Negação('~'): Nega o resultado combinado

```
assign s = ~&(e0 & e1);
//O and que está dentro faz a comparação de bit por bit
// ex -> e0 = 2'b01, e1 = 2'b11
// Ele verifica (0 AND 1) + (1  AND 1) = 2'b01
// O and de fora vai combinar os valores de dentro, então (0 AND 1) = 1'b0
// Agora como ele está negando, então meu resultado final vai ser 1'b1
```

# Criando Testbenches
Um testbench é usado para verificar a correção de um módulo aplicando diferentes casos de teste.

## Testbench para Exemplo de XOR

```
`timescale 1ns/1ps

module eq_test;
    reg [1:0] e0;
    reg [1:0] e1;
    wire s;

    eq uut (.e0(e0), .e1(e1), .s(s));

    initial begin
        // Casos de teste
        e0 = 2'b00; e1 = 2'b00;
        #10; $display("Test 1: e0 = %b, e1 = %b, s = %b", e0, e1, s);

        e0 = 2'b01; e1 = 2'b01;
        #10; $display("Test 2: e0 = %b, e1 = %b, s = %b", e0, e1, s);

        e0 = 2'b10; e1 = 2'b10;
        #10; $display("Test 3: e0 = %b, e1 = %b, s = %b", e0, e1, s);

        e0 = 2'b11; e1 = 2'b11;
        #10; $display("Test 4: e0 = %b, e1 = %b, s = %b", e0, e1, s);

        e0 = 2'b00; e1 = 2'b01;
        #10; $display("Test 5: e0 = %b, e1 = %b, s = %b", e0, e1, s);

        $stop;
    end
endmodule

```
# Operação OU em Verilog

## OU Bit a Bit('|')

```
module or_bitwise(
    input [1:0] a,
    input [1:0] b,
    output [1:0] y
);

assign y = a | b;

endmodule
```

## OU Lógico ('||')

```
module or_logical(
    input a,
    input b,
    output y
);

assign y = a || b;

endmodule
```

## Testbench para OU Bit a Bit

```
`timescale 1ns/1ps

module or_bitwise_test;
    reg [1:0] a;
    reg [1:0] b;
    wire [1:0] y;

    or_bitwise uut (.a(a), .b(b), .y(y));

    initial begin
        // Casos de teste
        a = 2'b00; b = 2'b00;
        #10; $display("Test 1: a = %b, b = %b, y = %b", a, b, y);

        a = 2'b01; b = 2'b01;
        #10; $display("Test 2: a = %b, b = %b, y = %b", a, b, y);

        a = 2'b10; b = 2'b10;
        #10; $display("Test 3: a = %b, b = %b, y = %b", a, b, y);

        a = 2'b11; b = 2'b11;
        #10; $display("Test 4: a = %b, b = %b, y = %b", a, b, y);

        $stop;
    end
endmodule
```

## Qual a diferença entre o '|' e o "||"
O operador OU bit a bit (|) realiza uma operação OU em cada par correspondente de bits dos operandos. Esta operação é aplicada a cada bit individualmente e resulta em um vetor de bits onde cada bit é o resultado da operação OU dos bits correspondentes nos operandos.
```
module or_bitwise;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;

    assign y = a | b;

    initial begin
        a = 4'b1010;
        b = 4'b1100;
        #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1110
    end
endmodule

```
```
a = 1010
b = 1100
---------
y = 1110 (resultante da operação OU bit a bit)

```
O operador OU lógico (||) é usado para comparar dois valores escalares (únicos bits ou expressões que são avaliadas como 0 ou 1) e resulta em um único valor booleano (1 bit). Se pelo menos um dos operandos for verdadeiro (diferente de zero), o resultado é verdadeiro (1). Caso contrário, o resultado é falso (0).
```
module or_logical;
    reg a;
    reg b;
    wire y;

    assign y = a || b;

    initial begin
        a = 1;
        b = 0;
        #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 0;
        b = 0;
        #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0
    end
endmodule
```

## Resumo das Diferenças

1. ### Operação:
   + OU Bit a Bit (|): Aplica a operação OU a cada par de bits correspondente dos operandos.
   + OU Lógico (||): Avalia dois valores escalares ou expressões e retorna um único valor booleano.
2. ### Resultados:
   + OU Bit a Bit (|): Retorna um vetor de bits onde cada bit é o resultado da operação OU dos bits correspondentes.
   + OU Lógico (||): Retorna um único bit (1 ou 0).
3. ### Uso:
   + OU Bit a Bit (|): Usado para operações em vetores de bits, como em operações de manipulação de dados.
   + OU Lógico (||): Usado em expressões condicionais para controle de fluxo, como em instruções if.
# Resumo dos Pontos Principais

+ Escalas de tempo em Verilog definem unidades de tempo de simulação e precisão.
+ Operações lógicas em valores de múltiplos bits (XOR, AND) são realizadas bit a bit, e os resultados podem ser combinados usando operadores de redução.
+ Testbenches são cruciais para verificar a funcionalidade dos módulos aplicando vários casos de teste.
+ A operação OU tem formas bit a bit (|) e lógica (||), usadas em diferentes contextos.

# Portas Lógicas em Verilog
Este guia fornece uma visão geral das portas lógicas disponíveis em Verilog, com explicações e exemplos de código para cada uma. As portas lógicas são fundamentais para o design de circuitos digitais e são usadas para criar operações lógicas básicas em hardware.

# índice
1. [Porta AND](#Porta-AND)
2. [Porta OR](#Porta-OR)
3. [Porta NOT](#Porta-NOT)
4. [Porta NAND](#Porta-NAND)
5. [PORTA NOR](#PORTA-NOR)
6. [PORTA XOR](#PORTA-XOR)
7. [PORTA XNOR](#PORTA-XNOR)

# Porta AND
A porta AND (&) realiza uma operação AND bit a bit entre os operandos.

## Exemplo:
```
module and_gate (
    input a,
    input b,
    output y
);

assign y = a & b;

endmodule
```
## Testebecnh
```
module and_gate_test;
    reg a, b;
    wire y;

    and_gate uut (.a(a), .b(b), .y(y));

    initial begin
        a = 0; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 0; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 1; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 1; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1
    end
endmodule
```

# Porta OR

A porta OR (|) realiza uma operação OR bit a bit entre os operandos.
## Exemplo:

```
verilog

module or_gate (
    input a,
    input b,
    output y
);

assign y = a | b;

endmodule
```

## Testbench:
```
Verilog

module or_gate_test;
    reg a, b;
    wire y;

    or_gate uut (.a(a), .b(b), .y(y));

    initial begin
        a = 0; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 0; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 1; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 1; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1
    end
endmodule
```

# Porta NOT
A porta NOT (~) realiza a negação bit a bit do operando.

## Exemplo: 
```
module not_gate (
    input a,
    output y
);

assign y = ~a;

endmodule
```
## Testebench:
```
module not_gate_test;
    reg a;
    wire y;

    not_gate uut (.a(a), .y(y));

    initial begin
        a = 0; #10;
        $display("a = %b, y = %b", a, y); // y = 1

        a = 1; #10;
        $display("a = %b, y = %b", a, y); // y = 0
    end
endmodule

```
# Porta NAND
A porta NAND (~&) realiza uma operação AND bit a bit seguida pela negação do resultado.

## Exemplo:
```
module nand_gate (
    input a,
    input b,
    output y
);

assign y = ~(a & b);

endmodule
```

## Testebench:
```
module nand_gate_test;
    reg a, b;
    wire y;

    nand_gate uut (.a(a), .b(b), .y(y));

    initial begin
        a = 0; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 0; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 1; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 1; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0
    end
endmodule
```

# Porta NOR 
A porta NOR (~|) realiza uma operação OR bit a bit seguida pela negação do resultado.

## Exemplo: 
```
module nor_gate (
    input a,
    input b,
    output y
);

assign y = ~(a | b);

endmodule

```
## Testbench:
```
module nor_gate_test;
    reg a, b;
    wire y;

    nor_gate uut (.a(a), .b(b), .y(y));

    initial begin
        a = 0; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 0; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 1; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 1; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0
    end
endmodule
```

# Porta XOR
A porta XOR (^) realiza uma operação OU exclusivo bit a bit entre os operandos.

## Exemplo: 
```
module xor_gate (
    input a,
    input b,
    output y
);

assign y = a ^ b;

endmodule
```

## Testbench:

```
module xor_gate_test;
    reg a, b;
    wire y;

    xor_gate uut (.a(a), .b(b), .y(y));

    initial begin
        a = 0; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 0; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 1; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 1; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0
    end
endmodule
```

# Porta XNOR
A porta XNOR (~^) realiza uma operação OU exclusivo bit a bit seguida pela negação do resultado.

## Exemplo:
```
module xnor_gate (
    input a,
    input b,
    output y
);

assign y = ~(a ^ b);

endmodule
```

## Testbench: 

```
module xnor_gate_test;
    reg a, b;
    wire y;

    xnor_gate uut (.a(a), .b(b), .y(y));

    initial begin
        a = 0; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 1

        a = 0; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 1; b = 0; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y = 0

        a = 1; b = 1; #10;
        $display("a = %b, b = %b, y = %b", a, b, y); // y =

```












