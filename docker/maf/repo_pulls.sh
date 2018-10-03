#!/bin/bash

source scl_source enable devtoolset-6; source /home/docmaf/stack/loadLSST.bash

eups declare sims_maf git -r /home/docmaf/repos/sims_maf -c
eups declare sims_data git -r /home/docmaf/repos/sims_data -c
cd /home/docmaf/repos/sims_maf
git pull
git checkout master
setup sims_maf git
cd /home/docmaf/repos/sims_data
git pull
git checkout master
setup sims_data git
cd /home/docmaf/repos/sims_maf
scons
cd /home/docmaf
source scl_source enable devtoolset-6; source /home/docmaf/stack/loadLSST.bash
/bin/bash --rcfile /home/docmaf/.maf_profile
