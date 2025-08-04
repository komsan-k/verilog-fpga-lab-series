module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    input tick,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            busy <= 0;
            state <= 0;
        end else if (tick) begin
            case (state)
                0: if (tx_start) begin
                    busy <= 1;
                    data <= tx_data;
                    tx <= 0; // Start bit
                    state <= 1;
                    bit_cnt <= 0;
                end
                1: begin // Data bits
                    tx <= data[bit_cnt];
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) state <= 2;
                end
                2: begin // Stop bit
                    tx <= 1;
                    state <= 3;
                end
                3: begin
                    busy <= 0;
                    state <= 0;
                end
            endcase
        end
    end
endmodule

