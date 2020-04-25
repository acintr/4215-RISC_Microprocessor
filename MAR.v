module MAR (output reg [31:0] Out_MAR, input [31:0] In_MAR, input MAR_Ld, Clk);
    always @ (posedge Clk)
    begin
        if (MAR_Ld == 1'b1)
        begin
        Out_MAR = In_MAR;
        end
    end
endmodule

module test;
    reg [31:0] D;
    reg X, C;
    wire [31:0] Q;
    MAR testing (Q, D, X, C);
    initial #30 $finish;
    
    initial begin
        C = 1'b0;
        repeat (20) #1 C = ~C;
    end
    
    initial begin
        X = 1'b0;
        repeat (10) #2 X = ~X;
    end
    
    initial begin
        D = 32'b00000000000000000000000000000000;
        repeat (20) #1 D = D + 32'b00000000000000000000010000000000;
    end
    
    initial begin
    $display (" Clk Load    Input    Output                 time ");
    $monitor (" %d   %d %d %d %d ", C, X, D, Q, $time);
    end
endmodule