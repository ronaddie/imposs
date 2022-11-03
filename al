alias e="gvim -p imposs.tex al makefile bmake.sh &"
alias v="make view"
alias x="make xview"
alias xa="make xviewans"
alias p="make imposs.pdf"
alias b="bibtex imposs"
alias pr="make print"
alias sa="more al"
alias wimposs="if [ -d /home/addie/usq/pg/PhD/Kaled/mypapers/impossible ]; then cd /home/addie/usq/pg/PhD/Kaled/mypapers/impossible; else cd /home/addie/usq/pg/PhD/Kaled/mypapers; cvs -d  checkout ; cd ; fi; source ./al"
export CVSROOT=/home/addie/usq/pg/PhD/Kaled/mypapers/CVS
./bmake.sh &
newpaper -upd imposs
