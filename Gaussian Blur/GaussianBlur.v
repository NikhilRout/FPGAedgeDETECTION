module GaussianBlur(
  input [7:0] lu, cu, ru,
              lc, cc, rc,
              lb, cb, rb,
  output [7:0] blurred
);
  reg [9:0] cc4; //temp store after shift
  reg [8:0] lc2, cu2, rc2, cb2;
  reg [11:0] sum;
  always @(*) begin
      cc4 = cc;
      lc2 = lc;
      cu2 = cu;
      rc2 = rc;
      cb2 = cb;

      cc4 = cc4 << 2; //multiplying 4
      lc2 = lc2 << 1; //multiplying 2
      cu2 = cu2 << 1;
      rc2 = rc2 << 1;
      cb2 = cb2 << 1;

      sum = cc4 + lc2 + cu2 + rc2 + cb2 + lu + ru + lb + rb;
  end
  assign blurred = sum[11:4]; //dividing by 16
endmodule
