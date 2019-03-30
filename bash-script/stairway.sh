FILES=./*.blueprint
STAIRWAY_PATH=./stairway_plot_es

for f in $FILES
do
  java -cp $STAIRWAY_PATH Stairbuilder $f
  bash $(basename $f .blueprint).blueprint.sh
done
