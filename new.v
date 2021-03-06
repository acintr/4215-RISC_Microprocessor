/**********************************************************************
                            ALU
***********************************************************************/
module ALU_32bit (output reg[31:0] Out, output reg N, Z, C_Out, V, input [31:0] In_A, In_B, input [4:0] OP, input C_In, Clk);
    always @ (In_A, In_B, OP)   //Cada vez que cambie In_A, In_B o OP
	// always @ (negedge Clk)
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
		//$display("ALU IN A = %b %d\nALU IN B = %b %d\nALU OUT = %b %d\nOP = %b\t%d=T", In_A, In_A, In_B, In_B, Out, Out, OP, $time);
    end
endmodule

/**********************************************************************
                            CONDITION TESTER
***********************************************************************/
// N Z C V
module ConditionTester (output reg cond, input [3:0] cond_code, input N, Z, C, V, Clk);
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

/**********************************************************************
                            FLAG REGISTER
***********************************************************************/
module Flag_Register (output reg N_out, Z_out, C_out, V_out, input N_in, Z_in, C_in, V_in, FR_Ld, Clk);
    always @ (posedge Clk)
    begin
        if (FR_Ld == 1'b1)
        begin
            N_out = N_in;
            Z_out = Z_in;
            C_out = C_in;
            V_out = V_in;
        end
    end
endmodule

/**********************************************************************
                            INSTRUCTION REGISTER
***********************************************************************/
module IR (output reg [31:0] Out_IR, input [31:0] In_IR, input IR_Ld, Clk);
    always @ (posedge Clk)
    begin
        if (IR_Ld == 1'b1)
        begin
        Out_IR = In_IR;
        end
		// $display("IRIN = %b\nIROUT = %b  \nIRLd = %b %d=T", In_IR, Out_IR, IR_Ld, $time);
    end
endmodule

/**********************************************************************
                            MAR
***********************************************************************/
module MAR (output reg [31:0] Out_MAR, input [31:0] In_MAR, input MAR_Ld, Clk);
    always @ (posedge Clk)
    begin
	    if (MAR_Ld == 1'b1)
        //if (MAR_Ld == 1'b1 && Clk == 1)
        begin
        Out_MAR = In_MAR;
        end
		// $display("MARIN = %b\nMAROUT = %b  \nMARLd = %b %d=T", In_MAR, Out_MAR, MAR_Ld, $time);
    end
endmodule

/**********************************************************************
                            MDR
***********************************************************************/
module MDR (output reg [31:0] Out_MDR, input [31:0] In_MDR, input MDR_Ld, Clk);
    always @ (posedge Clk)
    begin
        if (MDR_Ld == 1'b1)
        begin
        Out_MDR = In_MDR;
        end
		// $display("MDR IN = %b\nMDR OUT = %b	%d=T", In_MDR, Out_MDR, $time);
    end
endmodule

/**********************************************************************
                            MUX A
***********************************************************************/
module Mux_A (output reg [3:0] Out_A, input [3:0] In_A0, In_A1, In_A2, In_A3, input [1:0] S_A, input Clk);
    always @ (S_A, In_A0, In_A1, In_A2, In_A3)
	// always @ (Clk)
    begin
        case (S_A)
        2'b00:  Out_A = In_A0;
        2'b01:  Out_A = In_A1;
        2'b10:  Out_A = In_A2;
        2'b11:  Out_A = In_A3;
        endcase
		// $display("MUXA: IN00 = %b; IN01 = %b; IN10 = %b;\n IN11 = %b; OUT = %b; MA = %b\t%d=T", In_A0, In_A1, In_A2, In_A3, Out_A, S_A, $time);
    end
endmodule

/**********************************************************************
                            MUX B
***********************************************************************/
module Mux_B (output reg [31:0] Out_B, input [31:0] In_B0, In_B1, In_B2, In_B3, input [1:0] S_B, input Clk);
    always @ (S_B, In_B0, In_B1, In_B2, In_B3)
	// always @ (Clk)
    begin
        case (S_B)
        2'b00:  Out_B = In_B0;
        2'b01:  Out_B = In_B1;
        2'b10:  Out_B = In_B2;
        2'b11:  Out_B = In_B3;
        endcase
		// $display("MUXB: IN00 = %b; IN01 = %b; IN10 = %b;\n IN11 = %b; OUT = %b; MB = %b\t%d=T", In_B0, In_B1, In_B2, In_B3, Out_B, S_B, $time);
    end
endmodule

/**********************************************************************
                            MUX C
***********************************************************************/
module Mux_C (output reg [3:0] Out_C, input [3:0] IReg12_15, Ones, In_C3, IReg16_19, input [1:0] S_C, input Clk);
    always @ (S_C, IReg12_15, Ones, In_C3, IReg16_19)
	// always @ (Clk)
    begin
        case (S_C)
        2'b00:  Out_C = IReg12_15;
        2'b01:  Out_C = Ones;
        2'b10:  Out_C = IReg16_19; 
        2'b11:  Out_C = In_C3;
        endcase
		//$display("MC = %b; Out = %b;\t%d=T", S_C, Out_C, $time);
    end
endmodule

/**********************************************************************
                            MUX D
***********************************************************************/
module Mux_D (output reg [4:0] Out_D, input [3:0] In_D0, input [4:0] In_D1, input S_D, Clk);
    always @ (S_D, In_D0, In_D1)
	// always @ (Clk)
    begin
        case (S_D)
        1'b0:  Out_D = 5'b00000 + In_D0;
        1'b1:  Out_D = In_D1;
        endcase
		// $display("MD = %b; Out = %b;\t%d=T", S_D, Out_D, $time);
    end
endmodule

/**********************************************************************
                            MUX E
***********************************************************************/
module Mux_E (output reg [31:0] Out_E, input [31:0] In_E0, In_E1, input S_E, Clk);
    always @ (S_E, In_E0, In_E1)
	// always @ (Clk)
    begin
        case (S_E)
        1'b0:  Out_E = In_E0;
        1'b1:  Out_E = In_E1;
        endcase
		// $display("ME = %b; Out = %b;\t%d=T", S_E, Out_E, $time);
    end
endmodule

/**********************************************************************
                                RAM
***********************************************************************/
module ram512x8 (output reg MOC, output reg [31:0] DataOut, input
MOV, ReadWrite, input [31:0] Address, input [31:0]
DataIn, input [1:0] datatype); //se incluyo datatype para determinar el tamano del dato 

	//00: byte(8 bits)   01: half-word(16 bits)   10: word(32 bits)  11: doubleword (64 bits)

	reg [7:0] Mem[0:511];    //512 localizaciones de 1 byte
    reg dw;
	// initial MOC = 1'b0;      //Memory Operation Complete comienza como cero.

	always @ (Address, MOV, ReadWrite, DataIn, datatype)   //Se verifica el modulo con cada cambio en Address, MOV o ReadWrite. 
	begin 
		// $display("MOV = %b; R/W = %b; DataType = %b; Address = %b %d\t%d=T", MOV, ReadWrite, datatype, Address, Address, $time);
		MOC = 1'b0;                    //Operacion de Memoria no esta completada. 
		
		if(MOV)                         // Si Memory Operation Valid = 0, nada pasa.
		begin 
		
			if(ReadWrite)               //ReadWrite = 1 indica operacion Read. 
			begin 
			
				case(datatype)
				
					2'b01:             //01: byte
					begin 
						DataOut[31:8] = 24'b000000000000000000000000;
						DataOut[7:0] = Mem[Address];
						#1
						MOC = 1'b1;
					end
					
					2'b00:             //00: halfword
					begin 
						DataOut[31:16] = 16'b0000000000000000;
						DataOut[15:8] = Mem[Address];
						DataOut[7:0] = Mem[Address + 1];
						#1
						MOC = 1'b1;
					end 
					
					2'b10:             //10: word
					begin 
						DataOut[31:24] = Mem[Address];
						DataOut[23:16] = Mem[Address + 1];
						DataOut[15:8] = Mem[Address + 2];
						DataOut[7:0] = Mem[Address + 3];
						#1
						MOC = 1'b1;
					end

                    2'b11:             //11: doubleword
					begin 
                        if (dw == 1)
                        begin
                            DataOut[31:24] = Mem[Address+4];
                            DataOut[23:16] = Mem[Address+5];
                            DataOut[15:8] = Mem[Address+6];
                            DataOut[7:0] = Mem[Address+7];
							#1
                            MOC = 1'b1;
                            dw = 0;
                        end
                        else
                        begin
                        	DataOut[31:24] = Mem[Address];
                        	DataOut[23:16] = Mem[Address+1];
                        	DataOut[15:8] = Mem[Address+2];
                        	DataOut[7:0] = Mem[Address+3];
							#1
                            MOC = 1'b1;
                            dw = 1;
                        end
					end
					// 2'b11:            //11:doubleword
				    //     begin 
					// 	DataOut[31:24] = Mem[Address];
					// 	DataOut[23:16] = Mem[Address+1];
					// 	DataOut[15:8] = Mem[Address+2];
					// 	DataOut[7:0] = Mem[Address+3];
					// 	#2                                   //delay para darle tiempo al data bus
					// 	DataOut[31:24] = Mem[Address+4];
					// 	DataOut[23:16] = Mem[Address+5];
					// 	DataOut[15:8] = Mem[Address+6];
					// 	DataOut[7:0] = Mem[Address+7];
					// 	#1 MOC = 1'b1;
					// end
					
				endcase
				
			end
			
			else                       //Operacion Write
			begin 
			
				case(datatype) 
				
					2'b00:             //00: byte
					begin 
						Mem[Address] = DataIn[7:0];
						#1 MOC = 1'b1;
					end
					
					2'b01:             //01: Half-word
					begin 
						Mem[Address] = DataIn[15:8];
						Mem[Address + 1] = DataIn[7:0];
						#1 MOC = 1'b1;
					end
					
					2'b10:             //10: Word
					begin 
						Mem[Address] = DataIn[31:24]; 
						Mem[Address + 1] = DataIn[23:16]; 
						Mem[Address + 2] = DataIn[15:8];
						Mem[Address + 3] = DataIn[7:0];
						#1 MOC = 1'b1;
					end
					
                    2'b11:             //11: doubleword
					begin 
                        if (dw == 1)
                        begin
                            Mem[Address+4] = DataIn[31:24];
                            Mem[Address+5] = DataIn[23:16];
                            Mem[Address+6] = DataIn[15:8];
                            Mem[Address+7] = DataIn[7:0];
                            #1 MOC = 1'b1;
                            dw = 0;
                        end
                        else
                        begin
                            Mem[Address+4] = DataIn[31:24];
                            Mem[Address+5] = DataIn[23:16];
                            Mem[Address+6] = DataIn[15:8];
                            Mem[Address+7] = DataIn[7:0];
                            #1 MOC = 1'b1;
                            dw = 1;
                        end
					end
					// 2'b11:           //11: DoubleWord 
					// begin 
					// 	Mem[Address] = DataIn[31:24];
                    // 				Mem[Address+1] = DataIn[23:16];
                    // 				Mem[Address+2] = DataIn[15:8];
                    // 				Mem[Address+3] = DataIn[7:0];
                    // 				#2
                    // 				Mem[Address+4] = DataIn[31:24];
                    // 				Mem[Address+5] = DataIn[23:16];
                    // 				Mem[Address+6] = DataIn[15:8];
                    // 				Mem[Address+7] = DataIn[7:0];
                    // 				#1 MOC = 1'b1;
					// end
					
				endcase 
				
			end
		end
		// $display("MOC = %b; DataOut = %b;\t%d=T", MOC, DataOut, $time);
	end
	
endmodule

/**********************************************************************
                            Mux Incrementer
***********************************************************************/
module Mux_Incrementer (output reg [3:0] Rout, input [3:0] Rin, input incr, Clk);
    always @ (Rin, incr)
    begin
        case(incr)
            1'b0: Rout = Rin;
            1'b1: Rout = Rin + 4'b0001;
        endcase
    end
endmodule

/**********************************************************************
                            REGISTER FILE
***********************************************************************/
// Register
module Register (output reg [31:0] Q, input [31:0] D, input Ld, Clk);
    always @ (posedge Clk)  // Edge trigger
        if(Ld == 1) begin   // Two-gate Register
            Q = D;
            // $display("New data at register:\nClk = %d      Ld = %b     D = %d      Q = %d        t=%d", Clk, Ld, D, Q, $time);
            end
endmodule

// Binary Decoder 4 to 16
module Bin_Decoder_4x16 (output reg E15, E14, E13, E12, E11, E10, E9, E8, E7, 
                        E6, E5, E4, E3, E2, E1, E0, input [3:0] C, input Ld, Clk);
    
    always @ (Ld) begin
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
                // default begin
                //     E15=0; E14=0; E13=0; E12=0; 
                //     E11=0; E10=0; E9=0; E8=0; 
                //     E7=0; E6=0; E5=0; E4=0; 
                //     E3=0;E2=0;E1=0; E0=0;
                // end
            endcase
        // else begin
        //     E15=0; E14=0; E13=0; E12=0; 
        //     E11=0; E10=0; E9=0; E8=0; 
        //     E7=0; E6=0; E5=0; E4=0; 
        //     E3=0;E2=0;E1=0; E0=0;
        //     end
            // $display("Binary Decoder: Ld = %b   C = %b  t = %d \n[15:0]    %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", Ld, C, $time, E15, E14, E13, E12, E11, E10, E9, E8, E7, E6, E5, E4, E3, E2, E1, E0);
        end
        
endmodule

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

// Register File
module RegisterFile (output [31:0] r1, r2, r3, r5, r15, PA, PB, input [31:0] PC, 
                    input [3:0] C, input [3:0] A, input [3:0] B, input Ld, Clk);
    wire [31:0] R0M, R1M, R2M, R3M, R4M, R5M, 
                    R6M, R7M, R8M, R9M, R10M, 
                    R11M, R12M, R13M, R14M, R15M;       // Wires from Reg to Mux
    wire E15, E14, E13, E12, E11, E10, E9, 
            E8, E7, E6, E5, E4, E3, E2, E1, E0;         // Wires from Binary Decoder to Reg (Ld)
    
	assign r1 = R1M;
	assign r2 = R2M;
	assign r3 = R3M;
	assign r5 = R5M;
	assign r15 = R15M;

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
                                E6, E5, E4, E3, E2, E1, E0, C, Ld, Clk);
endmodule

/**********************************************************************
                            SHIFTER
***********************************************************************/
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
                        begin
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
                        else if (IR[7] == 1'b1 && IR[4] == 1'b1) // Addressing Mode 3 Immediate Offset
                        begin
                            Q[11:8] = IR[11:8];
                            Q[3:0] = IR[3:0];
                        end
                end
            3'b010: // Addressing Mode 2 Immediate Offset
                begin
                    Q[11:0] = IR[11:0];
                end
        endcase
    end
   
endmodule

/**********************************************************************
                            CONTROL UNIT
***********************************************************************/
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
            5'b00000:   Out = 7;    //AND
            5'b00001:   Out = 10;    //ANDS
            5'b00100:   Out = 7;    //SUB
            5'b00101:   Out = 12;    //SUBS
            5'b11000:   Out = 7;    //ORR
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
		// $display("Encoder State = %d\t%d=T", Out, $time);
    end
endmodule


// Memory Operation Decoder
module MOP_Decoder (output reg U, D, L, output reg [1:0] WB, input [31:0] IR, input [5:0] state);
    always @ (IR, state)
    begin
        U = IR[23]; // Unsigned
        if(IR[27:25] == 3'b000) // Addressing Mode 3
        begin
            if(IR[20] == 1'b1 && IR[6:5] == 10)
            begin
                if(IR[20] == 0)
                begin
                    case(IR[6:5])
                        2'b01:
                            begin
                                D = 1'b0;
                                L = 1'b0;
                                WB = 2'b00;
                            end
                        2'b10:
                            begin
                                D = 1'b1;
                                L = 1'b1;
                                WB = 2'b11;
                            end
                        2'b11:
                            begin
                                D = 1'b1;
                                L = 1'b0;
                                WB = 2'b11;
                            end
                    endcase
                end
                else
                begin
                    case(IR[6:5])
                        2'b01:
                            begin
                                D = 1'b0;
                                L = 1'b1;
                                WB = 2'b00;
                            end
                        2'b10:
                            begin
                                D = 1'b0;
                                L = 1'b1;
                                WB = 2'b01;
                            end
                        2'b11:
                            begin
                                D = 1'b0;
                                L = 1'b1;
                                WB = 2'b00;
                            end
                    endcase
                end
            end
        end
        else if (IR[27:26] == 2'b01)    // Addressing Mode 2
        begin
            WB[0] = IR[22]; // Byte
            WB[1] = ~WB[0];     // Word
            D = 1'b0;
            L = IR[20];
        end
        if (state == 6'b000000 || state == 6'b000001 || state == 6'b000010 || state == 6'b000011 || state == 6'b000100) // fetch
        begin
            D = 0;
            L = 0;
            WB = 2'b10;
        end
		// $display("Cajita Magica: U = %b; D = %b; L = %b; WB = %b\t%d=T", U, D, L, WB, $time);
    end
endmodule

// Next State Address Selector
module NextStateAddressSelector (output reg [1:0] M, input [2:0] N, input Sts);
    always @ (N, Sts) begin
        case(N)
            3'b000: M = 2'b00;  // Encoder
            3'b001: 
                if (Sts ==0) M = 2'b01;  // 1
                else M = 2'b10;  // Control Register
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

// Adder (increment by 1)
module Adder (output reg [5:0] Out, input [5:0] In);
    always @ (In) begin
        Out = In + 6'b000001;
    end
endmodule

// Increment Register
module IncrementRegister (output reg [5:0] Out, input [5:0] In, input Clk);
    always @ (posedge Clk) begin
        Out = In;
    end
endmodule

module Inverter (output reg InvOut, input In, VarInv);
always @ (In, VarInv)
  case(VarInv)
    1'b0: 
	  if(In == 0) InvOut = 0;
	  else InvOut = 1;
	1'b1:
	  if(In == 1) InvOut = 0;
	  else InvOut = 1;
  endcase
endmodule

module InverterMux (output reg InvIn, input MOC, Cond, unsignee, double, load, EntrySix, Entryseven, Entryeight, input [2:0] S);
  always @ (S, MOC, Cond) begin
    case(S)
      3'b000: InvIn = MOC;
	  3'b001: InvIn = Cond;
	  3'b010: InvIn = unsignee;
	  3'b011: InvIn = double;
	  3'b100: InvIn = load;
	  3'b101: InvIn = EntrySix;
	  3'b110: InvIn = Entryseven;
	  3'b111: InvIn = Entryeight;
    endcase
  end
endmodule

module MicrostoreMux (output reg [5:0] nextstate, 
input [5:0] EncoderOut, Entryone, ContRegiOut, IncRegiOut, input [1:0] M );
  always @ (M, EncoderOut, Entryone, ContRegiOut, IncRegiOut) begin 
    case(M)
	  2'b00: nextstate = EncoderOut;
	  2'b01: nextstate = 6'b000001;
	  2'b10: nextstate = ContRegiOut;
	  2'b11: nextstate = IncRegiOut;
      default:
        nextstate = EncoderOut;
	endcase
    // $display("%d    %d", nextstate, M); 
  end 
endmodule 

module Microstore (output reg [5:0] state_out, output reg FR, RF, IR, MAR, MDR, ReadWrite, MOV, MD, ME, Inv, MINCR, output reg [1:0] MA, 
output reg [1:0] MB, output reg [1:0] MC, output reg [4:0] OP, output reg [5:0] CR, 
		   output reg [2:0] N, output reg [2:0] S, input [5:0] state);
    always @ (state) begin
	case(state)
	6'b000000:					// STATE 0
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000001:					// STATE 1
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b10;
        		MB = 2'b00;
        		MC = 2'b01;
        		MD = 1;
        		ME = 0;
        		OP = 5'b10000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000010:					// STATE 2
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b10;
        		MB = 2'b00;
        		MC = 2'b01;
        		MD = 1;
        		ME = 0;
        		OP = 5'b10001;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000011:					// STATE 3
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 1;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b000011;	// STATE 000011
        		N = 3'b101;		// incr/cr
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000100:					// STATE 4
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b100;		// CR/enc
        		S = 3'b001;
        		MINCR = 0;
        	end
	6'b000101:					// STATE 5
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000110:					// STATE 6
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000111:					// STATE 7
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001000:					// STATE 8
        	begin
        		FR = 1;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001001:					// STATE 9
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001010:					// STATE 10
        	begin
        		FR = 1;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001011:					// STATE 11
        	begin
        		FR = 1;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001100:					// STATE 12
        	begin
        		FR = 1;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001101:					// STATE 13
        	begin
        		FR = 1;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001110:					// STATE 14
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b10;
        		MB = 2'b01;
        		MC = 2'b01;
        		MD = 1;
        		ME = 0;
        		OP = 5'b10010;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b001111:					// STATE 15
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b10;
        		MB = 2'b11;
        		MC = 2'b11;
        		MD = 1;
        		ME = 0;
        		OP = 5'b10000;
        		Inv = 0;
        		CR = 6'b001110;	// STATE 001110
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b010000:					// STATE 16
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b010010;	// STATE 010010
        		N = 3'b101;		// incr/CR
        		S = 3'b010;
        		MINCR = 0;
        	end
	6'b010001:					// STATE 17
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b010010:					// STATE 18
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00010;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b010011:					// STATE 19
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b010101;	// STATE 010101
        		N = 3'b101;		// incr/CR
        		S = 3'b010;
        		MINCR = 0;
        	end
	6'b010100:					// STATE 20
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b010110;	// STATE 010110
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b010101:					// STATE 21
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b00010;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b010110:					// STATE 22
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b10;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b010111:					// STATE 23
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b10000;
        		Inv = 1;
        		CR = 6'b011001;	// STATE 011001
        		N = 3'b101;		// incr/CR
        		S = 3'b010;
        		MINCR = 0;
        	end
	6'b011000:					// STATE 24
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b10;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b011001:					// STATE 25
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b01;
        		MC = 2'b10;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00010;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b011010:					// STATE 26
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b011100;	// STATE 011100
        		N = 3'b101;		// incr/CR
        		S = 3'b010;
        		MINCR = 0;
        	end
	6'b011011:					// STATE 27
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b011100:					// STATE 28
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b011101:					// STATE 29
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b011111;	// STATE 011111
        		N = 3'b101;		// incr/CR
        		S = 3'b010;
        		MINCR = 0;
        	end
	6'b011110:					// STATE 30
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b100000;	// STATE 100000
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b011111:					// STATE 31
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b00010;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b100000:					// STATE 32
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b10;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b100001:					// STATE 33
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 1;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b10000;
        		Inv = 1;
        		CR = 6'b100011;	// STATE 100011
        		N = 3'b101;		// incr/CR
        		S = 3'b010;
        		MINCR = 0;
        	end
	6'b100010:					// STATE 34
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b10;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00100;
        		Inv = 0;
        		CR = 6'b100100;	// STATE 100100
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b100011:					// STATE 35
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b10;
        		MD = 1;
        		ME = 0;
        		OP = 5'b00010;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b100100:					// STATE 36
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b101100;	// STATE 101100
        		N = 3'b101;		// incr/CR
        		S = 3'b011;
        		MINCR = 0;
        	end
	6'b100101:					// STATE 37
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b101001;	// STATE 101001
        		N = 3'b101;		// incr/CR
        		S = 3'b100;
        		MINCR = 0;
        	end
	6'b100110:					// STATE 38
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b100111;	// STATE 100111
        		N = 3'b011;		// incr
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b100111:					// STATE 39
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 1;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b100111;	// STATE 100111
        		N = 3'b101;		// incr/CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101000:					// STATE 40
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101001:					// STATE 41
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b01;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b10000;
        		Inv = 0;
        		CR = 6'b101010;	// STATE 101010
        		N = 3'b011;		// incr
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101010:					// STATE 42
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b101011;	// STATE 101011
        		N = 3'b011;		// incr
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101011:					// STATE 43
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b101011;	// STATE 101011
        		N = 3'b001;		// 1/CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101100:					// STATE 44
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b110011;	// STATE 110011
        		N = 3'b101;		// incr/CR
        		S = 3'b100;
        		MINCR = 0;
        	end
	6'b101101:					// STATE 45
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101110:					// STATE 46
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 1;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b101110;	// STATE 101110
        		N = 3'b101;		// incr/CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b101111:					// STATE 47
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b110000:					// STATE 48
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b110001:					// STATE 49
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 1;
        		ReadWrite = 1;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b0000;
        		Inv = 1;
        		CR = 6'b110001;	// STATE 110001
        		N = 3'b101;		// incr/CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b110010:					// STATE 50
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b10;
        		MC = 2'b00;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 1;
        	end
	6'b110011:					// STATE 51
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b01;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b10000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// Increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b110100:					// STATE 52
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b110101:					// STATE 53
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b110101;	// STATE 110101
        		N = 3'b101;		// incr/CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b110110:					// STATE 54
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 1;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b01;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 1;
        		ME = 1;
        		OP = 5'b10000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// increment
        		S = 3'b000;
        		MINCR = 1;
        	end
	6'b110111:					// STATE 55
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111000:					// STATE 56
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 1;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 1;
        		CR = 6'b111000;	// STATE 111000
        		N = 3'b001;		// 1/CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111001:					// STATE 57
        	begin
        		FR = 1;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111010:					// STATE 58
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111011:					// STATE 59
        	begin
        		FR = 1;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000001;	// STATE 000001
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111100:					// STATE 60
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b011;		// increment
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111101:					// STATE 61
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b11;
        		MC = 2'b01;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b111101:					// STATE 61
        	begin
        		FR = 0;
        		RF = 1;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b11;
        		MC = 2'b01;
        		MD = 1;
        		ME = 0;
        		OP = 5'b01101;
        		Inv = 0;
        		CR = 6'b000000;	// STATE 000000
        		N = 3'b010;		// CR
        		S = 3'b000;
        		MINCR = 0;
        	end
	6'b000000:		// STATE 0
        	begin
        		FR = 0;
        		RF = 0;
        		IR = 0;
        		MAR = 0;
        		MDR = 0;
        		ReadWrite = 0;
        		MOV = 0;
        		MA = 2'b00;
        		MB = 2'b00;
        		MC = 2'b00;
        		MD = 0;
        		ME = 0;
        		OP = 5'b00000;
        		Inv = 0;
        		CR = 6'b000000;
        		N = 3'b011;
        		S = 3'b000;
        	end
	endcase
        state_out = state;
    end
endmodule 

module ControlRegister (output reg [5:0] state, output reg FR, RF, IR, MAR, MDR, ReadWrite, MOV, MD, ME, Inv, MINCR_out, output reg [1:0] MA, 
output reg [1:0] MB, output reg [1:0] MC, output reg [4:0] OP, output reg [5:0] CR, output reg [2:0] N, output reg [2:0] S, 
input FR_IN, RF_IN, IR_IN, MAR_IN, MDR_IN, ReadWrite_IN, MOV_IN, MD_IN, ME_IN, Inv_IN, MINCR_in, input [1:0] MA_IN, 
input [1:0] MB_IN, input [1:0] MC_IN, input [4:0] OP_IN, input [5:0] CR_IN, input [2:0] N_IN, input [2:0] S_IN, input Clk, input [5:0] state_in);
    always @ (posedge Clk) begin
        FR = FR_IN;
        RF = RF_IN;
        IR = IR_IN;
        MAR = MAR_IN;
        MDR = MDR_IN;
        ReadWrite = ReadWrite_IN;
        MOV = MOV_IN; 
        MA = MA_IN;
        MB = MB_IN;
        MC = MC_IN;
        MD = MD_IN;
        ME = ME_IN;
        OP = OP_IN;
        Inv = Inv_IN;
        CR = CR_IN;
        N = N_IN;
        S = S_IN;
        state = state_in;
        MINCR_out = MINCR_in;
		// $display("STATE = %d\t%d=T", state, $time);
		// $display("FR=%b  RF=%b  IR=%b  MAR=%b  MDR=%b  R/W=%b  MOV=%b  MA=%B  MB=%b  MC=%b  MD=%b  ME=%b  OP=%b  MINCR=%b\nN=%b  INV=%b  S=%b  CR=%b\n\n",
		//  		FR, RF, IR, MAR, MDR, ReadWrite, MOV, MA, MB, MC, MD, ME, OP, MINCR_out, N, Inv, S, CR);
    end
endmodule

// ControlUnit - needs implementation update
module ControlUnit (output [5:0] state, output [5:0] CR, output [4:0] OP, output [2:0] N, S, output [1:0] MA, MC, MB, WB,
                    output FR, RF, IR, MAR, MDR, ReadWrite, MOV, MD, ME, Inv, MINCR,
                    input [31:0] InstructionRegister, input MOC, Cond, c2, c3, Clk, reset);
    wire [5:0] EuMux0, uMux1, CRuMux2, IncruMux3, uMux_2_uStr, Incr;
    wire [2:0] S_2_cMux, N_2_NSAS;
    wire [1:0] NSAS_2_uMux;
    wire cMux_2_inv, invCR, Sts, State;

    // Microstore to Control Register
    wire uFR, uRF, uIR, uMAR, uMDR, uReadWrite, uMOV, uMD, uME, uInv, uMINCR;
    wire [5:0] uCR, state_uStr_2_CR, current_state;
    wire [4:0] uOP;
    wire [2:0] uN, uS;
    wire [1:0] uMA, uMB, uMC;
    wire U, D, L, idk1, idk2, idk3;

    assign Inv = invCR;
    assign CR = CRuMux2;
    assign N = N_2_NSAS;
    assign S = S_2_cMux;
    // assign state = uMux_2_uStr;
    assign state = current_state;
    Encoder encoder (EuMux0, InstructionRegister, reset);
    // AddressModeDetector amd ();                                                  //Please help here if possible, no supe bregar
    MOP_Decoder mopd (U, D, L, WB, InstructionRegister, current_state);
    NextStateAddressSelector nsas (NSAS_2_uMux, N_2_NSAS, Sts);
    Adder adder (Incr, uMux_2_uStr);
    IncrementRegister incrReg (IncruMux3, Incr, Clk);
    Inverter inverter (Sts, cMux_2_inv, Inv);
    InverterMux cMux (cMux_2_inv, MOC, Cond, U, D, L, idk1, idk2, idk3, S_2_cMux);
    MicrostoreMux uMux (uMux_2_uStr, EuMux0, uMux1, CRuMux2, IncruMux3, NSAS_2_uMux);
    Microstore uStore (state_uStr_2_CR, uFR, uRF, uIR, uMAR, uMDR, uReadWrite, uMOV, uMD, uME, 
                        uInv, uMINCR, uMA, uMB, uMC, uOP, uCR, uN, uS, uMux_2_uStr);
    ControlRegister ctrlReg (current_state, FR, RF, IR, MAR, MDR, ReadWrite, MOV, MD, ME, 
                            invCR, MINCR, MA, MB, MC, OP, CRuMux2, N_2_NSAS, S_2_cMux,
                            uFR, uRF, uIR, uMAR, uMDR, uReadWrite, uMOV, uMD, uME, 
                            uInv, uMINCR, uMA, uMB, uMC, uOP, uCR, uN, uS, Clk, state_uStr_2_CR);
    
endmodule

/**********************************************************************
                            DATA PATH
***********************************************************************/
module DataPath (output [31:0] PC, MAR, R1, R2, R3, R5, IR, input Clk, RESET);
    
    // assign in_3 = 1'b0;
    wire [31:0] ir_bus, data_out, data_in, alu_bus, mdr_bus, rfpb_bus; // Busses
    wire [31:0] rfpa_alu, muxb_alu, shifter_muxb, mar_ram, muxe_mdr, r1, r2, r3, r5, r15; // 1-to-1
    wire [4:0] muxd_alu;
    wire alu_fr_N, alu_fr_Z, alu_fr_C, alu_fr_V, fr_cond_N, fr_cond_Z, fr_cond_alu_C, fr_cond_V;    // ALU to Flag Register & Flag Register to ConditionTester
    assign IR = ir_bus;
	assign MAR = mar_ram;

    wire [3:0] in_1, in_2;//bytes fijos
    wire [31:0] in_0;
    assign in_1 [3:0] = 4'b1111; //
    assign in_0 [31:0] = 32'b00000000_00000000_00000000_00000000; //
    assign in_2 [3:0] = 4'b1110; //
    // wire in_3;
    wire [3:0] muxa_rfa, muxc_rfc;
    // wire [31:0] R15; // Program Counter
// // Control Signals
    wire fr_ld, rf_ld, ir_ld, mar_ld, mdr_ld, rw, mov, md, me;
    //los añadí
    wire cond_cu, ram_moc, inv;//control unit y ram
    wire [1:0] wb;//control unit y ram
    wire [2:0] n, s;//control unit
    wire [5:0] cr; //control unit
    //------
    wire [1:0] ma, mb, mc;
    wire [4:0] op;
    wire [5:0] STATE; //por ahora 6 bits

    wire [3:0] MINCR_Ain, MINCR_Aout, MINCR_Cin, MINCR_Cout;
    wire MINCR;
    
    ALU_32bit alu (alu_bus, alu_fr_N, alu_fr_Z, alu_fr_C, alu_fr_V, rfpa_alu, muxb_alu, muxd_alu, fr_cond_alu_C, Clk);
    ConditionTester condTester (cond_cu, ir_bus [31:28], fr_cond_N, fr_cond_Z, fr_cond_alu_C, fr_cond_V, Clk);
    Flag_Register flagReg (fr_cond_N, fr_cond_Z, fr_cond_alu_C, fr_cond_V, alu_fr_N, alu_fr_Z, alu_fr_C, alu_fr_V, fr_ld, Clk);
    IR ir (ir_bus, data_out, ir_ld, Clk); 
    MAR mar (mar_ram, alu_bus, mar_ld, Clk);
    MDR mdr (data_in, muxe_mdr, mdr_ld, Clk);
    Mux_A muxa (MINCR_Ain, ir_bus [19:16], ir_bus [15:12], 4'b1111, 4'b0000, ma, Clk);
    Mux_B muxb (muxb_alu, rfpb_bus, shifter_muxb, data_in, in_0, mb, Clk);
    Mux_C muxc (MINCR_Cin, ir_bus [15:12], 4'b1111, 4'b1110, ir_bus [19:16], mc, Clk);
    Mux_D muxd (muxd_alu, ir_bus [24:21], op, md, Clk);
    Mux_E muxe (muxe_mdr, data_out, alu_bus, me, Clk);
    ram512x8 ram (ram_moc, data_out, mov, rw, mar_ram, data_in, wb);
    RegisterFile regFile (R1, R2, R3, R5, PC, rfpa_alu, rfpb_bus, alu_bus, MINCR_Cout, MINCR_Aout, ir_bus [3:0], rf_ld, Clk);//output [31:0] PA, PB, ProgamCounter, input [31:0] PC, input [3:0] C, input [3:0] A, input [3:0] B, input Ld, Clk);
    Shifter shifter (shifter_muxb, alu_fr_C, rfpb_bus, ir_bus, fr_cond_alu_C);
    ControlUnit cu (STATE, cr, op, n, s, ma, mc, mb, wb, fr_ld, rf_ld, ir_ld, mar_ld, mdr_ld, rw, mov, md, me, inv, MINCR, ir_bus, ram_moc, cond_cu, 1'b0, 1'b0, Clk, RESET);//output [5:0] state, output [5:0] CR, output [4:0] OP, output [2:0] N, S, output [1:0] MA, MC, MB, WB,output FR, RF, IR, MAR, MDR, ReadWrite, MOV, MD, ME, Inv,input [31:0] InstructionRegister, input MOC, Cond, c2, c3, Clk, reset);
    Mux_Incrementer ma_incr (MINCR_Aout, MINCR_Ain, MINCR, Clk);
    Mux_Incrementer mc_incr (MINCR_Cout, MINCR_Cin, MINCR, Clk);

endmodule


/**********************************************************************
                           TEST MODULE
***********************************************************************/
module ARM_Micro;
    integer fi, fo, code, i;
	reg [7:0] data;
	reg [31:0] Address;
	wire [31:0] PC, MAR, R1, R2, R3, R5, IR;
	reg Clk, RESET;

	DataPath dp (PC, MAR, R1, R2, R3, R5, IR, Clk, RESET);

	initial #600 $finish;

	initial begin
		Clk = 1'b0;
		repeat (300) #1 Clk = ~Clk;
	end

	initial begin
		$display("\tPC         MAR         R1         R2         R3         R5              \tIR");
		$monitor("%d %d %d %d %d %d\t%b\t", PC, MAR, R1, R2, R3, R5, IR);
	end

	initial begin fork
		RESET = 1;
		#5 RESET = 0;
	join
	end

	initial begin
		fi = $fopen("mem.txt", "r");
		Address = 32'b00000000_00000000_00000000_00000000;
		while (!$feof(fi)) begin
			code = $fscanf(fi, "%b", data);
			dp.ram.Mem[Address] = data;
			Address = Address + 1;
		end
		$fclose(fi);

		dp.ram.Mem[100] = 8'b00000000;
		dp.ram.Mem[101] = 8'b00000000;
		dp.ram.Mem[102] = 8'b11111111;
		dp.ram.Mem[103] = 8'b00000000;

		dp.ram.Mem[104] = 8'b00000000;
		dp.ram.Mem[105] = 8'b00000000;
		dp.ram.Mem[106] = 8'b00000000;
		dp.ram.Mem[107] = 8'b11111111;

		#750
		Address = 0;
		$display("\n\n-------------------------MEMORY-------------------------\nAddress   |   Byte0    Byte1    Byte2    Byte3");
		while (Address < 600) begin
			$display("%d| %b %b %b %b", Address, dp.ram.Mem[Address], dp.ram.Mem[Address+1], dp.ram.Mem[Address+2], dp.ram.Mem[Address+3]);
			Address = Address + 4;
		end
	end

endmodule