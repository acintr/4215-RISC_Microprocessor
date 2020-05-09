// N Z C V
module ConditionTester (output cond, input [3:0] cond_code, input N, Z, C, V);
    always @ (cond_code, N, Z, C, V)
    begin
        cond = 0;
        case(cond_code)
            4'b0000: if(Z == 1) cond = 1;   // EQ Equal
            4'b0001: if(Z == 0) cond = 1;   // NE Not Equal
            4'b0010: if(C == 1) cond = 1;   // CS/HS Unsigned Higher or Same
            4'b0011: if(C == 0) cond = 1;   // CC/LO Unsigned Lower
            4'b0100: if(N == 1) cond = 1;   // MI Minus
            4'b0101: if(N == 0) cond = 1;   // PL Positive or Zero
            4'b0110: if(V == 1) cond = 1;   // VS Overflow
            4'b0111: if(V == 0) cond = 1;   // VC No Overflow
            4'b1000: if(C == 0 && Z == 0) cond = 1;   // HI Unsigned Higher
            4'b1001: if(C == 0 && Z == 1) cond = 1;   // LS Unsigned Lower or Same
            4'b1010: if(N == V) cond = 1;   // GE Greater or Equal
            4'b1011: if(N == ~V) cond = 1;   // LT Less Than
            4'b1100: if(Z == 0 && N == V) cond = 1;   // GT Great Than
            4'b1101: if(Z == 1 || N == ~V) cond = 1;   // LE Less Than or Equal
            4'b1110: cond = 1;   // AL Always
            default: cond = 0;
        endcase
    end
endmodule