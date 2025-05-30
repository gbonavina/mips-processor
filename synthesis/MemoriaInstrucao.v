// Quartus Prime Verilog Template
// Single Port ROM

module MemoriaInstrucao
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] pc_addr,
	output reg [(DATA_WIDTH-1):0] q
);

	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

	initial
	begin
		$readmemb("codigo.txt", rom);
	end

	always @ (*) begin
		q = rom[pc_addr];
	end

endmodule
