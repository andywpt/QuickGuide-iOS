## Reference
- [iOS Storage Best Practices](https://developer.apple.com/videos/play/tech-talks/204/)

### Use the default FileManager's `contentsOfDirectory` method to get first-level file urls under a folder
```
let fileUrls = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
```
### Use the default FileManager's `enumerator` method to get all file urls (including subdirectories) under a folder 
```
let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)!
for case let file as URL in enumerator where file.pathExtension == "txt" { print(file.lastPathComponent) }
```
- You can skip searching for a subdirectory using `enumerator.skipDescendants()`

### Use `isExcludedFromBackup` to exclude files from iCloud backup (Cache Directory and Temporary Directory are not backed up and not reported in your app's Documents & Data total)

```
var values = URLResourceValues()
values.isExcludedFromBackup = true
try myFileURL.setResourceValues(values)
```
### Use NSFileCoordinator to handle concurrent access to iCloud Drive files from multiple devices
### Where to store files ?
- Files that the user should see (images, pdfs ...) -> **Documents Directory**
- Files that the user shouldn't see (database json files ...) -> **Application Support Directory**
- Files that are for caching -> **Caches Directory**
- Files that are for temporary usage -> **Temporary Directory**
- You should manually remove files in Temporary Directory after you're done with them, even though the system will periodically remove these files when your app is not running
