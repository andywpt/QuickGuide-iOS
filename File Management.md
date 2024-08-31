## Reference
- [iOS Storage Best Practices](https://developer.apple.com/videos/play/tech-talks/204/)

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
- You can skip searching for a subdirectory using `enumerator.skipDescendants()`

### Exclude a file from iCloud backup 
```
var values = URLResourceValues()
values.isExcludedFromBackup = true
try myFileURL.setResourceValues(values)
```
### Use NSFileCoordinator to handle concurrent access to iCloud Drive files from multiple devices
