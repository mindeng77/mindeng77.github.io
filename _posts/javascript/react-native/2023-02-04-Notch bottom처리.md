---
title: native base에서 safe area 처리
date: 2020-03-15 15:25:00 +0900
categories: [Javascript, React Native]
tags: [React Native, ios, notch, SafeAreaView]
published: true
---

## 환경

- expo@47.0.8
- @react-navigation/native@6.0.14
- native-base@3.4.23

## 문제

`native-base`을 이용하여 개발을 하다보니 Android에선 문제가 없었는데 IOS에서는 Notch bottom영역이 겹치는 문제가 발생했다. App.jsx에서 SafeAreaProvider를 적용하거나 각 화면에서 SafeAreaView를 적용해봐도 원하는 결과가 나오지 않음.

### App.jsx

동작안함

```jsx
...
import { SafeAreaProvider } from 'react-native-safe-area-context';
...
<Provider store={store}>
  <NativeBaseProvider colorModeManager={colorModeManager} theme={theme}>
    <SafeAreaProvider>
      <LocalizationContext.Provider value={localizationContextValue}>
        <NavigationContainer ref={NavigationService.navigationRef}>
          <MainScreen />
        </NavigationContainer>
      </LocalizationContext.Provider>
    </SafeAreaProvider>
  </NativeBaseProvider>
</Provider>
```

## 해결

native-base에서 제공해주는 `useSafeArea`를 사용하여 해결했다.
나는 bottom에만 겹치는 현상이 있어서 bottom쪽만 설정했다.

```jsx
import { Box, useSafeArea } from "native-base";

export default function SignUpScreen() {
  const { stepStyle } = useStepScreenContext();
  const safeAreaProps = useSafeArea({
    safeAreaBottom: true,
  });

  return (
    <Box flex="1" {...safeAreaProps}>
      ...
    </Box>
  );
}
```
