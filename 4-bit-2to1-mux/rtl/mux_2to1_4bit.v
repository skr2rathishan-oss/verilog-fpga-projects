module mux_2to1_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       sel,
    output wire [3:0] y
);

    wire [3:0] selbus;

    // Replicate the select signal to create a 4-bit bus
    assign selbus = {4{sel}};

    assign y = (a & (~selbus)) | (b & selbus);

endmodule