#!/usr/bin/perl -w 

use English;

@benchmarks = (
"CONS", 
"SCP");  

@file_list = (
"CUDA/CONS/output_CONS.txt", 
"CUDA/SCP/output_SCP.txt", 
);

$result_file = "all_results.txt";

open(OUTPUT, ">$result_file") || die "Cannot open file $result_file for writing\n";

for ($j = 0; $j <= $#file_list; $j++) 
{  
	my $ipc = `grep gpu_tot_ipc $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
	chomp($ipc);
	push @globalipc, $ipc;
	
	my $ins = `grep gpu_tot_sim_insn $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
	chomp($ins);
	push @globalins, $ins;	
	
	my $row_locality = `grep "average row locality" $file_list[$j] | tail -n 1 | awk '\{print \$7\}'`;
	chomp($row_locality);
    	push @globalrow_locality, $row_locality;
	
	my $averagemflatency = `grep "averagemflatency" $file_list[$j] | tail -n 1 |  awk '\{print \$3\}'`;
	chomp($averagemflatency);
    	push @globalaveragemflatency, $averagemflatency;

	@dram_util = `grep "bw_util" $file_list[$j] | tail -n 6 |  awk '\{print \$14\}' |  awk -F '=' '\{print \$2\}'`;
	chomp(@dram_util);
	push @globaldram_util, [avg(\@dram_util)];
	
} 
	print OUTPUT "Benchmarks \t";
	print OUTPUT "IPC\t";
	print OUTPUT "INS\t";
	print OUTPUT "RBL \t";
	print OUTPUT "AVGEMF \t";
	print OUTPUT "DRAM-Util \t";
	print OUTPUT "\n";

for ($k = 0;$k <= $#file_list;$k++) 
{
	print OUTPUT "$benchmarks[$k] \t";
	print OUTPUT "$globalipc[$k] \t";
	print OUTPUT "$globalins[$k] \t";
	print OUTPUT "$globalrow_locality[$k] \t";
	print OUTPUT "$globalaveragemflatency[$k] \t";
	print OUTPUT "$globaldram_util[$k][0] \t";
	print OUTPUT "$globalstat_avg_locality_count[$k] \t";
	
	print OUTPUT "\n";
}

sub avg {
	@_ == 1 or die ('Sub usage: $avg = avg(\@array);');
	my ($array_ref) = @_;
	my $sum;
	my $count = scalar @$array_ref;
        if ($count == 0) {
                return 0;
        }
	foreach (@$array_ref) { $sum += $_; }
	return $sum / $count;
}

sub max {
	@_ == 1 or die ('Sub usage: $max = max(\@array);');
	my ($array_ref) = @_;
	my $maxval = -999999999999999999;
	foreach (@$array_ref)
	{
		if ( $maxval < $_ )
		{
			$maxval = $_;
		}
	}
	return $maxval;
}

sub sum {
	@_ == 1 or die ('Sub usage: $sum = sum(\@array);');
	my ($array_ref) = @_;
	my $sum;
	foreach (@$array_ref) { $sum += $_; }
	return $sum;
}
