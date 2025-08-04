module clock_divider_tb;
    reg clk_in, rst;
    wire clk_out;

    clock_divider #(4) uut (.clk_in(clk_in), .rst(rst), .clk_out(clk_out));

    initial begin
        clk_in = 0; rst = 1; #5;
        rst = 0;
        forever #5 clk_in = ~clk_in;
    end

    initial begin
        $monitor("Time = %0t | clk_out = %b", $time, clk_out);
        #200 $finish;
    end
endmodule
