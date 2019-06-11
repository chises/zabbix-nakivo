#!/usr/bin/perl -w
# created by Michael Weber

use JSON;
use File::Basename;

my $cmd;

sub printHelp {
    print "WRONG Usage!\n";
}

#check if number of argument is valid
if(@ARGV<2){
    printHelp();
    exit;
}
my $NAKIVO_USER = "user";
my $NAKIVO_PWD = "password";
my $NAKIVO_IP = $ARGV[0];
my $NAKIVO_ACTION = $ARGV[1]; #valid Actions: "--job-list" "--job-info"

# Setup the Nakivo check script
my $script_path = dirname(__FILE__);
my $script_to_check = "$script_path/cli.sh";
my $script_auth = "--host $NAKIVO_IP --port 4443 --username $NAKIVO_USER --password '$NAKIVO_PWD'";

#check what action provided
if($NAKIVO_ACTION eq "--job-list"){
    my @jobs;
    $cmd = "$script_to_check $NAKIVO_ACTION $script_auth" . ' 2>&1';
    my @cmd_result = `$cmd`;
    shift(@cmd_result);

    foreach my $entry (@cmd_result){
        my @entryRow = split '\|', $entry;
        for (@entryRow) {
            $_ =~ s/^\s+|\s+$//g
        }
        push(@jobs, \@entryRow);
    }

    $first = 1;

    print "{\n";
    print "\t\"data\":[\n\n";

    foreach my $job (@jobs){
        print "\t,\n" if not $first;
        $first = 0;

        print "\t{\n";
        print "\t\t\"{#ID}\":\"@$job[0]\",\n";
        print "\t\t\"{#NAME}\":\"@$job[1]\"\n";
        print "\t}\n";
    }

    print "\n\t]\n";
    print "}\n";
}
elsif($NAKIVO_ACTION eq "--job-info"){
    if(@ARGV<3){
        printHelp();
        exit;
    }
    my @columns;
    my $NAKIVO_ID = $ARGV[2];
    $cmd = "$script_to_check $NAKIVO_ACTION $NAKIVO_ID $script_auth" . ' 2>&1';
    my $cmd_result = `$cmd`;
    my @cmd_result = `$cmd`;
    shift(@cmd_result);

    foreach my $entry (@cmd_result){
        my @entryRow = split '\|', $entry;
        for (@entryRow) {
            $_ =~ s/^\s+|\s+$//g
        }
        push(@columns, @entryRow);
    }
    print $columns[$ARGV[3]];
}
