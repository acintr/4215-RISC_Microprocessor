module Mux_A (output reg [3:0] Out_A, input [3:0] In_A0, In_A1, In_A2, In_A3, input [1:0] S_A);
    always @ (S_A)
    begin
        case (S_A)
        2'b00:  Out_A = In_A0;
        2'b01:  Out_A = In_A1;
        2'b10:  Out_A = In_A2;
        2'b11:  Out_A = In_A3;
        endcase
    end
endmodule

module test;
    reg [3:0] A0, A1, A2, A3;
    reg [1:0] S;
    wire [3:0] Y;
    Mux_A multiplexer (Y, A0, A1, A2, A3, S);
    initial begin
        A0 = 4'b0001;
        A1 = 4'b0010;
        A2 = 4'b0100;
        A3 = 4'b1000;
        S = 2'b11;
    end
    initial begin
        $display (" S  Y ");
        $monitor (" %b %b ", S, Y);
    end
endmodule