# Running LARS under Docker #

Steps to run LARS under Docker are as follows:

* `docker build -t lars .`
* `docker run -d -p 9080:9080 -p 9443:9443 --name lars lars`
* `docker run -d --net=container:lars mongo`

The `lars` image also includes a script to invoke the LARS client to populate the repository from the online repository. For example, `docker exec lars populate webProfile7Bundle` will add the features in `webProfile7Bundle` to the repository.
