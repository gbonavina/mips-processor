
`timescale 1ns/1ps

module tb_ProcessadorFinal;

    // ------------------------------------------------------------------------
    // 1) Declaração de sinais de estímulo (reg) e de resposta (wire)
    // ------------------------------------------------------------------------
    reg         clock;
    reg         SumZero;
    reg         ULAData;
    reg         ALUSrc;
    reg  [3:0]  ALUOp;
    reg  [31:0] imediato;
    reg  [5:0]  RS;
    reg  [5:0]  RT;
    reg  [5:0]  RD;
    reg  [31:0] SPIn;
    reg  [31:0] DadoEscrito;
    reg         RegWrite;
    reg         NOP;
    reg         StackOP;
    reg         JAL;

    wire [31:0] ULARes;
    wire        Zero;
    wire [31:0] dadoA;
    wire [31:0] dadoB;

    // ------------------------------------------------------------------------
    // 2) Instanciação do dispositivo sob teste (DUT)
    // ------------------------------------------------------------------------
    ProcessadorFinal DUT (
        .SumZero     (SumZero),
        .ULAData     (ULAData),
        .ALUSrc      (ALUSrc),
        .ALUOp       (ALUOp),
        .imediato    (imediato),
        .ULARes      (ULARes),
        .Zero        (Zero),
        .RS          (RS),
        .RT          (RT),
        .RD          (RD),
        .SPIn        (SPIn),
        .DadoEscrito (DadoEscrito),
        .RegWrite    (RegWrite),
        .NOP         (NOP),
        .StackOP     (StackOP),
        .JAL         (JAL),
        .clock       (clock),
        .dadoA       (dadoA),
        .dadoB       (dadoB)
    );

    // ------------------------------------------------------------------------
    // 3) Geração de clock periódico de 10 ns (50% duty cycle)
    // ------------------------------------------------------------------------
    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock; // período = 10 ns
    end

    // ------------------------------------------------------------------------
    // 4) Stimulus principal
    // ------------------------------------------------------------------------
    initial begin
        // 4.1) Inicialização de todos os sinais
        SumZero     = 1'b0;
        ULAData     = 1'b0;
        ALUSrc      = 1'b0;
        ALUOp       = 4'b0000;
        imediato    = 32'd0;
        RS          = 6'd0;
        RT          = 6'd0;
        RD          = 6'd0;
        SPIn        = 32'd0;
        DadoEscrito = 32'd0;
        RegWrite    = 1'b0;
        NOP         = 1'b0;
        StackOP     = 1'b0;
        JAL         = 1'b0;

        // Aguarda alguns ciclos de clock para estabilização
        #12;

        // ------------------------------------------------------------
        // 4.2) Escrevendo 10 em registrador 3 (RD = 3)
        // ------------------------------------------------------------
        RD          = 6'd3;         // escolhe registrador 3
        DadoEscrito = 32'd10;       // valor a ser escrito = 10
        RegWrite    = 1'b1;         // habilita escrita
        // Aguarda até antes da próxima borda de subida de clock
        #3;                         // clock estará 0 → vai subir em ~2 ns

        // No próximo rising edge (em t ≈ 15 ns), BancoDeRegistradores grava R[3] = 10
        #10;
        RegWrite    = 1'b0;         // desabilita escrita após a borda

        // ------------------------------------------------------------
        // 4.3) Escrevendo 20 em registrador 4 (RD = 4)
        // ------------------------------------------------------------
        #2;                         // aguarda para não coincidir exatamente com a borda
        RD          = 6'd4;         // agora escolhe registrador 4
        DadoEscrito = 32'd20;       // valor a ser escrito = 20
        RegWrite    = 1'b1;
        #8;                         // prepara para borda seguinte

        // No próximo rising edge (em t ≈ 35 ns), BancoDeRegistradores grava R[4] = 20
        #10;
        RegWrite    = 1'b0;         // desabilita escrita após a borda

        // ----------------------------------------------------------------------------
        // 4.4) Primeiro teste: soma de registrador + registrador (R[3] + R[4] = 10 + 20)
        // ----------------------------------------------------------------------------
        #5;                         // dá tempo para o dado do banco propagar
        RS       = 6'd3;            // ponteiro para R[3]
        RT       = 6'd4;            // ponteiro para R[4]
        // Para ler registradores, não queremos sobrescrever nada, então RegWrite=0
        ALUSrc   = 1'b0;            // 0 → Y = dado2 (conteúdo de R[RT])
        ULAData  = 1'b0;            // 0 → X = dado1 (conteúdo de R[RS])
        SumZero  = 1'b0;            // 0 → mux_zero_dado1 entrega dado1
        ALUOp    = 4'b0010;         // supondo que 0010 = código de ADD na sua ULA
        imediato = 32'd0;           // não será usado (ALUSrc=0)

        // Aguarda resultado estabilizar após um ciclo de ULA
        #10;
        $display("=== Teste 1: R[3] + R[4] ===");
        $display("   R[3] = %0d, R[4] = %0d → ULARes = %0d, Zero = %b", 
                 10, 20, ULARes, Zero);
        // Espera-se ULARes = 30, Zero = 0

        // ----------------------------------------------------------------------------
        // 4.5) Segundo teste: soma de registrador + imediato (R[3] + 5 = 10 + 5)
        // ----------------------------------------------------------------------------
        #5;                         // espaçamento para não coincidir com mudança brusca
        RS       = 6'd3;            // continua lendo R[3]
        RT       = 6'd0;            // não interessa neste teste
        ALUSrc   = 1'b1;            // 1 → Y = imediato
        ULAData  = 1'b0;            // 0 → X = dado1 (conteúdo de R[RS])
        SumZero  = 1'b0;            // 0 → mux_zero_dado1 entrega dado1
        ALUOp    = 4'b0010;         // ADD
        imediato = 32'd5;           // imediato = 5

        // Aguarda alguns nanosegundos para a ULA calcular
        #10;
        $display("=== Teste 2: R[3] + imediato(5) ===");
        $display("   R[3] = %0d, Imediato = %0d → ULARes = %0d, Zero = %b", 
                 10, 5, ULARes, Zero);
        // Espera-se ULARes = 15, Zero = 0

        // ----------------------------------------------------------------------------
        // 4.6) Encerramento da simulação
        // ----------------------------------------------------------------------------
        #10;
        $display("Fim da simulação.");
        $stop;
    end

    // ------------------------------------------------------------------------
    // 5) Dump de waveform (arquivo VCD) – opcional, para abrir no ModelSim
    // ------------------------------------------------------------------------
    initial begin
        $dumpfile("tb_ProcessadorFinal.vcd");
        $dumpvars(0, tb_ProcessadorFinal);
    end

endmodule
