FROM centos:7

COPY ./fedora-infra-sigul.repo /etc/yum.repos.d/

RUN yum install -y libxml2 libxslt \
  && curl -s https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/x/xmlstarlet-1.6.1-1.el7.x86_64.rpm \
  -o /tmp/xmlstarlet-1.6.1-1.el7.x86_64.rpm \
  && rpm -Uvh /tmp/xmlstarlet-1.6.1-1.el7.x86_64.rpm

RUN yum install -y git python python-devel make automake gcc kernel-devel sudo sigul \
  && yum clean all \
  && rm -rf /var/cache/yum

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py \
    && python get-pip.py \
    && rm -rf get-pip.py
RUN pip install --no-cache-dir --upgrade pip setuptools

RUN pip install --no-cache-dir -I lftools[openstack]==0.31.0