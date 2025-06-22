`timescale 1ns/1ps

module teste_so_do_pc;

    // Sinais para testar apenas o PC
    reg clk;
    reg reset;
    wire [31:0] pc_out;

    // Instancia APENAS o ProgramCounter
    ProgramCounter uut_pc (
        .pc_in    (pc_out + 1), // Para ele incrementar sozinho
        .pc_out   (pc_out),
        .halt     (1'b0),       // Halt desativado
        .reset    (reset),
        .clk      (clk)
    );

    // Geração de clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Teste
    initial begin
        $display("--- Iniciando teste isolado do PC ---");

        // Aplica o pulso de reset
        reset = 1;
        #15;
        reset = 0;
        
        // Monitora a saída do PC por alguns ciclos
        $monitor("Tempo: %0t | Reset: %b | Saida do PC (pc_out): %d", $time, reset, pc_out);

        // Roda a simulação por 100ns e para
        #100;
        $display("\n--- Teste do PC finalizado ---");
        $stop;
    end

endmodule
