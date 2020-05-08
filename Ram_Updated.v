module ram512x8 (output reg MOC, output reg [31:0] DataOut, input
MOV, ReadWrite, input [31:0] Address, input [31:0]
DataIn, input [1:0] datatype); //se incluyo datatype para determinar el tamano del dato 

	//00: byte(8 bits)   01: half-word(16 bits)   10: word(32 bits)  11: doubleword (64 bits)

	reg [7:0] Mem[0:511];    //512 localizaciones de 1 byte
	initial MOC = 1'b0;      //Memory Operation Complete comienza como cero.

	always @ (Address, MOV, ReadWrite)   //Se verifica el modulo con cada cambio en Address, MOV o ReadWrite. 
	begin 
	
		#1 MOC = 1'b0;                    //Operacion de Memoria no esta completada. 
		
		if(MOV)                         // Si Memory Operation Valid = 0, nada pasa.
		begin 
		
			if(ReadWrite)               //ReadWrite = 1 indica operacion Read. 
			begin 
			
				case(datatype)
				
					2'b01:             //01: byte
					begin 
						DataOut[31:8] = 24'b000000000000000000000000;
						DataOut[7:0] = Mem[Address];
						#1 MOC = 1'b1;
					end
					
					2'b00:             //00: halfword
					begin 
						DataOut[31:16] = 16'b0000000000000000;
						DataOut[15:8] = Mem[Address];
						DataOut[7:0] = Mem[Address + 1];
						#1 MOC = 1'b1;
					end 
					
					2'b10:             //10: word
					begin 
						DataOut[31:24] = Mem[Address];
						DataOut[23:16] = Mem[Address + 1];
						DataOut[15:8] = Mem[Address + 2];
						DataOut[7:0] = Mem[Address + 3];
						#1 MOC = 1'b1;
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
	end
	
endmodule
