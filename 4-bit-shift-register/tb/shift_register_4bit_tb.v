`timescale 1ns/1ps

module shift_register_4bit_tb;

    reg clk;
    reg rst;
    reg serial_in;
    wire [3:0] q;

    // Instantiate the shift register
    shift_register_4bit dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, shift_register_4bit_tb);
    end


    // Test sequence
    initial begin

        // Initial values
        clk = 0;
        rst = 1;
        serial_in = 0;

        // Reset the shift register
        #10;
        rst = 0;

        // Shift in 1
        serial_in = 1;
        #10;

        // Shift in 0
        serial_in = 0;
        #10;

        // Shift in 1
        serial_in = 1;
        #10;

        // Shift in 1
        serial_in = 1;
        #10;

        // End simulation
        $finish;
    end

    // Display signals in terminal
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | serial_in: %b | q: %b",
                 $time, clk, rst, serial_in, q);
    end

endmodule