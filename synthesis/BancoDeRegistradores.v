module BancoDeRegistradores(RS, RT, RD, SPIn, DadoEscrito, RegWrite, NOP, StackOP, JAL, dado1, dado2, SPOut, clock);
	input RegWrite; // sinal de controle
	input NOP; // sinal de controle
	input StackOP; // sinal de controle
	input JAL; // sinal de controle
	
	input clock;
	
	input [5:0]RS;
	input [5:0]RT;
	input [5:0]RD;
	input [31:0]SPIn; 
	input [31:0]DadoEscrito;
	
	output [31:0]dado1;
	output [31:0]dado2;
	output reg [31:0]SPOut;
	
	reg[63:0] regs[31:0];
	
	parameter Zero = 6'd0;
	parameter ra   = 6'd1;
	parameter SP   = 6'd2;

	initial begin
		regs[SP] = 32'd111;
	end
		
	// a escrita deve ser feita na subida do clock
	always @ (posedge clock) begin 
		regs[Zero] = 32'd0;
	
		if (RegWrite) begin
			regs[RD] = DadoEscrito;
		end
		
		if (StackOP) begin
			SPOut = regs[SP];
			regs[SP] = SPIn;
		end
		
		
		if (JAL) begin
			regs[ra] = DadoEscrito;		
		end
	
	end
	
	assign dado1 = NOP ? regs[Zero] : regs[RS];
	assign dado2 = NOP ? regs[Zero] : regs[RT];

	
endmodule
