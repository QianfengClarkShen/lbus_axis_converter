`timescale 1ps / 1ps
module tb();
	reg gt_refclk_p;
	reg gt_refclk_n;
	reg init_clk;
	reg rst;
	reg traffic_rst;

	wire bus_clk;
	wire gt_port_n_0;
	wire gt_port_p_0;
	wire gt_port_n_1;
	wire gt_port_p_1;
	wire gt_port_n_2;
	wire gt_port_p_2;
	wire gt_port_n_3;
	wire gt_port_p_3;

    wire [511:0] m_axis_tdata;
    wire [63:0] m_axis_tkeep;
    wire m_axis_tlast;
    wire m_axis_tvalid;
    wire [511:0] s_axis_tdata;
    wire [63:0] s_axis_tkeep;
    wire s_axis_tlast;
    wire s_axis_tready;
    wire s_axis_tvalid;

    wire check_result;
    wire check_result_valid;
	wire send_done;
	wire rx_aligned;

	lbus_sim_wrapper lbus_sim_inst (
		.bus_clk(bus_clk),
		.gt_ref_clk_n(gt_refclk_n),
		.gt_ref_clk_p(gt_refclk_p),
		.gt_rx_gt_port_0_n(gt_port_n_0),
		.gt_rx_gt_port_0_p(gt_port_p_0),
		.gt_rx_gt_port_1_n(gt_port_n_1),
		.gt_rx_gt_port_1_p(gt_port_p_1),
		.gt_rx_gt_port_2_n(gt_port_n_2),
		.gt_rx_gt_port_2_p(gt_port_p_2),
		.gt_rx_gt_port_3_n(gt_port_n_3),
		.gt_rx_gt_port_3_p(gt_port_p_3),
		.gt_tx_gt_port_0_n(gt_port_n_0),
		.gt_tx_gt_port_0_p(gt_port_p_0),
		.gt_tx_gt_port_1_n(gt_port_n_1),
		.gt_tx_gt_port_1_p(gt_port_p_1),
		.gt_tx_gt_port_2_n(gt_port_n_2),
		.gt_tx_gt_port_2_p(gt_port_p_2),
		.gt_tx_gt_port_3_n(gt_port_n_3),
		.gt_tx_gt_port_3_p(gt_port_p_3),
		.init_clk(init_clk),
		.m_axis_tdata(m_axis_tdata),
		.m_axis_tkeep(m_axis_tkeep),
		.m_axis_tlast(m_axis_tlast),
		.m_axis_tvalid(m_axis_tvalid),
		.rst(rst),
		.s_axis_tdata(s_axis_tdata),
		.s_axis_tkeep(s_axis_tkeep),
		.s_axis_tlast(s_axis_tlast),
		.s_axis_tready(s_axis_tready),
		.s_axis_tvalid(s_axis_tvalid),
		.rx_aligned(rx_aligned),
		.usr_rst(traffic_rst)
	);

    traffic_verification # (
        .DWIDTH(512),
        .TX_TRAFFIC_FILE_IN("traffic_in.bin"),
        .RX_TRAFFIC_FILE_OUT("traffic_out.csv"),
        .RX_TRAFFIC_GOLDEN_FILE_IN("traffic_in_golden.csv")
    ) traffic_verification_inst (
        .tx_clk(bus_clk),
        .rx_clk(bus_clk),
        .rst(traffic_rst),
        .remote_send_done(send_done),
        .s_axis_tdata(m_axis_tdata),
        .s_axis_tkeep(m_axis_tkeep),
        .s_axis_tlast(m_axis_tlast),
        .s_axis_tvalid(m_axis_tvalid),
        .send_done(send_done),
        .m_axis_tready(s_axis_tready),
        .m_axis_tdata(s_axis_tdata),
        .m_axis_tkeep(s_axis_tkeep),
        .m_axis_tlast(s_axis_tlast),
        .m_axis_tvalid(s_axis_tvalid),
        .check_result(check_result),
        .check_result_valid(check_result_valid)
    );

    initial begin
        rst = 1;
		traffic_rst = 1;
		repeat (100) @(posedge init_clk);
		rst = 0;
		wait(rx_aligned);
		repeat (500) @(posedge bus_clk);
		traffic_rst = 0;
    end

    initial begin
        wait(check_result_valid === 1);
        if (check_result === 1)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");
        $finish;
    end

	initial begin
		gt_refclk_p = 1;
		forever #1551.515 gt_refclk_p = ~ gt_refclk_p;
	end
	initial begin
		gt_refclk_n = 0;
		forever #1551.515 gt_refclk_n = ~ gt_refclk_n;
	end

	initial begin
		init_clk = 1;
		forever #2500.000 init_clk = ~ init_clk;
	end

endmodule
