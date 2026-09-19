// tb.v
// Starter testbench template -- YOU complete this file.

module tb;

  // TODO: declare the inputs and outputs
  reg  [2:0] t_sel;
  wire [7:0] t_dout;
  integer i;
  integer expected;
  // TODO: instantiate DUT here
  lut #(.WIDTH(8), .DEPTH(8)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );
  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
    for (i = 0; i < 8; i = i + 1) begin
      t_sel = i;
      #5;
      expected = i * i;
      if (t_dout !== expected)
        $display("FAIL at time %0t: sel=%0d  got dout=%0d  expected=%0d",
                  $time, t_sel, t_dout, expected);
      else
        $display("PASS at time %0t: sel=%0d  dout=%0d", $time, t_sel, t_dout);
    end
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout); // change as required

endmodule
