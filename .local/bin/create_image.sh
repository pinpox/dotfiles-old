name="image_"`date +"%y%m%d_%H%M%S"`.jpg
convert -size 800x500 xc:white $name
gpaint $name 
echo "![image]($name)"
