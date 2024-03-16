`include "GaussianBlur.v"

module GaussianBlur_tb;
  reg [7:0] lu, cu, ru,
            lc, cc, rc,
            lb, cb, rb;
  wire [7:0] blurred;
  GaussianBlur uut(.lu(lu), .cu(cu), .ru(ru),
                   .lc(lc), .cc(cc), .rc(rc),
                   .lb(lb), .cb(cb), .rb(rb),
                   .blurred(blurred));
  initial begin
    $dumpfile("GuassianBlur.vcd");
    $dumpvars(0, GaussianBlur_tb);
    repeat (1000) begin
      lu = $urandom_range(0, 255);
      lc = $urandom_range(0, 255);
      lb = $urandom_range(0, 255);
      cu = $urandom_range(0, 255);
      cc = $urandom_range(0, 255);
      cb = $urandom_range(0, 255);
      ru = $urandom_range(0, 255);
      rc = $urandom_range(0, 255);
      rb = $urandom_range(0, 255);
      #100;
    end
  end
endmodule