FROM oboberg/maf:stack-20181001
LABEL maintainer "boberg37@gmail.com"


USER docmaf
WORKDIR /home/docmaf

RUN mkdir repos && \
    cd repos && \
    git clone https://github.com/lsst/sims_maf.git && \
    git clone https://github.com/lsst/sims_data.git && \
    git clone https://github.com/lsst/oorb.git && \
    git clone https://github.com/lsst/sims_movingObjects.git && \
    cd ../


RUN source scl_source enable devtoolset-6; source /home/docmaf/stack/loadLSST.bash; \
    cd /home/docmaf/repos/oorb && \
    eupspkg -v 1 -e prep && \
    eupspkg -v 1 -e config && \
    eupspkg -v 1 -e build

WORKDIR /home/docmaf

RUN source scl_source enable devtoolset-6; source /home/docmaf/stack/loadLSST.bash; \
    eups declare sims_maf git -r ./repos/sims_maf -c && \
    eups declare sims_data git -r ./repos/sims_data -c && \
    eups declare oorb git -r ./repos/oorb -c && \
    eups declare sims_movingObjects git -r ./repos/sims_movingObjects -c && \
    eups declare pandas system -r none -m none && \
    cd && \
    cd repos && \
    cd sims_maf && \
    git checkout master && \
    setup sims_maf git && \
    cd && \
    cd repos && \
    cd sims_data && \
    git checkout master && \
    setup sims_data git && \
    cd && \
    cd repos && \
    cd sims_maf && \
    scons && \
    cd && \
    cd repos && \
    cd oorb && \
    setup oorb git && \
    cd /home/docmaf/repos/sims_movingObjects && \
    git checkout master  && \
    setup sims_movingObjects git && \
    scons && \
    cd ..

WORKDIR /home/docmaf

ADD --chown=docmaf:docmaf ./startup.sh /home/docmaf/startup.sh
ADD --chown=docmaf:docmaf ./.maf_profile /home/docmaf/.maf_profile
ADD --chown=docmaf:docmaf ./repo_pulls.sh /home/docmaf/repo_pulls.sh

USER docmaf

ENTRYPOINT ["/bin/bash", "--"]
CMD ["/home/docmaf/startup.sh"]
