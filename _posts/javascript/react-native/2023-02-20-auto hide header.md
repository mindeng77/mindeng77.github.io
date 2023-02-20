---
title: auto hide header on scroll
date: 2023-02-20 17:43:00 +0900
categories: [Javascript, React Native]
tags: [React Native, auto hide header]
published: true
---

스크롤에 따라 헤더를 숨김 처리

## 환경

- expo@~47.0.12
- react-native-reanimated@~2.12.0

expo 환경에서 `react-native-reanimated`를 사용하려면 다음과 같은 설정을 해야한다.([참고](https://docs.expo.dev/versions/latest/sdk/reanimated/))

```javascript
// babel.config.js
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ["babel-preset-expo"],
    plugins: ["react-native-reanimated/plugin"], // 이부분 추가
  };
};
```

## Component

컴포넌트로 만들었다.

```jsx
{% raw %}
// components/HeaderHideScrollView.jsx
import { Platform, StatusBar, View } from "react-native";
import Animated from "react-native-reanimated";

const HEADER_HEIGHT =
  Platform.OS === "ios" ? 115 : 70 + StatusBar.currentHeight;

export default function HeaderHideScrollView({ children }) {
  const scrollY = new Animated.Value(0);
  const diffClampScrollY = Animated.diffClamp(scrollY, 0, HEADER_HEIGHT);
  const headerY = Animated.interpolateNode(diffClampScrollY, {
    inputRange: [0, HEADER_HEIGHT],
    outputRange: [0, -HEADER_HEIGHT],
  });
  return (
    <View style={{ flex: 1 }}>
      <Animated.View
        style={{
          position: "absolute",
          left: 0,
          right: 0,
          top: 0,
          height: HEADER_HEIGHT,
          backgroundColor: "grey",
          transform: [
            {
              translateY: headerY,
            },
          ],
        }}
      />
      <Animated.ScrollView
        bounces={false}
        scrollEventThrottle={16}
        style={{ paddingTop: HEADER_HEIGHT }}
        onScroll={Animated.event([
          {
            nativeEvent: {
              contentOffset: {
                y: scrollY,
              },
            },
          },
        ])}
      >
        {children}
      </Animated.ScrollView>
    </View>
  );
}
{% endraw %}
```

## 사용

```jsx
// screens/main/HomeScreen.jsx
import { Text } from "react-native";
import HeaderHideScrollView from "../../components/HeaderHideScrollView";

const list = [
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
  "a",
];

export default function HomeScreen() {
  return (
    <HeaderHideScrollView>
      {list.map((item, index) => (
        <Text key={index} style={{ height: 100 }}>
          {item}
        </Text>
      ))}
    </HeaderHideScrollView>
  );
}
```

### 참고

[https://kr.noxinfluencer.com/youtube/video-analytics/JPx8IlfYQ-c](https://kr.noxinfluencer.com/youtube/video-analytics/JPx8IlfYQ-c)

> 위 주소에서 개발할때 버전의 차이인지 `Animated.interpolate()` 함수가 없어서 `Animated.interpolateNode()` 함수를 사용했다.
