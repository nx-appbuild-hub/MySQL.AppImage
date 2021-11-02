# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)
PORT:='33306'

all: clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/template


	apprepo --destination=$(PWD)/build appdir boilerplate mysql-server libselinux1

	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'ls $${HOME}/.mysql        > /dev/null 2>&1 || mkdir --parents $${HOME}/.mysql'                              >> $(PWD)/build/Boilerplate.AppDir/AppRun	
	echo 'ls $${HOME}/.mysql-server > /dev/null 2>&1 || mkdir --parents $${HOME}/.mysql-server'                       >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''		 																								      >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''		 																								      >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'ls $${HOME}/.mysql/my.cnf > /dev/null 2>&1 || cp --force $${APPDIR}/template/my.cnf $${HOME}/.mysql/my.cnf' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''		 																								      >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "HOME_ESCAPED=\$$(echo \$${HOME} | sed 's_/_\\\\\\\/_g')"                                                    >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''		 																								      >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'sed -i "s/\$${HOME}/$${HOME_ESCAPED}/g" $${HOME}/.mysql/my.cnf'                                             >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'sed -i "s/\$${USER}/$${USER}/g"         $${HOME}/.mysql/my.cnf'                                             >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'sed -i "s/\$${PORT}/$(PORT)/g"          $${HOME}/.mysql/my.cnf'                                             >> $(PWD)/build/Boilerplate.AppDir/AppRun		
	echo ''		 																								      >> $(PWD)/build/Boilerplate.AppDir/AppRun	
	echo ''		 																								      >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'INITSERVER="$${APPDIR}/bin/mysqld --defaults-file=$${HOME}/.mysql/my.cnf --initialize-insecure"'            >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'find $${HOME}/.mysql-server -type d -empty -exec bash -c "$${INITSERVER}" {} \; > /dev/null'  	          >> $(PWD)/build/Boilerplate.AppDir/AppRun	
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'rm -f $${HOME}/.mysql-server/undo_* > /dev/null 2>&1'                                                       >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'case "$${1}" in'                                                                                            >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  '--server') exec \$${APPDIR}/bin/mysqld       --defaults-file=\$${HOME}/.mysql/my.cnf    \$${*:2} ;;"     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  '--dump')   exec \$${APPDIR}/bin/mysqldump    --defaults-file=\$${HOME}/.mysql/my.cnf    \$${*:2} ;;"     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  '--safe')   exec \$${APPDIR}/bin/mysqld_safe  --defaults-file=\$${HOME}/.mysql/my.cnf    \$${*:2} ;;"     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  '--admin')  exec \$${APPDIR}/bin/mysqladmin   --defaults-file=\$${HOME}/.mysql/my.cnf    \$${*:2} ;;"     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  '--client') exec \$${APPDIR}/bin/mysql        --defaults-file=\$${HOME}/.mysql/my.cnf    \$${*:2} ;;"     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  *) \$${APPDIR}/bin/mysqld                     --defaults-file=\$${HOME}/.mysql/my.cnf    \$${@}  ;;"     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "esac"                                                                                                       >> $(PWD)/build/Boilerplate.AppDir/AppRun


	cp --force $(PWD)/AppDir/my.cnf        $(PWD)/build/Boilerplate.AppDir/template
	cp --force $(PWD)/AppDir/*.desktop     $(PWD)/build/Boilerplate.AppDir || true
	cp --force $(PWD)/AppDir/*.svg         $(PWD)/build/Boilerplate.AppDir || true
	cp --force $(PWD)/AppDir/*.png         $(PWD)/build/Boilerplate.AppDir || true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage  $(PWD)/build/Boilerplate.AppDir $(PWD)/MySQL.AppImage
	chmod +x $(PWD)/MySQL.AppImage

clean:
	rm -rf $(PWD)/build


