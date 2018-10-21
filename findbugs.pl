
use Understand;
use warnings;
$db1=Understand::open("/home/cyl/Desktop/udb/bash32-first.udb" );
$db2=Understand::open("/home/cyl/Desktop/udb/bash32-second.udb");
open(OUT,'>>', '/home/cyl/Desktop//bugs/bugs.csv');
#print OUT "funcname",',',"funcpath",",","bugnums","\n";
print "start\n";
my %bugdata;
my %name;
foreach $func1 ($db1->ents("Function"))
{
    $funcname=$func1->name();
    $fileref1=$func1->ref("definein");

    next if (!defined $fileref1);

    foreach $func2 ($db2->lookup($func1->name(),"Function"))
    {
    	$fileref2=$func2->ref("definein");
    	next if (!defined $fileref2);
    	$abspath=$fileref1->file()->relname();
	#print $abspath,",",($fileref2->file()->relname()),"\n";
$refpath=$fileref2->file()->relname();
	$refpath=~s/copy/bash-3.2/;


if ($abspath eq $file )

    #如果相对位置是对的，才是对应的文件
   { 

    $linecode1=$func1->metric("CountLineCode");
    $linecode2=$func2->metric("CountLineCode");
    $beginline1=$fileref1->line();

    $endline1=$fileref1->line()+$linecode1;

    $beginline2=$fileref2->line();

    $endline2=$fileref2->line()+$linecode2;

    my $flag=0;

    if($linecode1 eq $linecode2)
    {
	    $lexer1=$func1->lexer();
	    $lexer2=$func2->lexer();
	    
	   # next if (! $lexer1);
	    #next if (! $lexer2);
		$lexeme2 =$lexer2->lexemes($beginline2,$endline2);
		$lexeme1=$lexer1->lexemes($beginline1,$endline1);
		while(defined $lexeme1 && defined $lexeme2)
		{	
		print $funcname,",",$abspath,"****",$beginline1,$beginline2,"***",$lexeme1->text(),"-----",$lexeme2->text(),"\n";
		if(($lexeme1->text()) ne $lexeme2->text())
		{
			#print $funcname,",",$abspath,"****",$beginline1,$beginline2,"***",$lexeme1->text(),"-----",$lexeme2->text(),"\n";
			$flag=1;
			last;

		}
		$lexeme1=$lexeme1->next;
		$lexeme2=$lexeme2->next;
		
	  }


    }

    else{
	print $abspath,",",$linecode1,",",$linecode2,"\n";
	
      $flag=1;

    }



if ($flag==1)
    {
        if(exists($bugdata{$funcname}))
        {

            $bugdata{$funcname}=$bugdata{$funcname}+1;
        }

        else

        {

            $name{$funcname}=$abspath;

            $bugdata{$funcname}=1;

        }

    }
    last;
}
}
}



while (($k, $v) = each(%bugdata)) {
    print $name{$k},',',$k,',',$v,"\n";
    print OUT $name{$k},',',$k,',',$v,"\n";
}

close(OUT);




