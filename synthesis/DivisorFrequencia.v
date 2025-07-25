module DivisorFrequencia(CLOCK_50, CLK_DIV);
    input CLOCK_50;
    output reg CLK_DIV; 

    reg [25:0]count;

    always @(posedge CLOCK_50) begin
        if (count >= 26'd5000000) begin
            CLK_DIV = ~CLK_DIV;
			count = 0;
		end 
        else begin 
			 count = count + 1;
		  end
    end
    
   
endmodule