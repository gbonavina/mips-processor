module ProcessadorFinal(
    input SumZero, 
    input ULAData, 
    input ALUSrc, 
    input [3:0] ALUOp, 
    input [31:0] imediato,
    output [31:0] ULARes,
    output Zero,
    input [5:0] RS,
    input [5:0] RT,
    input [5:0] RD,
    input [31:0] SPIn,
    input [31:0] DadoEscrito,
    input RegWrite,
    input NOP,
    input StackOP,
    input JAL,
    input clock
);

    BancoDeRegistradores u_BancoDeRegistradores (
        .RS             (RS),
        .RT             (RT),
        .RD             (RD),
        .SPIn           (32d'111),
        .DadoEscrito    (DadoEscrito),
        .RegWrite       (RegWrite),
        .NOP            (NOP),
        .StackOP        (StackOP),
        .JAL            (JAL),
        .dado1          (dado1),
        .dado2          (dado2),
        .SPOut          (SPOut),
        .clock          (clock)
    );

    wire [31:0] mux_zero_dado1;
    wire [31:0] b = 32'd0;

    Mux mux_zeroOrDado1 (
        .a      (dado1),
        .b      (b),
        .s      (SumZero),
        .out    (mux_zero_dado1)
    );

    wire [31:0] mux_dado_ula;

    Mux mux_dadoUlaInput (
        .a      (dado2),
        .b      (dado1),
        .s      (ULAData),
        .out    (mux_dado_ula)
    );

    wire [31:0] mux_imediato_dado2;

    Mux mux_imediatoOrDado2 (
        .a      (dado2),
        .b      (imediato),
        .s      (ALUSrc),
        .out    (mux_imediato_dado2)
    );

    ULA u_ULA (
        .ALUOp     (ALUOp),
        .X         (mux_dado_ula),
        .Y         (mux_imediato_dado2),
        .ULARes    (ULARes),
        .Zero      (Zero)
    );
    
endmodule