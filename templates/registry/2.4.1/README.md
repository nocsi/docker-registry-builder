# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Registry v###-->ZZZ_REGISTRY_VERSION<--###][3]:** Docker registry.

## Details
* The container runs as "dev" user (i.e. UID 1000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /var/lib/registry

## Usage 
This image can easily be extended.  But to run Docker Registry:

````
docker run -it --rm \
	-v $(REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY):/data \
	-p $(EXPOSTED_PORT):5000 \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_REGISTRY_VERSION<--### version   
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###   
* Built on: ###-->ZZZ_DATE<--###  
* Base image: ###-->ZZZ_BASE_IMAGE<--###  


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
