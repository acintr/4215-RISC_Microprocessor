// Next State Address Selector
module NextStateAddressSelector (output reg [1:0] M, input [2:0] N, input Sts);
    always @ (N, Sts) begin
        case(N)
            3'b000: M = 2'b00;  // Encoder
            3'b001: 
                if (Sts == 0) M = 2'b01;  // 1
                else M = 2'b10  // Control Register
            3'b010: M = 2'b10;  // Control Register
            3'b011: M = 2'b11;  // Incrementer
            3'b100:
                if (Sts == 1) M = 2'b00; // Encoder
                else M = 2'b10; // Control Register
            3'b101:
                if (Sts == 1) M = 2'b10; // Control Register
                else M = 2'b11; // Incrementer
            3'b110:
                if (Sts == 1) M = 2'b00; // Encoder
                else M = 2'b11; // Incrementer
            3'b111: M = 2'b00;  //Encoder
        endcase
    end
endmodule

// // Tester
// module NSAS_Test;
//     reg [2:0] N;
//     reg Sts;
//     wire [1:0] M;

//     NextStateAddressSelector NSAS (M, N, Sts);

//     initial #20 $finish;

//     initial begin fork
//         #2 N = 3'b000;
//         #4 N = 3'b001;
//         #6 N = 3'b010;
//         #8 N = 3'b011;

//         #10 N = 3'b100;
//         #12 N = 3'b101;
//         #14 N = 3'b110;
//         #16 N = 3'b111;

//     join
//     end

//     initial begin
//         Sts = 1'b0;
//         repeat (1000) #1 Sts = ~Sts;
//     end

//     initial begin
//         $display("N     Sts     M                   Time");
//         $monitor("%b    %b      %b  %d", N, Sts, M, $time);
//     end
// endmodule