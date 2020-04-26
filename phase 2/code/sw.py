import random
import copy
def twosComp (sequence):
    s = copy.deepcopy(sequence)
    seq = ""
    
    toggle = False
    for i in range(len(s)-1 , -1 , -1):
        if toggle :
            if s[i] == '1':
                seq += '0'
            else:
                seq += '1'
        else:
            seq += s[i]
        if s[i] == '1' and toggle == False:
            toggle = True
            
    return seq[::-1]

def binaryToFloat(sequence,bits):
    s = copy.deepcopy(sequence)

    listbits = []
    listwieghts = []
    output =0
    
    sign = False
    if s[0] ==  '1':
        sign = True
        s = twosComp(s)
    for i,char in enumerate(s):
        listbits.append(int(char))
    for i in range (bits//2-1,-1,-1):
        listwieghts.append(pow(2,i))
    for i in range (1,bits//2+1):
        listwieghts.append(pow(2,-i))
    # print(listbits,listwieghts)
    for i in range(len(listbits)):
        output+=listbits[i]*listwieghts[i]

    if sign == True:
        output = -1 * output
    return output


def floatToBinary(number,bits):
    num = copy.deepcopy(number)
    sign = False
    if num < 0:
        sign = True
        num = -1 * num
    # print(num)
    decimalPart= bin(int(num))
    decimalPart = decimalPart.split('b')[1]
    fracionPart = num - int(num)
    fractionString = ""
    for i in range(bits//2):
        fracionPart = fracionPart*2
        # print(fracionPart)
        if( fracionPart>=1):
            fractionString += '1'
            fracionPart -=1
        else:
            fractionString +='0'
    for i in range (bits//2-len(decimalPart)):
        decimalPart = '0'+decimalPart
    out = decimalPart+fractionString
    # print(out)
    # print("hhhh",out)
    if sign == True:
        out = twosComp(out)
    # print("hhhh",out)
    # print(out)
    return(out)

# print(binaryToFloat("0000000100000000",16))
# print(floatToBinary(0.0078125,17))



def mat_mul (X,Y):
    X_c = copy.deepcopy(X)
    Y_c = copy.deepcopy(Y)
    rows = len(X_c)
    cols = len(Y_c[0])
    # result is 3x4
    result = [[0 for i in range(cols)] for j in range(rows)]


    # iterate through rows of X_c
    for i in range(len(X_c)):
        # iterate through columns of Y_c
        for j in range(len(Y_c[0])):
            # iterate through rows of Y_c
            for k in range(len(Y_c)):
                result[i][j] += X_c[i][k] * Y_c[k][j]

    # for r in result:
    #     print(r)
    return result


# 3x3 matrix
X = [[1,1,1],
    [4 ,5,6]]
# 3x4 matrix
Y = [[2,8,1,2],
    [2,7,3,0],
    [2,5,9,1]]
# print(mat_mul(X,Y))

def gen_random_num ():
    int_part = random.randint(0,4)
    floats = [ 2**j for j in range(-3,0) ]
    float_count = random.randint(0,len(floats))
    float_part = 0
    # float_count = 0
    for i in range(float_count):
        float_idx = random.randint(0,len(floats)-1)
        float_part += floats[float_idx]
    num = int_part+float_part
    sign = random.randint(0,1)
    if sign == 1:
        num = -1 * num
    return num

def generate_sizes ():
    num1 = random.randint(1,4)
    num4 = 1
    num2 = random.randint(1,4)
    num6 = random.randint(1,4)
    num5 = num1
    num8 = num4
    num3 = num2
    num7 = num6
    d = {
        'A':[num1,num2],
        'X':[num3,num4],
        'B':[num5,num6],
        'U':[num7,num8]
    }
    return d
def generate_matrix(size):
    rows = size[0]
    cols = size[1]
    result = [[gen_random_num() for i in range(cols)] for j in range(rows)]
    return result
def generate_matrices():
    sizes = generate_sizes ()
    A = generate_matrix(sizes['A'])
    X = generate_matrix(sizes['X'])
    B = generate_matrix(sizes['B'])
    U = generate_matrix(sizes['U'])
    AX = mat_mul(A,X)
    BU = mat_mul(B,U)
    result = AX
    for i in range(len(AX)):
        for j in range(len(AX[0])):
            result[i][j] = AX[i][j]+BU[i][j]

    d = {
        'A':A,
        'X':X,
        'B':B,
        'U':U,
        'result':result
    }
    return d

def float_to_binary_matrix(X):
    res = copy.deepcopy(X)
    for i in range(len(res)):
        for j in range(len(res[0])):
            res[i][j] = floatToBinary(res[i][j],16)
    return res
def float_to_binary_matrices(matrices):
    m = copy.deepcopy(matrices)
    A = m['A']
    X = m['X']
    B = m['B']
    U = m['U']
    result = m['result']
    A_bin = float_to_binary_matrix(A)
    X_bin = float_to_binary_matrix(X)
    B_bin = float_to_binary_matrix(B)
    U_bin = float_to_binary_matrix(U)
    result_bin = float_to_binary_matrix(result)
    d = {
        'A': A_bin,
        'X': X_bin,
        'B': B_bin,
        'U': U_bin,
        'result': result_bin
    }
    return d

   
matrices_as_float = generate_matrices()
matrices_as_binary = float_to_binary_matrices(matrices_as_float)
print(matrices_as_float)
print(matrices_as_binary)
print("llll")
print(matrices_as_float['A'][0])
A_row = matrices_as_float['A'][0]
X = matrices_as_float['X']
B_row = matrices_as_float['B'][0]
U = matrices_as_float['U']
result = matrices_as_float['result'][0]

X = [item for sublist in X for item in sublist]
U = [item for sublist in U for item in sublist]

N = len(A_row)
M = len(B_row)
AX = []
for i in range(len(A_row)):
    AX.append(A_row[i]*X[i])

BU = []
for i in range(len(B_row)):
    BU.append(B_row[i]*U[i])
s = 0
for i in range(len(BU)):
    s+=BU[i]
for i in range(len(AX)):
    s+=AX[i]
print(s)

res = floatToBinary(s,16)
# print(res)

for i in range(len(A_row)):
    A_row[i] = floatToBinary(A_row[i],16)

for i in range(len(X)):
    X[i] = floatToBinary(X[i],16)

for i in range(len(B_row)):
    B_row[i] = floatToBinary(B_row[i],16)

for i in range(len(U)):
    U[i] = floatToBinary(U[i],16)


print("A")
print (A_row)
print ("X")
print(X)
print("B")
print(B_row)
print("U")
print(U)
print("result")
print(res)
print("N: ",N)
print("M: ",M)

with open('A.txt', 'w+') as the_file:
    for i in A_row:
        the_file.write(i+'\n')

with open('B.txt', 'w+') as the_file:
    for i in B_row:
        the_file.write(i+'\n')
with open('U.txt', 'w+') as the_file:
    for i in U:
        the_file.write(i+'\n')
with open('X.txt', 'w+') as the_file:
    for i in X:
        the_file.write(i+'\n')

with open('result.txt', 'w+') as the_file:
    the_file.write(res+'\n')

M = floatToBinary(M,16)[0:8]
N = floatToBinary(N,16)[0:8]

with open('MN.txt', 'w+') as the_file:
    the_file.write(M+' '+N)


i = "0000000000000000"
with open('A.txt', 'a') as the_file:
    the_file.write(i+'\n')
    the_file.write(i+'\n')
    the_file.write(i)
with open('B.txt', 'a') as the_file:
    the_file.write(i+'\n')
    the_file.write(i+'\n')
    the_file.write(i)
with open('U.txt', 'a') as the_file:
    the_file.write(i+'\n')
    the_file.write(i+'\n')
    the_file.write(i)
with open('X.txt', 'a') as the_file:
    the_file.write(i+'\n')
    the_file.write(i+'\n')
    the_file.write(i)

