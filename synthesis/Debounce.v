module Debounce (
    input clk,
    input reset, 
    input button_bounce, 

    output reg button_debounce
);

    reg [25:0] count;
    reg new_state;

    always @ (posedge clk) begin
        if (reset) begin
            count <= 0;
            button_debounce <= 0;
            new_state <= 0;
        end

        else begin
            if (button_bounce != new_state) begin
                new_state <= button_bounce;
                count <= 0;
            end else begin
                if (count < 26'd50) begin
                    count <= count + 1;
                end else begin
                    button_debounce <= new_state;
                end
            end
        end
    end
endmodule