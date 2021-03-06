/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  ---
 *
 *  The internal logic cell simulation library.
 *
 *  This Verilog library contains simple simulation models for the internal
 *  logic cells (_NOT_, _AND_, ...) that are generated by the default technology
 *  mapper (see "stdcells.v" in this directory) and expected by the "abc" pass.
 *
 */

module _NOT_(A, Y);
input A;
output Y;
assign Y = ~A;
endmodule

module _AND_(A, B, Y);
input A, B;
output Y;
assign Y = A & B;
endmodule

module _OR_(A, B, Y);
input A, B;
output Y;
assign Y = A | B;
endmodule

module _XOR_(A, B, Y);
input A, B;
output Y;
assign Y = A ^ B;
endmodule

module _MUX_(A, B, S, Y);
input A, B, S;
output reg Y;
always @* begin
	if (S)
		Y = B;
	else
		Y = A;
end
endmodule

module _DFF_N_(D, Q, C);
input D, C;
output reg Q;
always @(negedge C) begin
	Q <= D;
end
endmodule

module _DFF_P_(D, Q, C);
input D, C;
output reg Q;
always @(posedge C) begin
	Q <= D;
end
endmodule

module _DFF_NN0_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(negedge C or negedge R) begin
	if (R == 0)
		Q <= 0;
	else
		Q <= D;
end
endmodule

module _DFF_NN1_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(negedge C or negedge R) begin
	if (R == 0)
		Q <= 1;
	else
		Q <= D;
end
endmodule

module _DFF_NP0_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(negedge C or posedge R) begin
	if (R == 1)
		Q <= 0;
	else
		Q <= D;
end
endmodule

module _DFF_NP1_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(negedge C or posedge R) begin
	if (R == 1)
		Q <= 1;
	else
		Q <= D;
end
endmodule

module _DFF_PN0_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(posedge C or negedge R) begin
	if (R == 0)
		Q <= 0;
	else
		Q <= D;
end
endmodule

module _DFF_PN1_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(posedge C or negedge R) begin
	if (R == 0)
		Q <= 1;
	else
		Q <= D;
end
endmodule

module _DFF_PP0_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(posedge C or posedge R) begin
	if (R == 1)
		Q <= 0;
	else
		Q <= D;
end
endmodule

module _DFF_PP1_(D, Q, C, R);
input D, C, R;
output reg Q;
always @(posedge C or posedge R) begin
	if (R == 1)
		Q <= 1;
	else
		Q <= D;
end
endmodule

