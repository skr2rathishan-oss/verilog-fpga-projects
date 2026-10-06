`timescale 1ns/1ps

module mux_2to1_4bit_tb;

  // Inputs
  reg [3:0] a;
  reg [3:0] b;
  reg sel;

  // Outputs
  wire [3:0] y;

  // Instantiate the Unit Under Test (UUT)
  mux_2to1_4bit uut (
    .a(a), 
    .b(b), 
    .sel(sel), 
    .y(y)
  );

  initial begin

    $monitor("Time: %0t | a: %b | b: %b | sel: %b | y: %b", $time, a, b, sel, y);

    $dumpfile("sim/mux.vcd");
    $dumpvars(0, mux_2to1_4bit_tb);
    
    // Initialize Inputs
    a = 4'b0000;
    b = 4'b0000;
    sel = 1'b0;

    // Wait for global reset to finish
    #10;
        
    // Test case 1: sel = 0, expect y = a
    a = 4'b1010; b = 4'b0101; sel = 0;
    #10;
    
    // Test case 2: sel = 1, expect y = b
    sel = 1;
    #10;

    // Test case 3: Change inputs and test again
    a = 4'b1111; b = 4'b0000; sel = 0;
    #10;

    sel = 1;
    #10;

    // Finish simulation
    $finish;
  end

endmodule