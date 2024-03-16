module rgb2grey_dsp(
  input [23:0] rgb_pixel,
  output [7:0] grey_pixel
);
  reg [7:0] red_c, green_c, blue_c;
  reg [15:0] summer;
  always @(*) begin
    red_c = 8'h4C;
    green_c = 8'h96;
    blue_c = 8'h1D;
    summer = (red_c * rgb_pixel[23:16]) + (green_c * rgb_pixel[15:8]) + (blue_c * rgb_pixel[7:0]);
  end
  assign grey_pixel = summer[15:8];
endmodule

/*
module rgb2grey_dsp(
  input [23:0] rgb_pixel,
  output [7:0] grey_pixel
);
  //initialization
  wire [15:0] summer;
  //constants
  integer red_c = 8'h4C;
  integer green_c = 8'h96;
  integer blue_c = 8'h1D;
  //multiplying summing and output
  assign summer = (red_c * rgb_pixel[23:16]) + (green_c * rgb_pixel[15:8]) + (blue_c * rgb_pixel[7:0]);
  assign grey_pixel = summer[15:8]; //Q8.0 * Q0.8 = Q8.8 
endmodule
*/