module Mux(a, b, s, out);
    input [31:0] a;
    input [31:0] b;
    input s;

    output out;

    assign out = s ? b : a;

endmodule