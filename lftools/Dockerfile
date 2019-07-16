FROM centos:7

COPY ./fedora-infra-sigul.repo /etc/yum.repos.d/

RUN yum install -y epel-release
RUN yum install -y git python python-devel make automake gcc kernel-devel sudo sigul xmlstarlet \
  && yum clean all \
  && rm -rf /var/cache/yum

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py \
    && python get-pip.py \
    && rm -rf get-pip.py
RUN pip install --upgrade pip setuptools

RUN pip install -I lftools[openstack]==0.23.1