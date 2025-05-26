module ULA(ALUOp, X, Y, ULARes, Zero);
// 16 instruções diferentes pra ULA
	input [3:0]ALUOp;
	input [31:0]X;
	input [31:0]Y;
	output reg [31:0]ULARes;
	output reg Zero;
	
	// para operações gerais
	always @* begin
		 case (ALUOp)
			  4'b0000: ULARes = X + Y;                   // ADD / ADDI
			  4'b0001: ULARes = X - Y;                   // SUB / SUBI
			  4'b0010: ULARes = X * Y;                   // MULT / MULTI
			  4'b0011: ULARes = X / Y;                   // DIV / DIVI 
			  4'b0100: ULARes = X & Y;                   // AND / ANDI
			  4'b0101: ULARes = X | Y;                   // OR  / ORI
			  4'b0110: ULARes = ~X;                          // NOT
			  4'b0111: ULARes = X << 1;                      // SL
			  4'b1000: ULARes = X >> 1;                   	  // SR
			  4'b1001: ULARes = (X < Y) ? 32'd1 : 32'd0; // SLT / SLTI
			  default: ULARes = 32'd0;
		 endcase
	end

	// controle de branch
	always @* begin
		 case (ALUOp)
			  4'b1010: Zero = (X == Y);  // BEQ
			  4'b1011: Zero = (X != Y);  // BNE
			  4'b1100: Zero = (X >  Y);  // BGT
			  4'b1101: Zero = (X <  Y);  // BLT
			  4'b1110: Zero = (X >= Y);  // BGE
			  4'b1111: Zero = (X <= Y);  // BLE
			  default: Zero = 1'b0;
		 endcase
	end

			
endmodule
