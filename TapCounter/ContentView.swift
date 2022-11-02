//
//  ContentView.swift
//  TapCounter
//
//  Created by 서광현 on 2022/11/01.
//

import SwiftUI
import AudioToolbox

/// SwiftUI 를 이용한 `TAP TAP COUNTER` 클론앱입니다. [링크](https://apps.apple.com/us/app/tap-tap-counter/id309642627?platform=iphone)
///
/// - 상단에 버튼그룹과 하단에 카운터가 있습니다.
/// 1. `Reset`으로 ***카운트값*** 을 **초기화**할 수 있습니다.
/// 2. `Subtract`으로 ***카운트값*** 을 **감소**합니다.
/// 3. `Split`으로 화면을 **분할**해 ***카운트값*** 을 **감소**, **증가** 합니다.
struct ContentView: View {
    @State private var count: Int = 1234
    @State private var resetAlert: Bool = false
    @State private var countValue: String = ""
    @State private var isSplitMode: Bool = false
    
    var countString: String {
        String(format: "%04d", count)
    }
    
    var body: some View {
        VStack {
            // MARK: - BUTTON FIELD
            buttonField
            
            // MARK: - COUNTER IMAGE
            Image("tapcounter")
                .resizable()
                .scaledToFit()
            // MARK: - DISPLAY FIELD
                .overlay{
                    let size = UIScreen.main.bounds.size
                    displayField(size: size)
                }
            // MARK: - FUNCTION FIELD
                .overlay(content: {
                    if isSplitMode {
                        splitField
                    } else {
                        defaultField
                    }
                })
                .padding()
            // MARK: - RESET ALERT
                .alert("Set Value", isPresented: $resetAlert) {
                    TextField("Set any value between 0~9999", text: $countValue).font(.caption)
                    Button("Cancel", role: .cancel) {}
                    Button("OK") {
                        if let newCount = Int(countValue) {
                            self.count = newCount
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension ContentView {
    /// 버튼의 레이아웃 필드입니다.
    var buttonField: some View {
        HStack {
            Button("Reset") { resetAlert = true }
                .frame(maxWidth: .infinity, alignment: .center)
            Button("Subtract", action: substractValue)
                .frame(maxWidth: .infinity, alignment: .center)
            Button("Split") { isSplitMode.toggle() }
                .frame(maxWidth: .infinity, alignment: .center)
            
        }
        .font(.title3)
        .fontWeight(.light)
        .buttonStyle(.plain)
    }
    
    /// 카운터 화면에 표시될 카운트값을 나타냅니다.
    /// - Parameter size: 디바이스 사이즈에 따라 카운터 화면이 자동으로 조정됩니다.
    /// - Returns: some View
    @ViewBuilder
    func displayField(size: CGSize) -> some View {
        HStack(spacing:0) {
            Text(countString[0])
                .frame(maxWidth: .infinity, alignment: .center)
            Divider()
            Text(countString[1])
                .frame(maxWidth: .infinity, alignment: .center)
            Divider()
            Text(countString[2])
                .frame(maxWidth: .infinity, alignment: .center)
            Divider()
            Text(countString[3])
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .font(.largeTitle)
        .foregroundColor(.white)
        .frame(width: size.width / 2.0, height: size.height / 10.0, alignment: .center)
        .background {
            Color(red: 0.2, green: 0.34, blue: 0.7)
                .cornerRadius(12.0)
        }
        .offset(x: 25, y: -10)
    }
    
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
    
    /// `default` 카운터 화면에서 동작하는 필드입니다.
    var defaultField: some View {
        Button(action: self.addValue) {
            Color.clear
        }
    }
    
    /// count 값을 감소시키는 메소드입니다.
    ///
    /// - 메소드가 동작할 때마다 iOS 기본시스템 사운드가 재생됩니다.
    func substractValue() {
        guard count > 0 else { return }
        count -= 1
        AudioServicesPlaySystemSound(1104)

    }
    
    /// count 값을 증가시키는 메소드입니다.
    ///
    /// - 메소드가 동작할 때마다 iOS 기본시스템 사운드가 재생됩니다.
    func addValue() {
        guard count < 9999 else { return }
        count += 1
        AudioServicesPlaySystemSound(1105)

    }
}

/// String을 정수 인덱스로 접근하기 위한 extension입니다.
extension String {
    subscript(_ number: Int) -> String {
        guard (0..<self.count).contains(number) else { return "" }
        
        let firstIndex = self.startIndex
        let offsetIndex = self.index(firstIndex, offsetBy: number)
        return String(self[offsetIndex])
    }
}
