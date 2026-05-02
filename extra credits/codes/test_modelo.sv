module test_Modelo ();

    localparam Nb  = 8,
               Nobs = 8'd7,
               Nf   = 3,
               Nbc  = 8;

    logic signed [Nb-1:0] X [0:Nobs-1][0:Nf-1];
    logic signed [Nb-1:0] W [0:Nf];
    logic signed [Nb-1:0] b;
    logic signed [1:0]    Y [0:Nobs-1];
    logic clk;
    logic reset;
    logic clkout;

    int i;

    Modelo #(Nb, Nobs, Nf, Nbc) Ml (
        .clk    (clk),
        .reset  (reset),
        .X      (X),
        .W      (W[1:Nf]),
        .b      (W[0]),
        .Ypred  (Y),
        .clkout (clkout)
    );

    initial begin
        X = '{
            '{-2,  4, -1},
            '{ 4,  1, -1},
            '{ 1,  6, -1},
            '{ 2,  4, -1},
            '{ 6,  2, -1},
            '{ 6,  1, -1},
            '{ 1,  2, -1}
        };
        W = '{2, -14, -4, -2};

        clk = 1'b0; reset = 1'b1; #10;
        reset = 1'b0;

        for (i = 0; i < Nobs; i++) begin
            clk = 1'b0; #10;
            clk = 1'b1; #10;
            $display("Y = %p", Y);
        end
    end

endmodule