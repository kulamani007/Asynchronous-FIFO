`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2024 18:48:42
// Design Name: 
// Module Name: asynchronous_fifo
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


module asynchronous_fifo #(
    parameter DATA_WIDTH = 8,       // Width of the data bus
    parameter FIFO_DEPTH = 16       // Depth of the FIFO (must be a power of 2)
)(
    input [DATA_WIDTH-1:0] data_in, // Input data to the FIFO
    input wr_en, rd_en,             // Write and Read enable signals
    input wr_clk, rd_clk,           // Write and Read clocks
    input rst,                      // Asynchronous reset
    output [DATA_WIDTH-1:0] data_out, // Output data from the FIFO
    output full, empty              // Full and Empty flags
);

    // Internal signals
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1]; // Memory array
    reg [$clog2(FIFO_DEPTH):0] wr_ptr, rd_ptr; // Write and Read pointers
    reg [$clog2(FIFO_DEPTH):0] wr_ptr_gray, rd_ptr_gray; // Gray-coded pointers
    reg [$clog2(FIFO_DEPTH):0] rd_ptr_gray_sync, wr_ptr_gray_sync; // Synchronized pointers

    // Full and Empty flag logic
    assign full  = (wr_ptr_gray == {~rd_ptr_gray_sync[$clog2(FIFO_DEPTH)], rd_ptr_gray_sync[$clog2(FIFO_DEPTH)-1:0]});
    assign empty = (wr_ptr_gray_sync == rd_ptr_gray);

    // Write operation
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[$clog2(FIFO_DEPTH)-1:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
            wr_ptr_gray <= (wr_ptr >> 1) ^ wr_ptr; // Binary to Gray conversion
        end
    end

    // Read operation
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
            rd_ptr_gray <= (rd_ptr >> 1) ^ rd_ptr; // Binary to Gray conversion
        end
    end

    // Pointer synchronization
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            wr_ptr_gray_sync <= 0;
        end else begin
            wr_ptr_gray_sync <= wr_ptr_gray;
        end
    end

    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            rd_ptr_gray_sync <= 0;
        end else begin
            rd_ptr_gray_sync <= rd_ptr_gray;
        end
    end

    // Data output
    assign data_out = mem[rd_ptr[$clog2(FIFO_DEPTH)-1:0]];

endmodule

