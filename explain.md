# Docker Course

## Creating a production level flow

### Tweaked docker command

- When we run `docker build .` withoud specifying any arguments, docker will automatically look for the file named _Dockerfile_.
- Since we want separate dockerfiles for development and production, we need to tell docker specifically which we want to use
- When in development, we run `docker build -f Dockerfile.dev .`
- When in production, we run `docker build -f Dockerfile.prod .`

### Make changes be reflected on docker right away

- When we update/modify something in our app, we often need to recopy everything to docker container.
- To make our changes be reflected immediately after editing, we need to use docker volumn, which basically mean we're essentially gonna put references of our local folders in docker container.
- So that when changes happen locally, the references in docker will change too.
- We run this `docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image_id>`
- The second -v tag means we're gonna map everyting in our current pwd(present working directory) into the "/app" folder.**The column between pwd and app means map pwd to app**
- The first -v tag is a bookmarking volumn, we need to bookmark node_modules because we don't have one locally. **Without a column, this means we're not trying to map a local file to docker, we just want there to be a placeholder called node_modules**

### Simplify docker run arguments with docker-compose

- Initially, we had to specify port and two volumns.
- We can use docker-compose to make executing docker run more easily.
- First as always, we specify the version, then we need a name for our service, finally, we can map ports and specify two volumns.
- Note that the build part is a little bit more complicated. The _context_ means what we want inside the container, "." means everything in the currently directory. If what we need is in, for instance, "/frontend" directory, we then, can specify that.
- The first basically means create a placeholder called node_modules in the app directory.
- The second means make references of every folder in the current directory into app directory.
- Now, instead of running that fuxxing long `docker run....` we can simply run `docker-compose up`

### Why we don't need COPY in docker anymore

- Since we already made references of local folders in docker container, we no longer need to copy them.
- However we still need to copy package.json in order to run `npm install` to install all the dependencies.

### What's gonna happen in our production Dockerfile

- We can seperate the process into two phases
  - Build
  - Run
- In the build phase, we first use node:alpine as before, and copy package.json to the container, then install dependancies, and finally run `npm run build`
- In the run phase, we need to use nginx then copy over the result of `npm run build` which is some static files, and finally, we start nginx

### Setting up Travis(travis.yml)

- Tell Travis we need a copy of docker running
- Build our image using Dockerfile.dev
- Tell Travis how to run our test suite
- Tell how to deploy our code to AWS

### AWS secret api keys

- Don't put api keys directly in your travis.yml file, go to travisCI settings, and set it as an environment variable

### Elasticbeanstalk port expose

- We can expose the port by specifying it in production docker file
