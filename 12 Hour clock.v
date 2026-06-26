module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);
    
    reg en1, en2, en3;
    
    assign en1 = ss[7:4] == 4'd5 && ss[3:0] == 4'd9;
    assign en2 = en1 & (mm[7:4] == 4'd5 && mm[3:0] == 4'd9);
    assign en3 = en2 & (hh[7:4] == 4'd1 && hh[3:0] == 4'd1);
    
    
    //for seconds
    sixty sec(clk, reset, ena, ss);
    sixty min(clk, reset, en1, mm);
    hours hrs(clk, reset, en2, hh);
    ampm aaaa(clk, reset, en3, pm);
   
endmodule

module sixty(
    input clk, reset, en,
    output [7:0] q);
    
    always @(posedge clk) begin
        if (reset) q <= 8'b0;
        else if (en) begin
            if (q[3:0] == 4'd9) begin //if ones = 9
                if (q[7:4] == 4'd5) begin //if tens = 5
                    q[7:4] <= 4'b0;	//reset tens to 0
                end
                else begin
                    q[7:4] <= q[7:4] + 4'b1;	//increase tens by one
                end
                
                q[3:0] <= 4'b0; //reset ones to 0
            end
            else begin
                q[3:0] <= q[3:0] + 4'b1; //increase ones by 1
            end
        end
    end
endmodule

module hours(
    input clk, reset, en,
    output [7:0] q);
    
    always @(posedge clk) begin
        if (reset) begin
            q[7:4] <= 4'd1;
            q[3:0] <= 4'd2;
        end
        else if (en) begin
            if (q[7:4] == 4'b1 && q[3:0] == 4'd2) begin
                q[7:4] <= 4'b0;
                q[3:0] <= 4'b1;
            end
            else if (q[3:0] == 4'd9) begin
                q[7:4] <= 4'b1;
                q[3:0] <= 4'b0;
            end
            else begin
                q[3:0] <= q[3:0] + 4'b1;
            end
        end
    end
endmodule

module ampm(
    input clk, reset, en,
    output q);
    
    always @(posedge clk) begin
        if (reset) q <= 1'b0;
        else if (en) begin
            q <= q^1'b1;
        end
    end
endmodule