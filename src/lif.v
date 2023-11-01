module lif (
    input wire [7:0] current,
    output wire [7:0] next_state,
    output wire spike,
    input wire clk,
    input wire rst_n
);
    reg [7:0] state, threshold;



    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 40;
        end else begin
            state <= next_state;
        end
    end

    // resting potential and threshold
    assign next_state = current + ((spike > 0) ? 0 : (state >> 1));
    assign spike = (state >= threshold);


endmodule