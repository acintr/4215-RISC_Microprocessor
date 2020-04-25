module Mux_C (output reg [3:0] Out_C, input [3:0] In_C0, In_C1, input S_C);
    always @ (S_C)
    begin
        case (S_C)
        1'b0:  Out_C = In_C0;
        1'b1:  Out_C = In_C1;
        endcase
    end
endmodule

module test;
    reg [3:0] C0, C1;
    reg S;
    wire [3:0] Y;
    Mux_C multiplexer (Y, C0, C1, S);
    initial begin
        C0 = 4'b0001;
        C1 = 4'b0100;
        S = 1'b1;
    end
    initial begin
        $display (" S  Y ");
        $monitor (" %b %b ", S, Y);
    end
endmodule