module Encoder (output reg [5:0] Out, input [31:0] In, input reset);
    always @ (In, reset)
    if (reset == 1) Out = 60;
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
        if (In [27:25] == 3'b000 && In [4] == 1'b0)
        begin
            case (In [24:20])
            5'b10100:   Out = 57;   //CMP register
            5'b11010:   Out = 58;   //MOV register
            5'b11011:   Out = 59;   //MOVS register
            endcase
        end
//---------------------AM3-------------------------------------------
        if (In [27:25] == 3'b000) begin
            if (In [24] == 1'b1 && In [7] == 1'b1 && In [4] == 1'b1) 
            begin
                case (In [22:21])
                2'b00:  Out = 26;  //register
                2'b01:  Out = 29;  //pre-register
                2'b10:  Out = 16;  //inme
                2'b11:  Out = 19;  //pre
                endcase
            end
            if (In [24] == 1'b0 && In [7] == 1'b1 && In [4] == 1'b1)
            begin
                case (In [22:21])
                2'b10:  Out = 23;  //post
                2'b00:  Out = 33;  //post-register
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
            5'b00000:   Out = 63;    //AND
            5'b00001:   Out = 63;    //ANDS
            5'b00100:   Out = 63;    //SUB
            5'b00101:   Out = 63;    //SUBS
            5'b11000:   Out = 53;    //ORR
            endcase
        end
//--------------------------010-----------------------------------------
        if (In [27:25] == 3'b010 && In [24] == 1'b1 && In[21] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 16;   //LDR, inme, -offset
                    else
                        Out = 16;   //STR, inme, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 16;   //LDRB, inme, -offset
                    else
                        Out = 16;   //STRB, inme, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 16;   //LDR, inme, +offset
                    else
                        Out = 16;   //STR, inme, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 16;   //LDRB, inme, +offset
                    else
                        Out = 16;   //STRB, inme, +offset
            endcase
        end
        if (In [27:25] == 3'b010 && In [24] == 1'b1 && In[21] == 1'b1)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 17;   //LDR, pre, -offset
                    else
                        Out = 17;   //STR, pre, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 17;   //LDRB, pre, -offset
                    else
                        Out = 17;   //STRB, pre, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 17;   //LDR, pre, +offset
                    else
                        Out = 17;   //STR, pre, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 17;   //LDRB, pre, +offset
                    else
                        Out = 17;   //STRB, pre, +offset
            endcase
        end
        if (In [27:25] == 3'b010 && In [24] == 1'b0 && In[21] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 23;   //LDR, inmepost, -offset
                    else
                        Out = 23;   //STR, inmepost, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 23;   //LDRB, inmepost, -offset
                    else
                        Out = 23;   //STRB, inmepost, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 23;   //LDR, inmepost, +offset
                    else
                        Out = 23;   //STR, inmepost, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 23;   //LDRB, inmepost, +offset
                    else
                        Out = 23;   //STRB, inmepost, +offset
            endcase
        end
//---------------------------011---------------------------------------
        if (In [27:25] == 3'b011 && In [24] == 1'b1 && In[21] == 1'b0 && In[4] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 26;   //LDR, register, -offset
                    else
                        Out = 26;   //STR, register, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 26;   //LDRB, register, -offset
                    else
                        Out = 26;   //STRB, register, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 26;   //LDR, register, +offset
                    else
                        Out = 26;   //STR, register, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 26;   //LDRB, register, +offset
                    else
                        Out = 26;   //STRB, register, +offset
            endcase
        end
        if (In [27:25] == 3'b011 && In [24] == 1'b1 && In[21] == 1'b1 && In[4] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 29;   //LDR, preregister, -offset
                    else
                        Out = 29;   //STR, preregister, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 29;   //LDRB, preregister, -offset
                    else
                        Out = 29;   //STRB, preregister, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 29;   //LDR, preregister, +offset
                    else
                        Out = 29;   //STR, preregister, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 29;   //LDRB, preregister, +offset
                    else
                        Out = 29;   //STRB, preregister, +offset
            endcase
        end
        if (In [27:25] == 3'b011 && In [24] == 1'b0 && In[4] == 1'b0)
        begin
            case (In [23:22])
            2'b00:  if (In [20] == 1'b1)
                        Out = 33;   //LDR, postregister, -offset
                    else
                        Out = 33;   //STR, postregister, -offset
            2'b01:  if (In [20] == 1'b1)
                        Out = 33;   //LDRB, postregister, -offset
                    else
                        Out = 33;   //STRB, postregister, -offset
            2'b10:  if (In [20] == 1'b1)
                        Out = 33;   //LDR, postregister, +offset
                    else
                        Out = 33;   //STR, postregister, +offset
            2'b11:  if (In [20] == 1'b1)
                        Out = 33;   //LDRB, postregister, +offset
                    else
                        Out = 33;   //STRB, postregister, +offset
            endcase
        end
//------------------------------101---------------------------------------
        if (In [27:25] == 3'b101)
        begin
            case (In [24])
            1'b0:   Out = 14;   //B
            1'b1:   Out = 15;   //BL
            endcase
        end
    end
endmodule
