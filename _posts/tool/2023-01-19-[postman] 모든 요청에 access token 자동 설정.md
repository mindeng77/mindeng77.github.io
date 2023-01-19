---
title: postman 모든 요청에 access token 자동 설정
date: 2023-01-19 14:09:00 +0900
categories: [Tool]
tags: [postman]
published: true
---

## 사전작업

Enviroments에서 환경변수 추가

- `server-url`: 서버주소
- `access-token`: 엑세스 토큰
- `access-token-expire`: 만료시간

## Pre-request Script 추가

적용하고자 하는 folder나 request의 Pre-request Script 탭에서 다음 스크립트 추가
folder에 적용할 경우 속한 request에서 Authorization탭에서 Type을 `Inherit auth from parent`(부모에서 상속)로 설정해야 함.

```javascript
// 토근이 없거나 만료되었을 경우에만 토큰 요청
let isGetToken = true;
if (
  !pm.environment.get("access-token-expire") ||
  !pm.environment.get("access-token")
) {
  console.log("Token or expiry date are missing");
} else if (pm.environment.get("access-token-expire") <= new Date().getTime()) {
  console.log("Token is expired");
} else {
  isGetToken = false;
  console.log("Token and expiry date are all good");
}

if (isGetToken) {
  const serverUrl = pm.environment.get("server-url");

  const options = {
    url: `${serverUrl}/rest/auth/login`,
    method: "POST",
    header: {
      "Content-Type": "application/json",
    },
    body: {
      mode: "application/json",
      raw: JSON.stringify({
        usrId: "test",
        usrPwd: "1234",
      }),
    },
  };

  pm.sendRequest(options, (err, response) => {
    if (err === null) {
      const { retcode, data } = response.json();
      if (retcode === "OK") {
        const { accessToken, accessTokenExpire } = data;
        pm.environment.set("access-token", accessToken);
        pm.environment.set("access-token-expire", accessTokenExpire);
      }
    }
  });
}
```
