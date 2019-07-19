FROM rappdw/docker-java-python:latest

MAINTAINER Abdulrahman Alabrash <aalabrash18@ku.edu.tr>

#WORKDIR /usr/src/app
RUN apt-get update
RUN apt-get -y install g++ python-dev python3-dev ant
#RUN apt-get install -y software-properties-common

##General tools
RUN apt-get install --yes --no-install-recommends \
    wget \
    vim \  
    git \
    tmux \ 
    cmake \
    apt-utils

#Update the pip
RUN pip install --upgrade pip   

#Increase java hub memory size to avoid out of memory exception 
ENV _JAVA_OPTIONS="-Xmx2g"

#Copy all the files in the source folder.
COPY . . 

#Install the necssary python library 
RUN pip install --no-cache-dir -r requirements.txt

##Nextflow
#Nextflow dependencies installation
RUN apt-get install --yes --no-install-recommends  build-essential 
#determine Nextflow version 
ENV NXF_VER=19.04.1
#run Nextflow installation process 
RUN wget -qO- https://get.nextflow.io | bash
RUN mv nextflow ./bin
RUN nextflow
# disable ANSI log 
ENV NXF_ANSI_LOG=false 

##SUtime dependencies 
#Install Maven
RUN apt-get install --yes --no-install-recommends maven
#get the repo from github
RUN git clone https://github.com/FraBle/python-sutime 
#install the jars using maven 
RUN cd python-sutime  && mvn dependency:copy-dependencies -DoutputDirectory=./jars && cd .. && mv -v python-sutime/java/ ./nextflow_test/bin/ && mv -v python-sutime/jars/ ./nextflow_test/bin/ && mv -v python-sutime/sutime/ ./nextflow_test/bin/   
#remove the repo folder
RUN rm -rf python-sutime

#used in classifier compoment for nltk.sentence 
RUN python -c "import nltk;nltk.download('popular', halt_on_error=False)"

#DTC depenedecy 
RUN apt-get install --yes --no-install-recommends locales 
#install Wapiti
RUN git clone https://github.com/Jekub/Wapiti && cd Wapiti && make install
#move all classes to bin, in order to execute without writing python beforehead
RUN cd /bin/ && ln -s ../nextflow_test/bin/clean.py && ln -s ../nextflow_test/bin/classifier.py && ln -s ../nextflow_test/bin/Publ.PublishDateGraper_DTC-nextflow.py  && ln -s ../nextflow_test/bin/placeTagger.py && ln -s ../nextflow_test/bin/temporalTagger.py && ln -s ../nextflow_test/svm/runSVM.py && ln -s ../nextflow_test/bin/PublishDateGraper_DTC-nextflow.py

#Run the API as the container build
RUN echo "tmux new-session -d -s SVM_Classifier 'python /nextflow_test/svm/run.py'" >> ~/.bashrc 
RUN echo "tmux new-session -d -s TT 'python /nextflow_test/bin/ttFlask.py'" >> ~/.bashrc 

WORKDIR /emw_pipeline_nf