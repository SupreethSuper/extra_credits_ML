module test_counter ();

localparam Nbc=4;

logic clk; 
logic reset;

logic [Nbc-1:0] MaxCnt;
logic [Nbc-1:0] Count;

logic clkout;

Counter # (Nbc) C1 ( clk, reset, 1'b1, MaxCnt, Count, clkout) ;
initial begin
clk=1'b0; reset=1'b1; MaxCnt = 4'd10; #10;
reset = 1'b0;
repeat (15) begin
clk = 1'b0; #10;
clk = 1'b1; #10;
$display ("Count %d clkout %b", Count, clkout) ;
end
end
endmodule