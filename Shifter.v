module Shifter (output reg [31:0] Q, output reg C_out, input signed [31:0] RF, input [31:0] IR, input C_in);
    reg [31:0] temp;
    reg [32:0] s_temp;
    reg signed [32:0] sign_temp;
    reg [7:0] immediate_8;
    reg [3:0] rotate;
    reg [4:0] shift_amount;
    reg [1:0] shift;
    always @ (RF, IR)
    begin
        Q = 0;
        case(IR[27:25])
            3'b001: 
                begin
                    /*
                        Immediate shifter:
                        Immed_8 is placed in least significant
                        at a temp register and rotated 2*rotate
                        times to the right.
                        IR[11:8] = rotate
                        IR[7:0] = immediate_8
                    */
                    Q[7:0] = IR[7:0];
                    temp = Q << 32 - (2*IR[11:8]);
                    Q = temp + (Q >> (2*IR[11:8]));
                    if (IR[20] == 1'b1) C_out = Q[31]; // Bit S
                end
            3'b000:
                begin
                    /*
                        Shift by Immediate:
                        Content of Rm is shifted shift_amount times.
                        IR[11:7] = shift amount
                        IR[6:5] --> Shift Op
                        IR[4] = 0
                        IR[3:0] = Rm
                        00 --> LSL = Logical Shift Left. Vacated bits are cleared.
                        01 --> LSR = Logical Shift Right. Vacated bits are cleared.
                        10 --> ASR = Arithmetic Shift Right. Register contents are treated as two’s complement signed integers. The sign bit is copied into vacated bits.
                        11 --> ROR = Rotate Right. Bits moved out of the right-hand end of the register are rotated back into the left-hand end.
                    */
                    if (IR[4] == 1'b0)
                        case(IR[6:5])
                            2'b00:  // LSL
                                begin
                                    if (IR[20] == 1'b1) begin
                                        s_temp[32] = C_in;
                                        s_temp[31:0] = RF;
                                        s_temp = s_temp << IR[11:7];
                                        C_out = s_temp[32];
                                        Q = s_temp[31:0];
                                    end
                                    else Q = RF << IR[11:7];
                                end
                            2'b01:  // LSR
                                begin
                                    if (IR[20] == 1'b1) begin
                                        s_temp[0] = C_in;
                                        s_temp[32:1] = RF;
                                        s_temp = s_temp >> IR[11:7];
                                        C_out = s_temp[0];
                                        Q = s_temp[32:1];
                                    end
                                    else Q = RF >> IR[11:7];
                                end
                            2'b10:  // ASR
                                begin
                                    if (IR[20] == 1'b1) begin
                                        sign_temp[0] = C_in;
                                        sign_temp[32:1] = RF;
                                        sign_temp = sign_temp >>> IR[11:7];
                                        C_out = sign_temp[0];
                                        Q = sign_temp[32:1];
                                    end
                                    else Q = RF >>> IR[11:7];
                                end
                            2'b11:  // ROR
                                begin
                                    temp = RF << (32 - IR[11:7]);
                                    Q = temp + (RF >> IR[11:7]);
                                    if (IR[20] == 1'b1) C_out = Q[0];
                                end
                        endcase
                end
        endcase
    end
   
endmodule

module ShiftTest;
    wire [31:0] Q;
    wire C_out;
    reg signed [31:0] RF;
    reg [31:0] IR;
    reg C_in;

    Shifter shifter (Q, C_out, RF, IR, C_in);

    initial #100 $finish;

    initial begin
        $display("              IR                                        RF                                     Q                   C_in   C_out                TIME");
        $monitor("%b        %b      %b      %b      %b   %d",IR, RF, Q, C_in, C_out, $time);
    end

    initial begin fork
    #1 IR[20] = 0;
    #1 IR[27:25] = 3'b001;     // imm shifter
    #1 IR[11:8] = 4'b0010;     // rotate
    #1 IR[7:0] = 8'b11111111;  // imm_8
    // Q = 11110000_00000000_00000000_00001111

    // #2 IR = 0;
    #3 IR[27:25] = 3'b000;  // shift by imm
    #3 IR[11:7] = 5'b00011; // shift amount
    #3 IR[6:5] = 2'b00;     // LSL
    #3 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #3 RF = 32'b00011110_00011110_00011110_00011110;
    // Q = 11110000_11110000_11110000_11110000

    // #4 IR = 0;
    #5 IR[27:25] = 3'b000;  // shift by imm
    #5 IR[11:7] = 5'b00001; // shift amount
    #5 IR[6:5] = 2'b01;     // LSR
    #5 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #5 RF = 32'b00011110_00011110_00011110_00011110;
    // Q = 00001111_00001111_00001111_00001111

    // #6 IR = 0;
    #7 IR[27:25] = 3'b000;  // shift by imm
    #7 IR[11:7] = 5'b11111; // shift amount
    #7 IR[6:5] = 2'b10;     // ASR signed
    #7 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #7 RF = 32'b10011110_00011110_00011110_00011110;
    // Q = 11111111_11111111_111111111_11111111

    // #8 IR = 0;
    #9 IR[27:25] = 3'b000;  // shift by imm
    #9 IR[11:7] = 5'b11111; // shift amount
    #9 IR[6:5] = 2'b10;     // ASR unsigned
    #9 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #9 RF = 32'b00011110_00011110_00011110_00011110;
    // Q = 00000000_00000000_00000000_00000000

    // #10 IR = 0;
    #11 IR[27:25] = 3'b000;  // shift by imm
    #11 IR[11:7] = 5'b10000; // shift amount
    #11 IR[6:5] = 2'b11;     // ROR
    #11 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #11 RF = 32'b11111111_11111111_00000000_00000000;
    // Q = 00000000_00000000_11111111_11111111

//// TESTING FOR S-BIT
    #13 C_in = 0;
    #13 IR[20] = 1;
    #13 IR[27:25] = 3'b001;     // imm shifter
    #13 IR[11:8] = 4'b0010;     // rotate
    #13 IR[7:0] = 8'b11111111;  // imm_8
    // Q = 11110000_00000000_00000000_00001111

    // #14 IR = 0;
    #15 IR[20] = 1;
    #15 C_in = 1;
    #15 IR[27:25] = 3'b000;  // shift by imm
    #15 IR[11:7] = 5'b00011; // shift amount
    #15 IR[6:5] = 2'b00;     // LSL
    #15 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #15 RF = 32'b00011110_00011110_00011110_00011110;
    // Q = 11110000_11110000_11110000_11110000

    #17 C_in = 1;
    #17 IR[27:25] = 3'b000;  // shift by imm
    #17 IR[11:7] = 5'b00001; // shift amount
    #17 IR[6:5] = 2'b01;     // LSR
    #17 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #17 RF = 32'b00011110_00011110_00011110_00011110;
    // Q = 00001111_00001111_00001111_00001111

    #19 C_in = 0;
    #19 IR[27:25] = 3'b000;  // shift by imm
    #19 IR[11:7] = 5'b11111; // shift amount
    #19 IR[6:5] = 2'b10;     // ASR signed
    #19 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #19 RF = 32'b10011110_00011110_00011110_00011110;
    // Q = 11111111_11111111_111111111_11111111

    #21 C_in = 1;
    #21 IR[27:25] = 3'b000;  // shift by imm
    #21 IR[11:7] = 5'b11111; // shift amount
    #21 IR[6:5] = 2'b10;     // ASR unsigned
    #21 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #21 RF = 32'b00011110_00011110_00011110_00011110;
    // Q = 00000000_00000000_00000000_00000000

    #23 C_in = 0;
    #23 IR[27:25] = 3'b000;  // shift by imm
    #23 IR[11:7] = 5'b10000; // shift amount
    #23 IR[6:5] = 2'b11;     // ROR
    #23 IR[4] = 0;
    // #3 IR[3:0] = ???     // register
    #23 RF = 32'b11111111_11111111_00000000_00000000;
    // Q = 00000000_00000000_11111111_11111111

    join
    end

endmodule
