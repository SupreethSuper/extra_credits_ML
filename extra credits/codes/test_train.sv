module test_Train();

localparam Nb=8, Nobs=7, Nf=3, Nc=8'd3, Nbco=8, Nbcc=8, Nepochs=200;
localparam Zero={Nb{1'b0}}, One = {{Nb-1{1'b0}},1'b1};
logic [Nbcc-1:0] Epoch;
logic clk, reset, enable;
logic signed [Nb-1:0] X[0:Nobs-1][0:Nf-1];
logic signed [1:0] Y[0:Nc-1][0:Nobs-1];
logic [3:0] etashift;
logic signed [Nb-1:0] W[0:Nc-1][0:Nf];
logic [Nb-1:0] TotalError;
logic clkoutc, clkoutt;

train #(Nb, Nobs, Nf, Nc, Nbco, Nbcc, Nepochs) Mt ( clk, reset, enable, X, Y,
    etashift, W, Epoch, clkoutc, clkoutt, TotalError);

initial begin
    etashift = 4'd1; enable = 1'b1;
    X = '{
        '{-2,4,-1},'{4,1,-1},'{1, 6, -1},'{2, 4, -1},'{6, 2, -1},'{6, 1, -1},'{1,2,-1}};
    // initial weights
    W = '{'{2, -14, -4, -2},'{2, 8, 9, -9},'{2, 9, -15, 9}};
    Y = '{'{1, 1, -1, -1, -1, -1, 1},'{-1, -1, 1, 1, -1, -1, -1},'{-1, -1, -1, -1, 1, 1, -1}};

    reset = 1'b1; #10;
    reset = 1'b0;
    Epoch = {Nbcc{1'b0}};
    repeat ( Nepochs ) begin
        // create clock edges for all features, obs, classes
        repeat ( Nf * Nobs * Nc ) begin
            clk = 1'b0; #10;
            clk = 1'b1; #10;
        end
        $display("Epoch %d clkoutc %b clkoutt %b \n W %p", Epoch, clkoutc, clkoutt, W);
        Epoch++;
        $display(" TotalError %d ", TotalError );
        if (TotalError==Zero) break;
    end
end
endmodule
