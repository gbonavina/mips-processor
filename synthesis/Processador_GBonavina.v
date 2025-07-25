module ProcessadorFinal(
    input [9:0] switches,
    input BUTTON_BOUNCE,
	 input reset,

    // --- Clock ---
    input CLK_50,

     output [6:0] display1,
     output [6:0] display2,
     output [6:0] display3,
     output [6:0] display4,
     output [6:0] display5,
     output [6:0] display6,
     output [6:0] display7,
     output [6:0] display8
    );
    //================================================================
    // SINAIS INTERNOS (WIRES)
    //================================================================

    wire clk;
    wire confirm;

    // --- Entradas de Controle ---
    wire SumZero;
    wire ULAData;
    wire ALUSrc;
    wire PushOP;
    wire PopOP;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MEMData;
    wire MemToReg;
    wire NOP;
    wire StackOP;
    wire JAL;
    wire JR;
    wire Jump;
    wire branch;
    wire halt;
    wire IMIn;
    wire [1:0] IMSel;
    wire RSSel;
    wire RTSel;
    wire [3:0] ALUOp;
    wire input_request;
    wire OutOP;
    wire IOE;
    wire IOSel;

    // -- Sinais do Caminho do PC --
    wire [31:0] pc_in;             
    wire [31:0] pc_out;            
    wire [31:0] pc_plus_one;       
    wire [31:0] pc_if_branch;
    wire [31:0] mux_jr_im;   
    wire [31:0] mux_pc_jump;       
    wire mux_control;             

    // -- Sinais da Instrução e Imediatos --
    wire [31:0] instrucao;         
    wire [5:0] opcode;
    wire [5:0] rs1, rs2, rt1, rt2, rd; 
    wire [5:0] out_mux_rs;         
    wire [5:0] out_mux_rt;         
    wire [13:0] im14;              
    wire [19:0] im20;              
    wire [25:0] im26;              
    wire [31:0] sinalEstendido;   
    wire [31:0] offset_para_branch; 
    wire [9:0] data_in_reg;
    wire [31:0] saida_dado;

    // -- Sinais do Banco de Registradores e Pilha --
    wire [31:0] dado1;             
    wire [31:0] dado2;             
    wire [31:0] SPIn;              
    wire [31:0] SPOut;             
    wire [31:0] SPmem;             
    wire [31:0] mux_jal_imediato;  


    // -- Sinais da ULA --
    wire [31:0] mux_zero_dado1;    
    wire [31:0] mux_dado_ula;      
    wire [31:0] mux_imediato_dado2; 
    wire [31:0] ULARes;            
    wire Zero;                   

    // -- Sinais da Memória de Dados --
    wire [31:0] out_mem;           
    wire [6:0] mux_pilha_ula;      
    wire [31:0] dado_para_memoria; 

    // -- Sinais do Caminho de Write-Back --
    wire [31:0] mux_mem_ULA;       
    wire [31:0] mux_jal_mem;
	 
     wire [31:0] stored_value;

     wire ok;

     //================================================================
     // DIVISOR DE FREQUÊNCIA
     //================================================================

    DivisorFrequencia u_DivisorFrequencia (
          .CLOCK_50    (CLK_50),
          .CLK_DIV     (clk)
    );


     assign ok = ~BUTTON_BOUNCE;

    Debounce u_Debounce (
         .clk                (CLK_50),
         .reset              (reset),
         .button_bounce      (ok),
         .button_debounce    (confirm)
    );

     ModuloEntradaSaida u_ModuloEntradaSaida (
          .switch_dado     (switches),
          .entrada_dado    (dado1),
          .IOE             (IOE),
          .IOsel           (IOSel),
          .saida_dado      (saida_dado),
          .HEX0            (display1),
          .HEX1            (display2),
          .HEX2            (display3),
          .HEX3            (display4),
          .HEX4            (display5),
          .HEX5            (display6),
          .HEX6            (display7),
          .HEX7            (display8)
     );

    //================================================================
    // ESTÁGIO 1: BUSCA DA INSTRUÇÃO (INSTRUCTION FETCH - IF)
    //================================================================

    // Contador de Programa (PC) que armazena o endereço da instrução atual.
    ProgramCounter u_ProgramCounter (
         .pc_in    (pc_in),
         .pc_out   (pc_out),
         .halt     (halt),
			.reset 	 (reset),
         .stall    (input_request),
         .confirm  (confirm),
         .clk      (clk)
    );

    // Memória que armazena as instruções do programa.
    // ADDR_WIDTH=5 significa 2^5 = 32 posições de memória.
    // A entrada pc_addr é truncada para 5 bits, usando pc_out[4:0].
    MemoriaInstrucao #(
         .DATA_WIDTH (32),
         .ADDR_WIDTH (4)
    ) u_MemoriaInstrucao (
         .pc_addr  (pc_out[5:0]), // Trunca pc_out para 6 bits de endereço
         .q        (instrucao)
    );

    // Soma 1 ao PC para apontar para a próxima instrução sequencial.
    adder sum_pc_one (
         .A        (pc_out),
         .B        (32'd1), // Constante 1 de 32 bits
         .sum      (pc_plus_one)
    );

    //================================================================
    // ESTÁGIO 2: DECODIFICAÇÃO E LEITURA DOS REGISTRADORES (ID)
    //================================================================

    assign opcode = instrucao[31:26]; // Extrai o opcode de 6 bits da instrução
    // Unidade de controle 
    UnidadeControle u_UnidadeControle (
     .opcode      (opcode),
     .SumZero     (SumZero),
     .JAL         (JAL),
     .JR          (JR),
     .HALT        (halt),
     .Jump        (Jump),
     .Branch      (branch),
     .RegWrite    (RegWrite),
     .RSSel       (RSSel),
     .RTSel       (RTSel),
     .ALUSrc      (ALUSrc),
     .MemData     (MemData),
     .NOP         (NOP),
     .IMIn        (IMIn),
     .OutOP       (OutOP),
     .MemWrite    (MemWrite),
     .PushOP      (PushOP),
     .PopOP       (PopOP),
     .StackOP     (StackOP),
     .MemRead     (MemRead),
     .MemToReg    (MemToReg),
     .IMSel       (IMSel),
     .ALUOp       (ALUOp),
     .input_request (input_request),
     .IOE         (IOE), // Sinal de controle para entrada/saída
     .IOSel       (IOSel)  // Sinal de controle para seleção de entrada/saída
    );

    // Decodifica os endereços dos registradores da instrução.
    // Os campos de registradores são de 6 bits, permitindo 64 registradores.
    assign rs1 = instrucao[19:14];
    assign rs2 = instrucao[25:20];
    assign rt1 = instrucao[19:14];
    assign rt2 = instrucao[13:8];
    assign rd  = instrucao[25:20];

    // Mux para selecionar o endereço do primeiro registrador de leitura (RS).
    // Seleciona entre rs1 e rs2 com base em RSSel.
    Mux6b mux_rs (
         .a        (rs1),
         .b        (rs2),
         .s        (RSSel),
         .out      (out_mux_rs)
    );

    // Mux para selecionar o endereço do segundo registrador de leitura (RT).
    // Seleciona entre rt1 e rt2 com base em RTSel.
    Mux6b mux_rt (
         .a        (rt1), 
         .b        (rt2),
         .s        (RTSel),
         .out      (out_mux_rt)
    );

    // Decodifica os campos de imediato da instrução.
    assign im14 = instrucao[13:0]; // 14 bits
    assign im20 = instrucao[19:0]; // 20 bits
    assign im26 = instrucao[25:0]; // 26 bits

    // Estende o sinal do imediato para 32 bits.
    // sinalInput é um imediato de 20 bits que pode ser usado como entrada.
    ExtensorSinal u_ExtensorSinal (
         .im26           (im26),
         .im20           (im20),
         .im14           (im14),
         .IMSel          (IMSel),
         .sinalEstendido (sinalEstendido)
    );

    // Banco de Registradores: lê os dados de RS e RT. A escrita ocorre no final do ciclo.
    // SPIn é o valor atualizado do Stack Pointer.
    // DadoEscrito é o dado final do caminho de write-back.
    BancoDeRegistradores u_BancoDeRegistradores (
         .RS           (out_mux_rs),
         .RT           (out_mux_rt),
         .RD           (rd),
         .SPIn         (SPIn),
         .DadoEscrito  (mux_jal_imediato), // Sinal final do caminho de write-back
         .RegWrite     (RegWrite),
         .NOP          (NOP),
         .StackOP      (StackOP),
         .JAL          (JAL),
         .dado1        (dado1),
         .dado2        (dado2),
         .SPOut        (SPOut),
         .clock        (clk)
    );

    //================================================================
    // ESTÁGIO 3: EXECUÇÃO (EXECUTE - EX)
    //================================================================

    // Mux para selecionar entre \'dado1\' ou \'0\' como primeiro operando da ULA.
    // Controlado por SumZero.
    Mux mux_zeroOrDado1 (
         .a        (dado1),
         .b        (32'd0),
         .s        (SumZero),
         .out      (mux_zero_dado1)
    );

    // Mux para selecionar entre a saída do mux anterior (mux_zero_dado1) ou \'dado2\'
    // Controlado por ULAData.
    Mux mux_dadoUlaInput (
         .a        (mux_zero_dado1),
         .b        (dado2),
         .s        (ULAData),
         .out      (mux_dado_ula)
    );

    // Mux (ALUSrc) para selecionar o segundo operando da ULA: \'dado2\' ou o imediato estendido.
    // Controlado por ALUSrc.
    Mux mux_imediatoOrDado2 (
         .a        (dado2),
         .b        (sinalEstendido),
         .s        (ALUSrc),
         .out      (mux_imediato_dado2)
    );

    // Unidade Lógica e Aritmética (ULA)
    // Realiza operações aritméticas e lógicas nos operandos X e Y.
    ULA u_ULA (
         .ALUOp    (ALUOp),
         .X        (mux_dado_ula),
         .Y        (mux_imediato_dado2),
         .ULARes   (ULARes),
         .Zero     (Zero)
    );


    //================================================================
    // ESTÁGIO 4: ACESSO À MEMÓRIA (MEMORY - MEM)
    //================================================================

    // Unidade de Controle da Pilha
    // Calcula os novos valores para o Stack Pointer (SP) e o endereço de memória da pilha.
    UC_Pilha u_UC_Pilha (
         .SPbefore (SPOut),
         .PushOP   (PushOP),
         .PopOP    (PopOP),
         .SPafter  (SPIn),
         .SPmem    (SPmem)
    );

    // Mux para selecionar o endereço da memória: resultado da ULA (ULARes) ou o ponteiro da pilha (SPmem).
    // O endereço da memória de dados é de 7 bits (2^7 = 128 posições).
    Mux7b mux_endereco (
         .a        (ULARes[6:0]), // Trunca ULARes para 7 bits de endereço
         .b        (SPmem[6:0]),  // Trunca SPmem para 7 bits de endereço
         .s        (StackOP),
         .out      (mux_pilha_ula)
    );

    // Mux para selecionar o dado a ser escrito na memória.
    // Seleciona entre dado1 e dado2 com base em MEMData.
    Mux mux_dado_escrita (
         .a        (dado1),
         .b        (dado2),
         .s        (MEMData),
         .out      (dado_para_memoria)
    );

    // Memória de Dados.
    // DATA_WIDTH=32, ADDR_WIDTH=7.
    MemoriaDados #(
         .DATA_WIDTH   (32),
         .ADDR_WIDTH   (7)
    ) u_MemoriaDados (
         .dado_escrita (dado_para_memoria),
         .endereco     (mux_pilha_ula),
         .MemWrite     (MemWrite),
         .MemRead      (MemRead),
         .clk          (clk),
         .out          (out_mem)
    );


    //================================================================
    // ESTÁGIO 5: ESCRITA DE VOLTA (WRITE-BACK - WB)
    //================================================================

    // Mux (MemToReg) para selecionar o dado a ser escrito no registrador: resultado da ULA ou dado da memória.
    Mux mux_memOrULA (
         .a        (ULARes),
         .b        (out_mem),
         .s        (MemToReg),
         .out      (mux_mem_ULA)
    );

    // Mux para o JAL (Jump and Link), que salva \'pc_plus_one\' no registrador de destino (ra).
    Mux mux_jal (
         .a        (mux_mem_ULA),
         .b        (pc_plus_one),
         .s        (JAL),
         .out      (mux_jal_mem)
    );

    // Mux final para carregar um valor imediato diretamente no registrador (IMIn).

     wire [31:0] mux_imediatos;

    Mux switch_imediato (
          .a (sinalEstendido)
          .b (saida_dado)
          .s (IOSel)
          .out (mux_imediatos)
    )


    Mux mux_imediato (
         .a        (mux_jal_mem),
         .b        (mux_imediatos),
         .s        (IMIn),
         .out      (mux_jal_imediato) // Sinal final que vai para o Banco de Registradores
    );


    //================================================================
    // LÓGICA DE ATUALIZAÇÃO DO PC (BRANCH, JUMP)
    //================================================================

    Mux mux_offset_branch (
        .a (32'd0),
        .b (sinalEstendido),
        .s (branch), // <<< O SINAL DE CONTROLE DO BRANCH
        .out (offset_para_branch)
    );

    // Calcula o endereço de destino para o branch.
    // Soma pc_plus_one com o imediato estendido.
    adder sum_branch (
         .A        (pc_plus_one),
         .B        (offset_para_branch),
         .sum      (pc_if_branch)
    );

    // Mux para selecionar entre o endereço de um jump (imediato estendido) ou jump register (dado1).
    // Controlado por JR.
    Mux mux_jr (
         .a        (sinalEstendido),
         .b        (dado1),
         .s        (JR),
         .out      (mux_jr_im)
    );

    // Mux para selecionar entre o caminho de jump (mux_jr_im) ou o caminho sequencial (pc_plus_one).
    // Controlado por Jump.
    Mux mux_jump (
         .a        (pc_plus_one),
         .b        (mux_jr_im),
         .s        (Jump),
         .out      (mux_pc_jump)
    );

    // Lógica de controle do branch: ocorre se \'branch\' for 1 e o resultado da ULA for zero.
    assign mux_control = Zero & branch;

    // Mux final: seleciona o próximo valor do PC.
    // Seleciona entre o caminho do branch (pc_if_branch) ou o caminho do jump/sequencial (mux_pc_jump).
    // Controlado por mux_control.
    Mux mux_branch_pc (
         .a        (mux_pc_jump), // Caminho do branch (se tomado)
         .b        (pc_if_branch),  // Caminho do jump ou sequencial
         .s        (mux_control),
         .out      (pc_in)         // Saída conectada à entrada do PC
    );
endmodule