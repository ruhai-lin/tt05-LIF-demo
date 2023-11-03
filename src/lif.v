module lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    input wire learnable_threshold,  // 控制阈值是否可以学习
    // input wire learnable_beta,  // 控制decay rate是否可以学习
    output reg [7:0] state,
    output wire spike
);

    wire [7:0] next_state;
    reg [7:0] threshold;  // 自适应阈值
    // reg [7:0] beta;

    parameter ADAPTIVE_INCREMENT = 1.15;  // 自适应阈值增加因子
    parameter ADAPTIVE_DECREMENT = 0.95;  // 自适应阈值减小因子


    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 100;  // initial threshold 100
            // beta <= 0.9;            // +
        end else begin
            if (spike) begin
                state <= 0;
                if (learnable_threshold && threshold < 220)  // avoiding overflow 255
                    threshold <= threshold * ADAPTIVE_INCREMENT;  // 增加自适应阈值
            end else begin
                state <= next_state;
                if (learnable_threshold && threshold > 8)  // avoiding being to low
                    threshold <= threshold * ADAPTIVE_DECREMENT;  // 减小自适应阈值
            end
        end
    end

    // resting potential and threshold
    assign next_state = (spike ? 0 : (current)) + (spike > 0 ? 0 : (state * 7'b1110000 >> 7));
    assign spike = (state >= threshold);

endmodule
