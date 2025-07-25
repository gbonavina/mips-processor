module ExtensorSinal(im26, im20, im14, IMSel, sinalEstendido);
    input [25:0] im26;
    input [19:0] im20;
    input [13:0] im14;
    input [1:0] IMSel;
    output reg [31:0] sinalEstendido;

    always @ (IMSel or im26 or im20 or im14) begin
        if (IMSel == 2'b00) begin
            sinalEstendido = {{6{im26[25]}}, im26}; 
        end

        else if (IMSel == 2'b01) begin
            sinalEstendido = {{12{im20[19]}}, im20}; 
        end
        else if (IMSel == 2'b10) begin
            sinalEstendido = {{18{im14[13]}}, im14}; 
        end
    end
endmodule