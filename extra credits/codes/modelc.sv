module Modelc #(parameter Nb=8, Nobs=8, Nf=3, Nc=8'd3, Nbco=6, Nbcc=8) (
    input clk, reset,
    input signed [Nb-1:0] X[0:Nobs-1][0:Nf-1],
    input signed [Nb-1:0] W[0:Nc-1][0:Nf],     // reverse Nc and Nf for reference
    output logic signed [1:0] Ypred[0:Nc-1][0:Nobs-1], output clkoutc);

int i, j;
localparam Zero={Nb{1'b0}};
logic clkouto;
logic [Nbcc-1:0] Count;
logic signed [1:0] Y_[0:Nobs-1];

Modelo #(Nb, Nobs, Nf, Nbco) M2 ( clk, reset, X, W[Count][1:Nf], W[Count][0], Y_, clkouto );
Counter #(Nbcc) Cl ( clkouto, reset, 1'b1, Nc[Nbcc-1:0], Count, clkoutc);

always_ff @ (posedge clkouto or posedge reset) begin
    i = 0; j = 0;
    if (reset) begin
        for(i=0;i<Nc;i++)
            for(j=0;j<Nobs;j++)
                Ypred[i][j] <= 2'd0;
    end
    else begin
        for(j=0;j<Nobs;j++)
            Ypred[Count][j] <= Y_[j];
    end
end
endmodule
