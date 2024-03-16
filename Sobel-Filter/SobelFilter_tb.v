`include "SobelFilter.v"

module SobelFilter_tb;
  reg [7:0] lu, cu, ru,
            lc,     rc,
            lb, cb, rb;
  wire [7:0] edge_lum;
  SobelFilter uut(.lu(lu), .cu(cu), .ru(ru),
                  .lc(lc),          .rc(rc),
                  .lb(lb), .cb(cb), .rb(rb),
                  .edge_lum(edge_lum));
  initial begin
    $dumpfile("SobelFilter.vcd");
    $dumpvars(0, SobelFilter_tb);
    repeat (1000) begin
      lu = $urandom_range(0, 255);
      lc = $urandom_range(0, 255);
      lb = $urandom_range(0, 255);
      cu = $urandom_range(0, 255);
      cb = $urandom_range(0, 255);
      ru = $urandom_range(0, 255);
      rc = $urandom_range(0, 255);
      rb = $urandom_range(0, 255);
      #100;
    end
  end
endmodule
