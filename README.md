# SwiftUI-RefreshableScrollView


Demo:



https://github.com/VansonLeung/SwiftUI-RefreshableScrollView/assets/1129695/092fe409-43ab-4dac-bc5a-7f990be4bf71


Usage:

```swift

struct __DEMO_VRSV: View {
    
    var body: some View {
        
        VanRefreshableScrollView(
            useInputOffsetY: false,
            inputOffsetY: 0,
            refreshIcon: "ic_mg_information_history",
            refreshHint: "Pull to refresh",
            isDisableRefreshHint: false,
            onRefresh: { completion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    completion()
                }
            }) {



            // Put any view, list, or any content inside this area

            LazyVStack(spacing: 0) {
                ForEach(0 ..< 100) {i in
                    Text("Item \(i)")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .frame(height: 30)
                }
            }



        }

    }
}



```
