module UnidadeControle(
    input [5:0] opcode,

    output reg SumZero,
    output reg JAL,
    output reg JR,
    output reg HALT,
    output reg Jump,
    output reg Branch,
    output reg RegWrite,
    output reg RSSel,
    output reg RTSel,
    output reg ALUSrc,
    output reg MemData,
    output reg NOP,
    output reg IMIn,
    output reg OutOP,
    output reg MemWrite,
    output reg PushOP,
    output reg PopOP,
    output reg StackOP,
    output reg MemRead,
    output reg MemToReg,
    output reg [1:0] IMSel,
    output reg [3:0] ALUOp
);

    always @ (*) begin
        // Inicializa todos os sinais de controle com o valor padrão (0 ou 'x')
        SumZero   = 1'b0;
        JAL       = 1'b0;
        JR        = 1'b0;
        HALT      = 1'b0;
        Jump      = 1'b0;
        Branch    = 1'b0;
        RegWrite  = 1'b0;
        RSSel     = 1'b0;
        RTSel     = 1'b0;
        ALUSrc    = 1'b0;
        MemData   = 1'b0;
        NOP       = 1'b0;
        IMIn      = 1'b0;
        OutOP     = 1'b0;
        MemWrite  = 1'b0;
        PushOP    = 1'b0;
        PopOP     = 1'b0;
        StackOP   = 1'b0;
        MemRead   = 1'b0;
        MemToReg  = 1'b0;
        IMSel     = 2'b00;
        ALUOp     = 4'b0000;

        case (opcode)
            // add
            6'b000000: begin
                ALUOp    = 4'b0000;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // sub
            6'b000001: begin
                ALUOp    = 4'b0001;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // mult
            6'b000010: begin
                ALUOp    = 4'b0010;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // div
            6'b000011: begin
                ALUOp    = 4'b0011;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // AND
            6'b000100: begin
                ALUOp    = 4'b0100;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // OR
            6'b000101: begin
                ALUOp    = 4'b0101;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // NOT
            6'b000110: begin
                ALUOp    = 4'b0110;
                RegWrite = 1'b1;
                RTSel   = 1'b1; 
            end
            
            // addi
            6'b010011: begin
                ALUOp    = 4'b0000;
                RegWrite = 1'b1;
                IMSel    = 2'b00;
                ALUSrc   = 1'b1;
            end
            
            // subi
            6'b010100: begin
                ALUOp    = 4'b0001;
                RegWrite = 1'b1;
                IMSel    = 2'b00;
                ALUSrc   = 1'b1;
            end
            
            // multi
            6'b010101: begin
                ALUOp    = 4'b0010;
                RegWrite = 1'b1;
                IMSel    = 2'b00;
                ALUSrc   = 1'b1;
            end
            
            // ANDI
            6'b010111: begin
                ALUOp    = 4'b0100;
                RegWrite = 1'b1;
                IMSel    = 2'b00;
                ALUSrc   = 1'b1;
            end
            
            // ORI
            6'b011000: begin
                ALUOp    = 4'b0101;
                RegWrite = 1'b1;
                IMSel    = 2'b00;
                ALUSrc   = 1'b1;
            end
            
            // sr (shift right)
            6'b000111: begin
                ALUOp    = 4'b1101;
                RegWrite = 1'b1;
            end
            
            // sl (shift left)
            6'b001000: begin 
                ALUOp    = 4'b1100;
                RegWrite = 1'b1;
            end
    
            // bge (branch greater than or equal)
            6'b100001: begin
                ALUOp  = 4'b1110;
                Branch = 1'b1;
                IMSel  = 2'b10;
                RSSel  = 1'b1;
                RTSel  = 1'b0;
            end
            
            // beq (branch if equal)
            6'b011101: begin
                ALUOp  = 4'b1010;
                Branch = 1'b1;
                IMSel  = 2'b10;
                RSSel  = 1'b1;
                RTSel  = 1'b0;
            end
            
            // bgt (branch greater than)
            6'b011111: begin
                ALUOp  = 4'b1100;
                Branch = 1'b1;
                IMSel  = 2'b10;
                RSSel  = 1'b1;
                RTSel  = 1'b0;
            end
            
            // blt (branch less than)
            6'b100000: begin
                ALUOp  = 4'b1101;
                Branch = 1'b1;
                IMSel  = 2'b10;
                RSSel  = 1'b1;
                RTSel  = 1'b0;
            end
            
            // ble (branch less than or equal)
            6'b100010: begin
                ALUOp  = 4'b1111;
                Branch = 1'b1;
                IMSel  = 2'b10;
                RSSel  = 1'b1;
                RTSel  = 1'b0;
            end

            // bne (branch not equal)
            6'b011110: begin
                ALUOp  = 4'b1011;
                Branch = 1'b1;
                IMSel  = 2'b10;
                RSSel  = 1'b1;
                RTSel  = 1'b0;
            end

            // slt (set on less than)
            6'b001001: begin
                ALUOp    = 4'b1001; // Operação SLT
                RegWrite = 1'b1;    // Habilita escrita no registrador
            end

            // slti (set on less than immediate)
            6'b011001: begin
                ALUOp    = 4'b1001; // Operação SLTI
                RegWrite = 1'b1;    // Habilita escrita no registrador
                IMSel    = 2'b10;   // Usa o imediato como entrada
                ALUSrc   = 1'b1;    // Habilita a entrada imediata
            end

            // divi
            6'b010110: begin
                ALUOp    = 4'b0011; // Operação DIVI
                RegWrite = 1'b1;    // Habilita escrita no registrador
                IMSel    = 2'b10;   // Usa o imediato como entrada
                ALUSrc   = 1'b1;    // Habilita a entrada imediata
            end
            
            // move 
            6'b010000: begin
                SumZero  = 1'b1; // Usa o registrador zero como entrada
                RegWrite = 1'b1;
            end
            
            // li (load immediate)
            6'b011010: begin
                SumZero  = 1'b1; // Usa o registrador zero como entrada
                RegWrite = 1'b1;
                IMSel    = 2'b01;
                ALUSrc   = 1'b1;
            end
            
            // lw (load word)
            6'b001010: begin
                SumZero  = 1'b1;
                RegWrite = 1'b1;
                IMSel    = 2'b01;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemToReg = 1'b1;
            end
            
            // sw (store word)
            6'b001011: begin
                SumZero  = 1'b1;
                RSSel    = 1'b1;
                IMSel    = 2'b01;
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
            end
            
            // lwr (load word register)
            6'b001100: begin
                ALUOp    = 4'b0000; // Endereço = RS + RT
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemToReg = 1'b1;
            end
            
            // swr (store word register)
            6'b001101: begin
                ALUOp    = 4'b0000; // Endereço = RS + RT
                RSSel    = 1'b1;
                RTSel    = 1'b1;
                MemWrite = 1'b1;
            end
            
            // lwd (load word displaced)
            6'b001110: begin
                ALUOp    = 4'b0000; // Endereço = RS + Imediato
                ALUSrc   = 1'b1;
                IMSel    = 2'b00;
                MemRead  = 1'b1;
                RegWrite = 1'b1;
                MemToReg = 1'b1;
            end
            
            // swd (store word displaced)
            6'b001111: begin
                ALUOp    = 4'b0000; // Endereço = RS + Imediato
                ALUSrc   = 1'b1;
                IMSel    = 2'b00;
                RSSel    = 1'b1;
                RTSel    = 1'b1;
                MemWrite = 1'b1;
            end
            
            // j (jump)
            6'b100110: begin
                Jump  = 1'b1;
                IMSel = 2'b10;
            end
            
            // jr (jump register)
            6'b100100: begin
                RSSel = 1'b1;
                Jump  = 1'b1;
                JR    = 1'b1;
            end
            
            // jal (jump and link)
            6'b100101: begin
                JAL   = 1'b1;
                IMSel = 2'b10;
                Jump  = 1'b1;
            end
            
            // PUSH
            6'b010001: begin
                RSSel    = 1'b1;  // Seleciona o registrador a ser salvo
                StackOP  = 1'b1;  // Habilita operação de pilha
                PushOP   = 1'b1;  // Define a operação como PUSH
                MemWrite = 1'b1;  // Escreve na memória (pilha)
            end
            
            // POP
            6'b010010: begin
                StackOP  = 1'b1;  // Habilita operação de pilha
                PopOP    = 1'b1;  // Define a operação como POP
                MemRead  = 1'b1;  // Lê da memória (pilha)
                MemToReg = 1'b1;  // Escreve o dado lido no registrador
                RegWrite = 1'b1;  // Habilita escrita no banco de registradores
            end

            // HLT (halt)
            6'b111111: begin
                HALT = 1'b1;
            end
            
            // Opcodes não definidos não fazem nada (NOP)
            default: begin
                NOP = 1'b1; 
            end
    
        endcase
    end

endmodule