module Mux6b(a, b, s, out);
    input [5:0] a;
    input [5:0] b;
    input s;

    output [5:0] out;

    assign out = s ? b : a;

endmodule