module ProgramCounter(pc_in, pc_out, halt, clk);
    input pc_in;
    input halt;
    input clk;
    output pc_out;

    reg [31:0] pc;

    always @ (posedge clk) begin
        if (halt) begin
            pc <= pc;
        end
        else begin
            pc <= pc_in;
        end

    end


    assign pc_out = pc;

endmodule