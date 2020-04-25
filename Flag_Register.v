module Flag_Register (output reg [3:0] Out_FR, input [3:0] In_FR, input FR_Ld, Clk);
    always @ (posedge Clk)
    begin
        if (FR_Ld == 1'b1)
        begin
        Out_FR = In_FR;
        end
    end
endmodule

module test;
    reg [3:0] D;
    reg X, C;
    wire [3:0] Q;
    Flag_Register testing (Q, D, X, C);
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
        D = 4'b0000;
        repeat (20) #1 D = D + 4'b0001;
    end
    
    initial begin
    $display (" Clk Load Input Output              time ");
    $monitor (" %d   %d   %d    %d %d ", C, X, D, Q, $time);
    end
endmodule