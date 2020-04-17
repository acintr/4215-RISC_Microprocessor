module encoder (output reg [5:0] Out, input [31:0] In);
    always @ (In)
    begin
        if (In [31:28] == 4'b1110)          //Condition Always
        begin
            if (In [27:25] == 3'b000)       //if bits 27 to 25 is 000
            begin 
                if (In [24:21] == 4'b0100)  //if opcode is 0100
                begin
                    case (In [11:5])
                    7'b0000000:  Out = 10;   //State 10 == ADD R-R
                    default:     Out = 12;   //State 11 == ADD shift
                    endcase
                end
            end
            if (In [27:25] == 3'b001)       //if bits 27 to 25 is 001
            begin
                case (In [24:21])
                4'b0100:    Out = 11;       //State 12 == ADD imme
                4'b1010:    Out = 13;       //State 13 == CMP
                4'b1101:    Out = 14;       //State 14 == MOV
                endcase
            end
            if (In [27:25] == 3'b010 | In [27:25] == 3'b011)       //if bits 27 to 25 is 010
            begin
                if (In [24] == 1'b1 & In [22:21] == 2'b00)        
                begin
                    case (In [20])
                    1'b1:   Out = 20;       //State 20 == LDR
                    1'b0:   Out = 25;       //State 25 == STR
                    endcase
                end
            end
        end
        if (In [27:25] == 4'b101)       //if bits 27 to 25 is 101
        begin
            if (In [24] == 1'b0)        //branch without link
            begin
                case (In [31:28])       //Condition
                4'b1110:    Out = 30;   //State 30 == B
                endcase
            end
        end
    end
endmodule
