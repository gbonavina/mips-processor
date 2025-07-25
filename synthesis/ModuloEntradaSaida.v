module ModuloEntradaSaida (
    input [9:0] switch_dado,
    input [31:0] entrada_dado,
    input IOE,
    input IOsel,
    output reg [31:0] saida_dado,

    output [6:0] HEX0, 
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7  
);

    // Sinais BCD individuais
    wire [3:0] bcd0, bcd1, bcd2, bcd3;
    wire [3:0] bcd4, bcd5, bcd6, bcd7;
	
	reg p_clk;
	
	initial begin
		p_clk = 1'b1;
	end
    // Valor que vai ser exibido
    reg [31:0] reg_out;

    // Logica de seleção: mostra switches ou entrada
    always @(*) begin
			if (p_clk) begin
				reg_out = 32'b0;
				p_clk = 1'b0;
			end
	 
        if (IOE) begin
				if (IOsel) begin
					saida_dado = switch_dado + 32'b0; // concatena zeros nos bits mais altos
				end
				else begin
					reg_out = entrada_dado;
				end
		  end
        else begin
            reg_out = reg_out;
		  end
	 end

    // Conversor Binário -> BCD
    BinToBcdConverter b2b_inst (
        .binary_in(reg_out),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .bcd4(bcd4),
        .bcd5(bcd5),
        .bcd6(bcd6),
        .bcd7(bcd7)
    );

    // Decodificadores
    BCDSevSeg dec0_inst (.bcd_in(bcd0), .seg_out(HEX0));
    BCDSevSeg dec1_inst (.bcd_in(bcd1), .seg_out(HEX1));
    BCDSevSeg dec2_inst (.bcd_in(bcd2), .seg_out(HEX2));
    BCDSevSeg dec3_inst (.bcd_in(bcd3), .seg_out(HEX3));
    BCDSevSeg dec4_inst (.bcd_in(bcd4), .seg_out(HEX4));
    BCDSevSeg dec5_inst (.bcd_in(bcd5), .seg_out(HEX5));
    BCDSevSeg dec6_inst (.bcd_in(bcd6), .seg_out(HEX6));
    BCDSevSeg dec7_inst (.bcd_in(bcd7), .seg_out(HEX7));

endmodule
