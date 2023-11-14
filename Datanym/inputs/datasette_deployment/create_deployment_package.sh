#!/bin/bash

set -e
module_name=${1:?"Missing arg 1 for module_name"} # directory stuff is in (lambda_function.py, module_name.db, requirements.txt)
docker_container=${2:?"Missing Docker Container Name - Build the Dockerfile and provide the tag name (Usually requirements_binaries)"} 
database_name=${3:-$module_name.db} # Name of sqlite db file
output_directory=${4:-deployment_package} # Name of folder to put all stuff and dep wheels in that tf will point at
python_function_file=${5:-lambda_function.py} #Name of python file where lambda handler is

echo "Module Name*: $module_name"
echo "Docker Container*: $docker_container"
echo "Database Name: $database_name" 
echo "Output Directory: $output_directory"
echo "Python Function File: $python_function_file" 

cd $module_name

if [ -d "$output_directory" ]; then
	rm -r $output_directory
fi

mkdir $output_directory

cp $python_function_file $output_directory/ 
cp $database_name $output_directory/

echo docker run -t -v $(pwd):/mnt $docker_container /bin/sh -c "pip install -r /mnt/requirements.txt -t /mnt/$output_directory"

docker run -t -v $(pwd):/mnt $docker_container /bin/sh -c "pip install -r /mnt/requirements.txt -t /mnt/$output_directory"

echo 'Done'




