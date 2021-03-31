//
//  ContentView.swift
//  Bookworm
//
//  Created by Adarsh Urs on 24/03/21.
//

import SwiftUI
import CoreData

struct ContentView: View{
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    

    var body: some View{
        NavigationView{
        List{
            ForEach(books, id: \.self){ book in
                NavigationLink(
                    destination: DetailView(book: book)){
                    EmojiRatingView(rating: book.rating)
                        .font(.largeTitle)
                    
                    VStack(alignment: .leading){
                        Text(book.title ?? "Unknown title")
                            .font(.headline)
                            .foregroundColor(book.rating <= 1 ? .red : .primary)
                        Text(book.author ?? "Unknown author")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteBooks)
        }
        .navigationBarTitle("Bookworm")
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
            self.showingAddScreen.toggle()
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddScreen) {
            AddBookView().environment(\.managedObjectContext, self.moc)
        }
    }
    
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets{
            let book = books[offset]
            moc.delete(book)
        }
        
        
        try? moc.save()
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title){
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct Student {
    var id: UUID
    var name: String
}
