---
title: Multi port 구성
date: 2022-01-03 14:12:00 +0900
categories: [Javascript, Node.js]
tags: [Node.js, multi port]
published: true
---

## 배경

- 채팅서버와 일반적인 rest api 서버를 구축해야하는데 node서버 하나로 구성을 하고 싶다.
- express-generator를 이용하여 프로젝트를 생성한 상태

## 구현

#### /app.js

```javascript
const express = require("express");
const app = express();
const chatApp = express();

/* 생략 */

module.exports = {
  app,
  chatApp,
};
```

#### /bin/www

```javascript
const { app, chatApp } = require("../app");
const debug = require("debug")("server");
const http = require("http");

//#region web server 설정
const port = normalizePort(process.env.PORT || "3000");
app.set("port", port);

const server = http.createServer(app);
server.listen(port);
server.on("error", onError);
server.on("listening", () => {
  const addr = server.address();
  const bind = typeof addr === "string" ? "pipe " + addr : "port " + addr.port;
  debug("Api Server Listening on " + bind);
});
//#endregion

//#region chatting server 설정
const chatPort = normalizePort(process.env.PORT || "3100");
chatApp.set("port", chatPort);

const chatServer = http.createServer(chatApp);
const io = require("socket.io")(chatServer, {
  cors: {
    origin: "http://localhost:3000",
    methods: ["GET", "POST"],
  },
});
io.on("connection", (socket) => {
  console.log("connection");
  socket.on("init", (payload) => {
    console.log(payload);
  });
});
chatServer.listen(chatPort);
chatServer.on("error", onError);
chatServer.on("listening", () => {
  const addr = chatServer.address();
  const bind = typeof addr === "string" ? "pipe " + addr : "port " + addr.port;
  debug("Chat Server Listening on " + bind);
});
//#endregion
```

#### /package.json

```json
{
  "scripts": {
    "start": "set DEBUG=* & node ./bin/www"
  },
  "dependencies": {
    "cookie-parser": "~1.4.4",
    "debug": "~2.6.9",
    "express": "~4.16.1",
    "http-errors": "~1.6.3",
    "jade": "~1.11.0",
    "morgan": "~1.9.1",
    "socket.io": "^4.4.0"
  }
}
```

#### 실행

```shell
npm run start
```

![Desktop View](/assets/img/node-multi-port-console.png){: width="299" height="72"}

3000번과 3001번 포트로 각각 서버가 띄워졌다.
