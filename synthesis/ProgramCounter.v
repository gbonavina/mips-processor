module ProgramCounter(pc_in, pc_out, halt, clk);
    input pc_in;
    input halt;
    input clk;
    output pc_out;

    reg [31:0] pc;

    always @ (posedge clk) begin
        pc <= pc_in;
    end


    assign pc_out = pc;

endmodule