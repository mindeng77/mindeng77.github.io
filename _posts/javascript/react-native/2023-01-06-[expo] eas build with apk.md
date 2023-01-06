---
title: expo eas를 이용하여 apk 빌드
date: 2020-03-15 15:25:00 +0900
categories: [Javascript, React Native]
tags: [React Native]
published: true
---

**/eas.json**

```json
{
  "cli": {
    "version": ">= 3.1.1"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal"
    },
    "production": {
      "android": {
        "buildType": "apk"
      }
    }
  },
  "submit": {
    "production": {}
  }
}
```

`build.production.android.buildType`을 `apk`로 설정하면된다. 디폴트는 aab파일로 빌드된다.
