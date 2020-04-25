module Mux_B (output reg [31:0] Out_B, input [31:0] In_B0, In_B1, In_B2, In_B3, input [1:0] S_B);
    always @ (S_B)
    begin
        case (S_B)
        2'b00:  Out_B = In_B0;
        2'b01:  Out_B = In_B1;
        2'b10:  Out_B = In_B2;
        2'b11:  Out_B = In_B3;
        endcase
    end
endmodule

module test;
    reg [31:0] B0, B1, B2, B3;
    reg [1:0] S;
    wire [31:0] Y;
    Mux_B multiplexer (Y, B0, B1, B2, B3, S);
    initial begin
        B0 = 32'b00000000000000000000000000000001;
        B1 = 32'b00000000000000000000000010000000;
        B2 = 32'b00000000000000001000000000000000;
        B3 = 32'b00000000100000000000000000000000;
        S = 2'b11;
    end
    initial begin
        $display (" S   Y ");
        $monitor (" %b %d ", S, Y);
    end
endmodule