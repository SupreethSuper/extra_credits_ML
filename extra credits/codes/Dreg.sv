// D register

module DReg # (parameter Nbits=8)
(input logic clk, 
 input logic reset, 
 input logic enable, 
 input logic [Nbits-1:0] D,
 output logic [Nbits-1:0] Q);



always ff @ (posedge clk or posedge reset)
if (reset)
Q <= {Nbits{1'b0}};
else if (enable)
Q <= D;
endmodule

// counter, counts to MaxCnt-1 and generates clkout true for l clk cycle

module Counter # (parameter Nbc=3) 
(input logic clk, 
input  logic reset, 
input  logic  enable,
input  logic  [Nbc-1:0] MaxCnt,
output logic [Nbc-1:0] Count, output logic clkout);

logic rst;
logic D;

DReg # (Nbc) Dl ( clk, reset | rst, enable, Count+{ {Nbc-1{1'b0} }, 1'bl}, Count);
assign rst = (Count == MaxCnt) ? 1'bl : 1'b0; // counts 0 1 2, ... MaxCnt-1
assign D = (Count == MaxCnt-1) ? 1'bl : 1'b0;
DReg #(1) D2 ( clk, reset, l'bl, D, clkout) ;
endmodule