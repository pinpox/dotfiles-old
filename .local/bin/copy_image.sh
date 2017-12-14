name="image_"`date +"%y%m%d_%H%M%S"`.jpg
scrot -s $name 
echo "![image]($name)"
