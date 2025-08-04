module serial_adder_fsm_tb;
    reg clk, rst, start;
    reg [3:0] A, B;
    wire [3:0] SUM;
    wire done;

    serial_adder_fsm uut (
        .clk(clk), .rst(rst), .start(start),
        .A(A), .B(B), .SUM(SUM), .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; start = 0; A = 4'b0000; B = 4'b0000; #10;
        rst = 0;

        A = 4'b0110; B = 4'b0011; start = 1; #10;
        start = 0;

        wait (done);
        #20;

        A = 4'b1111; B = 4'b0001; start = 1; #10;
        start = 0;

        wait (done);
        #20;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | A=%b B=%b SUM=%b done=%b", $time, A, B, SUM, done);
    end
endmodule

