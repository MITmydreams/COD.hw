module NPC_MUX (
    input                   [ 31: 0]            pc_add4,
    input                   [ 31: 0]            pc_offset,
    //input                   [ 31: 0]            pc_j,
    input                   [ 1 : 0]            npc_sel,

    output      reg         [31 : 0]            npc
);

always @(*) begin
    if(npc_sel == 2'b00)begin
        npc = pc_add4;
    end 
    else if(npc_sel == 2'b01)begin
        npc = pc_offset;
    end
    else
        npc = 32'b0;
end
endmodule