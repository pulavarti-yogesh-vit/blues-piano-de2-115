/* Main Control */ 
module projectmaint(
    input rawclk,       // 50MHz clock signal
    input [7:0] keys,   // Array of key inputs. Default HIGH.
    output speaker,     // Audio output (Square wave)
    output [6:0] hex1,  // Seven segment display output (Note letter)
    output [6:0] hex2   // Seven segment display output (Accidental)
); 

    wire [3:0] statevalue;
    wire [7:0] gkeys; 

    // Invert buttons so active-low becomes active-high
    assign gkeys = ~keys; 

    // Module calls
    tonemaker tonemakerinst1(
        .rawclk(rawclk), 
        .statevalue(statevalue), 
        .speaker(speaker)
    ); 

    keyboard keyinstance1(
        .key(gkeys), 
        .out(statevalue)
    ); 

    sevsegdisplaynote disnoteinstance1(
        .out1(hex2), 
        .out2(hex1), 
        .note(statevalue)
    ); 

endmodule 

/* ########################################################################## */
/* Clock Scheme Array Module */
module clockschemearray(
    input rawclk,
    output [31:0] clkarray0,
    output [31:0] clkarray1,
    output [31:0] clkarray2,
    output [31:0] clkarray3,
    output [31:0] clkarray4,
    output [31:0] clkarray5
);
    wire slwclk0, slwclk1, slwclk2, slwclk3, slwclk4, slwclk5;
    wire plllocked;

    // Upcounters functioning as clock dividers
    upcounter32 counterinstance0(slwclk0, clkarray0);
    upcounter32 counterinstance1(slwclk1, clkarray1);
    upcounter32 counterinstance2(slwclk2, clkarray2);

    // Quartus PLL Megafunction Instantiations
    pll pllinstance1(0, rawclk, slwclk0, slwclk1, slwclk2, plllocked);
    
    upcounter32 counterinstance3(slwclk3, clkarray3);
    upcounter32 counterinstance4(slwclk4, clkarray4);
    upcounter32 counterinstance5(slwclk5, clkarray5);
    
    pll2 pllinstance2(rawclk, slwclk3, slwclk4, slwclk5);

endmodule 

/* ########################################################################## */
/* Tone Generation Selection Module */
module tonemaker(
    input rawclk,
    input [3:0] statevalue,
    output reg speaker
);
    wire [31:0] clkarray0;
    wire [31:0] clkarray1;
    wire [31:0] clkarray2;
    wire [31:0] clkarray3;
    wire [31:0] clkarray4;
    wire [31:0] clkarray5;

    // Fixed sensitivity list to avoid simulator lockups
    always @(*) begin 
        case(statevalue)
            4'd0:    speaker = clkarray0[15]; // Dflat
            4'd1:    speaker = clkarray1[15]; // E
            4'd2:    speaker = clkarray2[15]; // Gflat
            4'd3:    speaker = clkarray3[15]; // G
            4'd4:    speaker = clkarray4[15]; // Aflat
            4'd5:    speaker = clkarray5[15]; // B
            4'd6:    speaker = clkarray0[14]; // Dflat Octave Up
            4'd7:    speaker = clkarray1[14]; // E Octave Up
            4'd8:    speaker = clkarray2[14]; // Gflat Octave Up
            default: speaker = 1'b0;          // Output Off
        endcase
    end 

    clockschemearray clkarrayinstance1(rawclk, clkarray0, clkarray1, clkarray2, clkarray3, clkarray4, clkarray5);

endmodule 

/* ########################################################################## */
/* Binary Upcounter Module */
module upcounter32(
    input ww,
    output reg [31:0] Qq
);
    // Safe initialization value for hardware registers
    initial Qq = 32'b0;

    always @(posedge ww) begin 
        Qq <= Qq + 1'b1;
    end 
endmodule 

/* ########################################################################## */
/* Keyboard Priority Encoder Module */
module keyboard(
    input [7:0] key,
    output reg [3:0] out
);
    always @(*) begin 
        casex(key) 
            8'b1xxxxxxx: out = 4'b0000; // Dflat
            8'b01xxxxxx: out = 4'b0001; // E
            8'b001xxxxx: out = 4'b0010; // G flat
            8'b0001xxxx: out = 4'b0011; // G
            8'b00001xxx: out = 4'b0100; // A flat
            8'b000001xx: out = 4'b0101; // B
            8'b0000001x: out = 4'b0110; // Dflat up
            8'b00000001: out = 4'b0111; // E up
            default    : out = 4'b1111; // No keys pressed
        endcase
    end 
endmodule 

/* ########################################################################## */
/* Seven Segment Display Driver Module */
module sevsegdisplaynote(
    output reg [6:0] out1, // Note letter
    output reg [6:0] out2, // Accidental (b)
    input [3:0] note
);
    always @(*) begin 
        case(note) 
            4'b0000: begin out1 = 7'b0000001; out2 = 7'b1100000; end // Dflat
            4'b0001: begin out1 = 7'b0110000; out2 = 7'b1111111; end // E
            4'b0010: begin out1 = 7'b0100001; out2 = 7'b1100000; end // G flat
            4'b0011: begin out1 = 7'b0100001; out2 = 7'b1111111; end // G
            4'b0100: begin out1 = 7'b0001000; out2 = 7'b1100000; end // A flat
            4'b0101: begin out1 = 7'b0000000; out2 = 7'b1111111; end // B
            4'b0110: begin out1 = 7'b0000001; out2 = 7'b1100000; end // Dflat up
            4'b0111: begin out1 = 7'b0110000; out2 = 7'b1111111; end // E up
            default: begin out1 = 7'b1111111; out2 = 7'b1111111; end // Off
        endcase
    end 
endmodule

