## Reference
- [iOS Storage Best Practices](https://developer.apple.com/videos/play/tech-talks/204/)
## FileManager
### Shared instance ➡️ `FileManager.default`
### Get first-level file urls under a folder ➡️ `contentsOfDirectory` method
### Get all file urls (including subdirectories) under a folder ➡️  `enumerator` method
```
let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)!
for case let file as URL in enumerator where file.pathExtension == "txt" { print(file.lastPathComponent) }
```
- You can skip searching for a subdirectory using `enumerator.skipDescendants()`
## Commonly Used Directories
- **Documents Directory**: store files that users should see (images, pdfs ...)
- **Application Support Directory** store files that users shouldn't see (database json files ...)
- **Caches Directory** store cached data
- **Temporary Directory:** store temporary files
```
let directoryUrl = try! FileManager.default.url(
  for: // .documentDirectory, .cachesDirectory, .applicationSupportDirectory ,
  in: .userDomainMask,
  appropriateFor: nil,
  create: true
)
// For Temporary Directory
let url = URL(filePath: NSTemporaryDirectory())

// iOS 16+
URL.documentsDirectory
URL.applicationSupportDirectory
URL.cachesDirectory
URL.temporaryDirectory
```
> [!NOTE]
> You should manually remove files in the **Temporary Directory** after you're done with them, even though the system       will periodically remove these files when your app is not running.
> 
> **Cache Directory** and **Temporary Directory** are not backed up and not reported in your app's Documents & Data total

### Use `isExcludedFromBackup` to exclude files from iCloud backup ()
```
var values = URLResourceValues()
values.isExcludedFromBackup = true
try fileUrl.setResourceValues(values)
```
### Use NSFileCoordinator to handle concurrent access to iCloud Drive files from multiple devices
