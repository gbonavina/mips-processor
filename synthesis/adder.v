module adder(A, B, sum);
    input [31:0]A;
	input [31:0]B;
    output reg [31:0]sum;

    always @ (*) begin
        sum = A + B;
    end

endmodule