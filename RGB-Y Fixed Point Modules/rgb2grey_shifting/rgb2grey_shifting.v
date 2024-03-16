module rgb2grey_shifting(
  input [23:0] rgb_pixel,
  output [7:0] grey_pixel
);
  reg [7:0] current, summer;
  always @(*) begin
    summer = 8*{1'b0};    

    //red
    current = rgb_pixel[23:16];
    current = current >> 2;
    summer = current;
    current = current >> 3;
    summer = summer + current;
    current = current >> 1;
    summer = summer + current;

    //green
    current = rgb_pixel[15:8];
    current = current >> 1;
    summer = summer + current;
    current = current >> 3;
    summer = summer + current;
    current = current >> 2;
    summer = summer + current;
    current = current >> 1;
    summer = summer + current;  

    //blue
    current = rgb_pixel[7:0];
    current = current >> 4;
    summer = summer + current;
    current = current >> 1;
    summer = summer + current;
    current = current >> 1;
    summer = summer + current;
    current = current >> 2;
    summer = summer + current;

    summer = summer + 3'b101;
    //compensating for the approximation made by ignoring 2^-8 onwards lower order bits
  end
  assign grey_pixel = summer;
endmodule

/*
//base orginal module
module rgb2grey_shifting(
  input [23:0] rgb_pixel,
  output reg [7:0] grey_pixel
);
  reg [7:0] red, green, blue;
  reg [7:0] red_w, green_w, blue_w;
  always @(*) begin
    red = rgb_pixel[23:16];
    blue = rgb_pixel[15:8];
    green = rgb_pixel[7:0];
    
    red = red >> 2;
    red_w = red;
    red = red >> 3;
    red_w = red_w + red;
    red_w = red >> 1;
    red_w = red_w + red;

    blue = blue >> 1;
    blue_w = blue;
    blue = blue >> 3;
    blue_w = blue_w + blue;
    blue = blue >> 2;
    blue_w = blue_w + blue;
    blue = blue >> 1;
    blue_w = blue_w + blue;  

    green = green >> 4;
    green_w = green;
    green = green >> 1;
    green_w = green_w + green;
    green = green >> 1;
    green_w = green_w + green;
    green = green >> 2;
    green_w = green_w + green;

    grey_pixel = red_w + green_w + blue_w;
  end
endmodule
*/