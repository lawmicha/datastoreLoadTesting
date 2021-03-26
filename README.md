1. `amplify add api`, with conflict resolution enabled, and using `schema.graphql`, `amplify push`

2. `xed .`

3. save 100 blogs, 300 posts, 900 comments

4. `amplify console api` and you can query for them

```
query MyQuery {
  listBlog6s {
    items {
      updatedAt
      name
      id
      createdAt
      _version
      _lastChangedAt
      _deleted
      posts {
        items {
          comments {
            nextToken
            startedAt
            items {
              _deleted
              _lastChangedAt
              _version
              content
              createdAt
              id
              postID
              updatedAt
            }
          }
          blogID
          _version
          _lastChangedAt
          _deleted
          createdAt
          id
          title
          updatedAt
        }
        nextToken
        startedAt
      }
    }
    nextToken
  }
}

```

5. check out data sources and open the tables for Blog, Post, Comment. make sure the count is correct. this will take some time for the app to save 

6. datastore clear and start. this will kick off the sync queries. notice the foreign key constraint issue

7. query for blog post and comments, the counts should not match 100, 300, 900 since some data could not be saved.

Without this change
```
Time elapsed Blog: 6.5854270458221436 s

Blog length 100
Post length 282
Comment length 762
```

With the change
```
Blog length 100
Post length 300
Comment length 900

Time elapsed Blog: 5.949587941169739 s.
Time elapsed Post: 14.409731984138489 s.
Time elapsed Comments: 34.13021099567413 s.
```

Because the operation fails out, 
```
2021-03-25 19:48:00.314409-0700 datastoreLoadTesting[73007:41288736] [ReconcileAndLocalSaveOperation] respond(to:): inError(DataStoreError: The operation couldn’t be completed. (SQLite.Result error 0.)
Recovery suggestion: The operation couldn’t be completed. (SQLite.Result error 0.)
Caused by:
FOREIGN KEY constraint failed (code: 19))
```