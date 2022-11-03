let tmo=1
let tcount=1
while true
do if [[  ! ( -f "imposs.pdf" )  || ( "imposs.tex" -nt "imposs.pdf" ) ]]
   then    make
       let tmo=1
       let tcount=1
   else let tcount=$tcount+1
       if [[ $tcount -lt 480 ]]
       then let tcount=$tcount+1
       else let tmo=2*$tmo
	    let tcount=1
       fi
   fi
   if [[ $tmo -gt 60 ]]
   then echo "Quitting bmake.sh due to inactivity.
"
        exit
   else sleep $tmo
   fi
done
