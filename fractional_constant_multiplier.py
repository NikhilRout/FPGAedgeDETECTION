#fractional constant multiplier hard-coded verilog script generator

def fixed_point(value, fractional_bits=8):
    scale_factor = 2 ** fractional_bits
    fixed_point = int(value * scale_factor)
    binary_representation = bin(fixed_point)[2:].zfill(fractional_bits)
    return str(binary_representation)

const_dec = float(input("Enter Constant to be multiplied by: "))
fractional_bits = int(input("Enter Constants' fractional bits size: "))
const_bin = fixed_point(const_dec, fractional_bits)
multiplicand = input("Enter multiplicand reg's name: ")

print('\n')
print(f"sum = {fractional_bits}'d0;")
print(f"temp = {multiplicand};")
shifts = 0
for i in const_bin:
    if i == '0':
        shifts+=1
    else:
        print(f"temp = temp >> {shifts+1};")
        print("sum = sum + temp;")
        shifts = 0
