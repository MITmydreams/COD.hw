module  Inter_stage_Regs(
    //common port
    input       [  0 : 0]       clk     ,
    input       [  0 : 0]       rst     ,
    input       [  0 : 0]       en      ,
    input       [  0 : 0]       flush   ,
    input       [  0 : 0]       commit  ,//5

    //generated from IF/ID
    input       [ 31 : 0]       pcadd4  ,
    input       [ 31 : 0]       pc      ,
    input       [ 31 : 0]       inst    ,//3
    
    //generated from ID/EX
    input       [  4 : 0]       alu_op  ,
    input       [ 31 : 0]       rf_rd0  ,
    input       [ 31 : 0]       rf_rd1  ,//yet in EX/MEM
    input       [ 31 : 0]       imm     ,
    input       [  4 : 0]       rf_wa   ,//
    input       [  0 : 0]       rf_we   ,
    input       [  0 : 0]       dmem_we ,
    input       [  4 : 0]       rf_ra0  ,
    input       [  4 : 0]       rf_ra1  ,

    input       [  3 : 0]       br_type ,

    input       [  3 : 0]       dmem_access,
    input       [  1 : 0]       rf_wd_sel   ,
    input       [  0 : 0]       alu_src0_sel,
    input       [  0 : 0]       alu_src1_sel,//14           

    //generated from EX/MEM
    input       [ 31 : 0]       alu_res ,
    input       [  1 : 0]       npc_sel ,
    input       [ 31 : 0]       alu_src0,
    input       [ 31 : 0]       alu_src1,
    
    //generated from MEM/WB
    input       [ 31 : 0]       dmem_rd_out,
    input       [ 31 : 0]       rf_wd,//6
//28

    //output port
    output reg  [  0 : 0]       commit_out,
    //IF/ID needed

    output reg  [ 31 : 0]       pcadd4_out,
    output reg  [ 31 : 0]       pc_out,
    output reg  [ 31 : 0]       inst_out,//4

    //ID/EX needed
    output reg  [  4 : 0]       alu_op_out,
    output reg  [ 31 : 0]       rf_rd0_out,
    output reg  [ 31 : 0]       rf_rd1_out,
    output reg  [ 31 : 0]       imm_out,
    output reg  [  4 : 0]       rf_wa_out,
    output reg  [  0 : 0]       rf_we_out,
    output reg  [  0 : 0]       dmem_we_out,

    output reg  [  4 : 0]       rf_ra0_out,
    output reg  [  4 : 0]       rf_ra1_out,

    output reg  [  3 : 0]       br_type_out,

    output reg  [  3 : 0]       dmem_access_out,
    output reg  [  1 : 0]       rf_wd_sel_out,
    output reg  [  0 : 0]       alu_src0_sel_out,
    output reg  [  0 : 0]       alu_src1_sel_out,//14


    //EX/MEM needed
    output reg  [ 31 : 0]       alu_res_out,
    output reg  [  1 : 0]       npc_sel_out,
    output reg  [ 31 : 0]       alu_src0_out,
    output reg  [ 31 : 0]       alu_src1_out,
    output reg  [ 31 : 0]       dmem_addr_out,

    //MEM/WB needed
    output  reg [ 31 : 0]       dmem_rd_out_out,
    output  reg [ 31 : 0]       rf_wd_out//7

//25
);

wire        [  0 : 0 ]    t_commit;
wire        [ 31 : 0 ]    t_pcadd4;
wire        [ 31 : 0 ]    t_pc;
wire        [ 31 : 0 ]    t_inst;
wire        [ 31 : 0 ]    t_rf_rd0;
wire        [ 31 : 0 ]    t_rf_rd1;
wire        [ 31 : 0 ]    t_imm;
wire        [  4 : 0 ]    t_rf_wa;
wire        [  0 : 0 ]    t_rf_we;
wire        [  0 : 0 ]    t_dmem_we;
wire        [ 31 : 0 ]    t_alu_res;
wire        [ 31 : 0 ]    t_dmem_rd_out;

assign      t_commit      = commit;
assign      t_pcadd4      = pcadd4;
assign      t_pc          = pc;
assign      t_inst        = inst;
assign      t_rf_rd0      = rf_rd0;
assign      t_rf_rd1      = rf_rd1;
assign      t_imm         = imm;
assign      t_rf_wa       = rf_wa;
assign      t_rf_we       = rf_we;
assign      t_dmem_we     = dmem_we;
assign      t_alu_res     = alu_res;
assign      t_dmem_rd_out = dmem_rd_out;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        pcadd4_out      <= 32'b0;
        pc_out          <= 32'b0;
        inst_out        <= 32'b0;
        rf_rd0_out      <= 32'b0;
        rf_rd1_out      <= 32'b0;
        imm_out         <= 32'b0;
        rf_wa_out       <= 5'b0;
        rf_we_out       <= 1'b0;
        dmem_we_out     <= 1'b0;
        alu_res_out     <= 32'b0;
        dmem_addr_out   <= 32'b0;
        dmem_rd_out_out <= 32'b0;

        rf_ra0_out      <= 5'b0;
        rf_ra1_out      <= 5'b0;
        br_type_out     <= 4'b0;
        dmem_access_out <= 4'b0;
        alu_src0_sel_out <= 1'b0;
        alu_src1_sel_out <= 1'b0;

        alu_src0_out    <= 32'b0;
        alu_src1_out    <= 32'b0;
        rf_wd_sel_out   <= 2'b0;
        alu_op_out      <= 5'b0;
        npc_sel_out     <= 2'b0;

        rf_wd_out       <= 32'b0;
        commit_out      <= 1'b0;
    end
    else if (en) begin
        if (flush) begin
            pcadd4_out    <= t_pcadd4;
            pc_out        <= t_pc;
            inst_out      <= t_inst;
            rf_rd0_out    <= t_rf_rd0;
            rf_rd1_out    <= t_rf_rd1;
            imm_out       <= t_imm;
            rf_wa_out     <= t_rf_wa;
            rf_we_out     <= t_rf_we;
            dmem_we_out   <= t_dmem_we;
            alu_res_out   <= t_alu_res;
            dmem_addr_out <= t_alu_res; // 注意这里有待确认，是否应该是 t_dmem_addr
            dmem_rd_out_out <= t_dmem_rd_out;
            rf_ra0_out      <= rf_ra0;
            rf_ra1_out      <= rf_ra1;
            br_type_out     <= br_type;
            dmem_access_out <= dmem_access;
            alu_src0_sel_out <= alu_src0_sel;
            alu_src1_sel_out <= alu_src1_sel;

            alu_src0_out <= alu_src0;
            alu_src1_out <= alu_src1;
            rf_wd_sel_out <= rf_wd_sel;
            alu_op_out <= alu_op;
            npc_sel_out <= npc_sel;

            rf_wd_out       <= rf_wd;
            commit_out <= 1'b0; // 如果 flush 为 1，则 commit 为 0
        end
        else begin
            pcadd4_out    <= t_pcadd4;
            pc_out        <= t_pc;
            inst_out      <= t_inst;
            rf_rd0_out    <= t_rf_rd0;
            rf_rd1_out    <= t_rf_rd1;
            imm_out       <= t_imm;
            rf_wa_out     <= t_rf_wa;
            rf_we_out     <= t_rf_we;
            dmem_we_out   <= t_dmem_we;
            alu_res_out   <= t_alu_res;
            dmem_addr_out <= t_alu_res; // 注意这里有待确认，是否应该是 t_dmem_addr
            dmem_rd_out_out <= t_dmem_rd_out;

            rf_ra0_out      <= rf_ra0;
            rf_ra1_out      <= rf_ra1;
            br_type_out     <= br_type;
            dmem_access_out <= dmem_access;
            alu_src0_sel_out <= alu_src0_sel;
            alu_src1_sel_out <= alu_src1_sel;
            rf_wd_out       <= rf_wd;
            alu_src1_out <= alu_src1;
            rf_wd_sel_out <= rf_wd_sel;
            alu_op_out <= alu_op;
            npc_sel_out <= npc_sel;

            commit_out    <= t_commit; // 如果 flush 为 0，则 commit 为 1
        end
    end
end

endmodule