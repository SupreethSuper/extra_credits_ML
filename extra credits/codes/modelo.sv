module Modelo # (parameter Nb=8, Nobs=8'd8, Nf=3, Nbc=8) 

(
input logic clk, 
input logic reset,
input logic signed [Nb-1:0] X[0:Nobs-1] [0:Nf-1],
input logic signed [Nb-1:0] W[0:Nf-1], input logic signed [Nb-1:0] b,
output logic signed [1:0] Ypred[0:Nobs-1],
output logic  clkout) ;



    localparam Zero={Nb{1'b0}};


    integer i;


    logic signed [1:0] Y_;


    logic [Nbc-1:0] Count;


    // is Y driven for all Count at all times? need a ff?
    Modelf # (Nb, Nf) Ml ( X[Count], W, b, Y_ ) ;

    Counter # (Nbc) Cl ( clk, reset, 1'b1, Nobs[Nbc-1:0], Count, clkout) ;

    always_ff @ (posedge clk or posedge reset) begin
        i = 0;
        if (reset) begin
            for (i=0;i<Nobs;i++)
                Ypred[i] <= 2'd0;
            end
        else begin
            Ypred[Count] <= Y_;
            // $display(" count %d Y_ %d Y %p ", Count, Y_, Y) ;
        end
    end

endmodule