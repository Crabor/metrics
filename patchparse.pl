use Understand;
use warnings;
$db=Understand::open("/home/cyl/Desktop/udb/bash32.udb" );
my %bugdata;
open(OUT,'>>', '/home/cyl/Desktop//bugs/bugs.csv');
open(log_out,'>>','/home/cyl/Desktop/log_out.txt');
$path="/home/cyl/Desktop/patch/"; 
my $num=0;
while($num<57)
{
   # assert($cnum,int);
    jiaoben();
	$num=$num+1;
}
while (($k, $v) = each(%bugdata)) {
   
    if ($v>0)
    {
         print $k,',',$v,"\n";
        print OUT $k,',',$v,"\n";
    }
}
$db->close();
close(OUT);
sub initbugnumtable()
{
    print "-----------begin init bugnumtable--------";
    foreach my $func ($db->ents("function ~unknown ~unresolved"))
	{
		$bugdata{ $func->parent()->relname() . "*" . $func->name() } = 0;
	}
}
sub jiaoben()
{
    if($num<10)
	{$temp=$path."bash32-00".$num.".txt";
	$udb_name1="bash32-00".$num;}
else{
	$temp=$path."bash32-0".$num.".txt";
	$udb_name1="bash32-0".$num;}
	print("-------------first patch--------------\n");
	chdir('/home/cyl/Desktop/bash-3.2' );
	$order_patch="patch -p0 -t < ".$temp;
	$order_udb="'/home/cyl/Desktop/Understand-5.0.964-Linux-64bit/scitools/bin/linux64/und' create -db '/home/cyl/Desktop/udb/bash32first.udb' -languages c++ add '/home/cyl/Desktop/bash-3.2' analyze -all > /dev/null";
	system($order_patch);	
	system($order_udb);
	$numplus=$num+1;
	print("-------------second patch---------\n");
	chdir('/home/cyl/Desktop/copy');
	#my $path=`pwd`;
	#print $path,"\n";
	if ($numplus<10){
	$temp=$path."bash32-00".$numplus.".txt";
	$udb_name2="bash32-00".$numplus;}
else {
	$temp=$path."bash32-0".$numplus.".txt";
	$udb_name2="bash32-0".$numplus;
}
	$order_patch="patch -p0 -t  < ".$temp;
	$order_udb="'/home/cyl/Desktop/Understand-5.0.964-Linux-64bit/scitools/bin/linux64/und' create -db '/home/cyl/Desktop/udb/bash32second.udb' -languages c++ add '/home/cyl/Desktop/copy' analyze -all > /dev/null";
	system($order_patch);	
	system($order_udb);
	chdir('/home/cyl/Desktop/Understand-5.0.964-Linux-64bit/scitools/bin/linux64');
	print("--------get the change $udb_name1****$udb_name2-----------\n");
	yanzhuo();
	system("rm '/home/cyl/Desktop/udb/bash32first.udb' ");
	system("rm '/home/cyl/Desktop/udb/bash32second.udb' ");
	#last;

}
sub yanzhuo()
{
$db1=Understand::open("/home/cyl/Desktop/udb/bash32first.udb");
$db2=Understand::open("/home/cyl/Desktop/udb/bash32second.udb");
foreach $func1 ($db1->ents("Function"))
{	
	$funcname=$func1->name();
    $fileref1=$func1->ref("definein");

    next if (!defined $fileref1);

    foreach $func2 ($db2->lookup("$funcname","function"))
    {
    	$fileref2=$func2->ref("definein");
    	next if (!defined $fileref2);
    	$abspath=$fileref1->file()->relname();
    	$refpath=$fileref2->file()->relname();
	$refpath=~s/copy/bash-3.2/;
	
        if (($func1->name() eq $func2->name()) && ($abspath eq $refpath))
        
        #如果相对位置是对的，才是对应的文件
        { 
            if ($func1->contents() ne $func2->contents())
            { 

		print log_out "funcname",",",$func1->parent()->relname(),"\n",$func1->contents(),"\n--------------\n",$func2->contents(),"\n------------\n";
                $bugdata{$func1->parent()->relname() . "->" . $func1->name()}+=1;
            }
        }
    }
    }
$db1->close();
$db2->close();
}



