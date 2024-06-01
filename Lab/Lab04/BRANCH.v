`define beq      4'b0001
`define bne      4'b0010
`define blt      4'b0011
`define bge      4'b0100
`define bltu     4'b0101
`define bgeu     4'b0110
`define jirl     4'b0111
`define b        4'b1000
`define bl       4'b1001

module BRANCH(
    input                   [ 3 : 0]            br_type,

    input                   [31 : 0]            br_src0,
    input                   [31 : 0]            br_src1,

    output      reg         [ 1 : 0]            npc_sel
);

reg signed [31:0] a_signed;
reg signed [31:0] b_signed;
always @(*) begin
    a_signed = $signed(br_src0);
    b_signed = $signed(br_src1);
end

always @(*) begin
    case (br_type)
        `beq:begin
            if(br_src0 == br_src1)begin
                npc_sel = 2'b01;
            end
            else 
                npc_sel = 2'b00;
        end
        `bne:begin
            if(br_src0 != br_src1)begin
                npc_sel = 2'b01;
            end
            else 
                npc_sel = 2'b00;
        end
        `blt:begin
            if(a_signed < b_signed)begin
                npc_sel = 2'b01;
            end
            else 
                npc_sel = 2'b00;
        end
        `bge:begin
            if(a_signed >= b_signed)begin
                npc_sel = 2'b01;
            end
            else 
                npc_sel = 2'b00;
        end
        `bltu:begin
            if(br_src0 < br_src1)begin
                npc_sel = 2'b01;
            end
            else 
                npc_sel = 2'b00;
        end
        `bgeu:begin
            if(br_src0 >= br_src1)begin
                npc_sel = 2'b01;
            end
            else 
                npc_sel = 2'b00;
        end

//--------------------------------------
    
        `b:begin
            npc_sel = 2'b01;
        end
        `bl:begin
            npc_sel = 2'b01;
        end
        `jirl:begin
            npc_sel = 2'b01;
        end
        default: begin
            npc_sel = 2'b00;
        end
    endcase
end

endmodule