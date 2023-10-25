import SwiftUI

struct CircleButtonView: View {

    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle().foregroundColor(.theme.background)
            )
            .shadow(
                color: .theme.accent.opacity(0.25),
                radius: 10, x: 0, y: 0
            )
            .padding()
    }
}

#Preview {
    Group {
        CircleButtonView(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
        .padding()
        CircleButtonView(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
