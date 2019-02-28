wget http://venera2.gric.dhz.hr/MGram/run00/14240_plume.png
wget http://venera2.gric.dhz.hr/MGram/run00/14240_ens.png

echo "Dobro jutro Ivane! " | mutt -s "ECWMF prognoza" -a 14240_ens.png 14240_plume.png -- ivan.guettler@cirus.dhz.hr

rm -vf 14240_plume.png
rm -vf 14240_ens.png
