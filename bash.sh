for file in `ls *.nc`; do file1="${file//.nc/.dta}"; rm -i $file1; done
#   Remove *.dta corresponding to *.nc

cd ${some_dir}
if [ $? -ne 0 ]; then { echo "cd ${some_dir} failed. Aborting." ; exit 1; } fi
#   Halt if "cd" failed

