module UC_Pilha(SPbefore, PushOP, PopOP, SPafter, SPmem);
	input [31:0]SPbefore;
	input PushOP;
	input PopOP;
	
	output reg [31:0]SPafter;
    output reg [31:0]SPmem;
	
	always @ (*) begin
		if (PushOP) begin
			SPafter = SPbefore + 32'd1;
            SPmem = SPafter;
		end
		
		else if (PopOP) begin 
			SPafter = SPbefore - 32'd1;
            SPmem = SPbefore;
		end
		
	end
	
endmodule 