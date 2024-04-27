module CPU (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [ 0 : 0]            global_en,

/* ------------------------------ Memory (inst) ----------------------------- */
    output                  [31 : 0]            imem_raddr,
    input                   [31 : 0]            imem_rdata,

/* ------------------------------ Memory (data) ----------------------------- */
    input                   [31 : 0]            dmem_rdata,
    output                  [ 0 : 0]            dmem_we,
    output                  [31 : 0]            dmem_addr,
    output                  [31 : 0]            dmem_wdata,

/* ---------------------------------- Debug --------------------------------- */
    output                  [ 0 : 0]            commit,
    output                  [31 : 0]            commit_pc,
    output                  [31 : 0]            commit_inst,
    output                  [ 0 : 0]            commit_halt,
    output                  [ 0 : 0]            commit_reg_we,
    output                  [ 4 : 0]            commit_reg_wa,
    output                  [31 : 0]            commit_reg_wd,
    output                  [ 0 : 0]            commit_dmem_we,
    output                  [31 : 0]            commit_dmem_wa,
    output                  [31 : 0]            commit_dmem_wd,

    input                   [ 4 : 0]            debug_reg_ra,
    output                  [31 : 0]            debug_reg_rd
);
// ......
`define     HALT_INST       32'h80000000 

wire [ 31 : 0]   alu_src0_ex;
wire [ 31 : 0]   alu_src1_ex;
wire [ 31 : 0]   alu_res_ex;
wire [ 4 : 0]   alu_op_id;
wire [ 4 : 0]   alu_op_ex;
wire [ 27: 0]   alu_temp;
wire [ 0 : 0]   src0_en;
wire [ 0 : 0]   src1_en;
wire [ 0 : 0]   res_en;
wire [ 0 : 0]   op_en;
wire [ 31 : 0]  imm_ex;
wire [ 31 : 0]  rf_rd0_ex;
wire [ 31 : 0]  rf_rd1_ex;
wire [ 31 : 0]  rf_rd0_id;
wire [ 31 : 0]  rf_rd1_id;
wire [ 31 : 0]  rf_rd1_mem;
wire [ 4 : 0]   rf_ra0_id;
wire [ 4 : 0]   rf_ra1_id;
wire [ 0 : 0]   alu_src0_sel_id;
wire [ 0 : 0]   alu_src1_sel_id;
wire [ 0 : 0]   alu_src0_sel_ex;
wire [ 0 : 0]   alu_src1_sel_ex;
wire [ 4 : 0]   rf_wa;
wire [ 0 : 0]   rf_we;
wire [31 : 0]   npc_ex;
wire [31 : 0]   pc_if;
wire [31 : 0]   cur_inst;
wire [31 : 0]   rf_wd;
wire [3:0]      dmem_access_id;
wire [3:0]      dmem_access_ex;
wire [3:0]      dmem_access_mem;
wire [1:0]      rf_wd_sel_id;
wire [1:0]      rf_wd_sel_ex;
wire [1:0]      rf_wd_sel_mem;
wire [1:0]      rf_wd_sel_wb;
wire [3:0]      br_type_id;
wire [3:0]      br_type_ex;
wire [31:0]     dmem_rd_in;
wire [31:0]     dmem_rd_out_mem;
wire [31:0]     dmem_rd_out_wb;
wire [31:0]     dmem_wd_out;
wire [31:0]     dmem_wd_in;
wire [31:0]     pc_offset;
wire [31:0]     pc_j;
wire [1:0]      npc_sel_ex;
wire [31 : 0]   dmem_wa;
wire [31 : 0]   dmem_wd;
wire [31 : 0]   pc_add4;
wire [0:0]      dmem_we_mem;
wire [0:0]      dmem_we_wb;
wire [0:0]  flush;
wire [0:0]  commit_if;
wire [0:0]  commit_id;
wire [0:0]  commit_ex;
wire [0:0]  commit_mem;
wire [0:0]  commit_wb;
wire [4:0] rf_wa_id;
wire [4:0] rf_wa_ex;
wire [4:0] rf_wa_mem;
wire [4:0] rf_wa_wb;
wire [31:0] rf_wd_wb;
wire [0:0]  rf_we_id;
wire [0:0]  rf_we_ex;
wire [0:0]  rf_we_mem;
wire [0:0]  rf_we_wb;
wire [31:0] imm_id;

wire [31:0] inst_if;
wire [31:0] alu_res_mem;
wire [31:0] pcadd4_if;
wire [31:0] pcadd4_id;
wire [31:0] pcadd4_ex;
wire [31:0] pcadd4_mem;
wire [31:0] pcadd4_wb;
wire [31:0] pc_id;
wire [31:0] pc_ex;
wire [31:0] pc_mem;
wire [31:0] pc_wb;
wire [31:0] alu_res_wb;
wire [31:0] inst_wb;
wire [31:0] inst_mem;
wire [31:0] inst_ex;
wire [31:0] inst_id;

MUX1 mux0(
    .src0(rf_rd0_ex),
    .src1(pc_ex),
    .sel(alu_src0_sel_ex),
    .res(alu_src0_ex)
);

MUX1 mux1(
    .src0(rf_rd1_ex),
    .src1(imm_ex),
    .sel(alu_src1_sel_ex),
    .res(alu_src1_ex)
);
REG_FILE register(
    .clk(clk),
    .rf_ra0(rf_ra0_id),
    .rf_ra1(rf_ra1_id),
    .rf_wa(rf_wa_wb),
    .rf_we(rf_we_wb),
    .rf_wd(rf_wd_wb),
    .rf_rd0(rf_rd0_id),
    .rf_rd1(rf_rd1_id),
    .debug_reg_ra(debug_reg_ra),
    .debug_reg(debug_reg_rd)
);

ALU ALU(
    .alu_src0(alu_src0_ex),
    .alu_src1(alu_src1_ex),
    .alu_op(alu_op_ex),
    .alu_res(alu_res_ex)
);

assign pcadd4_if = pc_if + 4;
assign inst_if = imem_rdata;
assign imem_raddr = pc_if;

DECODE decoder(
.inst(inst_id),
.alu_op(alu_op_id),
.imm(imm_id),
.rf_ra0(rf_ra0_id),
.rf_ra1(rf_ra1_id),
.rf_wa(rf_wa_id),
.rf_we(rf_we_id),
.alu_src0_sel(alu_src0_sel_id),
.alu_src1_sel(alu_src1_sel_id),
.dmem_access(dmem_access_id),
.rf_wd_sel(rf_wd_sel_id),
.br_type(br_type_id)
);  

PC my_pc (
    .clk    (clk        ),
    .rst    (rst        ),
    .en     (global_en  ),    // 当 global_en 为高电平时，PC 才会更新，CPU 才会执行指令。
    .npc    (npc_ex     ),
    .pc     (pc_if     )
);

BRANCH my_br(
    .br_type(br_type_ex),
    .br_src0(rf_rd0_ex),
    .br_src1(rf_rd1_ex),
    .npc_sel(npc_sel_ex),
    .flush (flush)
);

assign pc_j = pc_offset;
assign pc_offset = alu_res_ex;
NPCMUX my_npc (
    .pc_add4(pcadd4_if),
    .pc_offset(pc_offset),
    .pc_j(pc_j),
    .npc_sel(npc_sel_ex),
    .npc(npc_ex)
);

MUX2 MUX2(
    .src0(pcadd4_wb), 
    .src1(alu_res_wb), 
    .src2(dmem_rd_out_wb), 
    .src3(32'b0),
    .sel(rf_wd_sel_wb),
    .res(rf_wd_wb)
);
wire [31:0]     dmem_wdata_mem;
assign dmem_addr = alu_res_mem;
assign dmem_wd_in = rf_rd1_mem;
assign dmem_rd_in = dmem_rdata;
assign dmem_wdata_mem = dmem_wd_out;
assign dmem_wdata = dmem_wd_out;
assign dmem_wd = dmem_wd_out;
assign dmem_we = dmem_we_mem;
SLU  slu(
    .addr(dmem_addr),
    .dmem_access(dmem_access_mem),
    .rd_in(dmem_rd_in),
    .wd_in(dmem_wd_in),
    .rd_out(dmem_rd_out_mem),
    .wd_out(dmem_wd_out),
    .dmem_we(dmem_we_mem),
    .dmem_wa(dmem_wa)
);
wire [31:0]     dmem_addr_wb;
wire [31:0]     dmem_wdata_wb;

IFID IFID(
    .clk(clk),          
    .rst(rst),         
    .en(global_en),            
    .flush(flush),       
    .in1(pc_if),
    .in2(inst_if),
    .in3(pcadd4_if),   
    .commit_if(commit_if),
    .out1(pc_id),
    .out2(inst_id),
    .out3(pcadd4_id),
    .commit_id(commit_id)
);

IDEX IDEX(
    .clk(clk),          // 时钟信号
    .rst(rst),          // 同步清零信号
    .en(global_en),           // 使能信号
    .flush(flush),        // 清空信号
    .in1(pcadd4_id),
    .in2(pc_id),
    .in3(rf_rd0_id), 
    .in4(rf_rd1_id),   // 输入数据
    .in5(imm_id),
    .in6(rf_wa_id),
    .in7(rf_we_id),
    .in8(alu_src0_sel_id),
    .in9(alu_src1_sel_id),
    .in10(alu_op_id),
    .in11(br_type_id),
    .in12(dmem_access_id),
    .in13(rf_wd_sel_id),
    .inst_id(inst_id),
    .commit_id(commit_id),
    .out1(pcadd4_ex),
    .out2(pc_ex),
    .out3(rf_rd0_ex),
    .out4(rf_rd1_ex), // 输出数据
    .out5(imm_ex),
    .out6(rf_wa_ex),
    .out7(rf_we_ex),
    .out8(alu_src0_sel_ex),
    .out9(alu_src1_sel_ex),
    .out10(alu_op_ex),
    .out11(br_type_ex),
    .out12(dmem_access_ex),
    .out13(rf_wd_sel_ex),
    .commit_ex(commit_ex),
    .inst_ex(inst_ex)
);

EXMEM EXMEM(
    .clk(clk),          // 时钟信号
    .rst(rst),          // 同步清零信号
    .en(global_en),           // 使能信号
    .flush(),        // 清空信号
    .in1(pcadd4_ex),
    .in2(alu_res_ex),
    .in3(rf_rd1_ex), 
    .in4(pc_ex),  
    .in5(0),
    .in6(rf_wa_ex),//5
    .in7(rf_we_ex),//1
    .in8(0),//1
    .in9(0),//1
    .in10(0),//5
    .in11(0),//4
    .in12(dmem_access_ex),//4
    .in13(rf_wd_sel_ex),
    .inst_ex(inst_ex),
    .commit_ex(commit_ex),
    .out1(pcadd4_mem),
    .out2(alu_res_mem),
    .out3(rf_rd1_mem),
    .out4(pc_mem),
    .out5(),
    .out6(rf_wa_mem),//5
    .out7(rf_we_mem),//1
    .out8(),//1
    .out9(),//1
    .out10(),//5
    .out11(),//4
    .out12(dmem_access_mem),//4
    .out13(rf_wd_sel_mem),
    .commit_mem(commit_mem),
    .inst_mem(inst_mem)
);

MEMWB MEMWB(
    .clk(clk),          // 时钟信号
    .rst(rst),          // 同步清零信号
    .en(global_en),           // 使能信号
    .flush(),        // 清空信号
    .in1(pcadd4_mem),
    .in2(alu_res_mem),
    .in3(dmem_rd_out_mem), 
    .in4(dmem_addr),  
    .in5(dmem_wdata_mem),
    .in6(rf_wa_mem),//5
    .in7(rf_we_mem),//1
    .in8(dmem_we_mem),//1
    .in9(0),//1
    .in10(0),//5
    .in11(0),//4
    .in12(0),//4
    .in13(rf_wd_sel_mem),
    .commit_mem(commit_mem),
    .inst_mem(inst_mem),
    .pc_mem(pc_mem),
    .out1(pcadd4_wb),
    .out2(alu_res_wb),
    .out3(dmem_rd_out_wb),
    .out4(dmem_addr_wb),
    .out5(dmem_wdata_wb),
    .out6(rf_wa_wb),//5
    .out7(rf_we_wb),//1
    .out8(dmem_we_wb),//1
    .out9(),//1
    .out10(),//5
    .out11(),//4
    .out12(),//4
    .out13(rf_wd_sel_wb),
    .commit_wb(commit_wb),
    .inst_wb(inst_wb),
    .pc_wb(pc_wb)
);


assign commit_if = 1'H1;    // 这个信号需要经过 IF/ID、ID/EX、EX/MEM、MEM/WB 段间寄存器，最终连接到 commit_reg 上

reg  [ 0 : 0]   commit_reg          ;
reg  [31 : 0]   commit_pc_reg       ;
reg  [31 : 0]   commit_inst_reg     ;
reg  [ 0 : 0]   commit_halt_reg     ;
reg  [ 0 : 0]   commit_reg_we_reg   ;
reg  [ 4 : 0]   commit_reg_wa_reg   ;
reg  [31 : 0]   commit_reg_wd_reg   ;
reg  [ 0 : 0]   commit_dmem_we_reg  ;
reg  [31 : 0]   commit_dmem_wa_reg  ;
reg  [31 : 0]   commit_dmem_wd_reg  ;

always @(posedge clk) begin
    if (rst) begin
        commit_reg          <= 1'H0;
        commit_pc_reg       <= 32'H0;
        commit_inst_reg     <= 32'H0;
        commit_halt_reg     <= 1'H0;
        commit_reg_we_reg   <= 1'H0;
        commit_reg_wa_reg   <= 5'H0;
        commit_reg_wd_reg   <= 32'H0;
        commit_dmem_we_reg  <= 1'H0;
        commit_dmem_wa_reg  <= 32'H0;
        commit_dmem_wd_reg  <= 32'H0;
    end
    else if (global_en) begin
        // !!!! 请注意根据自己的具体实现替换 <= 右侧的信号 !!!!
        commit_reg          <= commit_wb;                        // 不需要改动
        commit_pc_reg       <= pc_wb;                      // 需要为当前的 PC
        commit_inst_reg     <= inst_wb;                    // 需要为当前的指令
        commit_halt_reg     <= inst_wb == `HALT_INST;      // 注意！请根据指令集设置 HALT_INST！
        commit_reg_we_reg   <= rf_we_wb;                       // 需要为当前的寄存器堆写使能
        commit_reg_wa_reg   <= rf_wa_wb;                       // 需要为当前的寄存器堆写地址
        commit_reg_wd_reg   <= rf_wd_wb;                       // 需要为当前的寄存器堆写数据
        commit_dmem_we_reg  <= dmem_we_mem;                     // 不需要改动
        commit_dmem_wa_reg  <= dmem_addr;                  // 不需要改动
        commit_dmem_wd_reg  <= dmem_wdata_mem;                     // 不需要改动
    end
end

assign commit               = commit_reg;
assign commit_pc            = commit_pc_reg;
assign commit_inst          = commit_inst_reg;
assign commit_halt          = commit_halt_reg;
assign commit_reg_we        = commit_reg_we_reg;
assign commit_reg_wa        = commit_reg_wa_reg;
assign commit_reg_wd        = commit_reg_wd_reg;
assign commit_dmem_we       = commit_dmem_we_reg;
assign commit_dmem_wa       = commit_dmem_wa_reg;
assign commit_dmem_wd       = commit_dmem_wd_reg;


endmodule
