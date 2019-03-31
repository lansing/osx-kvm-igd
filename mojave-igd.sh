echo "Switch to MDP now"
for I in 5 4 3 2 1
do
  echo $I
  sleep 1
done
echo Booting
sudo /home/max/Code/osx-kvm-igd/boot-igd.sh
