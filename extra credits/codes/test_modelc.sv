module test_Modelc();
localparam Nb=8, Nobs=8'd7, Nf=3, Nc=3, Nbco=6, Nbcc=8;
int i, j;

logic signed [Nb-1:0] X[0:Nobs-1][0:Nf-1];
logic signed [Nb-1:0] W[0:Nc-1][0:Nf];
logic signed [1:0] Y[0:Nc-1][0:Nobs-1];
logic clk, reset, clkoutc;

//
Modelc #( Nb, Nobs, Nf, Nc, Nbco, Nbcc) Mc ( clk, reset, X, W, Y, clkoutc);

initial begin
    X = '{
        '{-2, 4, -1}, '{4, 1, -1}, '{1, 6, -1}, '{2, 4, -1}, '{6, 2, -1}, '{6, 1, -1}, '{1, 2, -1}
    };
    W = '{'{2, -14, -4, -2}, '{2, 8, 9, -9}, '{2, 9, -15, 9}};

    clk = 1'b0; reset = 1'b1; #10;
    reset = 1'b0;
    for(i=0;i<Nc;i++) begin
        for(j=0;j<Nobs;j++) begin
            clk = 1'b0; #10;
            clk = 1'b1; #10;
        end
    end
    $display("test modelC Y=%p", Y);
end
endmodule
