`include "rgb2grey_shifting.v"

module rgb2grey_tb;
  reg [23:0] rgb_pixel;
  wire [7:0] grey_pixel;
  rgb2grey_shifting uut(.rgb_pixel(rgb_pixel), .grey_pixel(grey_pixel));
  initial begin
    $dumpfile("rgb2grey_shifting.vcd");
    $dumpvars(0, rgb2grey_tb);
    repeat (1000) begin
      rgb_pixel = $urandom_range(0,16777215); //2^24-1
      #100;
    end
  end
endmodule
