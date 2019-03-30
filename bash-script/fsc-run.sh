# run fsc26 over all par file in single-pop parameter set
FILES=.*.par

for f in $FILES
do
  fsc26 -i $f -n3 -s0 -X -I -T -d
  echo 'finish run of par file $(basename $f .par)'
done
