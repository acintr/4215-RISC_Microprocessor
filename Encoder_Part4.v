module encoder (output reg [7:0] Out, input [31:0] In, input reset);
    always @ (In, reset)
    if (reset == 1) Out = 0;
    else
    begin
//------------------000------------------------------------------
       if (In [27:25] == 3'b000) 
       begin
            if (In [24:20] == 5'b01000 && In [4] == 1'b0) 
            begin
                case (In [11:5])
                7'b0000000: Out = 5;   //ADD R-R
                default:    Out = 6;   //ADD shift
                endcase
            end
            if (In [24:20] == 5'b01001 && In [4] == 1'b0) 
            begin
                case (In [11:5])
                7'b0000000: Out = 10;   //ADDS R-R
                default:    Out = 11;   //ADDS shift
                endcase
            end
            
            //----------------------------AM3-----------------
            if (In [24] == 1'b1 && In [7] == 1'b1 && In [4] == 1'b1) 
            begin
                case (In [22:21])
                2'b00:  Out = 25;  //register
                2'b01:  Out = 26;  //pre-register
                2'b10:  Out = 27;  //inme
                2'b11:  Out = 28;  //pre
                endcase
            end
            if (In [24] == 1'b0 && In [7] == 1'b1 && In [4] == 1'b1)
            begin
                case (In [22:21])
                2'b10:  Out = 29;  //post
                2'b00:  Out = 30;  //post-register
                endcase
            end
        end
        if (In [27:25] == 3'b000 && In [4] == 1'b0)
        begin
            case (In [24:20])
            5'b00000:   Out = 83;   //AND register
            5'b00001:   Out = 84;   //ANDS register
            5'b00010:   Out = 85;   //EOR register
            5'b00011:   Out = 86;   //EORS register
            5'b00100:   Out = 87;   //SUB register
            5'b00101:   Out = 88;   //SUBS register
            5'b00110:   Out = 89;   //RSB register
            5'b00111:   Out = 90;   //RSBS register
            5'b01010:   Out = 91;   //ADC register
            5'b01011:   Out = 92;   //ADCS register
            5'b01100:   Out = 93;   //SBC register
            5'b01101:   Out = 94;   //SBCS register
            5'b01110:   Out = 95;   //RSC register
            5'b01111:   Out = 96;   //RSCS register
            5'b10000:   Out = 97;   //TST register
            5'b10010:   Out = 98;   //TEQ register
            5'b10100:   Out = 99;   //CMP register
            5'b10110:   Out = 100;   //CMN register
            5'b11000:   Out = 101;   //ORR register
            5'b11001:   Out = 102;   //ORRS register
            5'b11010:   Out = 103;   //MOV register
            5'b11011:   Out = 104;   //MOVS register
            5'b11100:   Out = 105;   //BIC register
            5'b11101:   Out = 106;   //BICS register
            5'b11110:   Out = 107;   //MVN register
            5'b11111:   Out = 108;   //MVNS register
            endcase
        end
//------------------001-------------------------------------------
        if (In [27:25] == 3'b001) 
        begin
            case (In [24:20])
            5'b00000:   Out = 82;   //AND 
            5'b00001:   Out = 81;   //ANDS
            5'b00010:   Out = 64;   //EOR
            5'b00011:   Out = 63;   //EORS
            5'b00100:   Out = 62;   //SUB
            5'b00101:   Out = 61;   //SUBS
            5'b00110:   Out = 60;   //RSB
            5'b00111:   Out = 59;   //RSBS
            5'b01000:   Out = 58;   //ADD inme
            5'b01001:   Out = 57;   //ADDS inme
            5'b01010:   Out = 56;   //ADC inme
            5'b01011:   Out = 55;   //ADCS inme
            5'b01100:   Out = 54;   //SBC
            5'b01101:   Out = 53;   //SBCS
            5'b01110:   Out = 52;   //RSC
            5'b01111:   Out = 51;   //RSCS
            5'b10000:   Out = 50;   //TST
            5'b10010:   Out = 49;   //TEQ
            5'b10100:   Out = 48;   //CMP
            5'b10110:   Out = 47;   //CMN
            5'b11000:   Out = 46;   //ORR
            5'b11001:   Out = 45;   //ORRS
            5'b11010:   Out = 44;   //MOV
            5'b11011:   Out = 43;   //MOVS
            5'b11100:   Out = 42;   //BIC
            5'b11101:   Out = 41;   //BICS
            5'b11110:   Out = 40;   //MVN
            5'b11111:   Out = 39;   //MVNS
            endcase
        end
//--------------------------010-----------------------------------------
        if (In [27:25] == 3'b010)
        begin
            if (In [24] == 1'b1)
            begin
                case (In [21])
                1'b0:   Out = 31;  //Inme
                1'b1:   Out = 32;  //Pre
                endcase
            end
            else 
            Out = 33;  //Post
        end
//---------------------------011---------------------------------------
        if (In [27:25] == 3'b011 && In [4] == 1'b0)
        begin
            if (In [24] == 1'b1)
            begin
                case (In [21])
                1'b0:   Out = 34;  //Inme register
                1'b1:   Out = 35;  //Pre register
                endcase
            end
            else 
            Out = 36;  //Post register
        end
//-------------------------100-------AM4--------------------------------
        if (In [27:25] == 3'b100)
        begin
            case (In [24:20])
            5'b00000:   Out = 65;  //STMDA, W=0
            5'b00010:   Out = 66;  //W=1
            5'b01000:   Out = 67;  //STMIA
            5'b01010:   Out = 68;  //W=1
            5'b10000:   Out = 69;  //STMDB
            5'b10010:   Out = 70;  //W=1
            5'b11000:   Out = 71;  //STMIB
            5'b11010:   Out = 72;  //W=1
            5'b00001:   Out = 73;  //LDMDA
            5'b00011:   Out = 74;  //W=1
            5'b01001:   Out = 75;  //LDMIA
            5'b01011:   Out = 76;  //W=1
            5'b10001:   Out = 77;  //LDMDB
            5'b10011:   Out = 78;  //W=1
            5'b11001:   Out = 79;  //LDMIB
            5'b11011:   Out = 80;  //W=1
            endcase
        end
//------------------------------101---------------------------------------
        if (In [27:25] == 3'b101)
        begin
            case (In [24])
            1'b0:   Out = 37;   //B
            1'b1:   Out = 38;   //BL
            endcase
        end
    end
endmodule
module test_encoder;
    reg [31:0] X;
    reg R;
    wire [7:0] Y;
    encoder fase3 (Y, X, R);
    initial begin
        X = 32'b11100111111100010000000000000000;
        R = 0;
    end
    initial begin
        $display (" Input     Output ");
        $monitor (" %h  %d ", X, Y);
    end
endmodule
