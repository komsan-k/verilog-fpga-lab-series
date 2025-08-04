module uart_tb;
    reg clk = 0, rst = 0;
    reg [7:0] tx_data = 8'h55;
    reg tx_start = 0;
    wire tx, rx;
    wire [7:0] rx_data;
    wire tick, rx_done, busy;

    assign rx = tx;

    baud_gen #(10416) baud (.clk(clk), .rst(rst), .tick(tick));
    uart_tx tx_inst (.clk(clk), .rst(rst), .tx_start(tx_start), .tx_data(tx_data),
                     .tick(tick), .tx(tx), .busy(busy));
    uart_rx rx_inst (.clk(clk), .rst(rst), .rx(tx), .tick(tick),
                     .rx_data(rx_data), .rx_done(rx_done));

    always #5 clk = ~clk;

    initial begin
        rst = 1; #20; rst = 0;
        #50 tx_start = 1; #10 tx_start = 0;
        #10000;
        $finish;
    end

    initial begin
        $monitor("TX = \%b | RX_DATA = \%h | RX_DONE = \%b", tx, rx_data, rx_done);
    end
endmodule
