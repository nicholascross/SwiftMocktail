# SwiftMocktail

A http stub file format in Swift

## File Format

- 1: Method
- 2: Path
- 3: Status code
- 4: Content type
- 5..n:  Optional additional HTTP headers - header values delimited by colon any leading or trailing whitespace will be trimmed
- 
- Content after first double line break is considered as the response body

```
GET
user/details
200
application/json
token : 123456
auth : user1234

{
"login" : "user1234",
"name" : "bob"
}
```

### Acknowledgements

The original implementation of this file format was in this github project - https://github.com/puls/objc-mocktail
