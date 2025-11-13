module seq_multiplier_tb;
    reg clk, rst, start;
    reg [3:0] A, B;
    wire [7:0] product;
    wire done;

    seq_multiplier_4bit uut (
        .clk(clk), .rst(rst), .start(start),
        .A(A), .B(B),
        .product(product), .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns clock period
    end

    // Test stimulus
    initial begin
        rst = 1; start = 0; A = 0; B = 0; #10;
        rst = 0;

        A = 4'd3;   // Fixed A value
        for (integer i = 1; i <= 10; i = i + 1) begin
            B = i[3:0];          // Set B = 1 to 10
            start = 1;           // Trigger multiplication
            #1 start = 0;       // Deassert start
            wait (done);         // Wait until multiplication completes
            $display("A = %0d, B = %0d => Product = %0d", A, B, product);
            #2;                 // Small delay before next iteration
        end

        $finish;
    end
endmodule
