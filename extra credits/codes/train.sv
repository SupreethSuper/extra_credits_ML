module train #(parameter Nb=8, Nobs=8, Nf=3, Nc=8'd3, Nbco=8, Nbcc=8, Nepochs=15)
    ( input clk, reset, enable,
      input signed [Nb-1:0] X[0:Nobs-1][0:Nf-1], input signed [1:0] Y[0:Nc-1][0:Nobs-1],
      input [3:0] etashift,
      output logic signed [Nb-1:0] BestW[0:Nc-1][0:Nf],
      output logic [Nbcc-1:0] Count, output clkoutc, clkoutt,
      output logic [Nb-1:0] TotalError);

localparam Zero={Nb{1'b0}}, One = {{Nb-1{1'b0}},1'b1};
integer i, j;
logic signed [1:0] Ypred[0:Nc-1][0:Nobs-1];
logic signed [Nb-1:0] dW[0:Nc-1][0:Nf];
logic signed [Nb-1:0] W[0:Nc-1][0:Nf];
logic [Nb-1:0] BestTotalError;

//
Modelct #(Nb, Nobs, Nf, Nc, Nbco, Nbcc) Mc ( clk, reset, X, W, Y, etashift,
    Ypred, dW, clkoutc, TotalError);

// goes through iterations to train model
Counter #(Nbcc) Cl ( clkoutc, reset, (TotalError!=Zero), Nepochs[Nbcc-1:0], Count, clkoutt);
//

always_ff @ (posedge clkoutc or posedge reset) begin
    i = 0; j = 0;
    if (reset) begin
        for(i=0;i<Nc;i++) begin
            for(j=0;j<=Nf;j++) begin
                W[i][j] <= One;
            end
        end
        BestTotalError = {Nb{1'b1}};  // big number
    end
    else if (enable & clkoutc) begin
        //    pocket method
        //
        if (TotalError<BestTotalError) begin
            BestTotalError = TotalError;
            for(i=0;i<Nc;i++) begin
                for(j=0;j<=Nf;j++) begin
                    BestW[i][j] <= W[i][j];
                end
            end
        end
        //    update the weight matrix
        for(i=0;i<Nc;i++) begin
            for(j=0;j<=Nf;j++) begin
                W[i][j] <= W[i][j] + dW[i][j];
            end
        end
    end
end
endmodule
