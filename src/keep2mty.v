`timescale 1ps/1ps

module keep2mty (
	input wire [15:0] tkeep,
	output reg [3:0] mty
);
	always @ (*) begin
		if (tkeep == 16'b1111111111111111) begin
			mty = 4'd0;
		end
		else if (tkeep == 16'b1111111111111110) begin
			mty = 4'd1;
		end
		else if (tkeep == 16'b1111111111111100) begin
			mty = 4'd2;
		end
		else if (tkeep == 16'b1111111111111000) begin
			mty = 4'd3;
		end
		else if (tkeep == 16'b1111111111110000) begin
			mty = 4'd4;
		end
		else if (tkeep == 16'b1111111111100000) begin
			mty = 4'd5;
		end
		else if (tkeep == 16'b1111111111000000) begin
			mty = 4'd6;
		end
		else if (tkeep == 16'b1111111110000000) begin
			mty = 4'd7;
		end
		else if (tkeep == 16'b1111111100000000) begin
			mty = 4'd8;
		end
		else if (tkeep == 16'b1111111000000000) begin
			mty = 4'd9;
		end
		else if (tkeep == 16'b1111110000000000) begin
			mty = 4'd10;
		end
		else if (tkeep == 16'b1111100000000000) begin
			mty = 4'd11;
		end
		else if (tkeep == 16'b1111000000000000) begin
			mty = 4'd12;
		end
		else if (tkeep == 16'b1110000000000000) begin
			mty = 4'd13;
		end
		else if (tkeep == 16'b1100000000000000) begin
			mty = 4'd14;
		end
		else if (tkeep == 16'b1000000000000000) begin
			mty = 4'd15;
		end
		else begin
			mty = 4'd0;
		end
	end
endmodule
