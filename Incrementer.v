// Adder (increment by 1)
module Adder (output reg [5:0] Out, input [5:0] In);
    always @ (In) begin
        Out = In + 6'b000001;
    end
endmodule

// Increment Register
module IncrementerRegister (output reg [5:0] Out, input [5:0] In, input Clk);
    always @ (posedge Clk) begin
        Out = In;
    end
endmodule

// // Incrementer - connecting components
// module Incrementer (output [5:0] Out, input [5:0] In, input Clk);
//     wire [5:0] Add2Reg;
//     Adder adder (Add2Reg, In);
//     IncrementerRegister register (Out, Add2Reg, Clk);
// endmodule

// // Incrementer testing module
// module IncreTester;
//     reg [5:0] In;
//     reg Clk;
//     wire [5:0] Out;
    
//     Incrementer incrementer (Out, In, Clk);
    
//     initial #100 $finish;

//     initial begin       // Clock
//         Clk = 1'b0;
//         repeat (1000) #1 Clk = ~Clk;
//     end

//     initial begin fork
//         #5 In = 0;
//         #10 In = Out;
//         #15 In = Out;
//         #20 In = 5'b011010;
//         #25 In = Out;
//         #30 In = Out;
//         #35 In = Out;
//     join
//     end

//     initial begin
//         $display("IN        OUT                 TIME");
//         $monitor("%d        %d  %d", In, Out, $time);
//     end
// endmodule


    