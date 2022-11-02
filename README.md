# Tap Tap Counter Clone App

### SwiftUI를 이용한 Tap Tap Counter 클론앱입니다.

* App Store에서 Tap Tap Counter 앱을 참고해 만든 앱입니다. [링크 바로가기](https://apps.apple.com/us/app/tap-tap-counter/id309642627?platform=iphone)

#### 설명

- 상단에 버튼그룹과 하단에 카운터가 있습니다.

> **버튼그룹**
1. `Reset 버튼`은 *카운트값* 을 **초기화**할 수 있습니다.
2. `Subtract 버튼`은 *카운트값* 을 **감소**합니다.
3. `Split버튼` 은 Split mode를 전환합니다.

> **카운터 동작**

* 화면을 터치하면 기본으로 *카운트값*을 **증가**시킵니다.

```swift
/// `default` 카운터 화면에서 동작하는 필드입니다.
var defaultField: some View {
    Button(action: self.addValue) {
        Color.clear
    }
}
```

* split 모드 화면에서 좌측화면은 *카운트값* 감소, 우측화면은 *카운트값* 증가 동작을 수행합니다.

```swift
/// `split` 카운터 화면에서 동작하는 필드입니다.
var splitField: some View {
    GeometryReader { geo in
        HStack(spacing: 0) {
            Button {
                self.substractValue()
            } label: {
                Color.secondary.opacity(0.5)
                    .frame(width: geo.size.width / 2.0)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "minus.circle")
                            .padding()
                    }
            }
            
            Button {
                self.addValue()
            } label: {
                Color.secondary.opacity(0.0)
                    .frame(width: geo.size.width / 2.0)
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "plus.circle")
                            .padding()
                            
                    }
            }
        }
     }
}
```

### DEMO

<p align=center>
    <img src="img/tap-counter.gif" width=50% >
</p>