`timescale 1ns / 1ps

module testbench_detailed;

    // Sinais para controlar o DUT
    reg clk;
    reg reset;
    reg [19:0] sinalInput;

    // --- Fios para Observação Detalhada ---
    wire [31:0] pc_out_tb;
    wire [31:0] instrucao_tb;
    wire [31:0] dado1_tb, dado2_tb;
    wire [31:0] ulares_tb;
    wire        zero_tb;
    wire        regwrite_tb, branch_tb, memread_tb, memwrite_tb;
    wire [5:0]  rs_addr_tb, rt_addr_tb, rd_addr_tb;

    // Instancia o ProcessadorFinal.
    ProcessadorFinal uut (
        .clk(clk),
        .reset(reset),
        .sinalInput(sinalInput)
    );

    // Conecta fios internos para observação
    assign pc_out_tb     = uut.pc_out;
    assign instrucao_tb  = uut.instrucao;
    // Sinais do Banco de Registradores
    assign dado1_tb      = uut.dado1;
    assign dado2_tb      = uut.dado2;
    assign rs_addr_tb    = uut.out_mux_rs;
    assign rt_addr_tb    = uut.out_mux_rt;
    assign rd_addr_tb    = uut.rd;
    // Sinais da ULA
    assign ulares_tb     = uut.ULARes;
    assign zero_tb       = uut.Zero;
    // Sinais de Controle Chave
    assign regwrite_tb   = uut.RegWrite;
    assign branch_tb     = uut.branch;
    assign memread_tb    = uut.MemRead;
    assign memwrite_tb   = uut.MemWrite;

    // Geração de Clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Período de 20ns
    end
    
    // Sequência de Teste Principal
    initial begin
        $display("=======================================");
        $display("=== INICIO DA SIMULACAO COM UC (DEBUG) ===");
        $display("=======================================");

        sinalInput = 0;

        // 1. Aplica o Reset
        reset = 1; #15;
        reset = 0;
        #1; 
        $display("--> RESET concluído. PC inicial: %0d", pc_out_tb);
        
        // 2. Apenas observa o processador rodar por alguns ciclos
        repeat (10) begin
            @(posedge clk);
            #1;
            // Display formatado para debugging
            $display("-----------------------------------------------------------------");
            $display("PC: %2d | Instrução: %b", pc_out_tb, instrucao_tb);
            $display("Regs: RS_addr=%d, RT_addr=%d, RD_addr=%d", rs_addr_tb, rt_addr_tb, rd_addr_tb);
            $display("Data: Dado1=%d, Dado2=%d", dado1_tb, dado2_tb);
            $display("ULA:  ULARes=%b, Zero_Flag=%b", ulares_tb, zero_tb);
            $display("Ctrl: RegW=%b, Branch=%b, MemR=%b, MemW=%b", regwrite_tb, branch_tb, memread_tb, memwrite_tb);
            
            // Condição de parada
            if (uut.halt) begin
                $display("-----------------------------------------------------------------");
                $display("--> SINAL DE HALT RECEBIDO. FIM DA SIMULACAO.");
                $stop;
            end
        end

        $display("--> Simulação terminou por tempo.");
        $stop;
    end
endmodule