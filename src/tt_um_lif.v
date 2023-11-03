`default_nettype none

module tt_um_lif (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input current
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 digit output
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    assign uio_out [6:0] = 7'd0;
    wire temp;

    // instantiate the lif neurons
    lif lif1 (.current(ui_in), .state(uo_out), .spike(temp), .learnable_threshold(1'b1), .learnable_beta(1'b1), .clk(clk), .rst_n(rst_n));
    // lif lif2 (.current(temp >> 6), .state(uo_out), .spike(uio_out[7]), .learnable_threshold(1'b1), .learnable_beta(1'b1), .clk(clk), .rst_n(rst_n));

endmodule
