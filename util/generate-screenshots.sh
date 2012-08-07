#!/bin/bash
output_file="out.wordpress"
rm *.jpg
rm ${output_file}

while IFS= read -r N; do 
	filename=`echo "${N}" | sed 's/^\.\///'`
	echo "<h2>${filename}</h2>" >> ${output_file}
	output=`ruby convertor.rb "${N}"`
	ruby convertor.rb "${N}" > runme.sh
	chmod +x runme.sh
	./runme.sh
	echo "<pre>" >> ${output_file}
	echo "${output}" >> ${output_file}
	echo "</pre>" >> ${output_file}
	reset; ./colortest.sh
	scrot -s "${N}.jpg"
	echo "$N"; 
	echo "" >> ${output_file}
	url=`echo "http://www.sharms.org/blog/wp-content/uploads/2012/08/${filename}.jpg" | sed 's/\ /-/'`
	echo "<img src=\"${url}\" />" >> ${output_file}
	echo "" >> ${output_file}
done < <(find . -iname "*.itermcolors" -type f)

