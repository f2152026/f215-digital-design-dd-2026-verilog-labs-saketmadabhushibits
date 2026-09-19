module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer errors;
  integer total;
  integer i, j;
  reg     exp_gt, exp_lt, exp_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    total  = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;

        // Compute expected values independently -- not by copying comp2's logic
        exp_gt = (t_a > t_b);
        exp_lt = (t_a < t_b);
        exp_eq = (t_a == t_b);

        total = total + 1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                    $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    $write("Summary: %0d / %0d passed", total - errors, total);
    if (errors == 0)
      $display(" -- ALL PASS");
    else
      $display(" -- %0d FAILURES", errors);

    $finish;
  end

endmodule