This Repo contains [EMW pipeline's](https://github.com/alabrashJr/emw_pipeline_nf) components which are as follows,
-----------
* clean.py  HTML pages parser and cleaner. return the body and the title of HTML input news page.
* classifier.py A pre-trained SVM document classifier return 
* PublishDateGraper_DTC-nextflow.py  [A python wrapper of Publish Data Extractor Using DCTFinder](https://github.com/emerging-welfare/PublishDataExtractor).
* TemporalTageer.py Using [SUTime](https://github.com/FraBle/python-sutime) is a library for recognizing and normalizing time expressions.
* PlaceTagger.py Using [geograpy3](https://pypi.org/project/geograpy3/ ), which is a fork of [Geograpy2](https://github.com/Corollarium/geograpy2), which is itself a fork of [geograpy](https://github.com/ushahidi/geograpy) and inherits most of it, but solves several problems (such as support for utf8, places names with multiple words, confusion over homonyms etc). Also, geograpy3 is compatible with Python 3, unlike Geography2. [geograpy3 library]

To contribute,
--------------

Install Docker for your platform, make sure you can run the Docker tutorials in the examples. You do not need to create an account on https://hub.docker.com/.

Open a terminal window in order to pull the image from [Docker](https://hub.docker.com/r/alabrashjr/emw_pipeline)
```
docker pull alabrashjr/emw_pipeline:v1.2
```
Run a container from the image. give it a name with --name, --rm Automatically remove the container when it exits ..Number of CPUs(between 1-3) --cpus
```
docker run --rm --cpus=3 --name <container_name> -it alabrashjr/emw_pipeline:v1.2  /bin/bash
```
check if the container has the last version of this repo, 
```
git pull
```
All the python scripts are having a symbolic link to the bin folder, which means that any component can be executed by just writing the name of the component without writing python beforehand.
The components' input and output are designed according to the pipeline [flowchart](https://github.com/emerging-welfare/emw_pipeline_nf/blob/master/README.md#flowchart), 

```
clean.py <file:inputfile.html>

PublishDateGraper_DTC-nextflow.py <file:inputfile.html>

classifier.py <file:inputfile.clean.json>

TemporalTageer.py <file:inputfile.*classifier.json>

PlaceTagger.py <file:inputfile.*classifier.json>
```

Using `docker cp` you can copy files/folders from the host computer to the container and vice versa.
for more information run. 

```
docker cp --help
```

If any changes are done to this code you need to commit the changes to your local docker image then run the pipeline,

```
docker commit <container_id> alabrashjr/emw_pipeline:v1.2
```
To run the pipeline follow the instructions [here](https://github.com/emerging-welfare/emw_pipeline_nf/blob/master/README.md)

to push to your image 
`docker commit <container_id> <imageName>`
you need to change the `process.container` in [nextflow.config](https://github.com/emerging-welfare/emw_pipeline_nf/blob/master/nextflow.config)


If you want to add any component to the pipeline,
===============================
* Write your python code.
* Add `#!/usr/bin/env python3` line in top of your python script.
* `cd /bin/ && ln -s ../nextflow_test/bin/<your_class_name>`.
* Create a process in [Nextflow script](https://github.com/emerging-welfare/emw_pipeline_nf/blob/master/emw_pipeline.nf). To learn how to create nextflow process [look here](https://www.nextflow.io/docs/latest/process.html).
* Run the pipeline. 
