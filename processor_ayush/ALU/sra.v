module sra(A, shiftamt, result);
    input [31:0] A;
    input [4:0] shiftamt;

    output [31:0] result;

    wire [31:0] result16, result8, result4, result2, result1, in8, in4, in2, in1;
    wire MSB = A[31];

    //16 bit shifter
    assign result16[31] = MSB;
    assign result16[30] = MSB;
    assign result16[29] = MSB;
    assign result16[28] = MSB;
    assign result16[27] = MSB;
    assign result16[26] = MSB;
    assign result16[25] = MSB;
    assign result16[24] = MSB;
    assign result16[23] = MSB;
    assign result16[22] = MSB;
    assign result16[21] = MSB;
    assign result16[20] = MSB;
    assign result16[19] = MSB;
    assign result16[18] = MSB;
    assign result16[17] = MSB;
    assign result16[16] = MSB;

    assign result16[15] = A[31];
    assign result16[14] = A[30];
    assign result16[13] = A[29];
    assign result16[12] = A[28];
    assign result16[11] = A[27];
    assign result16[10] = A[26];
    assign result16[9]  = A[25];
    assign result16[8]  = A[24];
    assign result16[7]  = A[23];
    assign result16[6]  = A[22];
    assign result16[5]  = A[21];
    assign result16[4]  = A[20];
    assign result16[3]  = A[19];
    assign result16[2]  = A[18];
    assign result16[1]  = A[17];
    assign result16[0]  = A[16];



    //8 bit shifter
    assign result8[31] = MSB;
    assign result8[30] = MSB;
    assign result8[29] = MSB;
    assign result8[28] = MSB;
    assign result8[27] = MSB;
    assign result8[26] = MSB;
    assign result8[25] = MSB;
    assign result8[24] = MSB;
    assign result8[23] = MSB;

    assign result8[23] = in8[31];
    assign result8[22] = in8[30];
    assign result8[21] = in8[29];
    assign result8[20] = in8[28];
    assign result8[19] = in8[27];
    assign result8[18] = in8[26];
    assign result8[17] = in8[25];
    assign result8[16] = in8[24];
    assign result8[15] = in8[23];
    assign result8[14] = in8[22];
    assign result8[13] = in8[21];
    assign result8[12] = in8[20];
    assign result8[11] = in8[19];
    assign result8[10] = in8[18];
    assign result8[9]  = in8[17];
    assign result8[8]  = in8[16];
    assign result8[7]  = in8[15];
    assign result8[6]  = in8[14];
    assign result8[5]  = in8[13];
    assign result8[4]  = in8[12];
    assign result8[3]  = in8[11];
    assign result8[2]  = in8[10];
    assign result8[1]  = in8[9];
    assign result8[0]  = in8[8];


    //4 bit shifter
    assign result4[31] = MSB;
    assign result4[30] = MSB;
    assign result4[29] = MSB;
    assign result4[28] = MSB;

    assign result4[27] = in4[31];
    assign result4[26] = in4[30];
    assign result4[25] = in4[29];
    assign result4[24] = in4[28];
    assign result4[23] = in4[27];
    assign result4[22] = in4[26];
    assign result4[21] = in4[25];
    assign result4[20] = in4[24];
    assign result4[19] = in4[23];
    assign result4[18] = in4[22];
    assign result4[17] = in4[21];
    assign result4[16] = in4[20];
    assign result4[15] = in4[19];
    assign result4[14] = in4[18];
    assign result4[13] = in4[17];
    assign result4[12] = in4[16];
    assign result4[11] = in4[15];
    assign result4[10] = in4[14];
    assign result4[9]  = in4[13];
    assign result4[8]  = in4[12];
    assign result4[7]  = in4[11];
    assign result4[6]  = in4[10];
    assign result4[5]  = in4[9];
    assign result4[4]  = in4[8];
    assign result4[3]  = in4[7];
    assign result4[2]  = in4[6];
    assign result4[1]  = in4[5];
    assign result4[0]  = in4[4];

    
    //2 bit shifter

    assign result2[31] = MSB;
    assign result2[30] = MSB;

    assign result2[29] = in2[31];
    assign result2[28] = in2[30];
    assign result2[27] = in2[29];
    assign result2[26] = in2[28];
    assign result2[25] = in2[27];
    assign result2[24] = in2[26];
    assign result2[23] = in2[25];
    assign result2[22] = in2[24];
    assign result2[21] = in2[23];
    assign result2[20] = in2[22];
    assign result2[19] = in2[21];
    assign result2[18] = in2[20];
    assign result2[17] = in2[19];
    assign result2[16] = in2[18];
    assign result2[15] = in2[17];
    assign result2[14] = in2[16];
    assign result2[13] = in2[15];
    assign result2[12] = in2[14];
    assign result2[11] = in2[13];
    assign result2[10] = in2[12];
    assign result2[9]  = in2[11];
    assign result2[8]  = in2[10];
    assign result2[7]  = in2[9];
    assign result2[6]  = in2[8];
    assign result2[5]  = in2[7];
    assign result2[4]  = in2[6];
    assign result2[3]  = in2[5];
    assign result2[2]  = in2[4];
    assign result2[1]  = in2[3];
    assign result2[0]  = in2[2];


    //1 bit shifter

    assign result1[31] = MSB;

    assign result1[30] = in1[31];
    assign result1[29] = in1[30];
    assign result1[28] = in1[29];
    assign result1[27] = in1[28];
    assign result1[26] = in1[27];
    assign result1[25] = in1[26];
    assign result1[24] = in1[25];
    assign result1[23] = in1[24];
    assign result1[22] = in1[23];
    assign result1[21] = in1[22];
    assign result1[20] = in1[21];
    assign result1[19] = in1[20];
    assign result1[18] = in1[19];
    assign result1[17] = in1[18];
    assign result1[16] = in1[17];
    assign result1[15] = in1[16];
    assign result1[14] = in1[15];
    assign result1[13] = in1[14];
    assign result1[12] = in1[13];
    assign result1[11] = in1[12];
    assign result1[10] = in1[11];
    assign result1[9]  = in1[10];
    assign result1[8]  = in1[9];
    assign result1[7]  = in1[8];
    assign result1[6]  = in1[7];
    assign result1[5]  = in1[6];
    assign result1[4]  = in1[5];
    assign result1[3]  = in1[4];
    assign result1[2]  = in1[3];
    assign result1[1]  = in1[2];
    assign result1[0]  = in1[1];



    // mux logic
    mux_2 AFTER16(in8, shiftamt[4], A, result16);
    mux_2 AFTER8(in4, shiftamt[3], in8, result8);
    mux_2 AFTER4(in2, shiftamt[2], in4, result4);
    mux_2 AFTER2(in1, shiftamt[1], in2, result2);
    mux_2 AFTER1(result, shiftamt[0], in1, result1);


endmodule