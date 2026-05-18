# PostgreSQL
sudo docker run -d --name plane-db \
  -e POSTGRES_USER=plane \
  -e POSTGRES_PASSWORD=plane \
  -e POSTGRES_DB=plane \
  -p 15432:5432 \
  postgres:15.4

# Redis
sudo docker run -d --name plane-redis \
  -p 16379:6379 redis:7.2.4

# RabbitMQ
sudo docker run -d --name plane-mq \
  -e RABBITMQ_DEFAULT_USER=plane \
  -e RABBITMQ_DEFAULT_PASS=plane \
  -e RABBITMQ_DEFAULT_VHOST=plane \
  -p 15673:5672 rabbitmq:3.13

# MinIO
sudo docker run -d --name plane-minio \
  -e MINIO_ROOT_USER=plane \
  -e MINIO_ROOT_PASSWORD=planepass \
  -p 19000:9000 \
  -p 19090:9090 \
  minio/minio server /data --console-address ":9090"

MYIP=192.168.68.169
  docker run --name plane-aio --rm -it \
  -p 3001:80 \
  -p 20025:20025 \
  -p 20465:20465 \
  -p 20587:20587 \
  -e DOMAIN_NAME=${MYIP} \
  -e DATABASE_URL=postgresql://plane:plane@${MYIP}:15432/plane \
  -e REDIS_URL=redis://${MYIP}:16379 \
  -e AMQP_URL=amqp://plane:plane@${MYIP}:15673/plane \
  -e AWS_REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID> \
  -e AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY> \
  -e AWS_S3_BUCKET_NAME=plane-app \
  -e AWS_S3_ENDPOINT_URL=http://${MYIP}:19000 \
  -e FILE_SIZE_LIMIT=10485760 \
  artifacts.plane.so/makeplane/plane-aio-commercial:stable