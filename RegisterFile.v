/*
Author: Alexander J. Cintron Baez
Email: alexander.cintron1@upr.edu
ICOM4215 Project Phase 1: Register File using Verilog
Prof. Nestor J. Rodriguez
*/

// Register
module Register (output reg [31:0] Q, input [31:0] D, input Ld, Clk);
    always @ (posedge Clk, posedge Ld)  // Edge trigger
        if(Ld == 1 && Clk == 1) begin   // Two-gate Register
            Q = D;
            // $display("New data at register:\nClk = %d      Ld = %b     D = %b      Q = %b        t=%d", Clk, Ld, D, Q, $time);
            end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Binary Decoder 4 to 16
module Bin_Decoder_4x16 (output reg E15, E14, E13, E12, E11, E10, E9, E8, E7, 
                        E6, E5, E4, E3, E2, E1, E0, input [3:0] C, input Ld);
    
    always @ (posedge Ld, C) begin
                    E15=0; E14=0; E13=0; E12=0; 
                    E11=0; E10=0; E9=0; E8=0; 
                    E7=0; E6=0; E5=0; E4=0; 
                    E3=0;E2=0;E1=0; E0=0;
        if (Ld == 1)
            case(C)
                4'b0000: E0 = 1'b1;
                4'b0001: E1 = 1'b1;
                4'b0010: E2 = 1'b1;
                4'b0011: E3 = 1'b1;
                4'b0100: E4 = 1'b1;
                4'b0101: E5 = 1'b1;
                4'b0110: E6 = 1'b1;
                4'b0111: E7 = 1'b1;
                4'b1000: E8 = 1'b1;
                4'b1001: E9 = 1'b1;
                4'b1010: E10 = 1'b1;
                4'b1011: E11 = 1'b1;
                4'b1100: E12 = 1'b1;
                4'b1101: E13 = 1'b1;
                4'b1110: E14 = 1'b1;
                4'b1111: E15 = 1'b1;
                default begin
                    E15=0; E14=0; E13=0; E12=0; 
                    E11=0; E10=0; E9=0; E8=0; 
                    E7=0; E6=0; E5=0; E4=0; 
                    E3=0;E2=0;E1=0; E0=0;
                end
            endcase
        else begin
            E15=0; E14=0; E13=0; E12=0; 
            E11=0; E10=0; E9=0; E8=0; 
            E7=0; E6=0; E5=0; E4=0; 
            E3=0;E2=0;E1=0; E0=0;
            end
            // $display("Binary Decoder: Ld = %b   C = %b  t = %d \n[15:0]    %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", Ld, C, $time, E15, E14, E13, E12, E11, E10, E9, E8, E7, E6, E5, E4, E3, E2, E1, E0);
        end
        
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Multiplexer 16 to 1
module Mux_16x1 (output reg [31:0] Y, input [3:0] S, input [31:0] R0, R1, R2, R3,
                R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15);
    always @ (Y, S, R0, R1, R2, R3,
                R4, R5, R6, R7, R8, R9,
                R10, R11, R12, R13, R14, R15) begin
        case (S)
            4'b0000: Y = R0;
            4'b0001: Y = R1;
            4'b0010: Y = R2;
            4'b0011: Y = R3;
            4'b0100: Y = R4;
            4'b0101: Y = R5;
            4'b0110: Y = R6;
            4'b0111: Y = R7;
            4'b1000: Y = R8;
            4'b1001: Y = R9;
            4'b1010: Y = R10;
            4'b1011: Y = R11;
            4'b1100: Y = R12;
            4'b1101: Y = R13;
            4'b1110: Y = R14;
            4'b1111: Y = R15;
        endcase
        // $display("Mux:      S = %b      Y = %b      %d", S, Y, $time);
        end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Register File
module RegisterFile (output [31:0] PA, output [31:0] PB, input [31:0] PC, 
                    input [3:0] C, input [3:0] A, input [3:0] B, input Ld, Clk);
    wire [31:0] R0M, R1M, R2M, R3M, R4M, R5M, 
                    R6M, R7M, R8M, R9M, R10M, 
                    R11M, R12M, R13M, R14M, R15M;       // Wires from Reg to Mux
    wire E15, E14, E13, E12, E11, E10, E9, 
            E8, E7, E6, E5, E4, E3, E2, E1, E0;         // Wires from Binary Decoder to Reg (Ld)
    // Instantiating Register File internal components
    Register R0 (R0M, PC, E0, Clk); 
    Register R1 (R1M, PC, E1, Clk);
    Register R2 (R2M, PC, E2, Clk);
    Register R3 (R3M, PC, E3, Clk);
    Register R4 (R4M, PC, E4, Clk);
    Register R5 (R5M, PC, E5, Clk);
    Register R6 (R6M, PC, E6, Clk);
    Register R7 (R7M, PC, E7, Clk);
    Register R8 (R8M, PC, E8, Clk);
    Register R9 (R9M, PC, E9, Clk);
    Register R10 (R10M, PC, E10, Clk); 
    Register R11 (R11M, PC, E11, Clk); 
    Register R12 (R12M, PC, E12, Clk); 
    Register R13 (R13M, PC, E13, Clk); 
    Register R14 (R14M, PC, E14, Clk);
    Register R15 (R15M, PC, E15, Clk);
    Mux_16x1 MA (PA, A, R0M, R1M, R2M, R3M, R4M, R5M, R6M, R7M, 
                R8M, R9M, R10M, R11M, R12M, R13M, R14M, R15M);
    Mux_16x1 MB (PB, B, R0M, R1M, R2M, R3M, R4M, R5M, R6M, R7M, 
                R8M, R9M, R10M, R11M, R12M, R13M, R14M, R15M);
    Bin_Decoder_4x16 BDecoder (E15, E14, E13, E12, E11, E10, E9, E8, E7, 
                                E6, E5, E4, E3, E2, E1, E0, C, Ld);
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Register File Test
module RegisterFileTest;
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [31:0] PC;
    reg Ld, Clk;
    wire [31:0] PA;
    wire [31:0] PB;
    // integer fr, fw, fs, i;
    integer i;
    RegisterFile RF (PA, PB, PC, C, A, B, Ld, Clk); // Register File instantiation
    reg [32:0] V[0:15];
    initial #1000 $finish;

    initial begin       // Clock
        Clk = 1'b0;
        repeat (1000) #5 Clk = ~Clk;
    end

    // initial begin       // Load
    //     Ld = 1'b0;
    //     repeat (1000) #5 Ld = ~Ld;
    // end

    initial begin fork
        #180 $display("Checking PA and PB"); 
        #181 $display("A             PA      |B              PB      |C              PC                         t");

        // Checking PA and PB; PA even Registers and PB odd Registers
        #185 A = 4'b0000;
        #185 B = 4'b0001;

        #190 A = 4'b0010;
        #190 B = 4'b0011;

        #195 A = 4'b0100;
        #195 B = 4'b0101;

        #200 A = 4'b0110;
        #200 B = 4'b0111;

        #205 A = 4'b1000;
        #205 B = 4'b1001;

        #210 A = 4'b1010;
        #210 B = 4'b1011;

        #215 A = 4'b1100;
        #215 B = 4'b1101;

        #220 A = 4'b1110;
        #220 B = 4'b1111;
        
        // Changing value of R10
        #275 $display("Changing value at R10");
        #280 B = 4'b1010;
        // #290 $display("BEFORE: Value at R10 = %d", PB);
        #300 C = 4'b1010;
        #300 Ld = 4'b1;
        #300 PC = 32'b00000000_00000000_00000011_10101011;      // New value at PC = 939
        #310 Ld = 1'b0;
        #315 A = 4'b1010;
        // #320 $display("AFTER: Value at R10 = %d = %b", PA);

    join
    end

    initial begin       // Monitoring Ports and Controls
        $display("A             PA      |B              PB      |C              PC                         t");
        $monitor("%d    %d      |%d     %d      |%d     %d      %d", A, PA, B, PB, C, PC,$time);
    end

    initial begin       // Loading Registers with input file
        A = 4'b0000;
        B = A;
        C = 4'b0000;
        i = 0;
        // fr = $fopen("reg_input.txt","r");
        Ld = 4'b0000;
        V[0] = 0;    
        V[1] = 4253;
        V[2] = 535454;
        V[3] = 531; // <3
        V[4] = 488;
        V[5] = 99999;
        V[6] = 123456;
        V[7] = 69;
        V[8] = 3;
        V[9] = 04721;
        V[10] = 787;
        V[11] = 223;
        V[12] = 4807;
        V[13] = 1111111;
        V[14] = 6546889;
        V[15] = 802151388;

        #5 $display ("Loading Registers");
        ////////////////////
        while (i < 16) begin
            PC = V[i];
            // $display("%b    %d", V[i], V[i]);
            // $display("%b    %d", PC, PC);
            Ld = 4'b0001;
            #10 Ld = 4'b0000;       // Delays are used to make sure Ld and Clk match in order to load data on Register succesfully
            C = C + 4'b0001;
            A = A + 4'b0001;
            B = A;
            i = i + 1;
        end 
        ////////////////////
        $display("Registers loaded!");
        // $display("%b        %b      %d      %d", PA, A, PB, B);
        // $fclose(fr);
    end

endmodule

/*  This is to read Register values from an input file
while (!$feof(fr)) begin
            fs = $fscanf(fr, "%d", PC);
            Ld = 4'b0001;
            // $display("Scanned %b", PC);
            // $display("C = %d        PC = %d", PA, A, PB, B);
            #10 Ld = 4'b0000;       // Delays are used to make sure Ld and Clk match in order to load data on Register succesfully
            if (i<15) begin         // i is used to stop the loop from overflowing C and reloading a different value on R0
                C = C + 4'b0001;
                A = A + 4'b0001;
                B = A;
            end
            i = i + 1;
        end 
*/