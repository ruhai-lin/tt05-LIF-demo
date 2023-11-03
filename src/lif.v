module lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    output reg [7:0] state,
    output wire spike
);

    wire [7:0] next_state;
    reg [7:0] threshold;  // 自适应阈值

    parameter ADAPTIVE_INCREMENT = 1.15;  // 自适应阈值增加因子
    parameter ADAPTIVE_DECREMENT = 0.95;  // 自适应阈值减小因子

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 8'b00000000;
            threshold <= 8'b01100100;  // 初始自适应阈值100
        end else begin
            if (spike) begin
                state <= 8'b00000000;
                if (threshold < 8'b11011100)  // 防止超过255
                    threshold <= threshold * ADAPTIVE_INCREMENT;  // 增加自适应阈值
            end else begin
                state <= next_state;
                if (threshold > 8'b00001000)  // 防止下降得过低
                    threshold <= threshold * ADAPTIVE_DECREMENT;  // 减小自适应阈值
            end
        end
    end

    // resting potential and threshold
    assign next_state = (spike ? 0 : current) + (spike > 0 ? 0 : (state * 7'b1110000 >> 7));
    assign spike = (state >= threshold);

endmodule
