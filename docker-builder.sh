#!/bin/sh

echo "Docker builder: get source code, build docker image, push to repo"

# json
config="./docker-builder.json"
if [ -f $config ]; then
	PROJECT=$(jq '. |  .PROJECT' $config | tr -d '"')
	VERSION=$(jq '. |  .VERSION' $config | tr -d '"')
	GIT_URL=$(jq '. |  .GIT_URL' $config | tr -d '"')
fi

echo "----------------------------------------------------------------"
echo " ::::::: Variables used for docker-builder ::::::: "
echo "----------------------------------------------------------------"

echo "PROJECT: "$PROJECT
echo "VERSION: "$VERSION
echo "GIT_URL: "$GIT_URL


cd /opt
mkdir projects
cd projects
git clone $GIT_URL
cd $PROJECT

# mvn projects
mvn clean package -DskipTests

# build docker image
cp target/$PROJECT-$VERSION.jar src/delivery
cd src/delivery
docker build -t ebuit/$PROJECT --build-arg JAR_FILE=$PROJECT-$VERSION.jar .
cd ../../

docker login --username=ebuit -p=3er4pl09X+-
docker push ebuit/master-scheduler
