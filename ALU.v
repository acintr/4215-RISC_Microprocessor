// module ALU_32bit (output reg[31:0] Out, output reg Z, V, N, C_Out, input [31:0] In_A, In_B, input [4:0] OP, input C_In);
module ALU_32bit (output reg[31:0] Out, output reg N, Z, C_Out, V, input [31:0] In_A, In_B, input [4:0] OP, input C_In);
    always @ (In_A, In_B, OP)   //Cada vez que cambie In_A, In_B o OP
    begin
        case(OP)
        5'b00000:   Out = In_A & In_B;            
        5'b00001:   Out = In_A ^ In_B;            
        5'b00010:   {C_Out,Out} = In_A - In_B;           
        5'b00011:   {C_Out,Out} = In_B - In_A;           
        5'b00100:   {C_Out,Out} = In_A + In_B;            
        5'b00101:   {C_Out,Out} = In_A + In_B + C_In;    
        5'b00110:   {C_Out,Out} = In_A - In_B - ~C_In;    
        5'b00111:   {C_Out,Out} = In_B - In_A - ~C_In;     
        5'b01000:   Out = In_A & In_B;            //AND, update flags after
        5'b01001:   Out = In_A ^ In_B;            //XOR, update flags after
        5'b01010:   {C_Out,Out} = In_A - In_B;    //Resta, update flags after
        5'b01011:   {C_Out,Out} = In_A + In_B;    //Suma, update flags after
        5'b01100:   Out = In_A | In_B;           
        5'b01101:   Out = In_B;                
        5'b01110:   Out = In_A & ~In_B;         
        5'b01111:   Out = ~In_B;                  
        5'b10000:   Out = In_A;                 
        5'b10001:   {C_Out,Out} = In_A + 4;               
        5'b10010:   {C_Out,Out} = In_A + In_B + 4;       
        endcase
        //ADD
        if (OP == 4 || OP == 5 || OP == 11 || OP == 17 || OP == 18)
            begin
                if (Out == 0)
                    Z = 1;
                else
                    Z = 0;
                if (Out [31] == 1)
                    N = 1;
                else
                    N = 0;
                if ((In_A [31] == 1 && In_B [31] == 1 && Out [31] == 0)||(In_A [31] == 0 && In_B [31] == 0 && Out [31] == 1))
                    V = 1;
                else 
                    V = 0;
            end
        //SUB A - B
        if (OP == 2 || OP == 6 || OP == 10)
            begin
                if (Out == 0)
                    Z = 1;
                else
                    Z = 0;
                if (Out [31] == 1)
                    N = 1;
                else
                    N = 0;
                if ((In_A [31] == 0 && In_B [31] == 1 && Out [31] == 1)||(In_A [31] == 1 && In_B [31] == 0 && Out [31] == 0))
                    V = 1;
                else 
                    V = 0;
            end
        //SUB B - A
        if (OP == 3 || OP == 7)
            begin
                if (Out == 0)
                    Z = 1;
                else
                    Z = 0;
                if (Out [31] == 1)
                    N = 1;
                else
                    N = 0;
                if ((In_A [31] == 1 && In_B [31] == 0 && Out [31] == 1)||(In_A [31] == 0 && In_B [31] == 1 && Out [31] == 0))
                    V = 1;
                else 
                    V = 0;
            end
        //Logical
        if (OP == 0 || OP == 1 || OP == 8 || OP == 9 || OP == 12 || OP == 13 || OP == 14 || OP == 15 || OP == 16)
            begin
                if (Out == 0)
                    Z = 1;
                else
                    Z = 0;
                if (Out [31] == 1)
                    N = 1;
                else
                    N = 0;
            end
    end
endmodule
//-----Modulo de prueba-----//
module test_ALU_32bit;
  reg [31:0] A, B;                             
  reg [4:0] X;                               
  reg C;                                  
  wire [31:0] Y; 
  wire Zero, Ovf, Neg, Co;
  parameter timer = 50;                          
  ALU_32bit testing (Y, Zero, Ovf, Neg, Co, A, B, X, C);
  initial #timer $finish;                       
  initial 
  begin
    A = 4294967295;                                     
    B = 0;  
    C = 0;
    X = 5'b00000;                          
    repeat (18) #2 X = X + 5'b00001;  
  end
  initial begin
    $display (" Op      Input_1                            Input_2                          Carry Z   V   N   C   Output                                          Tiempo ");
    $monitor (" %b   %b   %b   %b   %b   %b   %b   %b   %b %d ", X, A, B, C, Zero, Ovf, Neg, Co, Y, $time);
  end
endmodule