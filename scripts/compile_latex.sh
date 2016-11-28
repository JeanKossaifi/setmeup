#! /bin/zsh
clear

###############################################################
#                                                             #
#    Bash script to create pdf files from  latex sources      #
#    Author: Jean Kossaifi <jean [dot] kossaifi[at]gmail.com> #
#                                                             #
#      **************************************************     #
#                                                             #
#                  CORE OPTIONS                               #
#                                                             #
###############################################################
# Pass the name of the file using -o and -n or set in here:
name="main"
output="${name}"

# If you change the default values, using the corresponding flag will
# set them to the OPPOSITE value :)
view=0
nobib=0
inplace=0
silent=0
cleanup=0

# Decide which software to use to visualise the output
if [[ `uname` == 'Linux' ]]; then
    viewpdf="evince"
elif [[ `uname` == 'Darwin' ]]; then
    viewpdf="open"
fi



###############################################################
#                    USAGE FUNCTION                           #
#                                                             #
#      **************************************************     #
#                                                             #
#                  Display usage                              #
#                                                             #
###############################################################
usage()
{
echo "*****************************************************"
cat << EOF
usage: $0 [-smbvhc] [-n source_file] [-o target_file]

This script compiles a latex document (by default main.tex)
By default, the source file is assumed to be in the current
 working directory.

TYPICAL USE:
	$0 -vs -n my_tex_script -o my_awesome_pdf

	This will compile your latex file into a pdf saving you the 
	verbose outputs but still showing you errors + bibtex errors.

BASIC OPTIONS:
   -h         Show this message

   -n         Name of the source file (default is main)

   -o         Name of the output pdf file (default is main)

   -b         NO BIBLIOGRAPHY
                Add this option if your pdf has no bibliography
   -v         View the result (default using open)
   -s         Silent compilation (=Do NOT display information)
   -c         Cleanup the temporary files

ADVANCED OPTIONS:
   -m         Move to the directory containing this script.
              If selected, the source file is assumed to be in the same
                  directory as this script.

By Jean KOSSAIFI <jean [dot] kossaifi [at] gmail.com>
EOF
echo "*****************************************************"
}


###############################################################
#                     PARSE OPTIONS                           #
###############################################################
while getopts ":n:o:smbvhc" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         n)
             name="${OPTARG:r}"
             ;;
         o)
             output=${OPTARG:r}
             ;;
         v)
			 view=$((1-${view}))
             ;;
         b) 
			 nobib=$((1-${nobib}))
             ;;
         d)
			 inplace=$((1-${inplace}))
             ;;
         s)
			 silent=$((1-${silent}))
             ;;
         c)
			 cleanup=$((1-${cleanup}))
             ;;
         \?)
			 echo "Invalid option: -$OPTARG" >&2
             usage
             exit
             ;;
     esac
done


echo "**********************************************************"
echo "*  Please have a seat while your pdf is being compiled!  *"
echo "**********************************************************"

###############################################################
#                    NECESSARY FILES                          #
###############################################################
temp_dir="latex_temp"

if [ -d $temp_dir ]
then
    echo "* Saving temporary file in existing folder ${temp_dir}."
else
	mkdir ${temp_dir}
    echo "* Creating folder ${temp_dir} for temporary files."
fi
sourcefile="${name}.tex"
target="${output}.pdf"
compiled="${temp_dir}/${name}.pdf"
aux="${temp_dir}/${name}.aux"


###############################################################
#           SUPPRESS OUTPUTS FROM COMMAND                     #
###############################################################
if [[ ($silent == 1) ]]; then
    noout() {
        "$@" >/dev/null 2>&1
    }
	makepdf="noout pdflatex -interaction=batchmode -output-directory=${temp_dir} $sourcefile"
else
    noout() {
        "$@"
    }
	makepdf="pdflatex -output-directory=${temp_dir} $sourcefile"
fi



###############################################################
#                     VIEW FUNCTION                           #
###############################################################
function view {
    if [[ ($view == 1) ]]; then
        echo "* Viewing the output pdf ..."
        $viewpdf $target 2> /dev/null &
        echo "   .. Done."
    fi
}


###############################################################
#                   COMPILE FUNCTION                          #
###############################################################
function compile {
	# Compile with or without bibtex
    eval $makepdf

	# Check if command was successful
	if [ $? -eq 0 ]; then
		echo "   .. Seems to be going fine so far :)"
	else
		echo "!! pdf creation FAILED!"
		if [ $silent -eq 1 ]; then
			echo "!! Rerunning without silent to get error message!"
			echo "**********************************************************"
			echo "*                Problematic run :                       *"
			echo "**********************************************************"
			pdflatex -output-directory=${temp_dir} $sourcefile
		fi
		exit
	fi

	# Run again and potentially add bib
    if [[ ($nobib == 1) ]]; then
        eval $makepdf;
    else 
		echo "**********************************************************"
		echo "*                Bibliography    :                       *"
		echo "**********************************************************"
		bibtex $aux
		if [ $? -eq 0 ]; then
			echo 
			echo "**** Bibliography creation went great :) ****"
		else
			echo "!! Error creating the bibliography, EXITING!"
			exit
		fi
		echo "**********************************************************"
		echo "*              Finalising the pdf :                      *"
		echo "**********************************************************"
		echo "* Additional run"
	    eval $makepdf && eval $makepdf;
    fi

    # Rename to the target name if it is different from the current one...
    if [ "$compiled" != "$target" ]; then
        mv ${compiled} ${target};
    fi
}


###############################################################
#                     MAIN "FUNCTION"                         #
###############################################################
# Move in the right directory if needed
if [[ ($inplace == 1) ]]; then
    echo "* Moving to the file's directory"
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd $DIR
fi

#compile
if [ -f ${sourcefile} ]; then
    echo "* Compiling pdf....."
    compile;
    echo "   .. Done."
    echo "* Removing compilation files..."
	if [[ ($cleanup == 1) ]]; then
		rm ${temp_dir}/*
		rmdir ${temp_dir}
	fi
    echo "   .. Done."
    view;
else
    echo "!! No source available for the file:' ${name} ' in the directory ${DIR} ."
    echo "   .. Maybe the pdf was not correctly created.."
fi

#move back
if [[ ($inplace == 1) ]]; then
    echo "* Moving back to the working directory"
    cd -
fi

echo "**********************************************************"
echo "* Congratulations, you are now the proud owner of a pdf! *"
echo "**********************************************************"


