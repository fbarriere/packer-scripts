
# Overview:

Packer templates and scripts to build CentOS-5 and CentOS-6 hosts for
compilation. Contains most devel packages...

# Local build:

packer build -only=default template.json

# Released build:

Build a variables JSON file, define the following variables:

``̀ 

{
    "buildversion": "the-build-version",
    "cloud_token": "your-vagrant-cloud-token",
    "changes_list": "List here the changes compared to previous version.",
    "base_path": "Where to put the generated box, on your local disk",
    "release_base_url": "URL of the released box (for boxes stored outside Vagrant cloud)"
}

`̀̀ `

packer build -only=atlas -var-file=variables.json template.json

