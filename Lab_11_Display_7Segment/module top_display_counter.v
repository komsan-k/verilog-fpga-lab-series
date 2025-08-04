module top_display_counter (
    input clk,
    input rst,
    output [6:0] seg,
    output [3:0] an
);
    wire [3:0] ones, tens;

    bcd_counter bcd (.clk(clk), .rst(rst), .tens(tens), .ones(ones));
    mux_display mux (.clk(clk), .rst(rst), .digit1(ones), .digit2(tens), .seg(seg), .an(an));
endmodule
