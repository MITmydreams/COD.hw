//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/15 19:34:57
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

    output      reg         [ 4 : 0]            alu_op,

    output      reg         [ 3 : 0]            dmem_access,

    output      reg         [31 : 0]            imm,

    output      reg         [ 4 : 0]            rf_ra0,
    output      reg         [ 4 : 0]            rf_ra1,
    output      reg         [ 4 : 0]            rf_wa,
    output      reg         [ 0 : 0]            rf_we,
    output      reg         [ 1 : 0]            rf_wd_sel,

    output      reg         [ 0 : 0]            alu_src0_sel,
    output      reg         [ 0 : 0]            alu_src1_sel,

    output      reg         [ 3 : 0]            br_type,
    output      reg         [ 0 : 0]            dmem_we
);

always @(*) begin
    if(inst[31:15] == 17'b0000_0000_0001_00000)begin//add.w rd,rj,rk
        alu_op = 5'b00000;//0
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;
        dmem_we = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01010)begin//addi.w rd,rj,si12
        alu_op = 5'b00000;//0
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;
        dmem_we = 1'b0;

    end

    else if(inst[31:15] == 17'b0000_0000_0001_00010)begin//sub.w rd,rj,rk
        alu_op = 5'b00010;//2
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;
        dmem_we = 1'b0;

    end

    else if(inst[31:15] == 17'b0000_0000_0001_00100)begin//slt rd,rj,rk
        alu_op = 5'b00100;//4
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01000)begin//slti.w rd,rj,si12
        alu_op = 5'b00100;//4
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;
        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_00101)begin//sltu rd,rj,rk
        alu_op = 5'b00101;//5
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;
        dmem_we = 1'b0;

    end

    else if(inst[31:22] == 10'b00000_01001)begin//sltui.w rd,rj,si12
        alu_op = 5'b00101;//5
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01001)begin//and rd,rj,rk
        alu_op = 5'b01001;//9
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01101)begin//andi.w rd,rj,usi12
        alu_op = 5'b01001;//9
        imm = {{20{1'b0}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01010)begin//or rd,rj,rk
        alu_op = 5'b01010;//10
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01110)begin//ori.w rd,rj,si12
        alu_op = 5'b01010;//10
        imm = {{20{1'b0}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01011)begin//xor rd,rj,rk
        alu_op = 5'b01011;//11
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:22] == 10'b00000_01111)begin//xori.w rd,rj,si12
        alu_op = 5'b01011;//11
        imm = {{20{1'b0}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01110)begin//sll.w rd,rj,rk
        alu_op = 5'b01110;//14
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0100_00001)begin//slli.w rd,rj,si12
        alu_op = 5'b01110;//14
        imm = {{27{1'b0}},inst[14:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_01111)begin//srl.w rd,rj,rk
        alu_op = 5'b01111;//15
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0100_01001)begin//srli.w rd,rj,si12
        alu_op = 5'b01111;//15
        imm = {{27{1'b0}},inst[14:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:15] == 17'b0000_0000_0001_10000)begin//sra.w rd,rj,rk
        alu_op = 5'b10000;//16
        imm = 32'b0;
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b0;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end
    
    else if(inst[31:15] == 17'b0000_0000_0100_10001)begin//srai.w rd,rj,si12
        alu_op = 5'b10000;//16
        imm = {{27{1'b0}},inst[14:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:25] == 7'b000_1010)begin//lu12i.w rd,si20
        alu_op = 5'b10011;//19
        imm = {inst[24:5],{12{1'b0}}};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

    else if(inst[31:25] == 7'b000_1110)begin//pcaddu12i rd,si20
        alu_op = 5'b10111;//23
        imm = {inst[24:5],{12{1'b0}}};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b01;
        br_type = 4'b0000;

        dmem_we = 1'b0;
    end

//----------------------------------------------------------------------
//----------------------------------------------------------------------
//----------------------------------------------------------------------

    //涉及到了访存指令。
    else if(inst[31:22] == 10'b00101_00010)begin//ld.w rd,rj,si12----------LD : 24
        alu_op = 5'b00000;//24
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0001;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b0;

    end
    else if(inst[31:22] == 10'b00101_00001)begin//ld.h rd,rj,si12----------LD : 24
        alu_op = 5'b00000;//24
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0010;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b0;
        
    end
    else if(inst[31:22] == 10'b00101_00000)begin//ld.b rd,rj,si12----------LD : 24
        alu_op = 5'b00000;//24
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0011;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b0;
        
    end

    else if(inst[31:22] == 10'b00101_01001)begin//ld.hu rd,rj,si12----------LD : 24
        alu_op = 5'b00000;//24
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0100;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b0;
        
    end

    else if(inst[31:22] == 10'b00101_01000)begin//ld.bu rd,rj,si12----------LD : 24
        alu_op = 5'b00000;//24
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[14:10];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0101;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b0;
        
    end

    else if(inst[31:22] == 10'b00101_00110)begin//st.w rd,rj,si12----------SW : 25
        alu_op = 5'b00000;//25
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0110;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b1;
        
    end

    else if(inst[31:22] == 10'b00101_00101)begin//st.h rd,rj,si12----------SW : 25
        alu_op = 5'b00000;//25
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0111;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;
        
        dmem_we = 1'b1;
    end
    
    else if(inst[31:22] == 10'b00101_00100)begin//st.b rd,rj,si12----------SW : 25
        alu_op = 5'b00000;//25
        imm = {{20{inst[21]}},inst[21:10]};
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rk
        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b1000;
        rf_wd_sel = 2'b10;
        br_type = 4'b0;

        dmem_we = 1'b1;
        
    end


//跳转指令！！！！！！
//----------------------------------------------------------------
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//----------------------------------------------------------------------


    else if(inst[31:26] == 6'b010_110)begin//beq rj,rd,offs----------beq : 29
        //alu_op = 5'b11101;//29
        alu_op = 5'b00000;//29
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0001;
        dmem_we = 1'b0;
        
    end
    
    else if(inst[31:26] == 6'b010_111)begin//bne rj,rd,offs----------bne : 30
        //alu_op = 5'b11110;//30
        alu_op = 5'b00000;
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0010;
        dmem_we = 1'b0;

    end

    else if(inst[31:26] == 6'b011_000)begin//blt rj,rd,offs----------blt : 31
        //alu_op = 5'b11111;//31
        alu_op = 5'b00000;
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0011;
        dmem_we = 1'b0;

    end

    else if(inst[31:26] == 6'b011_001)begin//bge rj,rd,offs----------bge : 31
        //alu_op = 5'b11111;//31
        alu_op = 5'b00000;
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0100;
        dmem_we = 1'b0;

    end

    else if(inst[31:26] == 6'b011_010)begin//bltu rj,rd,offs----------bltu : 31
        //alu_op = 5'b11111;//31
        alu_op = 5'b00000;
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0101;
        dmem_we = 1'b0;
        
    end

    else if(inst[31:26] == 6'b011_011)begin//bgeu rj,rd,offs----------bgeu : 31
        //alu_op = 5'b11111;//31
        alu_op = 5'b00000;
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0110;
        dmem_we = 1'b0;
        
    end
    else if(inst[31:26] == 6'b010_011)begin//jirl rd,rj,offs----------jirl : 26
        //alu_op = 5'b11010;//26
        alu_op = 5'b00000;
        imm = {{14{inst[25]}},inst[25:10],2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b1;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b00;
        br_type = 4'b0111;
        dmem_we = 1'b0;

        
    end


    else if(inst[31:26] == 6'b010_100)begin//b offs----------b : 27
        //alu_op = 5'b11011;//27
        alu_op = 5'b00000;
        imm = {{4{inst[25]}},{inst[9:0]},{inst[25:10]},2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = inst[4 : 0];           //wa  = rd
        rf_we  = 1'b0;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b1000;
        dmem_we = 1'b0;

    end

    else if(inst[31:26] == 6'b010_101)begin//bl offs----------bl : 28
        //alu_op = 5'b11100;//28
        alu_op = 5'b00000;
        imm = {{4{inst[25]}},{inst[9:0]},{inst[25:10]},2'b0};//offset
        rf_ra0 = inst[9 : 5];           //ra0 = rj
        rf_ra1 = inst[4 : 0];           //ra1 = rd

        rf_wa  = 5'b00001;           //wa  = rd
        rf_we  = 1'b1;
        alu_src0_sel = 1'b0;
        alu_src1_sel = 1'b1;

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b00;
        br_type = 4'b1001;
        dmem_we = 1'b0;
        
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

        dmem_access = 4'b0000;
        rf_wd_sel = 2'b11;
        br_type = 4'b0000;
        dmem_we = 1'b0;
    end
end
endmodule