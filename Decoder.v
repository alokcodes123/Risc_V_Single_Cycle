module main_decoder (op,zero,func3,func7,PCSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite,ALUOp,ALUControl)

// declare input outputs

input zero;
input func3[2:0];
input func7;
input op[6:0];
output PCSrc, ResultSrc, MemWrite, RegWrite,ALUSrc;
output ImmSrc[1:0];
output ALUOp[1:0];
output ALUControl[2:0];

// interim wire

wire branch;
wire [1:0] concatenation; // for alu decoder
// output allocation of main decoder 

assign PCSrc = Zero & Branch;
assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0;
assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
assign ALUSrc = ((op == 7'b0000011) | (op == 7'b0100011))? 1'b1 : 1'b0;
assign ImmSrc = (op == 7'0100011) ? 2'b01 : (op == 7'b1100011) ? 2'b10 : 2'b00;
assign Regwrite = ((op == 7'b0000011) | (op == 7'b0110011)) ? 1'b1 : 1'b0;
assign ALUOp = (op == 7'0110011) ? 2'b10 : (op == 7'b1100011) ? 2'b01 : 2'b00;
assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0;

// output allocation of ALU decoder

assign concatenation = {op[5], func7};

assign ALUControl = (ALUOp == 2'b00) ? 3'b000 : 
                    (ALUOp == 2'b01) ? 3'b001 :
                    ((ALUOp == 2'b10) & (func3 == 3'b010)) ? 3'b101 : 
                    ((ALUOp == 2'b10) & (func3 == 3'b110)) ? 3'b001 :
                    ((ALUOp == 2'b10) & (func3 == 3'b111)) ? 3'b010 : 
                    ((ALUOp == 2'b10) & (func3 = 3'b000)) & (concatenation == 2'b11) ? 3'b001 :
                    ((ALUOp == 2'b10) & (func3 = 3'b000)) & (concatenation != 2'b11) ? 3'b000 : 3'b000;

endmodule
