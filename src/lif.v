module lif (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    input wire learnable_threshold,  // 控制阈值是否可以学习
    input wire learnable_beta,  // 控制decay rate是否可以学习
    output reg [7:0] state,
    output wire spike
);

    wire [7:0] next_state;
    reg [7:0] threshold;
    reg [7:0] beta;

    parameter ADAPTIVE_INCREMENT = 295;  // adaptive increment factor
    parameter ADAPTIVE_DECREMENT = 250;  // adaptive decrement factor
    // parameter ADAPTIVE_BETA_INCREMENT = 295;  // adaptive increment factor
    // parameter ADAPTIVE_BETA_DECREMENT = 218;  // adaptive decrement factor


    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 100;  // initial threshold 100
            beta <= 224;       // initial beta 224 = 224/256 = 0.875
        end else begin
            if (spike) begin
                state <= 0;
                if (learnable_threshold && (threshold < 220))  // avoiding overflow 255
                    threshold <= threshold * ADAPTIVE_INCREMENT >> 8;  // increase threshold
                if (learnable_beta && (beta > 128))
                    beta <= beta * ADAPTIVE_DECREMENT >> 8; // decrease decay rate
            end else begin
                state <= next_state;
                if (learnable_threshold && (threshold > 32))  // avoiding being to low
                    threshold <= threshold * ADAPTIVE_DECREMENT >> 8;  // decrease threshold
                if (learnable_beta && (beta < 220))
                    beta <= beta * ADAPTIVE_INCREMENT >> 8; // increse decay rate
            end
        end
    end

    // resting potential and threshold
    assign next_state = (spike ? 0 : (current)) + (spike ? 0 : (state * beta >> 8));
    assign spike = (state >= threshold);

endmodule
