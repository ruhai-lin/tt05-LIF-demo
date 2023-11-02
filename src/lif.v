module lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    output reg [7:0] state,
    output wire spike
);
    
    reg [7:0] threshold;
    wire [7:0] next_state;


    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 200;
        end else begin
            state <= next_state;
        end
    end

    // resting potential and threshold
    assign next_state = (spike ? 0 : current) + (spike > 0 ? 0 : (state * 7'b1110000 >> 7));
    assign spike = (state >= threshold);


endmodule
