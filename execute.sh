# 定义变量
API_NAME="vigilant_poitras"
WORKSPACE="/home/webroot/MyBlog/"
current=`date "+%Y-%m-%d %H:%M:%S"`  
timeStamp=`date -d "$current" +%s`   
#将当前的时间戳作为版本号精确到分钟  
API_VERSION=$((timeStamp/1000)) 
API_PORT="8080"
IMAGE_NAME="deandoc/spring-boot"-$API_VERSION
CONTAINER_NAME=$API_NAME-$API_VERSION


cd $WORKSPACE

#git pull

mvn clean install

# 进入target目录并复制Dockerfile文件
cd $WORKSPACE
#cp classes/Dockerfile .

# 构建Docker镜像
docker build -t $IMAGE_NAME .

# 推送Docker镜像
docker push $IMAGE_NAME

# 删除Docker容器
cid=$(docker ps | grep $CONTAINER_NAME |awk '{print $1}')
if [ x"$cid" != x ]
    then 
	docker stop $CONTAINER_NAME
	sleep 100
    docker rm -f $cid
fi

# 启动Docker容器
docker run -d -p $API_PORT:8080 --name $CONTAINER_NAME $IMAGE_NAME

# 删除Dockerfile文件
rm -f Dockerfile
