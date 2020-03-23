module zero_latency_axis_fifo #
(
	parameter DATA_WIDTH	=	32,
	parameter FIFO_DEPTH	=	512,
	parameter HAS_DATA	=	1,
	parameter HAS_KEEP	=	1,
	parameter HAS_LAST	=	1,
	parameter RAM_STYLE	=	"auto"
)
(
	input wire clk,
	input wire rst,
	input wire [DATA_WIDTH-1:0] s_axis_tdata,
	input wire [DATA_WIDTH/8-1:0] s_axis_tkeep,
	input wire s_axis_tlast,
	input wire s_axis_tvalid,
	input wire m_axis_tready,
	output wire s_axis_tready,
	output wire [DATA_WIDTH-1:0] m_axis_tdata,
	output wire [DATA_WIDTH/8-1:0] m_axis_tkeep,
	output wire m_axis_tlast,
	output wire m_axis_tvalid,
	output wire [$clog2(FIFO_DEPTH):0] data_cnt
);
	localparam LUT_DEPTH = FIFO_DEPTH > 16 ? 16 : FIFO_DEPTH;
	(* ram_style = RAM_STYLE *) reg [DATA_WIDTH+DATA_WIDTH/8:0] axis_bram[FIFO_DEPTH-1:0];
	reg [DATA_WIDTH+DATA_WIDTH/8:0] axis_lutram[LUT_DEPTH-1:0];
	reg [$clog2(FIFO_DEPTH)-1:0] bram_rd_idx;
	reg [$clog2(FIFO_DEPTH)-1:0] bram_wr_idx;
	reg [DATA_WIDTH+DATA_WIDTH/8:0] bram_reg_1, bram_reg_2;
	reg [$clog2(LUT_DEPTH)-1:0] lutram_rd_idx;
	reg [$clog2(LUT_DEPTH)-1:0] lutram_wr_idx;
	reg bram_valid_1, bram_valid_2;
	reg bram_to_lutram, bram_to_lutram_1, bram_to_lutram_2;
	reg [$clog2(FIFO_DEPTH)-1:0] data_cnt_reg;

	wire [DATA_WIDTH-1:0] data_from_fifo;
	wire [DATA_WIDTH/8-1:0] keep_from_fifo;
	wire last_from_fifo;

	wire [DATA_WIDTH-1:0] data_in;
	wire [DATA_WIDTH/8-1:0] keep_in;
	wire last_in;

	wire lutram_valid;
	wire lutram_ready;
	wire bram_ready;
	wire bram_not_empty;
	wire input_to_output;
	wire input_to_lutram;
	wire input_to_bram;
	wire [$clog2(FIFO_DEPTH)-1:0] bram_cnt;
	wire [$clog2(LUT_DEPTH)-1:0] lut_cnt;

	if (FIFO_DEPTH > 16) begin
		always @(posedge clk) begin
			bram_reg_1 <= axis_bram[bram_rd_idx];
			bram_reg_2 <= bram_reg_1;
		end
		always @(posedge clk) begin
			if (rst) begin
				lutram_rd_idx <= {{$clog2(LUT_DEPTH)}{1'b0}};
				lutram_wr_idx <= {{$clog2(LUT_DEPTH)}{1'b0}};
				bram_rd_idx <= {{$clog2(FIFO_DEPTH)}{1'b0}};
				bram_wr_idx <= {{$clog2(FIFO_DEPTH)}{1'b0}};
				bram_valid_1 <= 1'b0;
				bram_valid_2 <= 1'b0;
				bram_to_lutram <= 1'b0;
				bram_to_lutram_1 <= 1'b0;
				bram_to_lutram_2 <= 1'b0;
				data_cnt_reg <= {{$clog2(FIFO_DEPTH)+1}{1'b0}};
			end
			else begin
				if (bram_ready & input_to_bram) begin
					axis_bram[bram_wr_idx] <= {last_in, keep_in, data_in};
					bram_wr_idx <= bram_wr_idx + 1'b1;
				end

				if (input_to_lutram)
					axis_lutram[lutram_wr_idx] <= {last_in, keep_in, data_in};
				else if (bram_to_lutram_2 & bram_valid_2)
					axis_lutram[lutram_wr_idx] <= bram_reg_2;

				if (input_to_lutram | (bram_to_lutram_2 & bram_valid_2))
					lutram_wr_idx <= lutram_wr_idx + 1'b1;

				if (bram_rd_idx != bram_wr_idx && bram_to_lutram)
					bram_rd_idx <= bram_rd_idx + 1'b1;

				bram_valid_1 <= bram_rd_idx != bram_wr_idx;
				bram_valid_2 <= bram_valid_1;

				bram_to_lutram_1 <= bram_to_lutram;
				bram_to_lutram_2 <= bram_to_lutram_1;

				if (lutram_rd_idx + 3'd4 == lutram_wr_idx)
					bram_to_lutram <= 1'b1;
				else if (lutram_wr_idx + 3'd5 == lutram_rd_idx)
					bram_to_lutram <= 1'b0;

				if (m_axis_tready && lutram_rd_idx != lutram_wr_idx)
					lutram_rd_idx <= lutram_rd_idx + 1'b1;

				data_cnt_reg <= bram_cnt + lut_cnt;
			end
		end
		assign s_axis_tready = bram_ready;
		assign bram_ready = bram_wr_idx + 1'b1 != bram_rd_idx;
		assign bram_not_empty = bram_rd_idx != bram_wr_idx || bram_valid_1 || bram_valid_2;
		assign input_to_bram = s_axis_tvalid & (bram_not_empty | ~lutram_ready);
	end
	else begin
		always @(posedge clk) begin
			if (rst) begin
				lutram_rd_idx <= {{$clog2(LUT_DEPTH)}{1'b0}};
				lutram_wr_idx <= {{$clog2(LUT_DEPTH)}{1'b0}};
				data_cnt_reg <= {{$clog2(FIFO_DEPTH)+1}{1'b0}};
			end
			else begin
				if (input_to_lutram) begin
					axis_lutram[lutram_wr_idx] <= {last_in, keep_in, data_in};
					lutram_wr_idx <= lutram_wr_idx + 1'b1;
				end
				if (m_axis_tready && lutram_rd_idx != lutram_wr_idx)
					lutram_rd_idx <= lutram_rd_idx + 1'b1;
				data_cnt_reg <= lut_cnt;
			end
		end
		assign s_axis_tready = lutram_ready;
		assign bram_ready = 1'b0;
		assign bram_not_empty = 1'b0;
		assign input_to_bram = 1'b0;
	end

	assign bram_cnt = bram_wr_idx - bram_rd_idx;
	assign lut_cnt = lutram_wr_idx - lutram_rd_idx;
	assign lutram_ready = lutram_wr_idx + 1'b1 != lutram_rd_idx;
	assign lutram_valid = lutram_rd_idx != lutram_wr_idx;

	assign input_to_output = ~lutram_valid & m_axis_tready;
	assign input_to_lutram = ~input_to_output & s_axis_tvalid & lutram_ready & ~bram_not_empty;

	assign m_axis_tdata = lutram_valid ? data_from_fifo : data_in;
	assign m_axis_tkeep = lutram_valid ? keep_from_fifo : keep_in;
	assign m_axis_tlast = lutram_valid ? last_from_fifo : last_in;
	assign m_axis_tvalid = lutram_valid ? 1'b1 : s_axis_tvalid;
	assign data_cnt = data_cnt_reg;

	assign data_from_fifo = axis_lutram[lutram_rd_idx][DATA_WIDTH-1:0];
	assign keep_from_fifo = axis_lutram[lutram_rd_idx][DATA_WIDTH+DATA_WIDTH/8:DATA_WIDTH];
	assign last_from_fifo = axis_lutram[lutram_rd_idx][DATA_WIDTH+DATA_WIDTH/8];

	assign data_in = HAS_DATA ? s_axis_tdata : {{DATA_WIDTH}{1'b0}};
	assign keep_in = HAS_KEEP ? s_axis_tkeep : {{DATA_WIDTH/8}{1'b0}};
	assign last_in = HAS_LAST ? s_axis_tlast : 1'b0;
endmodule
