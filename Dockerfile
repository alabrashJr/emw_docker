FROM rappdw/docker-java-python:latest

MAINTAINER Abdulrahman Alabrash <aalabrash18@ku.edu.tr>

#WORKDIR /usr/src/app
RUN apt-get update
RUN apt-get -y install g++ python-dev python3-dev ant
#RUN apt-get install -y software-properties-common


RUN apt-get install --yes --no-install-recommends \
    wget \
    vim \  
    git \
    maven \  
    tmux \ 
    locales \
    cmake \
  #  gcc-multilib \
    build-essential \
    apt-utils


RUN pip install --upgrade pip   
ENV _JAVA_OPTIONS="-Xmx2g"
COPY . . 
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

#nextflow installation
ENV NXF_VER=19.04.1
RUN wget -qO- https://get.nextflow.io | bash
RUN mv nextflow ./bin
RUN nextflow

#SUtime dependencies 
RUN git clone https://github.com/FraBle/python-sutime 
RUN cd python-sutime  && mvn dependency:copy-dependencies -DoutputDirectory=./jars && cd .. && mv -v python-sutime/java/ ./nextflow_test/bin/ && mv -v python-sutime/jars/ ./nextflow_test/bin/ && mv -v python-sutime/sutime/ ./nextflow_test/bin/   
RUN rm -rf python-sutime

#for nltk.sentence 
RUN python -c "import nltk;nltk.download('popular', halt_on_error=False)"

#DTC depenedecy 
RUN git clone https://github.com/Jekub/Wapiti && cd Wapiti && make install
RUN cd /bin/ && ln -s ../nextflow_test/bin/clean.py && ln -s ../nextflow_test/bin/classifier.py && ln -s ../nextflow_test/bin/Publ.PublishDateGraper_DTC-nextflow.py  && ln -s ../nextflow_test/bin/placeTagger.py && ln -s ../nextflow_test/bin/temporalTagger.py && ln -s ../nextflow_test/svm/runSVM.py && ln -s ../nextflow_test/bin/PublishDateGraper_DTC-nextflow.py

RUN echo "tmux new-session -d -s SVM_Classifier 'python /nextflow_test/svm/run.py'" >> ~/.bashrc 
RUN echo "tmux new-session -d -s TT 'python /nextflow_test/bin/ttFlask.py'" >> ~/.bashrc 

WORKDIR /emw_pipeline_nf



