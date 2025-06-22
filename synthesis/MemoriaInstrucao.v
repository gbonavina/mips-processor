// Quartus Prime Verilog Template
// Single Port ROM

module MemoriaInstrucao
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)
(
	input [(ADDR_WIDTH-1):0] pc_addr,
	output reg [(DATA_WIDTH-1):0] q
);

	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

	initial
	begin
		$readmemb("C:/LABAOC/ModelSim/synthesis/codigo.txt", rom);
		// rom[0] = 32'b0110100000110000000000000110010;
	end

	always @ (*) begin
		q = rom[pc_addr];
	end

endmodule
