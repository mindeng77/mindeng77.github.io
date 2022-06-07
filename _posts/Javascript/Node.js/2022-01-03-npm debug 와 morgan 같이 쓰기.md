---
title: npm debug 와 morgan 같이 쓰기
date: 2022-01-03 16:56:00 +0900
categories: [Javascript, Node.js]
tags: [Node.js, debug, morgan]
published: true
---

`express-generate`를 이용하여 프로젝트를 생성하면 `debug`, `morgan`이 기본으로 설치되는데,
`debug`는 디버그 로그를 남기기 위한 유틸성 모듈이고, `mogran`은 사용자의 요청과 응답 사이에서 로그를 남기는 미들웨어로 둘다 로그를 남기고, 포맷이 다르다보니,
로그 포맷을 통일해야겠다는 생각이 들었다.

```javascript
const debug = require('debug')('app:server');
const logger = require('morgan');
...

app.use(
  logger(
    function (tokens, req, res) {
      const method = tokens.method(req, res);
      return [
        `[${method}]`,
        tokens.url(req, res),
        tokens.status(req, res),
        '-',
        tokens['response-time'](req, res),
        'ms',
        !isEmpty(req.body) ? JSON.stringify(req.body) : null
      ].join(' ');
    },
    { stream: { write: msg => debug(msg) } } // morgan의 로그를 debug로 쓰겠다는 설정
  )
);
```

`morgan`은 이미 정의된 포맷으로 지정을 할 수도 있지만 위 소스 처럼 커스텀하게 바꿀수도 있다.

[https://expressjs.com/en/resources/middleware/morgan.html](https://expressjs.com/en/resources/middleware/morgan.html){:target="\_blank"}
