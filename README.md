# underscorespace

This repo is using git-lfs https://git-lfs.github.com/ to host some files. Make sure you have the appropriate client tools installed. 

./prereqs/client-install-git-lfs.sh 

can help with that on ubuntu


To instantiate CI components you will need a Github oauth token (https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) and AWS key/secret:

source ./prereqs/compose-codepipeline.sh -a <action>

eg:

source ./prereqs/compose-codepipeline.sh -a plan
source ./prereqs/compose-codepipeline.sh -a apply
