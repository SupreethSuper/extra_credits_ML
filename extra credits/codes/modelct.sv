module Modelct #(parameter Nb=8, Nobs=8, Nf=3, Nc=8'd3, Nbco=8, Nbcc=8) (
    input clk, reset,
    input signed [Nb-1:0] X[0:Nobs-1][0:Nf-1],
    input signed [Nb-1:0] W[0:Nc-1][0:Nf],
    input signed [1:0] Y[0:Nc-1][0:Nobs-1],
    input [3:0] etashift,
    output logic signed [1:0] Ypred[0:Nc-1][0:Nobs-1],
    output logic signed [Nb-1:0] dW[0:Nc-1][0:Nf],
    output clkoutc,
    output logic [Nb-1:0] TotalError );

int i, j, k;
int i_, j_, k_;
localparam Zero={Nb{1'b0}}, One = {{Nb-1{1'b0}},1'b1};
logic signed [1:0] zero2s;
logic clkouto;
logic [Nbcc-1:0] Count;
logic signed [1:0] Y_[0:Nobs-1];
logic signed [1:0] Error[0:Nc-1][0:Nobs-1];

assign zero2s = 2'd0;

// function to Take absolute value
//
function [Nb-1:0] abs;
    input [Nb-1:0] a;
    begin
        abs = a;
        if (a[Nb-1] == 1'b1)
            abs = ~a + {{Nb-1{1'b0}},1'b1};  // 2's compliment
    end
endfunction

// multiply 2, 1 bit signed numbers
// (requires 2 bits)
function signed [1:0] onebitmult;
    input signed [1:0] a;
    input signed [1:0] b;
    begin
        onebitmult = 2'd1;
        if ((a>0 && b>0) || (a<0 && b<0))
            onebitmult = 2'd1;
        else if ((a<0 && b>0) || (a>0 && b<0))
            onebitmult = -2'd1;
    end
endfunction

Modelo #(Nb, Nobs, Nf, Nbco) M2 ( clk, reset, X, W[Count][1:Nf], W[Count][0], Y_, clkouto );
// count through all the classes
Counter #(Nbcc) Cl ( clkouto, reset, 1'b1, Nc[Nbcc-1:0], Count, clkoutc);

always_ff @ (posedge clkouto or posedge reset) begin
    i = 0; j = 0;
    if (reset) begin
        for(i=0;i<Nc;i++)
            for(j=0;j<Nobs;j++)
                // reset to all 1 which shows plenty of error
                Ypred[i][j] <= 2'd1;
    end
    else begin
        for(j=0;j<Nobs;j++)
            Ypred[Count][j] <= Y_[j];
    end
end

always_comb begin
    //    initialization
    TotalError = {Nb{1'b0}};
    for(i_=0;i_<Nc;i_++) begin
        for(j_=0;j_<Nobs;j_++)
            Error[i_][j_] = 2'd0;
        for(k_=0;k_<=Nf;k_++)
            dW[i_][k_] = Zero;
    end

    for(i_=0;i_<Nc;i_++) begin
        for(j_=0;j_<Nobs;j_++) begin
            Error[i_][j_] = onebitmult(Y[i_][j_],Ypred[i_][j_]);
            if (Error[i_][j_]<zero2s)
                TotalError += One;  // capture total error
        end

        for(k_=0;k_<=Nf;k_++) begin
            dW[i_][k_] = Zero;
            for(j_=0;j_<Nobs;j_++) begin
                if (k_==0) begin  // b, only sum for bias
                    if (Error[i_][j_]<zero2s) begin
                        if (Y[i_][j_]>zero2s)
                            dW[i_][k_] += One;
                        else
                            dW[i_][k_] -= One;
                    end
                end
                else begin
                    if (Error[i_][j_]<zero2s) begin  // only sum for weights
                        if (Y[i_][j_]>zero2s)
                            dW[i_][k_] += X[j_][k_-1]>>>etashift;
                        else
                            dW[i_][k_] -= X[j_][k_-1]>>>etashift;
                    end
                end
            end
        end
    end
    // $display(" Y %p \n Ypred %p \n Error %p \n dW %p \n TotalError %d", Y, Ypred, Error, dW, TotalError);
end
endmodule
