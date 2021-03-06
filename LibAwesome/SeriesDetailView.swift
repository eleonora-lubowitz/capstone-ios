//
//  SeriesDetailView.swift
//  LibAwesome
//
//  Created by Sabrina on 1/7/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct SeriesDetailView: View {
    @EnvironmentObject var env: Env
    static var series: SeriesList.Series = SeriesList.Series()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(SeriesDetailView.series.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Section {
                VStack(alignment: .leading) {
                    if SeriesDetailView.series.plannedCount > 0 {
                        Text("\(SeriesDetailView.series.plannedCount) books in series")
                            .font(.caption)
                    }
                    Text("Contributers: \(self.getContributers())")
                        .font(.caption)
                }.padding(.horizontal)
            }
            
            Section {
                VStack(alignment: .center) {
                    Text("Books")
                        .font(.headline)
                        .padding(.top)
                    List {
                        ForEach(self.getBooks().sorted(by: {$0.position < $1.position})) { book in
                            Button(action: {
                                self.env.book = book
                                self.env.topView = .bookdetail
                            }) {
                                HStack {
                                    Text("\(book.position)")
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                        Text(book.authorNames())
                                            .font(.caption)
                                    }
                                    Spacer()
                                    ArrowRight()
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func getBooks() -> [BookList.Book] {
        var booksInSeries: [BookList.Book] = []
        // loop through env.booklist, checking each book's id
        for book in self.env.bookList.books {
            // if that id is present in series.books,
            if let _ = SeriesDetailView.series.books.first(where: { $0 == book.id }) {
                // add that book to a list to be returned
                booksInSeries.append(book)
            }
        }
        return booksInSeries
    }
    
    func getContributers() -> String {
        var contributers: [String] = []
        
        // loop through the results of getBooks()
        let allBooks = self.getBooks()
        for book in allBooks {
            // for each author of the book, put it in contributers
            for author in book.authors {
                contributers.append(author)
            }
        }
        
        let uniqueAuthors = Set(contributers)
        contributers = Alphabetical(Array(uniqueAuthors)) // sort alphabetically
        let contributersJoined = contributers.joined(separator: ", ")
        
        return contributersJoined
    }
    
}

struct SeriesDetailView_Previews: PreviewProvider {
    static var book1 = BookList.Book(
        id: 1,
        title: "Storm Front",
        authors: [
            "James Butcher"
        ],
        position: 3)
    static var book2 = BookList.Book(
        id: 2,
        title: "Fool Moon",
        authors: [
            "James Butcher"
        ],
        position: 2)
    static var book3 = BookList.Book(
        id: 3,
        title: "Grave Peril",
        authors: [
            "Jim Butcher"
        ],
        position: 1)
    static var bookList = BookList(books: [book1, book2, book3])
    
    static var series = SeriesList.Series(
        id: 3,
        name: "The Dresden Files",
        plannedCount: 23,
        books: [1, 2, 3])
    
    static var seriesList = SeriesList(series: [series])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: bookList,
        authorList: Env.defaultEnv.authorList,
        seriesList: seriesList,
        tagList: Env.defaultEnv.tagList,
        tag: Env.defaultEnv.tag,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        SeriesDetailView()
//            .environmentObject(series)
            .environmentObject(env)
    }
}
