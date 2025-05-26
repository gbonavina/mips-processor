module ProcessadorFinal(input ALUOp, input X, input Y, output ULARes,output Zero,input RS,input RT,input RD,input SPIn,input DadoEscrito,input RegWrite,input NOP,input StackOP,input JAL,output dado1,output dado2,output SPOut,input clock);
    BancoDeRegistradores u_BancoDeRegistradores (
        .RS             (RS),
        .RT             (RT),
        .RD             (RD),
        .SPIn           (SPIn),
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

    ULA u_ULA (
        .ALUOp     (ALUOp),
        .X         (dado1),
        .Y         (dado2),
        .ULARes    (ULARes),
        .Zero      (Zero)
    );
	
endmodule 