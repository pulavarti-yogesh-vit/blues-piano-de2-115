`timescale 1ns/1ps

module tb_projectmaint;

    // Inputs
    reg rawclk;
    reg [7:0] keys;

    // Outputs
    wire speaker;
    wire [6:0] hex1;
    wire [6:0] hex2;

    // Instantiate the Unit Under Test (UUT)
    projectmaint uut (
        .rawclk(rawclk),
        .keys(keys),
        .speaker(speaker),
        .hex1(hex1),
        .hex2(hex2)
    );

    // Generate 50MHz clock (20ns period)
    initial begin
        rawclk = 0;
        forever #10 rawclk = ~rawclk;
    end

    // Stimulus and Monitoring
    initial begin
        // Default state: all keys released (active-HIGH input, so 8'hFF)
        keys = 8'hFF;

        // Print header
        $display("==================================================================");
        $display(" Time (ns) | Keys (Active-Low) | Speaker | Hex1    | Hex2    | Note");
        $display("==================================================================");

        // Continuous monitoring using text output with a music note symbol
        $monitor("%0t ns    | %b         | %b       | %b | %b | ♫", 
                 $time, keys, speaker, hex1, hex2);

        // Cycle through all 8 keys one by one (active-low pulls individual bits to 0)
        #100 keys = 8'b01111111; // Tests Key 7 (State 0: Dflat)
        #200 keys = 8'b10111111; // Tests Key 6 (State 1: E)
        #200 keys = 8'b11011111; // Tests Key 5 (State 2: Gflat)
        #200 keys = 8'b11101111; // Tests Key 4 (State 3: G)
        #200 keys = 8'b11110111; // Tests Key 3 (State 4: Aflat)
        #200 keys = 8'b11111011; // Tests Key 2 (State 5: B)
        #200 keys = 8'b11111101; // Tests Key 1 (State 6: Dflat Up)
        #200 keys = 8'b11111110; // Tests Key 0 (State 7: E Up)
        #200 keys = 8'b11111111; // Release all keys (Default / Off)
        #200;

        $display("==================================================================");
        $display("Test completed successfully.");
        $finish;
    end

endmodule
