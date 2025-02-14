python3 -m compileall -b .
sudo rm -r bin 
mkdir bin
mkdir ./bin/working_space
mkdir ./bin/images
cp *.pyc ./bin/
cp eHealthDevice ./bin/
cp ./working_space/*.jsn  ./bin/working_space
cp ./working_space/*.sh  ./bin/working_space
cp ./working_space/AmazonRootCA1.* ./bin/working_space
cp ./images/*.png ./bin/images

BASEDIR=$(realpath $(dirname $0))

echo "cd ${BASEDIR}/bin" >> ./bin/start_gui.sh
echo "sudo chmod 777 eHealthDevice" >> ./bin/start_gui.sh
echo "python3 main.pyc" >> ./bin/start_gui.sh

git log -1 --format="%H" >> ./bin/commit_info
sudo chmod 777 ./bin/start_gui.sh
rm *.pyc
sudo rm ${BASEDIR}/start_gui.sh 2> /dev/null
sudo ln -s ${BASEDIR}/bin/start_gui.sh  ${BASEDIR}/start_gui.sh
