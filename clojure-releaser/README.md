# clojure-releaser

A Docker image that helps a bit with Clojure releases. This will mostly be of help if you're having issues getting leiningen + GPG to work well on OS X.

## Build

```docker build --rm -t <image-tag> .```

## Usage

Install git on your host machine and configure the "user.email" and "user.name" settings.

Get ssh installed on your host machine, generate a key-pair, and register the public key with your Github account.

On your host machine, install leiningen:

    http://leiningen.org

Follow the directions here for setting up your GPG keys on your host machine. Make sure the email address you use when generating the keys matches the email address you configured git with:

    https://github.com/technomancy/leiningen/blob/master/doc/GPG.md

You'll need to be able to encrypt and decrypt files. Don't worry about getting gpg-agent to work; if you're using this image, it will end up running inside the docker container.

Follow the instructions here to get your ~/.lein/credentials.clj.gpg file set up and encrypted on your host machine:

    https://github.com/technomancy/leiningen/blob/stable/doc/DEPLOY.md#gpg

Finally, run the image from inside the root directory of the Clojure project you want to deploy/release:

    ```docker run --rm -it -v $HOME/.lein:/root/.lein -v $HOME/.gnupg:/root/.gnupg -v $HOME/.ssh:/root/.ssh -v $HOME/.gitconfig:/root/.gitconfig -v $(pwd):/<repo-dir> -w /<repo-dir> <image-tag>```

Replace <repo-dir> with the name of the Clojure project you're releasing and replace <image-tag> with the Docker image tag of built clojure-releaser image.

You should now be in a bash shell inside the container, where you can run commands like 'lein deploy clojars' and 'lein release :patch' without your terminal becoming unresponsive and/or all messed up.