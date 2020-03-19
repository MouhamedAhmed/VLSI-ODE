import numpy as np

def twos_complement(string_num,string_f):
    string = string_num+string_f
    s = ''
    st = 0
    string = string[::-1]
    for i in range(len(string)):
        s  += string[i]
        if(i == len(string_f)-1):
            s+='.'
        if string[i] == '1':
            st = i+1
            break
    for i in range(st,len(string)):
        
        if string[i] == '1':
            s += '0' 
        else:
            s += '1' 
        if(i == len(string_f)-1):
            s+='.'
    
    return s[::-1]



def float_to_bin(x,typ):
    sign = 1
    if x<0:
        x *= -1
        sign = -1
    num,fraction = str(float(x)).split(".")
    num = int(num)
    fraction = x-num
    # convert num to binary
    num_bin = ''
    while (num != 0):
        num_bin = str(num%2) + num_bin
        num = int(num/2)
    
    
    #convert fraction to binary
    fraction_bin = ''
    i = 0
    while(fraction != 0 and i < 16):
        fraction *= 2
        fraction_bin += str(int(fraction))
        if fraction>=1:
            fraction -= 1
        
        i += 1
    
    if sign == -1 and typ == "s":
        return '1'+twos_complement(num_bin,fraction_bin)
    
    return '0'+num_bin+'.'+fraction_bin


def bin_to_float (string):
    a1,a2 = string.split(".")
    scale_f = 2**(-1*len(a2))

    a_bin = a1+a2
    a_bin = a_bin[::-1]

    sign = 1
    if (a_bin[-1] == '1'):
        sign = -1
        st = 0
        aa = ''
        for i in range(len(a_bin)):
            aa  += a_bin[i]
            if a_bin[i] == '1':
                st = i+1
                break
        for i in range(st,len(a_bin)-1):
            if a_bin[i] == '1':
                aa += '0' 
            else:
                aa += '1' 

        a_bin = aa

    decimal = 0
    for i in range(len(a_bin)):
        decimal += int(a_bin[i])*(2**i)
    decimal = decimal * scale_f * sign
    return decimal

def test(A,B,op):
    A_a = A[4:]
    B_b = B[4:]
    scale_A = bin_to_float('0'+A[0:4]+'.')
    scale_B = bin_to_float('0'+B[0:4]+'.')
    A_a = A_a[::-1]
    B_b = B_b[::-1]
    inputA = A_a[:scale_A] + '.' + A_a[scale_A:]
    inputB = B_b[:scale_B] + '.' + B_b[scale_B:]
    inputA = inputA[::-1]
    inputB = inputB[::-1]
    inputA_f = bin_to_float(inputA)
    inputB_f = bin_to_float(inputB)

    if op == '+':
        output_f = inputA_f+inputB_f
        scale_out = 11 + np.minimum(scale_A,scale_B)
        size_of_num = 24 - scale_out


    elif op == '*':
        output_f = inputA_f*inputB_f
        scale_out = scale_A+scale_B
        size_of_num = 24 - scale_out


    output_bin = float_to_bin(output_f,"s")
    
    num,fraction = output_bin.split(".")

    #extend fraction 
    while(len(fraction)<scale_out):
        fraction += "0"
    if (len(fraction)>scale_out):
        fraction = fraction[:scale_out]
   
    #sign extend to num
    while(len(num) < size_of_num):
        num = num[0]+num
    if(len(num) > size_of_num):
        num = num[:size_of_num]

    scale_out_str = float_to_bin(scale_out,"u")[1:-1]
    while(len(scale_out_str) < 5):
        scale_out_str = '0'+scale_out_str
    if(len(scale_out_str) > 5):
        scale_out_str = scale_out_str[:5]
        
    output = scale_out_str+num+fraction
   

    
    return output

print(test("1100010111010010","1001110110110000","*"))

