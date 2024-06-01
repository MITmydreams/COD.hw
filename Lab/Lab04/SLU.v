//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/15 22:33:43
// Design Name: 
// Module Name: SLU
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


module SLU (
    input                   [31 : 0]                addr,
    input                   [ 3 : 0]                dmem_access,

    input                   [31 : 0]                rd_in,
    input                   [31 : 0]                wd_in,

    output      reg         [31 : 0]                rd_out,
    output      reg         [31 : 0]                wd_out
    //output      reg         [31 : 0]                dmem_wa
);

wire [1:0] temp;//0~3
assign temp = addr[1:0];

always @(*) begin
    case (dmem_access)
        4'b0001: begin//ld.w指令
            wd_out = wd_in;
            rd_out = rd_in;
            //dmem_wa = 0;
        end 
        4'b0010:begin//ld.h指令_加载半字。
            wd_out = wd_in;
            //dmem_wa = 0;
            case (temp)
                2'b00: begin
                    rd_out = {{16{rd_in[15]}},rd_in[ 15 : 0]};
                end
                2'b10: begin
                    rd_out = {{16{rd_in[31]}},rd_in[31 : 16]};
                end
                default:begin
                    rd_out = 32'b0;
                end
            endcase
        end
        4'b0011:begin//ld.b指令_加载一个字节
            wd_out = wd_in;
            //dmem_wa = 0;
            case (temp)
                2'b00: begin
                    rd_out = {{24{rd_in[7]}},rd_in[ 7 : 0]};
                end
                2'b01: begin
                    rd_out = {{24{rd_in[15]}},rd_in[ 15 : 8]};
                end
                2'b10: begin
                    rd_out = {{24{rd_in[23]}},rd_in[ 23 : 16]};
                end
                2'b11: begin
                    rd_out = {{24{rd_in[31]}},rd_in[31 : 24]};
                end
            endcase
        end

        4'b0100:begin//ld.hu指令_加载半字。
            wd_out = wd_in;
            //dmem_wa = 0;
            case (temp)
                2'b00: begin
                    rd_out = {{16'b0},rd_in[ 15 : 0]};
                end
                2'b10: begin
                    rd_out = {{16{1'b0}}, rd_in[31:16]};
                end
                default:begin
                    rd_out = 32'b0;
                end
            endcase
        end

        4'b0101:begin//ld.bu指令_无符号加载一个字节
            wd_out = wd_in;
            //dmem_wa = 0;
            case (temp)
                2'b00: begin
                    rd_out = {{24'b0},rd_in[ 7 : 0]};
                end
                2'b01: begin
                    rd_out = {{24'b0},rd_in[ 15 : 8]};
                end
                2'b10: begin
                    rd_out = {{24'b0},rd_in[ 23 :16]};
                end
                2'b11: begin
                    rd_out = {{24'b0},rd_in[31 : 24]};
                end
            endcase
        end
        4'b0110: begin//st.w指令
            wd_out = wd_in;
            rd_out = rd_in;
            //dmem_wa = addr;
            
        end

        4'b0111:begin//st.h指令_存储半字。
            rd_out = rd_in;
            //dmem_wa = addr;
            case (temp)
                2'b00: begin
                    wd_out = {rd_in[31 : 16],wd_in[ 15 : 0]};
                end
                2'b10: begin
                    wd_out = {wd_in[31 : 16],rd_in[ 15 : 0]};
                end
                default:begin
                    wd_out = 32'b0;
                end
            endcase
        end

        4'b1000:begin//st.b指令_存储一个字节
            rd_out = rd_in;
            case (temp)
                2'b00: begin
                    wd_out = {rd_in[ 31 : 8],wd_in[ 7 : 0]};
                end
                2'b01: begin
                    wd_out = {rd_in[ 31 : 16],wd_in[ 15 : 8],rd_in[ 7 : 0]};
                end
                2'b10: begin
                    wd_out = {rd_in[ 31 : 24],wd_in[ 23 : 16],rd_in[ 15 : 0]};
                end
                2'b11: begin
                    wd_out = {wd_in[ 31 : 24],rd_in[23 : 0]};
                end
            endcase
        end


        default: begin
            rd_out = 32'b0;
            wd_out = 32'b0;
        end
    endcase
end
endmodule
