module ExtensorSinal(im26, im20, im14, IMSel, sinalInput, sinalEstendido);
    input [25:0] im26;
    input [19:0] im20;
    input [13:0] im14;
    input [19:0] sinalInput;
    input [1:0] IMSel;
    output reg [31:0] sinalEstendido;

    always @ (IMSel or im26 or im20 or im14 or sinalInput) begin
        if (IMSel == 2'b00) begin
            sinalEstendido = {{6{im26[25]}}, im26}; 
        end
        // Para LOAD/STORE, o testbench manda '01'. Essas instruções usam im20.
        else if (IMSel == 2'b01) begin
            sinalEstendido = {{12{im20[19]}}, im20}; // CORRETO: '01' usa im20
        end
        // Para BEQ, o testbench manda '10'. Essa instrução usa im14.
        else if (IMSel == 2'b10) begin
            sinalEstendido = {{18{im14[13]}}, im14}; // CORRETO: '10' usa im14
        end
        else if (IMSel == 2'b11) begin
            sinalEstendido = {{12{sinalInput[19]}}, sinalInput};
        end
    end
endmodule