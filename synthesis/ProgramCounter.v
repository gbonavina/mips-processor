module ProgramCounter(pc_in, pc_out, halt, stall, confirm, reset, clk);
    input [31:0] pc_in;
    input halt;
    input stall;
    input clk;
    input confirm;
	 input reset;
    
    output [31:0] pc_out;

    reg [31:0] pc;
	 
	 initial begin 
		pc <= 32'b0;
	 end

    always @ (posedge clk or posedge reset) begin
		  if (reset) begin
			pc <= 32'b0;
		  end
			
        else if (halt) begin
            pc <= pc;
        end

        else if (stall) begin
            if (confirm) begin
                pc <= pc_in;
				end
            else begin
                pc <= pc;
            end
        end

        else begin
            pc <= pc_in;
        end

    end


    assign pc_out = pc;

endmodule