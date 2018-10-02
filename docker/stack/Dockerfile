FROM lsstsqre/centos:7-stackbase-devtoolset-6
LABEL maintainer "boberg37@gmail.com"


ENV USER ${USER:-docmaf}
ENV HOME /home/docmaf

# Create user and group
RUN groupadd docmaf && adduser -m -g docmaf -s /bin/bash docmaf

USER root

RUN yum remove -y git

RUN yum groupinstall -y "Development Tools"

RUN yum install -y gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel

WORKDIR /home/docmaf

# Update git
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.14.1.tar.gz
RUN tar -zxf git-2.14.1.tar.gz
WORKDIR /home/docmaf/git-2.14.1
RUN /home/docmaf/git-2.14.1/configure; \
    make && \
    make install && \
    hash -r

WORKDIR /home/docmaf

RUN rm -rf /home/docmaf/git-2.14.1
RUN rm git-2.14.1.tar.gz

WORKDIR /home/docmaf

USER docmaf
WORKDIR /home/docmaf

RUN source scl_source enable devtoolset-6; \
    mkdir stack && \
    cd stack && \
    curl -OL https://raw.githubusercontent.com/lsst/lsst/master/scripts/newinstall.sh && \
    unset PYTHONPATH && \
    bash newinstall.sh -b -c -3

WORKDIR /home/docmaf/stack


RUN source scl_source enable devtoolset-6; source ./loadLSST.bash; eups distrib install lsst_sims -t sims


RUN source scl_source enable devtoolset-6; source ./loadLSST.bash; \
    conda update -y -n base conda && \
    conda install -y ipython jupyter tornado=4.5.3 jinja2 scipy ephem gitpython && \
    conda update -y pyqt fontconfig sqlalchemy && \
    cd ../ && \
    python -c 'import matplotlib.pyplot' && \
    conda clean -ay

RUN source scl_source enable devtoolset-6; source /home/docmaf/stack/loadLSST.bash; \
    pip install bokeh && \
    conda install -y -c conda-forge jupyterlab  basemap && \
    jupyter serverextension enable --py jupyterlab --sys-prefix


USER root

RUN source scl_source enable devtoolset-6; source ./loadLSST.bash; dbus-uuidgen > /etc/machine-id

WORKDIR /home/docmaf

USER docmaf
