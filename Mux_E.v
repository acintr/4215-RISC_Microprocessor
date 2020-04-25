module Mux_E (output reg [31:0] Out_E, input [31:0] In_E0, In_E1, input S_E);
    always @ (S_E)
    begin
        case (S_E)
        1'b0:  Out_E = In_E0;
        1'b1:  Out_E = In_E1;
        endcase
    end
endmodule

module test;
    reg [31:0] E0, E1;
    reg S;
    wire [31:0] Y;
    Mux_E multiplexer (Y, E0, E1, S);
    initial begin
        E0 = 32'b00000000000000000000000010000000;
        E1 = 32'b00000000000000001000000000000000;
        S = 1'b1;
    end
    initial begin
        $display (" S   Y ");
        $monitor (" %b %d ", S, Y);
    end
endmodule