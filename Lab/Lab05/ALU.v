//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/15 22:31:17
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define ADD                 5'B00000    
`define SUB                 5'B00010   
`define SLT                 5'B00100
`define SLTU                5'B00101
`define AND                 5'B01001
`define OR                  5'B01010
`define XOR                 5'B01011
`define SLL                 5'B01110   
`define SRL                 5'B01111    
`define SRA                 5'B10000  
`define SRC0                5'B10001
`define SRC1                5'B10010
`define LU12i               5'B10011
`define pacu                5'B10111

// `define LD                  5'B11000//ld.w  ld.b  ld.h  ld.bu  ld.hu
// `define ST                  5'B11001//ST.W  st.h  st.b

module ALU (
    input                   [31 : 0]            alu_src0,
    input                   [31 : 0]            alu_src1,
    input                   [ 4 : 0]            alu_op,

    output      reg         [31 : 0]            alu_res
);
reg signed [31:0] a_signed;
reg signed [31:0] b_signed;

always @(*) begin
    a_signed = $signed(alu_src0);
    b_signed = $signed(alu_src1);
end

    always @(*) begin
        case(alu_op)
            `ADD  :
                alu_res = alu_src0 + alu_src1;
            `SUB  :
                alu_res = alu_src0 - alu_src1;
            `SLT : begin
                if (a_signed >= b_signed) begin
                    alu_res = 32'b0;
                end else begin
                    alu_res = 32'b1;
                end
            end
            `SLTU :
            alu_res = (alu_src0 < alu_src1) ? 32'b1 : 32'b0;
            `AND  :
                alu_res = alu_src0 & alu_src1;
            `OR   :
                alu_res = alu_src0 | alu_src1;
            `XOR  :
                alu_res = alu_src0 ^ alu_src1;
            `SLL  :
                alu_res = alu_src0 << alu_src1[4:0];
            `SRL  :
                alu_res = alu_src0 >> alu_src1[4:0];
            `SRA  :
                alu_res = $signed(a_signed) >>> alu_src1[4:0];
            `SRC0 :
                alu_res = alu_src0;
            `SRC1 :
                alu_res = alu_src1;
            `LU12i :
                alu_res = alu_src1;
            `pacu :
                alu_res = alu_src0 + (alu_src1);
            default :
                alu_res = 32'H0;
        endcase
    end
endmodule
