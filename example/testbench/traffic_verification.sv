`timescale 1ps / 1ps
module traffic_verification #
(
	parameter DWIDTH = 128,
	parameter TX_TRAFFIC_FILE_IN = "tx.bin",
	parameter RX_TRAFFIC_FILE_OUT = "rx.csv",
	parameter RX_TRAFFIC_GOLDEN_FILE_IN = "rx_golden.csv"
)
(
	input wire tx_clk,
	input wire rx_clk,
	input wire rst,
	input wire remote_send_done,
	input wire [DWIDTH-1:0] s_axis_tdata,
	input wire [DWIDTH/8-1:0] s_axis_tkeep,
	input wire s_axis_tlast,
	input wire s_axis_tvalid,
	input wire m_axis_tready,
	output reg send_done,
	output wire [DWIDTH-1:0] m_axis_tdata,
	output wire [DWIDTH/8-1:0] m_axis_tkeep,
	output wire m_axis_tlast,
	output wire m_axis_tvalid,
	output reg check_result = 0,
	output reg check_result_valid = 0
);

	reg [511:0] data;
	reg [63:0] keep;
	reg last;
	reg valid;
	reg [511:0] meta_box;
	reg receive_done;
	reg [31:0] wr_cnt;
	reg [5:0] index;
	wire [DWIDTH-1:0] s_axis_tdata_int;
//send
	int traffic_in;
	initial begin
		send_done = 0;
		wr_cnt = 0;
		data = 0;
		keep = 0;
		last = 0;
		valid = 0;
		meta_box = 0;
		wait(rst === 0);
		traffic_in = $fopen (TX_TRAFFIC_FILE_IN, "rb");
		//sync to tx clock edge
		repeat (1) @(posedge tx_clk);
		$fseek(traffic_in,24,0);
		while (!$feof(traffic_in)) begin
			$fread(meta_box,traffic_in);
			if($feof(traffic_in)) break;
			index = 0;
			while (index < 63) begin
				if (m_axis_tready) begin
					$fread(data,traffic_in);
					for (int i = 0; i < DWIDTH/8; i++) begin
						keep[i] = meta_box[7:1] > i;
					end
					last = meta_box[0];
					valid = meta_box[7:1] != 0 ? 1 : 0;
					meta_box = meta_box >> 8; 
					if (valid)
						wr_cnt = wr_cnt + 1;
					index = index + 1;
				end
				repeat (1) @(posedge tx_clk);
			end
		end
		$fclose(traffic_in);
		send_done = 1;
	end
//receive
	int yield_out;
	reg [31:0] rd_invalid_cnt;
	initial begin
		rd_invalid_cnt = 0;
		receive_done = 0;
		wait(rst === 0);
		yield_out = $fopen (RX_TRAFFIC_FILE_OUT, "w");
		$fdisplay(yield_out, "tdata,tkeep,tlast,tvalid");
		//sync to rx clock edge
		repeat (1) @(posedge rx_clk);
		while (rd_invalid_cnt < 500 || ~remote_send_done) begin
			if (s_axis_tvalid) begin
				$fdisplay(yield_out,"0x%x,0x%x,%d,%d",s_axis_tdata_int,s_axis_tkeep,s_axis_tlast,s_axis_tvalid);
				rd_invalid_cnt = 0;
			end
			else
				rd_invalid_cnt = rd_invalid_cnt + 1;
			repeat (1) @(posedge rx_clk);
		end
		$fclose(yield_out);
		receive_done = 1;
	end
//check
	string golden;
	string yield;
	reg [31:0] line_cnt;
	int golden_in;
	int yield_in;
	initial begin
		line_cnt = 0;
		check_result = 0;
		check_result_valid = 0;
		wait(rst === 0);
		wait(receive_done === 1);
		golden_in = $fopen (RX_TRAFFIC_GOLDEN_FILE_IN,"r");
		yield_in = $fopen (RX_TRAFFIC_FILE_OUT,"r");
		while(!$feof(golden_in) || !$feof(yield_in)) begin
			$fscanf(golden_in," %s\n", golden);
			$fscanf(yield_in," %s\n", yield);
			//str.compre --> not equal if non-zero
			if (golden.compare(yield)) begin
				check_result = 0;
				check_result_valid = 1;
				break;
			end
			line_cnt = line_cnt + 1;
		end
		if (check_result_valid !== 1) begin
			check_result = 1;
			check_result_valid = 1;
		end
	end

	genvar i;
	for (i = 0; i < DWIDTH/8; i=i+1) begin
		assign s_axis_tdata_int[DWIDTH-1-i*8:DWIDTH-8-i*8] = s_axis_tkeep[DWIDTH/8-1-i] ? s_axis_tdata[DWIDTH-1-i*8:DWIDTH-8-i*8] : 8'b0;
		assign m_axis_tdata[i*8+7:i*8] = data[511-i*8:504-i*8];
		assign m_axis_tkeep[DWIDTH/8-1-i] = keep[i];
	end

	assign m_axis_tlast = last;
	assign m_axis_tvalid = valid;

endmodule
