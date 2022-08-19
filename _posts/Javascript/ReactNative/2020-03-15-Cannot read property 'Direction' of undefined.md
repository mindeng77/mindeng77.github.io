---
title: Cannot read property 'Direction' of undefined
date: 2020-03-15 15:25:00 +0900
categories: [Javascript, React Native]
tags: [React Native]
published: true
---

react-native-gesture-handler 패키지가 link가 안될수도 있어서 다음으로 처리.

```shell
react-native link react-native-gesture-handler
```

만약 IOS로 실행중이라면 라이브러리가 설치가 안되어 있을 수도 있어서 다음으로 처리.

```shell
cd ios
pod install
```
