module IR_2_UWBDL (output reg U, W, B, D, L, input [31:0] IR, input [5:0] state);
    always @ (IR, state)
    begin
        U = IR[23]; // Unsigned
        if(IR[27:25] == 3'b000) // Addressing Mode 3
        begin
            if(IR[20] == 1'b1 && IR[6:5] == 10)
                if(IR[20] == 0)
                    case(IR[6:5])
                        2'b01:
                            begin
                                W = 1'b0;
                                B = 1'b0;
                                D = 1'b0;
                                L = 1'b0;
                            end
                        2'b10:
                            begin
                                W = 1'b0;
                                B = 1'b0;
                                D = 1'b1;
                                L = 1'b1;
                            end
                        2'b11:
                            begin
                                W = 1'b0;
                                B = 1'b0;
                                D = 1'b1;
                                L = 1'b0;
                            end
                    endcase
                else
                    case(IR[6:5])
                        2'b01:
                            begin
                                W = 1'b0;
                                B = 1'b0;
                                D = 1'b0;
                                L = 1'b1;
                            end
                        2'b10:
                            begin
                                W = 1'b0;
                                B = 1'b1;
                                D = 1'b0;
                                L = 1'b1;
                            end
                        2'b11:
                            begin
                                W = 1'b0;
                                B = 1'b0;
                                D = 1'b0;
                                L = 1'b1;
                            end
                    endcase
            end
        end
        else if (IR[27:26] == 2'b01)    // Addressing Mode 2
        begin
            B = IR[22]; // Byte
            W = ~B;     // Word
            D = 1'b0;
            L = IR[20];
        end
        else if (state == 6'b000000 || state == 6'b000001 || state == 6'b000010 || state == 6'b000011) // fetch
        begin
            B = 0;
            W = 1;
            D = 0;
            L = 0;
        end
    end
endmodule