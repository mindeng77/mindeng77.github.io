---
title: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.
date: 2019-12-12 15:25:00 +0900
categories: [Javascript, React Native]
tags: [React Native]
published: true
---

react-native xcode에서 빌드시 에러발생

Pods폴더와 Podfile.lock파일 삭제 후 다시 설치하면됨.

```shell
$ cd {project root}/iod

$ rm -rf Pods

$ rm -rf Podfile.lock

$ pod install
```

xcode에서 Product > Clean Build Folder
