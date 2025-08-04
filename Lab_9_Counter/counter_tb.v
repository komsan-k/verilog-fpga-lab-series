module counter_tb;
    reg clk, rst;
    wire [3:0] count;

    counter_4bit uut (.clk(clk), .rst(rst), .count(count));

    initial begin
        clk = 0; rst = 1; #5;
        rst = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("Time = %0t | Count = %b", $time, count);
        #100 $finish;
    end
endmodule
