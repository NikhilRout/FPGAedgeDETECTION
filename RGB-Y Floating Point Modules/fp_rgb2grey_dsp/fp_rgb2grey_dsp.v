module fp_rgb2grey_dsp(
  input [47:0] rgb_pixel,
  output [15:0] grey_pixel
);
  reg [10:0] redc_significand, greenc_significand, bluec_significand;
  reg [4:0] redc_exp, greenc_exp, bluec_exp;
  reg [21:0] redw_multiplied, greenw_multiplied, bluew_multiplied;
  reg [4:0] redw_exp, greenw_exp, bluew_exp;
  reg [10:0] redw_sig, greenw_sig, bluew_sig;
  reg [4:0] augend_exp0, shift0, augend_exp1, shift1;
  reg [10:0] augend_sig0, addend_sig0, sum_sig0, augend_sig1, addend_sig1, sum_sig1;
  reg carry0, carry1;

  always @(*) begin
    redc_significand = 11'b10011001001;
    greenc_significand = 11'b10010110010;
    bluec_significand = 11'b11101001100;

    redc_exp = 5'b01101;
    greenc_exp = 5'b01110;
    bluec_exp = 5'b01011;

    redw_multiplied = {1'b1, rgb_pixel[41:32]} * redc_significand;
    greenw_multiplied = {1'b1, rgb_pixel[25:16]} * greenc_significand;
    bluew_multiplied = {1'b1, rgb_pixel[9:0]} * bluec_significand;

    redw_exp = rgb_pixel[46:42] - 15 + redc_exp;
    greenw_exp = rgb_pixel[30:26] - 15 + greenc_exp;
    bluew_exp = rgb_pixel[14:10] - 15 + bluec_exp;
    
    redw_sig = redw_multiplied[21] ? redw_multiplied[21:11] : redw_multiplied[20:10];
    redw_exp = redw_multiplied[21] ? redw_exp + 1'b1 : redw_exp;
    greenw_sig = greenw_multiplied[21] ? greenw_multiplied[21:11] : greenw_multiplied[20:10];   
    greenw_exp = greenw_multiplied[21] ? greenw_exp + 1'b1 : greenw_exp;
    bluew_sig = bluew_multiplied[21] ? bluew_multiplied[21:11] : bluew_multiplied[20:10];
    bluew_exp = bluew_multiplied[21] ? bluew_exp + 1'b1 : bluew_exp;  

    if (redw_exp < greenw_exp) begin //green > red
      augend_sig0 = greenw_sig;
      addend_sig0 = redw_sig;
      augend_exp0 = greenw_exp;
      shift0 = greenw_exp - redw_exp;
    end else begin //red > green
      augend_sig0 = redw_sig;
      addend_sig0 = greenw_sig;
      augend_exp0 = redw_exp;
      shift0 = redw_exp - greenw_exp;
    end
    addend_sig0 = addend_sig0 >> shift0;
    {carry0,sum_sig0} = augend_sig0 + addend_sig0;
    if (carry0) begin
      sum_sig0 = sum_sig0 >> 1;
      augend_exp0 = augend_exp0 + 1'b1;
    end
    
    if (bluew_exp < augend_exp0) begin
      augend_sig1 = sum_sig0;
      addend_sig1 = bluew_sig;
      augend_exp1 = augend_exp0;
      shift1 = augend_exp0 - bluew_exp;
    end else begin
      augend_sig1 = bluew_sig;
      addend_sig1 = sum_sig0;
      augend_exp1 = bluew_exp;
      shift1 = bluew_exp - augend_exp0;
    end
    addend_sig1 = addend_sig1 >> shift1;
    {carry1, sum_sig1} = augend_sig1 + addend_sig1;
    if (carry1) begin
      sum_sig1 = sum_sig1 >> 1;
      augend_exp1 = augend_exp1 + 1'b1;
    end

  end
  assign grey_pixel = {1'b0, augend_exp1, sum_sig1[9:0]};
endmodule
