module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer errors;
  integer total;
  reg  [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  task check;
    begin
      #5;
      if (t_op == 1'b0)
        expected = t_a + t_b;
      else
        expected = t_a - t_b;

      total = total + 1;

      if (t_result !== expected) begin
        $display("FAIL at time %0t: a=%b b=%b op=%b  got result=%b  expected=%b",
                  $time, t_a, t_b, t_op, t_result, expected);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;

    // Same operand pair, switch op -- targets the sensitivity-list bug
    t_a = 4'd5; t_b = 4'd3;
    t_op = 0; check;
    t_op = 1; check;

    t_a = 4'd9; t_b = 4'd2;
    t_op = 0; check;
    t_op = 1; check;

    // Both operations again, with operands changing -- targets the
    // blocking/non-blocking bug in the subtract path
    t_a = 4'd7; t_b = 4'd7; t_op = 1; check;
    t_a = 4'd1; t_b = 4'd6; t_op = 1; check;
    t_a = 4'd15; t_b = 4'd1; t_op = 1; check;
    t_a = 4'd10; t_b = 4'd4; t_op = 0; check;
    t_a = 4'd3;  t_b = 4'd3; t_op = 0; check;
    t_a = 4'd0;  t_b = 4'd0; t_op = 1; check;

    $write("Summary: %0d / %0d passed", total - errors, total);
    if (errors == 0)
      $display(" -- ALL PASS");
    else
      $display(" -- %0d FAILURES", errors);

    $finish;
  end

endmodule