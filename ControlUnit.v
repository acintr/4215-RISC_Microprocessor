module Encoder (output reg [5:0] Out, input [31:0] In, input reset);
    always @ (In, reset)
    if(reset == 1) Out = 0;
    else
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

module InverterMux (output reg InvIn, input MOC, Cond, Entrythree, Entryfour, input [1:0] S);
  always @ (S, MOC, Cond) begin
    case(S)
      2'b00: InvIn = MOC;
	  2'b01: InvIn = Cond;
	  2'b10: InvIn = Entrythree;
	  2'b11: InvIn = Entryfour;
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

module Microstore (output reg [5:0] state_out, output reg FR, RF, IR, MAR, MDR, ReadWrite, MOV, MC, MD, ME, Inv, output reg [1:0] MA, 
output reg [1:0] MB, output reg [4:0] OP, output reg [5:0] CR, 
output reg [2:0] N, output reg [1:0] S, input [5:0] state);
    always @ (state) begin
        case(state)
            6'b000000: 
                begin
                    FR = 0;
                    RF = 0;
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
                end
            6'b000001:
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
                    MC = 0;
                    MD = 1;
                    ME = 0;
                    OP = 5'b10000;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b000010:
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
                    MC = 1;
                    MD = 1;
                    ME = 0;
                    OP = 5'b10001;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b000011:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 1;
                    CR = 6'b000011;
                    N = 3'b101;
                    S = 2'b00;
                end
            6'b000100:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b100;
                    S = 2'b01;
                end
            6'b001010:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            6'b001011:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            6'b001100:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            6'b001101:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            6'b001110:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            6'b010100:
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
                    MC = 0;
                    MD = 1;
                    ME = 0;
                    OP = 5'b00100;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b010101:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b010110:
                begin
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
                end
            6'b010111:
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
                    MC = 0;
                    MD = 1;
                    ME = 0;
                    OP = 5'b01101;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            6'b011001:
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
                    MC = 0;
                    MD = 1;
                    ME = 0;
                    OP = 5'b00100;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b011010:
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
                    MC = 0;
                    MD = 1;
                    ME = 1;
                    OP = 5'b10000;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b011011:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b011;
                    S = 2'b00;
                end
            6'b011100:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 1;
                    CR = 6'b011100;
                    N = 3'b001;
                    S = 2'b00;
                end
            6'b011110:
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
                    MC = 1;
                    MD = 1;
                    ME = 0;
                    OP = 5'b10010;
                    Inv = 0;
                    CR = 6'b000001;
                    N = 3'b010;
                    S = 2'b00;
                end
            default:
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
                    MC = 0;
                    MD = 0;
                    ME = 0;
                    OP = 5'b00000;
                    Inv = 0;
                    CR = 6'b000000;
                    N = 3'b000;
                    S = 2'b00;
                end
        endcase
        state_out = state;
    end
endmodule 

module ControlRegister (output reg [5:0] state, output reg FR, RF, IR, MAR, MDR, ReadWrite, MOV, MC, MD, ME, Inv, output reg [1:0] MA, 
output reg [1:0] MB, output reg [4:0] OP, output reg [5:0] CR, output reg [2:0] N, output reg [1:0] S, 
input FR_IN, RF_IN, IR_IN, MAR_IN, MDR_IN, ReadWrite_IN, MOV_IN, MC_IN, MD_IN, ME_IN, Inv_IN, input [1:0] MA_IN, 
input [1:0] MB_IN, input [4:0] OP_IN, input [5:0] CR_IN, input [2:0] N_IN, input [1:0] S_IN, input Clk, input [5:0] state_in);
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
    end
endmodule

module ControlUnit (output [5:0] state, output [5:0] CR, output [4:0] OP, output [2:0] N, output [1:0] MA, MB, S,
                    output FR, RF, IR, MAR, MDR, ReadWrite, MOV, MC, MD, ME, Inv,
                    input [31:0] InstructionRegister, input MOC, Cond, c2, c3, Clk, reset);
    wire [5:0] EuMux0, uMux1, CRuMux2, IncruMux3, uMux_2_uStr, Incr;
    wire [2:0] N_2_NSAS;
    wire [1:0] S_2_cMux, NSAS_2_uMux;
    wire cMux_2_inv, invCR, Sts, State;

    // Microstore to Control Register
    wire uFR, uRF, uIR, uMAR, uMDR, uReadWrite, uMOV, uMC, uMD, uME, uInv;
    wire [5:0] uCR, state_uStr_2_CR;
    wire [4:0] uOP;
    wire [2:0] uN;
    wire [1:0] uMA, uMB, uS;

    assign Inv = invCR;
    assign CR = CRuMux2;
    assign N = N_2_NSAS;
    assign S = S_2_cMux;
    // assign state = uMux_2_uStr;

    Encoder encoder (EuMux0, InstructionRegister, reset);
    NextStateAddressSelector nsas (NSAS_2_uMux, N_2_NSAS, Sts);
    Adder adder (Incr, uMux_2_uStr);
    IncrementRegister incrReg (IncruMux3, Incr, Clk);
    Inverter inverter (Sts, cMux_2_inv, Inv);
    InverterMux cMux (cMux_2_inv, MOC, Cond, c2, c3, S_2_cMux);
    MicrostoreMux uMux (uMux_2_uStr, EuMux0, uMux1, CRuMux2, IncruMux3, NSAS_2_uMux);
    Microstore uStore (state_uStr_2_CR, uFR, uRF, uIR, uMAR, uMDR, uReadWrite, uMOV, uMC, uMD, uME, 
                        uInv, uMA, uMB, uOP, uCR, uN, uS, uMux_2_uStr);
    ControlRegister ctrlReg (state, FR, RF, IR, MAR, MDR, ReadWrite, MOV, MC, MD, ME, 
                            invCR, MA, MB, OP, CRuMux2, N_2_NSAS, S_2_cMux,
                            uFR, uRF, uIR, uMAR, uMDR, uReadWrite, uMOV, uMC, uMD, uME, 
                            uInv, uMA, uMB, uOP, uCR, uN, uS, Clk, state_uStr_2_CR);
    
endmodule

module CUTest;

    reg [31:0] InstReg;
    reg MOC, Cond, c2, c3, Clk, reset;
    wire [5:0] CR;
    wire [4:0] OP;
    wire [2:0] N;
    wire [1:0] MA, MB, S;
    wire FR, RF, IR, MAR, MDR, ReadWrite, MOV, MC, MD, ME, Inv;
    wire [5:0] State; 
    ControlUnit cu (State, CR, OP, N, MA, MB, S, FR, RF, IR, MAR, MDR, ReadWrite, MOV, MC, MD, ME, Inv, InstReg, MOC, Cond, c2, c3, Clk, reset);  

    initial #200 $finish;

    initial begin
        Clk = 1'b0;
        repeat (1000) #1 Clk = ~Clk;
    end

    initial begin
        MOC = 0;
        repeat (1000) #3 MOC = ~MOC;
    end

    initial begin
        $display("STATE |   FR      RF      IR      MAR     MDR     R/W     MOV     MA      MB      MC      MD      ME      OP                      TIME");
        $monitor("%d    |   %b       %b       %b       %b       %b       %b       %b       %b      %b      %b       %b       %b       %b%d", State, FR, RF, IR, MAR, MDR, ReadWrite, MOV, MA, MB, MC, MD, ME, OP, $time);
    end

    initial begin fork
    #1 reset = 1;
    #1 Cond = 1;
    #3 reset = 0;
    // #1 MOC = 1;
    // INSTRUCTION CODE                                  INSTRUCTION         STATES         
    #2 InstReg = 32'b11100000100000100101000000000001; // ADD R-R            STATE = 10

    #14 InstReg = 32'b11100010100000000001000000101000; // ADD immediate     STATE = 11

    #26 InstReg = 32'b11100000100000000001000100000010; // ADD shift         STATE = 12
    
    #38 InstReg = 32'b11100011010000000001000000101000; // CMP               STATE = 13

    #50 InstReg = 32'b11100011101000000001000000101000; // MOV               STATE = 14

    #62 InstReg = 32'b11100101000101100101000000010100; // LDR               STATE = 20, 21, 22, 23

    #84 InstReg = 32'b11100111100001100101100011101100; // STR              STATE = 25, 26, 27, 28

    #104 InstReg = 32'b11101010111111111111111111111100; // B                STATE = 30

    // #1 InstReg = 32'b11101010111111111111111111111100;   // FOR TESTING A SINGLE INSTRUCTION

    join
    end


endmodule