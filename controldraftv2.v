module microstore (output reg FR, RF, IR, MAR, 
MDR, ReadWrite, MOV, MC, MD, ME, Inv, output reg [1:0] MA, 
output reg [1:0] MB, output reg [4:0] OP, output reg [5:0] CR, 
output reg [2:0] N, output reg [1:0] S, input [5:0] state );
always @ (state)
  case(state):
    6'b000000: 
	  FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b11;
	  MC = 1;
	  MD = 1;
	  ME = 0;
	  OP = 5'b01101;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
	6'b000001:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 1;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b10;
	  MB = 2'b00;
	  MC = 0;
	  MD = 1;
	  ME = 0;
	  OP = 5'b10000;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
    6'b000010:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 1;
	  MOV = 1; 
	  MA = 2'b10;
	  MB = 2'b00;
	  MC = 1;
	  MD = 1;
	  ME = 0;
	  OP = 5'b10001;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
    6'b000011:
      FR = 0;
	  RF = 0;
	  IR = 1;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 1;
	  MOV = 1; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 1;
	  CR = 6'b000011;
	  N = 3'b101;
	  S = 2'b00;
	6'b000100:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 4'b000000;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b100;
	  S = 2'b01;
	6'b001010:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	6'b001011:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b01;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	6'b001100:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b01;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	6'b001101:
      FR = 1;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b01;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	6'b001110:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b01;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	6'b010100:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 1;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b01;
	  MC = 0;
	  MD = 1;
	  ME = 0;
	  OP = 5'b00100;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
	6'b010101:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 1;
	  MOV = 1; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
	6'b010110:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 1;
	  ReadWrite = 1;
	  MOV = 1; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 1;
	  CR = 6'b010110;
	  N = 3'b101;
	  S = 2'b00;
	6'b010111:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b01;
	  MC = 0;
	  MD = 1;
	  ME = 0;
	  OP = 5'b01101;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	6'b011001:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 1;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 1;
	  ME = 0;
	  OP = 5'b00100;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
	6'b011010:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 1;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b01;
	  MB = 2'b00;
	  MC = 0;
	  MD = 1;
	  ME = 1;
	  OP = 5'b10000;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
	6'b011011:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 1; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b011;
	  S = 2'b00;
	6'b011100:
      FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 1; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 1;
	  CR = 6'b011100;
	  N = 3'b001;
	  S = 2'b00;
	6'b011110:
      FR = 0;
	  RF = 1;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b10;
	  MB = 2'b01;
	  MC = 1;
	  MD = 1;
	  ME = 0;
	  OP = 5'b10010;
	  Inv = 0;
	  CR = 6'b000001;
	  N = 3'b010;
	  S = 2'b00;
	default: 
	  FR = 0;
	  RF = 0;
	  IR = 0;
	  MAR = 0;
	  MDR = 0;
	  ReadWrite = 0;
	  MOV = 0; 
	  MA = 2'b00;
	  MB = 2'b00;
	  MC = 0;
	  MD = 0;
	  ME = 0;
	  OP = 5'b00000;
	  Inv = 0;
	  CR = 6'b000000;
	  N = 3'b000;
	  S = 2'b00;
  endcase
endmodule 


module inverter (output reg InvOut, input In, VarInv);
always @ (In, VarInv)
  case(VarInv):
    1'b0: 
	  if(In == 0) InvOut = 0;
	  else InvOut = 1;
	1'b1:
	  if(In == 1) InvOut = 0;
	  else InvOut = 1;
  endcase
endmodule


module InverterMux (output reg InvIn, input MOC, Cond, 
Entrythree, Entryfour, input [1:0] S);
  always @ (S) begin
    case(S):
      2'b00: InvIn = MOC;
	  2'b01: InvIn = Cond;
	  2'b10: InvIn = Entrythree;
	  2'b11: InvIn = Entryfour;
    endcase
  end
endmodule


module MicrostoreMux (output reg [5:0] nextstate, 
input [5:0] EncoderOut, input [5:0] ContRegiOut, 
input [5:0] IncRegiOut, input [5:0] Entryone, input [1:0] M );
  always @ (M) begin 
    case(M): 
	  2'b00: nextstate = EncoderOut;
	  2'b01: nextstate = 6'b000001;
	  2'b10: nextstate = ContRegiOut;
	  2'b11: nextstate = IncRegiOut;
	endcase 
  end 
endmodule 

