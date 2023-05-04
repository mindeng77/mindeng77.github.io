---
title: npm package를 tgz로 압축하기
date: 2023-05-04 16:20:00 +0900
categories: [Tool]
tags: [npm, tgz]
published: true
---

nexus에 npm 패키지를 업로드하기 위해서 tgz파일로 압축을 해야하는데 npm으로는 방법을 찾지 못했는데, yarn으로 가능하다.

**/.yarnrc**

```properties
yarn-offline-mirror "./npm_packages"
yarn-offline-mirror-pruning true
```

위의 파일을 만들고 yarn으로 패키지 설치를 하면 `/npm_packages` 폴더에 각 패키지들이 tgz파일로 만들어진다.
