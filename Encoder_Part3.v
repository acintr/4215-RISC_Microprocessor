module encoder (output reg [6:0] Out, input [31:0] In, input reset);
    always @ (In, reset)
    if (reset == 1) Out = 0;
    else
    begin
//------------------000------------------------------------------
       if (In [27:25] == 3'b000) begin
            if (In [24:20] == 5'b01000 && In [4] == 1'b0) begin
                case (In [11:5])
                7'b0000000: Out = 5;   //ADD R-R
                default:    Out = 6;   //ADD shift
                endcase
            end
            if (In [24:20] == 5'b01001 && In [4] == 1'b0) begin
                case (In [11:5])
                7'b0000000: Out = 10;   //ADDS R-R
                default:    Out = 11;   //ADDS shift
                endcase
            end
        end
//------------------001-------------------------------------------
        if (In [27:25] == 3'b001) 
        begin
            case (In [24:20])
            5'b01000:   Out = 7;   //ADD inme
            5'b01001:   Out = 12;   //ADDS inme
            5'b10100:   Out = 8;   //CMP
            5'b11010:   Out = 9;   //MOV
            5'b11011:   Out = 13;   //MOVS
            5'b00000:   Out = 127;    //AND
            5'b00001:   Out = 126;    //ANDS
            5'b00100:   Out = 125;    //SUB
            5'b00101:   Out = 124;    //SUBS
            5'b11000:   Out = 123;    //ORR
            endcase
        end
//--------------------------010-----------------------------------------
        if (In [27:25] == 3'b010 && In [24] == 1'b1 && In[21] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 122;   //LDR, inme, -offset
                    else
                        Out = 121;   //STR, inme, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 120;   //LDRB, inme, -offset
                    else
                        Out = 119;   //STRB, inme, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 118;   //LDR, inme, +offset
                    else
                        Out = 117;   //STR, inme, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 116;   //LDRB, inme, +offset
                    else
                        Out = 115;   //STRB, inme, +offset
            endcase
        end
        if (In [27:25] == 3'b010 && In [24] == 1'b1 && In[21] == 1'b1)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 114;   //LDR, pre, -offset
                    else
                        Out = 113;   //STR, pre, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 112;   //LDRB, pre, -offset
                    else
                        Out = 111;   //STRB, pre, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 110;   //LDR, pre, +offset
                    else
                        Out = 109;   //STR, pre, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 108;   //LDRB, pre, +offset
                    else
                        Out = 107;   //STRB, pre, +offset
            endcase
        end
        if (In [27:25] == 3'b010 && In [24] == 1'b0 && In[21] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 106;   //LDR, inmepost, -offset
                    else
                        Out = 105;   //STR, inmepost, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 104;   //LDRB, inmepost, -offset
                    else
                        Out = 103;   //STRB, inmepost, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 102;   //LDR, inmepost, +offset
                    else
                        Out = 101;   //STR, inmepost, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 100;   //LDRB, inmepost, +offset
                    else
                        Out = 99;   //STRB, inmepost, +offset
            endcase
        end
        if (In [27:25] == 3'b010 && In [24] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 98;   //LDR, inmepost, -offset
                    else
                        Out = 97;   //STR, inmepost, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 96;   //LDRB, inmepost, -offset
                    else
                        Out = 95;   //STRB, inmepost, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 94;   //LDR, inmepost, +offset
                    else
                        Out = 93;   //STR, inmepost, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 92;   //LDRB, inmepost, +offset
                    else
                        Out = 91;   //STRB, inmepost, +offset
            endcase
        end
//---------------------------011---------------------------------------
        if (In [27:25] == 3'b011 && In [24] == 1'b1 && In[21] == 1'b0 && In[4] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 90;   //LDR, register, -offset
                    else
                        Out = 89;   //STR, register, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 88;   //LDRB, register, -offset
                    else
                        Out = 87;   //STRB, register, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 86;   //LDR, register, +offset
                    else
                        Out = 85;   //STR, register, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 84;   //LDRB, register, +offset
                    else
                        Out = 83;   //STRB, register, +offset
            endcase
        end
        if (In [27:25] == 3'b011 && In [24] == 1'b1 && In[21] == 1'b1 && In[4] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 82;   //LDR, preregister, -offset
                    else
                        Out = 81;   //STR, preregister, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 80;   //LDRB, preregister, -offset
                    else
                        Out = 79;   //STRB, preregister, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 78;   //LDR, preregister, +offset
                    else
                        Out = 77;   //STR, preregister, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 76;   //LDRB, preregister, +offset
                    else
                        Out = 75;   //STRB, preregister, +offset
            endcase
        end
        if (In [27:25] == 3'b011 && In [24] == 1'b0 && In[4] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 74;   //LDR, postregister, -offset
                    else
                        Out = 73;   //STR, postregister, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 72;   //LDRB, postregister, -offset
                    else
                        Out = 71;   //STRB, postregister, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 70;   //LDR, postregister, +offset
                    else
                        Out = 69;   //STR, postregister, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 68;   //LDRB, postregister, +offset
                    else
                        Out = 67;   //STRB, postregister, +offset
            endcase
        end
//------------------------------101---------------------------------------
        if (In [27:25] == 3'b101)
        begin
            case (In [24])
            1'b0:   Out = 30;   //B
            1'b1:   Out = 31;   //BL
            endcase
        end
    end
endmodule
module test_encoder;
    reg [31:0] X;
    reg R;
    wire [6:0] Y;
    encoder fase3 (Y, X, R);
    initial begin
        X = 32'b11100111110100010010000000000000;
        R = 0;
    end
    initial begin
        $display (" Input     Output ");
        $monitor (" %h  %d ", X, Y);
    end
endmodule
