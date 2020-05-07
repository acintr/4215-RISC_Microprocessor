module Mux_C (output reg [3:0] Out_C, input [3:0] IReg12_15, Ones, In_C3, IReg16_19, input [1:0] S_C);
    always @ (S_C)
    begin
        case (S_C)
        2'b00:  Out_C = IReg12_15;
        2'b01:  Out_C = Ones;
        2'b10:  Out_C = IReg16_19; 
        2'b11:  Out_C = In_C3;
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
