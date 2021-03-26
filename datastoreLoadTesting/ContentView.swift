//
//  ContentView.swift
//  datastoreLoadTesting
//
//  Created by Law, Michael on 3/24/21.
//

import SwiftUI
import Amplify
struct ContentView: View {

    // 100 blogs, 300posts, 900 comments
    func save() {
        for _ in 0..<100 {
            let blog = Blog6(name: "name")
            Amplify.DataStore.save(blog) { (result) in
                switch result {
                case .success:
                    let post1 = Post6(title: "title1", blog: blog)
                    let post2 = Post6(title: "title2", blog: blog)
                    let post3 = Post6(title: "title3", blog: blog)
                    save(posts: [post1, post2, post3])
                case .failure(let error): print(error)
                }
            }
        }
        
    }
    func save(posts: [Post6]) {
        for post in posts {
            Amplify.DataStore.save(post) { result in
                switch result {
                case .success:
                    let comment1 = Comment6(post: post, content: "content1")
                    let comment2 = Comment6(post: post, content: "content2")
                    let comment3 = Comment6(post: post, content: "content3")
                    save(comments: [comment1, comment2, comment3])
                case .failure(let error): print(error)
                }
            }
        }
    }
    
    func save(comments: [Comment6]) {
        for comment in comments {
            Amplify.DataStore.save(comment) { result in
                switch result {
                case .success:
                    print("Success")
                case .failure(let error): print(error)
                }
            }
        }
    }
    
    func queryBlogs() {
        Amplify.DataStore.query(Blog6.self) { (result) in
            switch result {
            case .success(let blogs):
                //print(blogs)
                print("Blog length \(blogs.count)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func queryPosts() {
        Amplify.DataStore.query(Post6.self) { (result) in
            switch result {
            case .success(let posts):
                //print(posts)
                print("Post length \(posts.count)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func queryComments() {
        Amplify.DataStore.query(Comment6.self) { (result) in
            switch result {
            case .success(let comments):
                //print(comments)
                print("Comment length \(comments.count)")
            case .failure(let error):
                print(error)
            }
        }
    }
    var body: some View {
        VStack {
//            Button("save", action: {
//                self.save()
//            })
            Button("clear", action: {
                Amplify.DataStore.clear { (result) in
                    switch result {
                    case .success:
                        print("Clear completed")
                    case .failure(let error): print(error)
                    }
                }
            })
            Button("start", action: {
                Amplify.DataStore.start { (result) in
                    switch result {
                    case .success:
                        print("Start completed")
                    case .failure(let error):
                        print(error)
                    }
                }
            })
            
            Button("query blogs", action: {
                self.queryBlogs()
            })
            Button("query posts", action: {
                self.queryPosts()
            })
            
            Button("query comments", action: {
                self.queryComments()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
