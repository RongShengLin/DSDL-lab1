`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder, gate level modeling
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder, gate level modeling
module FA(output CO, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(CO, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	assign {C3, S} = A+B+C0;
endmodule

//  ripple-carry adder, gate level modeling
//  Do not modify the input/output of module
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	wire c_1;
    wire c_2;
    FA fa_1(c_1, S[0], A[0], B[0], C0);
    FA fa_2(c_2, S[1], A[1], B[1], c_1);
    FA fa_3(C3, S[2], A[2], B[2], c_2);
endmodule

// carry-lookahead adder, gate level modeling
// Do not modify the input/output of module
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	wire G0, G1, G2;
	wire P0, P1, P2;
	wire C1, C2;
	wire P0C0, G0P1, C0P0P1;
	AND g0(G0 ,A[0], B[0]);
	AND g1(G1, A[1], B[1]);
	AND g2(G2, A[2], B[2]);
	OR p0(P0, A[0], B[0]);
	OR p1(P1, A[1], B[1]);
	OR p2(P2, A[2], B[2]);
	AND p0c0(P0C0, P0, C0);
	AND g0p1(G0P1, G0, P1);
	AND4 c0p0p1(C0P0P1, 1, C0, P0, P1);
	OR c1(C1, G0, P0C0);
	OR4 c2(C2, 0, G1, G0P1, C0P0P1);
	wire c_1, c_2;
	FA fa_1(c_1, S[0], A[0], B[0], C0);
	FA fa_2(c_2, S[1], A[1], B[1], C1);
	FA fa_3(C3, S[2], A[2], B[2], C2);
	// TODO:: Implement gate-level CLA
endmodule

`endif
