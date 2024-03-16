`include "fp_rgb2grey_shifting.v"

module fp_rgb2grey_tb;
  reg [47:0] rgb_pixel;
  wire [15:0] grey_pixel;
  fp_rgb2grey_shifting uut(.rgb_pixel(rgb_pixel), .grey_pixel(grey_pixel));
  initial begin
    $dumpfile("fp_rgb2grey_shifting.vcd");
    $dumpvars(0, fp_rgb2grey_tb);
    repeat (1000) begin
      rgb_pixel[47] = 1'b0; //always positive
      rgb_pixel[46:42] = $urandom_range(15, 22); //exp of numbers between 0 and 255
      rgb_pixel[41:32] = $urandom_range(0, 1023); //2^10-1
      rgb_pixel[31] = 1'b0;
      rgb_pixel[30:26] = $urandom_range(15, 22);
      rgb_pixel[25:16] = $urandom_range(0, 1023);
      rgb_pixel[15] = 1'b0;
      rgb_pixel[14:10] = $urandom_range(15, 22);
      rgb_pixel[9:0] = $urandom_range(0, 1023);
      #100;
    end
  end
endmodule
