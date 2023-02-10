---
title: moment의 locale을 dynamic하게 import하기
date: 2023-02-10 14:05:00 +0900
categories: [Javascript, React Native]
tags: [moment, dynamic import]
published: true
---

locale에 따라 한국어, 영어, 일본어로 표시하고 싶은데 공식문서를 보면 다음과 같이 최상단에 import를 하고, locale를 `ko`로 변경하면 한글은 잘 나온다.

```jsx
import moment from 'moment';
import "moment/locale/ko"; // 한국어
...
moment().locale('ko');

console.log(moment().format('LLL')); // 2023년 2월 10일 오후 2:24
```

영문으로 표현하기 위해 다음처럼 변경을 했지만 영문으로 표시가 되지 않는다.

```jsx
import moment from 'moment';
import "moment/locale/ko"; // 한국어
...
moment().locale('en');

console.log(moment().format('LLL')); // 2023년 2월 10일 오후 2:24
```

상단의 import 구문을 제거했더니 영문으로 표시가 된다.

```jsx
import moment from 'moment';
...
moment().locale('en');

console.log(moment().format('LLL')); // February 10, 2023 2:29 PM
```

import 구문은 최 상단에 위치해야되어 위와 같은 방법으로는 각 언어별로 import를 할 수 없다.

원래 하고자 했던건 다음 처럼 locale에 따라 언어를 설정하고자 했지만 문제가 맨 마지막에 import 한 언어로 표시가 된다는것이다.

```jsx
import * as Localization from 'expo-localization';
import moment from 'moment';
import "moment/locale/ko"; // 한국어
import "moment/locale/ja"; // 일본어
...
if (Localization.locale === 'ko-KR') {
  moment().locale('ko');
} else if (Localization.locale === 'ja-JP') {
  moment().locale('ja');
} else {
  moment().locale('en');
}

console.log(moment().format('LLL')); // 2023年2月10日 14:35
```

그래서 다음과 같이 dynamic import를 하는 방식으로 해결했다.

```jsx
import * as Localization from 'expo-localization';
import moment from 'moment';

...

if (Localization.locale === 'ko-KR') {
  import('moment/locale/ko').then(() => moment().locale('ko'));
} else if (Localization.locale === 'ja-JP') {
  import('moment/locale/ja').then(() => moment().locale('ja'));
}
```
