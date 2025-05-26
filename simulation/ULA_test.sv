module ULA_test();
    // O clock não é usado pela ULA (combinacional), mas é bom para temporizar estímulos.
    logic clk = 1;
    always #5 clk = ~clk; // Período de 10 unidades de tempo

    logic [3:0]  ALUOp;
    logic [31:0] X;
    logic [31:0] Y;
    logic [31:0] ULARes; // Corrigido: removido 'reg'
    logic        Zero;   // Corrigido: removido 'reg'

    ULA u_ULA (
        .ALUOp     (ALUOp),
        .X         (X),
        .Y         (Y),
        .ULARes    (ULARes),
        .Zero      (Zero)
    );

    initial begin
        // Monitorar mudanças nos sinais importantes
        $monitor("Time=%0t: ALUOp=%b X=%d Y=%d => ULARes=%d Zero=%b",
                 $time, ALUOp, X, Y, ULARes, Zero);

        // Teste 0: ADD (X + Y)
        #1; // Pequeno delay inicial para o $monitor capturar o estado inicial se necessário
        $display("Test 0: ADD");
        ALUOp = 4'd0;
        X = 32'd22;
        Y = 32'd108; // Esperado: ULARes = 130, Zero = 0 (default do outro case)
        #10;

        // Teste 1: SUB (X - Y)
        $display("Test 1: SUB");
        ALUOp = 4'd1;
        X = 32'd22;
        Y = 32'd108; // Esperado: ULARes = -86 (representação em complemento de 2), Zero = 0
        #10;

        // Teste 2: MULT (X * Y)
        $display("Test 2: MULT");
        ALUOp = 4'd2;
        X = 32'd22;
        Y = 32'd108; // Esperado: ULARes = 2376, Zero = 0
        #10;

        // Teste 3: DIV (X / Y)
        $display("Test 3: DIV");
        ALUOp = 4'd3;
        X = 32'd108;
        Y = 32'd22;  // Esperado: ULARes = 4, Zero = 0
        #10;
        X = 32'd22;
        Y = 32'd108; // Esperado: ULARes = 0, Zero = 0
        #10;


        // Teste 4: AND (X & Y)
        $display("Test 4: AND");
        ALUOp = 4'd4;
        X = 32'h0000_0016; // 22
        Y = 32'h0000_006C; // 108
                           // Esperado: ULARes = 0x04 (4), Zero = 0
        #10;

        // Teste 5: OR (X | Y)
        $display("Test 5: OR");
        ALUOp = 4'd5;
        X = 32'h0000_0016; // 22
        Y = 32'h0000_006C; // 108
                           // Esperado: ULARes = 0x7E (126), Zero = 0
        #10;

        // Teste 6: NOT (~X)
        $display("Test 6: NOT");
        ALUOp = 4'd6;
        X = 32'd22;
        Y = 32'd0; // Y não é usado, mas é bom definir
                   // Esperado: ULARes = ~22, Zero = 0
        #10;

        // Teste 7: SL (X << 1)
        $display("Test 7: SL (Shift Left)");
        ALUOp = 4'd7;
        X = 32'd22;    // Esperado: ULARes = 44, Zero = 0
        #10;

        // Teste 8: SR (X >> 1)
        $display("Test 8: SR (Shift Right)");
        ALUOp = 4'd8;
        X = 32'd22;    // Esperado: ULARes = 11, Zero = 0
        #10;

        // Teste 9: SLT (X < Y)
        $display("Test 9: SLT (Set Less Than)");
        ALUOp = 4'd9;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 1, Zero = 0
        #10;
        X = 32'd108;
        Y = 32'd22;    // Esperado: ULARes = 0, Zero = 0
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0, Zero = 0
        #10;

        // Teste 10: BEQ (X == Y)
        $display("Test 10: BEQ (Branch if Equal)");
        ALUOp = 4'd10;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 0 (default), Zero = 0
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0 (default), Zero = 1
        #10;

        // Teste 11: BNE (X != Y)
        $display("Test 11: BNE (Branch if Not Equal)");
        ALUOp = 4'd11;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0 (default), Zero = 0
        #10;

        // Teste 12: BGT (X > Y)
        $display("Test 12: BGT (Branch if Greater Than)");
        ALUOp = 4'd12;
        X = 32'd108;
        Y = 32'd22;    // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 0 (default), Zero = 0
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0 (default), Zero = 0
        #10;

        // Teste 13: BLT (X < Y)
        $display("Test 13: BLT (Branch if Less Than)");
        ALUOp = 4'd13;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd108;
        Y = 32'd22;    // Esperado: ULARes = 0 (default), Zero = 0
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0 (default), Zero = 0
        #10;

        // Teste 14: BGE (X >= Y)
        $display("Test 14: BGE (Branch if Greater Than or Equal)");
        ALUOp = 4'd14;
        X = 32'd108;
        Y = 32'd22;    // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 0 (default), Zero = 0
        #10;

        // Teste 15: BLE (X <= Y)
        $display("Test 15: BLE (Branch if Less Than or Equal)");
        ALUOp = 4'd15;
        X = 32'd22;
        Y = 32'd108;   // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd50;
        Y = 32'd50;    // Esperado: ULARes = 0 (default), Zero = 1
        #10;
        X = 32'd108;
        Y = 32'd22;    // Esperado: ULARes = 0 (default), Zero = 0
        #10;

        // Teste para default (ALUOp inválido)
        $display("Test Default: Invalid ALUOp");
        ALUOp = 4'bxxxx; // ou um valor não coberto como 4'hF (se não fosse BLE)
                         // Para garantir que não seja um ALUOp válido, podemos usar um valor fora do range se o tipo permitisse,
                         // mas como é 4 bits, todos os valores são tecnicamente válidos.
                         // O default do seu case já cobre ALUOps não listados explicitamente.
                         // Se ALUOp for, por exemplo, 4'b1010 (BEQ), ULARes irá para default 32'd0.
                         // Se ALUOp for, por exemplo, 4'b0000 (ADD), Zero irá para default 1'b0.
                         // O $monitor já mostrará isso.

        $display("Todos os testes concluídos.");
        #20; // Espera um pouco mais antes de finalizar
        $finish;
    end

endmodule