//`timescale 1ns / 1ps


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 18:47:32
// Design Name: 
// Module Name: DECODE
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


module DECODE (
    input                   [31 : 0]            inst,

    output       reg        [ 4 : 0]            alu_op,
    output       reg        [31 : 0]            imm,

    output       reg        [ 4 : 0]            rf_ra0,
    output       reg        [ 4 : 0]            rf_ra1,
    output       reg        [ 4 : 0]            rf_wa,
    output       reg        [ 0 : 0]            rf_we,

    output       reg        [ 0 : 0]            alu_src0_sel,
    output       reg        [ 0 : 0]            alu_src1_sel
);


always @(*) begin
    if(inst[31:15] == 17'b0000_0000_0001_00000)begin//add.w rd,rj,rk
        alu_op = 5'b00000;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01010)begin//addi.w rd,rj,si12
        alu_op = 5'b00000;
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_00010)begin//sub.w rd,rj,rk
        alu_op = 5'b00010;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_00100)begin//slt rd,rj,rk
        alu_op = 5'b00100;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01000)begin//slti.w rd,rj,si12
        alu_op = 5'b00100;
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_00101)begin//sltu rd,rj,rk
        alu_op = 5'b00101;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01001)begin//sltui.w rd,rj,si12
        alu_op = 5'b00101;
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01001)begin//and rd,rj,rk
        alu_op = 5'b01001;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01101)begin//andi.w rd,rj,usi12
        alu_op = 5'b01001;
        imm = {{20{1'b0}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01010)begin//or rd,rj,rk
        alu_op = 5'b01010;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01110)begin//ori.w rd,rj,si12
        alu_op = 5'b01010;
        imm = {{20{1'b0}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01011)begin//xor rd,rj,rk
        alu_op = 5'b01011;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01111)begin//xori.w rd,rj,si12
        alu_op = 5'b01011;
        imm = {{20{1'b0}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01110)begin//sll.w rd,rj,rk
        alu_op = 5'b01110;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0100_00001)begin//slli.w rd,rj,si12
        alu_op = 5'b01110;
        imm = {{27{1'b0}},inst[14:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01111)begin//srl.w rd,rj,rk
        alu_op = 5'b01111;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0100_01001)begin//srli.w rd,rj,si12
        alu_op = 5'b01111;
        imm = {{27{1'b0}},inst[14:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_10000)begin//sra.w rd,rj,rk
        alu_op = 5'b10000;
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end
    
    else if(inst[31:15] == 17'b0000_0000_0100_10001)begin//srai.w rd,rj,si12
        alu_op = 5'b10000;
        imm = {{27{1'b0}},inst[14:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:25] == 7'b000_1010)begin//lu12i.w rd,si20
        alu_op = 5'b10011;
        imm = {inst[24:5],{12{1'b0}}};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;
    end

    else if(inst[31:25] == 7'b000_1110)begin//pcaddu12i rd,si20
        alu_op = 5'b10111;
        imm = {inst[24:5],{12{1'b0}}};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;
    end
    else begin
        alu_op = 5'b0;
        imm = 32'b0;
        rf_ra0 = 5'b0;
        rf_ra1 = 5'b0;
        rf_wa = 5'b0;
        rf_we = 1'b0;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;
    end
end
endmodule
