import SwiftUI

struct MainNoteView: View {
    let note: String

    var body: some View {
        Text(note)
            .font(.system(size: 40, design: .rounded))
            .bold()
            .alignmentGuide(.noteCenter) { dimensions in
                dimensions[HorizontalAlignment.center]
            }
    }
}

struct MainNoteView_Previews: PreviewProvider {
    static var previews: some View {
        MainNoteView(note: "E")
            .previewLayout(.sizeThatFits)
    }
}
