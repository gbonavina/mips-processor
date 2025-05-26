module BancoDeRegistradores_test();
    logic clk = 1;
    always #10 clk = ~clk; 

    logic RegWrite; // sinal de controle
    logic NOP; // sinal de controle
    logic StackOP; // sinal de controle
    logic JAL; // sinal de controle
    
    
    logic [5:0]RS;
    logic [5:0]RT;
    logic [5:0]RD;
    logic [31:0]SPIn; 
    logic [31:0]DadoEscrito;
    
    logic [31:0]dado1;
    logic [31:0]dado2;
    logic [31:0]SPOut;


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
        .clock          (clk) 
    );

    initial begin
        // definindo t = 0;
        #0;
        RS = 0; 
        RT = 0; 
        SPIn = 0; 
        RD = 6'd3;
        DadoEscrito = 32'd7;
        NOP = 0;
        StackOP = 0;
        JAL = 0;
        RegWrite = 1;

        // t = 30;
        #30;
        RS = 6'd3;
        RD = 0; 
        DadoEscrito = 0; 
        NOP = 0;
        StackOP = 0;
        JAL = 0;
        RegWrite = 0;

        #300        
        $finish; 
    end 




endmodule