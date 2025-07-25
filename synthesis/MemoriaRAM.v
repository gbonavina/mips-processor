// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// single read/write clock

module MemoriaDados
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=7) 
(
	input [(DATA_WIDTH-1):0] dado_escrita,
	input [(ADDR_WIDTH-1):0] endereco,
	input MemWrite, MemRead, clk,
	output [(DATA_WIDTH-1):0] out
);

	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (negedge clk)
	begin
		// Write
		if (MemWrite)
			ram[endereco] <= dado_escrita;

	end
    
    assign out = ram[endereco];

endmodule
