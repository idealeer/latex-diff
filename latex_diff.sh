#!/bin/bash
# simple script used to diff latex files by Xiang Li, version 1.0, 03/26/2023
# please install 'unzip' and 'latexdiff'


# all tex files to diff here
# please keep the same sequence
latex_file_modify=("0_abstract.tex" "1_introduction.tex" "2_background.tex")
latex_file_origin=("0_abstract.tex" "1_introduction.tex" "2_background.tex")
latex_file_num=13


# cmd p1: old zip file downloaded from overleaf
# cmd p2: new zip file downloaded from overleaf
# cmd p3: generated diff zip file uploaded to overleaf
origin_dir="$1"
modify_dir="$2"
diff_dir="$3"

rm -rf "${origin_dir}"
rm -rf "${modify_dir}"
rm -rf "${diff_dir}"


# depending on your zip cmd to remove '-d' or not
# please make sure there is only one-level parent folder, like:
# origin_dir
#	- abstract.tex
# not like:
# origin_dir
#	- origin_dir
#		- abstract.tex
unzip -q "${origin_dir}" "${origin_dir}.zip"
unzip -q "${modify_dir}.zip"
rm -rf "${diff_dir}.zip"

cp -r "${modify_dir}" "${diff_dir}"


for((i=0;i<${latex_file_num};i++));  
do
	cp "${origin_dir}/${latex_file_origin[${i}]}" "${diff_dir}/origin_${latex_file_origin[${i}]}"
	cp "${modify_dir}/${latex_file_modify[${i}]}" "${diff_dir}/modify_${latex_file_modify[${i}]}"
	rm "${diff_dir}/${latex_file_modify[${i}]}"
	cd "${diff_dir}"
	latexdiff -t UNDERLINE "origin_${latex_file_origin[${i}]}" "modify_${latex_file_modify[${i}]}" > "${latex_file_modify[${i}]}"
	rm "origin_${latex_file_origin[${i}]}"
	rm "modify_${latex_file_modify[${i}]}"
	cd ..
done


diff_dir="$3"
zip -q -r "${diff_dir}.zip" "${diff_dir}"


#####
# after uploading the generated file to overleaf
# add these references to your package.tex
#####
# %DIF PREAMBLE EXTENSION ADDED BY LATEXDIFF
# \RequirePackage[normalem]{ulem}
# \RequirePackage{color}\definecolor{RED}{rgb}{1,0,0}\definecolor{BLUE}{rgb}{0,0,1}
# \providecommand{\DIFadd}[1]{{\protect\color{blue}\uwave{#1}}}
# \providecommand{\DIFdel}[1]{{\protect\color{red}\sout{#1}}}
# \providecommand{\DIFaddbegin}{}
# \providecommand{\DIFaddend}{}
# \providecommand{\DIFdelbegin}{}
# \providecommand{\DIFdelend}{}
# \providecommand{\DIFmodbegin}{}
# \providecommand{\DIFmodend}{}
# \providecommand{\DIFaddFL}[1]{\DIFadd{#1}}
# \providecommand{\DIFdelFL}[1]{\DIFdel{#1}}
# \providecommand{\DIFaddbeginFL}{}
# \providecommand{\DIFaddendFL}{}
# \providecommand{\DIFdelbeginFL}{}
# \providecommand{\DIFdelendFL}{}
# \RequirePackage{listings}
# \RequirePackage{color}
# \lstdefinelanguage{DIFcode}{
#   moredelim=[il][\color{red}\sout]{\%DIF\ <\ },
#   moredelim=[il][\color{blue}\uwave]{\%DIF\ >\ }
# }
# \lstdefinestyle{DIFverbatimstyle}{
# 	language=DIFcode,
# 	basicstyle=\ttfamily,
# 	columns=fullflexible,
# 	keepspaces=true
# }
# \lstnewenvironment{DIFverbatim}{\lstset{style=DIFverbatimstyle}}{}
# \lstnewenvironment{DIFverbatim*}{\lstset{style=DIFverbatimstyle,showspaces=true}}{}
