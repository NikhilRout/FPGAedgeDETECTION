/*
----------------------------------------------------------------
	 
  vertical edge kernel             horizontal edge kernel
	|-1 0 1|			|-1 -2 -1|
	|-2 0 2|			| 0  0  0|
	|-1 0 1|			| 1  2  1|

		   pixel matrix for cc
		       |lu cu ru|
                       |lc cc rc|
                       |lb cb rb|
----------------------------------------------------------------
*/

module SobelFilter(
  input [7:0] lu, cu, ru,
              lc,     rc,
              lb, cb, rb,
  output [7:0] edge_lum
);
  wire [19:0] gx_squared, gy_squared;
  wire [21:0] squared_sum;
  wire [10:0] edge_grad;
  matrix_mul g_x(.m1u(lu), .m2c(lc), .m1b(lb), .p1u(ru), .p2c(rc), .p1b(rb), .squared(gx_squared));
  matrix_mul g_y(.m1u(lu), .m2c(cu), .m1b(ru), .p1u(lb), .p2c(cb), .p1b(rb), .squared(gy_squared));
  assign squared_sum = gx_squared + gy_squared;
  sqrt g(.radicand(squared_sum), .root(edge_grad));
  assign edge_lum = ~ edge_grad[9:2]; //divide by 4 and subtract that by 255 so edges are black on a white bg
  //assign canny = (edge_lum>8'd200) ? 8'd255 : 8'd0; (sharp cut-off without hysterisis)
endmodule

module sqrt(
  input [21:0] radicand,
  output [10:0] root
);
  integer i; //iterator
  reg [21:0] t; //result of sign test
  reg [10:0] q; //temp sqrt ans
  reg [43:0] ax;
  always @(*) begin
    ax = {22'd0,radicand};
    t = 22'd0;
    q = 11'd0;
    for (i = 0; i < 11; i=i+1) begin
      ax = ax << 2;
      t = ax[43:22] - {q, 2'b01};
      q = q << 1;
      if (t[21] == 1'b0) begin //if zero or +ve
        ax[43:22] = t;
        q[0] = 1'b1;
      end
    end
  end
  assign root = q;
endmodule

module matrix_mul(
  input [7:0] m1u, m2c, m1b, p1u, p2c, p1b,
  output [19:0] squared
);
  reg [10:0] sum;
  reg [8:0] m2,p2;
  always @(*) begin
    m2 = m2c;
    p2 = p2c;
    m2 = m2 << 1;
    p2 = p2 << 1;
    sum = p1u + p2 + p1b - m1u - m2 - m1b;
    sum = sum[10] ? -sum : sum;
  end
  assign squared = sum[9:0]*sum[9:0];
endmodule
