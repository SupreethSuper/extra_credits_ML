module test_Modelct();
localparam Nb=8, Nobs=8'd7, Nf=3, Nc=3, Nbco=8, Nbcc=8;
int i, j;

logic signed [Nb-1:0] X[0:Nobs-1][0:Nf-1];
logic signed [Nb-1:0] W[0:Nc-1][0:Nf];
logic signed [1:0] Y[0:Nc-1][0:Nobs-1];
logic signed [1:0] Ypred[0:Nc-1][0:Nobs-1];
logic signed [Nb-1:0] dW[0:Nc-1][0:Nf];
logic clk, reset, clkoutc;
logic [3:0] etashift;
logic [Nb-1:0] TotalError;
//
Modelct #( Nb, Nobs, Nf, Nc, Nbco, Nbcc) Mct ( clk, reset, X, W, Y, etashift,
    Ypred, dW, clkoutc, TotalError );
// Modelc #( Nb, Nobs, Nf, Nc, Nbco, Nbcc) Mc ( clk, reset, X, W, T, clkoutc);

initial begin
    etashift = 4'd1;
    X = '{
        '{-2,4,-1},'{4,1,-1},'{1, 6, -1},'{2, 4, -1},'{6, 2, -1},'{6, 1, -1},'{1,2,-1}};
    W = '{'{2, -14, -4, -2},'{2, 8, 9, -9},'{2, 9, -15, 9}};
    Y = '{'{1, 1, -1, -1, -1, -1, 1},'{-1, -1, 1, 1, -1, -1, -1},'{-1, -1, -1, -1, 1, 1, -1}};

    clk = 1'b0; reset = 1'b1; #10;
    reset = 1'b0;
    for(i=0;i<Nc;i++) begin
        for(j=0;j<=Nobs;j++) begin
            clk = 1'b0; #10;
            clk = 1'b1; #10;
        end
    end
    $display("test modelCt Y %p \n Ypred %p", Y, Ypred);
end
endmodule
