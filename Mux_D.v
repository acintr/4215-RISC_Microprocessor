module Mux_D (output reg [3:0] Out_D, input [3:0] In_D0, In_D1, input S_D);
    always @ (S_D)
    begin
        case (S_D)
        1'b0:  Out_D = In_D0;
        1'b1:  Out_D = In_D1;
        endcase
    end
endmodule

module test;
    reg [3:0] D0, D1;
    reg S;
    wire [3:0] Y;
    Mux_D multiplexer (Y, D0, D1, S);
    initial begin
        D0 = 4'b0001;
        D1 = 4'b1000;
        S = 1'b0;
    end
    initial begin
        $display (" S  Y ");
        $monitor (" %b %b ", S, Y);
    end
endmodule