module pll (
    input areset,
    input inclk0,
    output reg c0,
    output reg c1,
    output reg c2,
    output reg locked
);
    reg [3:0] div_cnt = 0;

    initial begin
        c0 = 0;
        c1 = 0;
        c2 = 0;
        locked = 1'b1; // Always locked for simulation
    end

    always @(posedge inclk0) begin
        div_cnt <= div_cnt + 1;
        if (div_cnt[0]) c0 <= ~c0;
        if (div_cnt[1]) c1 <= ~c1;
        if (div_cnt[2]) c2 <= ~c2;
    end
endmodule
