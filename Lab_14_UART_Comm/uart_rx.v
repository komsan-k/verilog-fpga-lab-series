module uart_rx (
    input clk,
    input rst,
    input rx,
    input tick,
    output reg [7:0] rx_data,
    output reg rx_done
);
    reg [3:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            rx_done <= 0;
        end else if (tick) begin
            case (state)
                0: if (!rx) state <= 1; // Start bit
                1: begin
                    data[bit_cnt] <= rx;
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) state <= 2;
                end
                2: begin // Stop bit
                    rx_data <= data;
                    rx_done <= 1;
                    state <= 3;
                end
                3: begin
                    rx_done <= 0;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
