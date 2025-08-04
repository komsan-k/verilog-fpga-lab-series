module tb_traffic_light;
    reg clk = 0, rst = 1;
    wire [2:0] lights;

    traffic_light_fsm uut (.clk(clk), .rst(rst), .lights(lights));

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%t, State={R,Y,G}=%b", $time, lights);
        #15 rst = 0;
        #200 $finish;
    end
endmodule
