FROM python:3.11-buster as builder-image

RUN echo "deb http://apt.ksyun.cn/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://apt.ksyun.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://apt.ksyun.cn/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://apt.ksyun.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://apt.ksyun.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C

RUN apt-get update

COPY install/requirements_py3.11.txt .
RUN pip3 install -U pip -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --no-cache-dir -r requirements_py3.11.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

FROM python:3.11-slim-buster

COPY --from=builder-image /usr/local/bin /usr/local/bin
COPY --from=builder-image /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

WORKDIR /opt/code
COPY . .
ENV PYTHONPATH /opt/code

ENTRYPOINT ["python3", "-m", "vectordb_bench"]
