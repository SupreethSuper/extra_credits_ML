module test_Modelf () ;
    localparam Nb=8, Nf=3;
    logic signed [Nb-1:0] X[0:Nf-1];
    logic signed [Nb-1:0] W[0:Nf-1];
    logic signed [Nb-1:0] b;
    logic signed [1:0] Y;
    Modelf # (Nb, Nf) M1 ( X, W, b, Y) ;
    initial begin
        X = {-2, 4, -1} ;
        W = {-14, -4, -2};
        b = 2; #10;
        $display("Y=%d", Y) ;
    end
endmodule