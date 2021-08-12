#!/bin/bash

cd  /home/roborock_rc/Cinderella/
rm -f release_note.txt
touch release_note.txt

echo -e "\n" >> /home/roborock_rc/Cinderella/release_note.txt
echo -e "Nav release note: \n" >> /home/roborock_rc/Cinderella/release_note.txt
cd RoboScrub_Nav/
git log --pretty=format:"%h %cn %s " --graph -50 >> /home/roborock_rc/Cinderella/release_note.txt

echo -e "\n" >> /home/roborock_rc/Cinderella/release_note.txt
echo -e "Navigation release note: \n" >> /home/roborock_rc/Cinderella/release_note.txt
cd ../RoboScrub_RockNavigation/
git log --pretty=format:"%h %cn %s " --graph -50 >> /home/roborock_rc/Cinderella/release_note.txt

echo -e "\n" >> /home/roborock_rc/Cinderella/release_note.txt
echo -e "QT release note: \n" >> /home/roborock_rc/Cinderella/release_note.txt
cd ../RoboScrub_QT/
git log --pretty=format:"%h %cn %s " --graph -50 >> /home/roborock_rc/Cinderella/release_note.txt

echo -e "\n" >> /home/roborock_rc/Cinderella/release_note.txt
echo -e "System release note: \n" >> /home/roborock_rc/Cinderella/release_note.txt
cd ../RoboScrub_System/
git log --pretty=format:"%h %cn %s " --graph -50 >> /home/roborock_rc/Cinderella/release_note.txt
