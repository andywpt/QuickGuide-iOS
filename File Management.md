### Shallow search for all .txt files under a folder
```
let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)

for file in contents where file.pathExtension == "txt" {
    print(file.lastPathComponent)
}
```
### Deep search of all .txt files under a folder
```
let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)!

for case let file as URL in enumerator where file.pathExtension == "txt" {
    print(file.lastPathComponent) // file1.txt, file2.txt
}
```
