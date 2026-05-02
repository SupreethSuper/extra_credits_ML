module Modelf #(parameter Nb=8, Nf=3) (
    input signed [Nb-1:0] X[0:Nf-1],
    input signed [Nb-1:0] W[0:Nf-1],
    input signed [Nb-1:0] b,
    output logic signed [1:0] Ypred);

integer i;
logic signed [Nb-1:0] Y;
localparam signed [Nb-1:0] Zero = {Nb{1'b0}};
//
function signed [1:0] quantization;
    input signed [Nb-1:0] Y;
    begin
        if (Y > Zero)
            quantization = 2'd1;
        else
            quantization = -2'd1;
    end
endfunction
//
always_comb begin
    Y = b; Ypred = 2'd0;
    for(i=0;i<Nf;i++) begin
        Y += X[i]*W[i];
    end
    Ypred = quantization(Y);
end
endmodule