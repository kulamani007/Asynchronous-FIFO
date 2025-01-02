`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 12:13:58
// Design Name: 
// Module Name: asynchronous_fifo_tb
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


module asynchronous_fifo_tb( );
reg [7:0]data_in;
reg wr_en, rd_en;
reg wr_clk, rd_clk;
reg rst;
wire [7:0]data_out;
wire full, empty;

asynchronous_fifo AF(.data_in(data_in), .wr_en(wr_en), .rd_en(rd_en), .wr_clk(wr_clk), .rd_clk(rd_clk), .rst(rst), .data_out(data_out), .full(full), .empty(empty));
initial
begin
wr_clk = 0;
forever #5 wr_clk = ~wr_clk;
end
initial
begin
rd_clk = 0;
forever #5 rd_clk = ~rd_clk;
end
initial
begin
rst = 1; data_in = 0; wr_en = 0; rd_en = 0;

#10 rst = 0;

#10 wr_en = 1;
#10 data_in = 8'd3;
#10 data_in = 8'd4;
#10 data_in = 8'd5;
#10 data_in = 8'd6;
#10 data_in = 8'd7;
#10 wr_en = 0;

#10 rd_en = 1;
#50 rd_en = 0;

#50 $finish;
end
endmodule
