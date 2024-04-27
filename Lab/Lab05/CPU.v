//`include "./include/config.v"

`define HALT_INST 32'H80000000

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

    input                   [ 4 : 0]            debug_reg_ra,   // TODO
    output                  [31 : 0]            debug_reg_rd    // TODO
);

wire    [31 : 0]    cur_pc,cur_npc,cur_inst;
wire    [ 31: 0]    next_npc;
wire    [ 3 : 0]    br_type,dmem_access;

//add4 模块
assign cur_npc = cur_pc + 32'h4;

wire    [ 1 : 0]    npc_sel;
//PC instantiation
PC my_pc (
    .clk    (clk        ),
    .rst    (rst        ),
    .en     (global_en  ),    // 当 global_en 为高电平时，PC 才会更新，CPU 才会执行指令。
    .npc    (next_npc   ),
    .pc     (cur_pc     )
);

wire    [ 31 : 0]   alu_res;
wire    [ 31 : 0]   npc_ex;//这个我暂时没有存到段间寄存器中，请注意
wire    [  0 : 0]   flush;





//临时放这里，懒得调了
wire    [  4 : 0]    rf_ra0_if      , rf_ra0_id, rf_ra0_ex, rf_ra0_mem, rf_ra0_wb;
wire    [  4 : 0]    rf_ra1_if      , rf_ra1_id, rf_ra1_ex, rf_ra1_mem, rf_ra1_wb;
wire    [  3 : 0]    br_type_if     , br_type_id, br_type_ex, br_type_mem, br_type_wb;
wire    [  3 : 0]    dmem_access_if , dmem_access_id, dmem_access_ex, dmem_access_mem, dmem_access_wb;
wire    [  0 : 0]    alu_src0_sel_if, alu_src0_sel_id, alu_src0_sel_ex, alu_src0_sel_mem, alu_src0_sel_wb;
wire    [  0 : 0]    alu_src1_sel_if, alu_src1_sel_id, alu_src1_sel_ex, alu_src1_sel_mem, alu_src1_sel_wb;
wire    [ 31 : 0]    rf_wd_if, rf_wd_id, rf_wd_ex, rf_wd_mem, rf_wd_wb;
wire    [  1 : 0]    rf_wd_sel_if   , rf_wd_sel_id, rf_wd_sel_ex, rf_wd_sel_mem, rf_wd_sel_wb;
wire    [ 31 : 0]    alu_res_ex     ,pcadd4_ex,pc_ex,inst_ex,rf_rd0_ex,rf_rd1_ex,imm_ex;

wire    [  4 : 0]    alu_op_if, alu_op_id, alu_op_ex, alu_op_mem, alu_op_wb;
wire    [  1 : 0]    npc_sel_if, npc_sel_id, npc_sel_ex, npc_sel_mem, npc_sel_wb;
wire    [ 31 : 0]    alu_src0_if, alu_src0_id, alu_src0_ex, alu_src0_mem, alu_src0_wb;
wire    [ 31 : 0]    alu_src1_if, alu_src1_id, alu_src1_ex, alu_src1_mem, alu_src1_wb;


NPC_MUX npc_m(
    .pc_add4(cur_npc),
    .pc_offset(alu_res_ex),
    .npc_sel(npc_sel_ex),
    .flush(flush),
    .npc(npc_ex)
);

assign next_npc = npc_ex;

//与取指令有关
assign imem_raddr = cur_pc;

//第一个段间寄存器

wire    [  0 : 0]   commit_if;
wire    [ 31 : 0]   pcadd4_if, pc_if, inst_if, rf_rd0_if, rf_rd1_if, imm_if, alu_res_if, dmem_rd_out_if;
wire    [  4 : 0]   rf_wa_if;
wire    [  0 : 0]   rf_we_if, dmem_we_if;

wire    [  0 : 0]   commit_id;
wire    [ 31 : 0]   pcadd4_id, pc_id, inst_id, rf_rd0_id, rf_rd1_id, imm_id, alu_res_id, dmem_rd_out_id;
wire    [  4 : 0]   rf_wa_id;
wire    [  0 : 0]   rf_we_id, dmem_we_id;


assign pcadd4_if = cur_npc  ;
assign pc_if     = cur_pc   ;
assign inst_if   = imem_rdata;

Inter_stage_Regs IF_ID(
    //common port
    .clk(clk),
    .rst(rst),
    .en(global_en),
    .flush(flush),
    .commit(commit_if),

    //generated from IF/ID
    .pcadd4(pcadd4_if),
    .pc(pc_if),
    .inst(inst_if),

    //generated from ID/EX
    .rf_rd0(32'b0),
    .rf_rd1(32'b0), //yet in EX/MEM
    .imm(32'b0),
    .rf_wa(5'b0), //
    .rf_we(1'b0),
    .dmem_we(1'b0),

    .rf_ra0(5'b0),
    .rf_ra1(5'b0),
    .br_type(4'b0),
    .dmem_access(4'b0),
    .alu_src0_sel(1'b0),
    .alu_src1_sel(1'b0),

    //generated from EX/MEM
    .alu_res(32'b0),
    .alu_op(5'b0),
    .rf_wd_sel(2'b0),
    .npc_sel(2'b0),
    .alu_src0(32'b0),
    .alu_src1(32'b0),

    //generated from MEM/WB
    .dmem_rd_out(32'b0),
    .rf_wd(32'b0),


//输出部分
    //output port
    .commit_out(commit_id),
    //IF/ID needed
    .pcadd4_out(pcadd4_id),
    .pc_out(pc_id),
    .inst_out(inst_id),

    //ID/EX needed
    .rf_rd0_out(),
    .rf_rd1_out(),
    .imm_out(),
    .rf_wa_out(),
    .rf_we_out(),
    .dmem_we_out(),

    .rf_ra0_out(),
    .rf_ra1_out(),
    .br_type_out(),
    .dmem_access_out(),
    .alu_src0_sel_out(),
    .alu_src1_sel_out(),

    //EX/MEM needed
    .alu_res_out(),
    .dmem_addr_out(),

    .alu_op_out(),
    .rf_wd_sel_out(),
    .npc_sel_out(),
    .alu_src0_out(),
    .alu_src1_out(),

    //MEM/WB needed
    .dmem_rd_out_out(),
    .rf_wd_out()

);

wire    [ 4 : 0]    alu_op;
wire    [ 31: 0]    imm;
wire    [ 4 : 0]    rf_ra0;
wire    [ 4 : 0]    rf_ra1;
wire    [ 4 : 0]    rf_wa;
wire    [ 0 : 0]    rf_we;
wire    [ 31: 0]    rf_wd;
wire    [ 0 : 0]    alu_src0_sel;
wire    [ 0 : 0]    alu_src1_sel;

wire    [ 31: 0]    rf_rd0,rf_rd1;

wire    [ 31: 0]    alu_src0,alu_src1;



wire    [ 31: 0]    dmem_rd_out,dmem_rd_in,dmem_wd_in,dmem_wd_out;

//assign rf_wd = alu_res;
wire    [ 1 : 0]    rf_wd_sel;
wire    [ 31: 0]    dmem_wa,dmem_wd;

assign dmem_wd = dmem_wd_out;

DECODE deco(
    .inst(inst_id),
    .alu_op(alu_op_id),
    .dmem_access(dmem_access_id),
    .imm(imm_id),
    .rf_ra0(rf_ra0_id),
    .rf_ra1(rf_ra1_id),
    .rf_wa(rf_wa_id),
    .rf_we(rf_we_id),
    .alu_src0_sel(alu_src0_sel_id),
    .alu_src1_sel(alu_src1_sel_id),
    .rf_wd_sel(rf_wd_sel_id),
    .br_type(br_type_id),
    .dmem_we(dmem_we_id)
);

assign cur_inst = imem_rdata;

wire    [  0 : 0]   rf_we_wb            ;
wire    [  4 : 0]   rf_wa_wb            ;

REG_FILE reg_f(
    .clk(clk),
    .rf_ra0(rf_ra0_id),
    .rf_ra1(rf_ra1_id),
    .rf_wa(rf_wa_id),//有一些特殊处理，可能会有错不过没关系。
    .rf_we(rf_we_id),//
    .rf_wd(rf_wd_wb),//
    .rf_rd0(rf_rd0_id),
    .rf_rd1(rf_rd1_id),
    .dbg_reg_ra(debug_reg_ra),
    .dbg_reg_rd(debug_reg_rd)
);

wire    [  0 : 0]   commit_mem, commit_ex;
wire    [ 31 : 0]   pcadd4_mem, pc_mem, inst_mem, rf_rd0_mem, rf_rd1_mem, imm_mem, alu_res_mem, dmem_rd_out_mem;
wire    [  4 : 0]   rf_wa_mem, rf_wa_ex;
wire    [  0 : 0]   rf_we_mem, rf_we_ex, dmem_we_mem, dmem_we_ex;
wire    [ 31 : 0]   dmem_addr_ex, dmem_addr_mem,dmem_rdata_mem;


assign imm_id = imm;

assign rf_ra0_id = rf_ra0;
assign rf_ra1_id = rf_ra1;
assign br_type_id = br_type;
assign dmem_access_id = dmem_access;
assign alu_src0_sel_id  = alu_src0_sel;
assign alu_src1_sel_id  = alu_src1_sel;

//assign rf_wa_id = rf_wa;
//assign rf_we_id = rf_we;
//assign dmem_we_id = dmem_we;

assign alu_res_ex = alu_res;

//第二个段间寄存器
Inter_stage_Regs ID_EX(
    //common port
    .clk(clk),
    .rst(rst),
    .en(global_en),
    .flush(flush),
    .commit(commit_id),

    //generated from IF/ID
    .pcadd4(pcadd4_id),
    .pc(pc_id),
    .inst(inst_id),

    //generated from ID/EX
    .rf_rd0(rf_rd0_id),
    .rf_rd1(rf_rd1_id), //yet in EX/MEM
    .imm(imm_id),
    .rf_wa(rf_wa_id), //
    .rf_we(rf_we_id),
    .dmem_we(dmem_we_id),

    .rf_ra0(rf_ra0_id),
    .rf_ra1(rf_ra1_id),
    .br_type(br_type_id),
    .dmem_access(dmem_access_id),
    .alu_src0_sel(alu_src0_sel_id),
    .alu_src1_sel(alu_src1_sel_id),

    //generated from EX/MEM
    .alu_res(32'b0),
    .alu_op(alu_op_id),
    .rf_wd_sel(rf_wd_sel_id),
    .npc_sel(2'b0),
    .alu_src0(32'b0),
    .alu_src1(32'b0),

    //generated from MEM/WB
    .dmem_rd_out(32'b0),
    .rf_wd(32'b0),

    //output port

    .commit_out(commit_ex),
    //IF/ID needed
    .pcadd4_out(pcadd4_ex),
    .pc_out(pc_ex),
    .inst_out(inst_ex),

    //ID/EX needed
    .rf_rd0_out(rf_rd0_ex),
    .rf_rd1_out(rf_rd1_ex),
    .imm_out(imm_ex),
    .rf_wa_out(rf_wa_ex),
    .rf_we_out(rf_we_ex),
    .dmem_we_out(dmem_we_ex),

    .rf_ra0_out(rf_ra0_ex),
    .rf_ra1_out(rf_ra1_ex),
    .br_type_out(br_type_ex),
    .dmem_access_out(dmem_access_ex),
    .alu_src0_sel_out(alu_src0_sel_ex),
    .alu_src1_sel_out(alu_src1_sel_ex),

    .alu_op_out(alu_op_ex),
    .rf_wd_sel_out(rf_wd_sel_ex),
    .npc_sel_out(),
    .alu_src0_out(),
    .alu_src1_out(),

    //EX/MEM needed
    .alu_res_out(),
    .dmem_addr_out(),

    //MEM/WB needed
    .dmem_rd_out_out(),
    .rf_wd_out()

);

BRANCH bra(
    .br_type(br_type_ex),
    .br_src0(rf_rd0_ex),
    .br_src1(rf_rd1_ex),
    .npc_sel(npc_sel_ex)
);

//源操作数0
MUX #(.WIDTH(32)) mux0 (//res = sel ? src1 : src0;
    .src0(pc_ex),
    .src1(rf_rd0_ex),
    .sel(alu_src0_sel_ex),
    .res(alu_src0_ex)//
);

//源操作数1
MUX #(.WIDTH(32)) mux1 (//res = sel ? src1 : src0;
    .src0(rf_rd1_ex),
    .src1(imm_ex),
    .sel(alu_src1_sel_ex),
    .res(alu_src1_ex)//
);

ALU alu(
    .alu_src0(alu_src0_ex),
    .alu_src1(alu_src1_ex),
    .alu_op(alu_op_ex),
    .alu_res(alu_res_ex)
);


//第三个段间寄存器

//这条还没改，一会记得改。?应该已经改过了泪目
assign dmem_wd_in = rf_rd1_mem;
assign dmem_rdata_mem = dmem_rdata;


Inter_stage_Regs EX_MEM (
    //common port
    .clk(clk),
    .rst(rst),
    .en(global_en),
    .flush(1'b0),
    .commit(commit_ex),

    //generated from IF/ID
    .pcadd4(pcadd4_ex),
    .pc(pc_ex),
    .inst(inst_ex),

    //generated from ID/EX
    .rf_rd0(rf_rd0_ex),
    .rf_rd1(rf_rd1_ex), //yet in EX/MEM
    .imm(imm_ex),
    .rf_wa(rf_wa_ex), //
    .rf_we(rf_we_ex),
    .dmem_we(dmem_we_ex),

    .rf_ra0(rf_ra0_ex),
    .rf_ra1(rf_ra1_ex),
    .br_type(br_type_ex),
    .dmem_access(dmem_access_ex),
    .alu_src0_sel(alu_src0_sel_ex),
    .alu_src1_sel(alu_src1_sel_ex),
    
    //generated from EX/MEM
    .alu_res(alu_res_ex),
    .alu_op(alu_op_ex),
    .rf_wd_sel(rf_wd_sel_ex),
    .npc_sel(npc_sel_ex),
    .alu_src0(alu_src0_ex),
    .alu_src1(alu_src1_ex),
    
    //generated from MEM/WB
    .dmem_rd_out(32'b0),
    .rf_wd(32'b0),

    //output port
    .commit_out(commit_mem),
    //IF/ID needed
    .pcadd4_out(pcadd4_mem),
    .pc_out(pc_mem),
    .inst_out(inst_mem),
    
    //ID/EX needed
    .rf_rd0_out(rf_rd0_mem),
    .rf_rd1_out(rf_rd1_mem),
    .imm_out(imm_mem),
    .rf_wa_out(rf_wa_mem),
    .rf_we_out(rf_we_mem),
    .dmem_we_out(dmem_we_mem),

    .rf_ra0_out(rf_ra0_mem),
    .rf_ra1_out(rf_ra1_mem),
    .br_type_out(br_type_mem),
    .dmem_access_out(dmem_access_mem),
    .alu_src0_sel_out(alu_src0_sel_mem),
    .alu_src1_sel_out(alu_src1_sel_mem),

    .alu_op_out(alu_op_mem),
    .rf_wd_sel_out(rf_wd_sel_mem),
    .npc_sel_out(npc_sel_mem),
    .alu_src0_out(alu_src0_mem),
    .alu_src1_out(alu_src1_mem),
    
    //EX/MEM needed
    .alu_res_out(alu_res_mem),
    .dmem_addr_out(),
    
    //MEM/WB needed
    .dmem_rd_out_out(),
    .rf_wd_out()
);


//第四个段间寄存器

// 这里的信号都是 MEM/WB 段间寄存器的输出
wire    [  0 : 0]   commit_wb           ;
wire    [ 31 : 0]   pcadd4_wb           ;
wire    [ 31 : 0]   pc_wb               ;
wire    [ 31 : 0]   inst_wb             ;

wire    [  0 : 0]   dmem_we_wb          ;
wire    [ 31 : 0]   dmem_addr_wb        ;
wire    [ 31 : 0]   dmem_wdata_wb       ;
wire    [ 31 : 0]   alu_res_wb          ;//dmen_addr
wire    [ 31 : 0]   dmem_rd_out_wb      ;//dmem_wd_in
wire    [ 31 : 0]   rf_rd0_wb           ;
wire    [ 31 : 0]   rf_rd1_wb           ;
wire    [ 31 : 0]   imm_wb              ;

assign dmem_wd_in = rf_rd1_mem;

assign dmem_rd_in = dmem_rdata;
assign dmem_wdata = dmem_wd_out;

assign dmem_addr  = alu_res_mem;
assign dmem_rd_out_mem = dmem_rd_out;

SLU slu(
    .addr(dmem_addr),
    .dmem_access(dmem_access_mem),
    .rd_in(dmem_rdata_mem),
    .wd_in(dmem_wd_in),
    .rd_out(dmem_rd_out),
    .wd_out(dmem_wd_out),
    .dmem_wa(dmem_wa)
);

Inter_stage_Regs MEM_WB (
    //common port
    .clk(clk),
    .rst(rst),
    .en(global_en),
    .flush(1'b0),
    .commit(commit_mem),

    //generated from IF/ID
    .pcadd4(pcadd4_mem),
    .pc(pc_mem),
    .inst(inst_mem),

    //generated from ID/EX
    .rf_rd0(rf_rd0_mem),
    .rf_rd1(rf_rd1_mem), //yet in EX/MEM
    .imm(imm_mem),
    .rf_wa(rf_wa_mem), //
    .rf_we(rf_we_mem),
    .dmem_we(dmem_we_mem),

    .rf_ra0(rf_ra0_mem),
    .rf_ra1(rf_ra1_mem),
    .br_type(br_type_mem),
    .dmem_access(dmem_access_mem),
    //.rf_wd_sel(rf_wd_mem),
    .alu_src0_sel(alu_src0_sel_mem),
    .alu_src1_sel(alu_src1_sel_mem),

    
    //generated from EX/MEM
    .alu_res(alu_res_mem),
    .alu_op(alu_op_mem),
    .rf_wd_sel(rf_wd_sel_mem),
    .npc_sel(npc_sel_mem),
    .alu_src0(alu_src0_mem),
    .alu_src1(alu_src1_mem),
    
    //generated from MEM/WB
    .dmem_rd_out(dmem_rd_out_mem),
    .rf_wd(32'b0),

    //output port
    .commit_out(commit_wb),
    //IF/ID needed
    .pcadd4_out(pcadd4_wb),
    .pc_out(pc_wb),
    .inst_out(inst_wb),
    
    //ID/EX needed
    .rf_rd0_out(rf_rd0_wb),
    .rf_rd1_out(rf_rd1_wb),
    .imm_out(imm_wb),
    .rf_wa_out(rf_wa_wb),
    .rf_we_out(rf_we_wb),
    .dmem_we_out(dmem_we_wb),

    .rf_ra0_out(rf_ra0_wb),
    .rf_ra1_out(rf_ra1_wb),
    .br_type_out(br_type_wb),
    .dmem_access_out(dmem_access_wb),
    .alu_src0_sel_out(alu_src0_sel_wb),
    .alu_src1_sel_out(alu_src1_sel_wb),

    .alu_op_out(alu_op_wb),
    .rf_wd_sel_out(rf_wd_sel_wb),
    .npc_sel_out(npc_sel_wb),
    .alu_src0_out(alu_src0_wb),
    .alu_src1_out(alu_src1_wb),
    
    //EX/MEM needed
    .alu_res_out(alu_res_wb),
    .dmem_addr_out(),
    
    //MEM/WB needed
    .dmem_rd_out_out(dmem_rd_out_wb),
    .rf_wd_out()
);


MUX2 #(.WIDTH(32)) mux_pc (
    .src0(pcadd4_wb),
    .src1(alu_res_wb),
    .src2(dmem_rd_out_wb),
    .src3(32'b0),
    .sel(rf_wd_sel_wb),
    .res(rf_wd)
);

assign rf_wd_wb = rf_wd;

    // Commit
    reg  [  0 : 0]   commit_reg          ;
    reg  [ 31 : 0]   commit_pc_reg       ;
    reg  [ 31 : 0]   commit_inst_reg     ;
    reg  [  0 : 0]   commit_halt_reg     ;
    reg  [  0 : 0]   commit_reg_we_reg   ;
    reg  [  4 : 0]   commit_reg_wa_reg   ;
    reg  [ 31 : 0]   commit_reg_wd_reg   ;
    reg  [  0 : 0]   commit_dmem_we_reg  ;
    reg  [ 31 : 0]   commit_dmem_wa_reg  ;
    reg  [ 31 : 0]   commit_dmem_wd_reg  ;

    

    // Commit
assign commit_if = 1'H1;    // 这个信号需要经过 IF/ID、ID/EX、EX/MEM、MEM/WB 段间寄存器，最终连接到 commit_reg 上

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
        // 这里右侧的信号都是 MEM/WB 段间寄存器的输出
        commit_reg          <= commit_wb;
        commit_pc_reg       <= pc_wb;
        commit_inst_reg     <= inst_wb;
        commit_halt_reg     <= inst_wb == `HALT_INST;
        commit_reg_we_reg   <= rf_we_wb;
        commit_reg_wa_reg   <= rf_wa_wb;
        commit_reg_wd_reg   <= rf_wd_wb;//ok
        commit_dmem_we_reg  <= dmem_we_wb;
        commit_dmem_wa_reg  <= dmem_addr_wb;
        commit_dmem_wd_reg  <= dmem_wdata_wb;
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
