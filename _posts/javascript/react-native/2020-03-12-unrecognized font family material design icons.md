---
title: unrecognized font family 'material design icons'
date: 2020-03-12 00:00:00 +0900
categories: [Javascript, React Native]
tags: [React Native, unrecognized font family material design icons]
published: true
---

## 환경

- React Native
- 사용중인 패키지: react-native-vector-icons
- IOS에서 빌드시 위 에러 발생

**Info.plist 파일에서 다음을 추가**

```xml
<key>UIAppFonts</key>
<array>
    <string>AntDesign.ttf</string>
    <string>Entypo.ttf</string>
    <string>EvilIcons.ttf</string>
    <string>Feather.ttf</string>
    <string>FontAwesome.ttf</string>
    <string>FontAwesome5_Brands.ttf</string>
    <string>FontAwesome5_Regular.ttf</string>
    <string>FontAwesome5_Solid.ttf</string>
    <string>Foundation.ttf</string>
    <string>Ionicons.ttf</string>
    <string>MaterialIcons.ttf</string>
    <string>MaterialCommunityIcons.ttf</string>
    <string>SimpleLineIcons.ttf</string>
    <string>Octicons.ttf</string>
    <string>Zocial.ttf</string>
</array>
```

참고: [stack overflow](https://stackoverflow.com/questions/48601206/error-unrecognized-font-family-material-design-icons-after-installing-react-nat){:target="\_blank"}
