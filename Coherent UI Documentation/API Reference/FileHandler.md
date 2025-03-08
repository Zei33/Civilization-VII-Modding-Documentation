# FileHandler

The `FileHandler` class allows you to customize how Coherent UI loads resources such as HTML, CSS, JavaScript, and image files.

## Namespace

```cpp
namespace Coherent::UI
```

## Class Definition

```cpp
class FileHandler
```

## Description

The `FileHandler` class is an abstract base class that you can implement to provide custom file handling for Coherent UI. This allows you to:

- Load files from custom locations (e.g., packed archives, memory, remote servers)
- Implement virtual file systems
- Add runtime processing or modification of resources
- Control access to files and resources

By implementing your own `FileHandler`, you can customize how the `coui://` protocol resolves and loads resources.

## Methods to Implement

### Open

```cpp
virtual int Open(const char* path) = 0;
```

Opens a file and returns a handle to it.

#### Parameters
- `path`: The path to the file, relative to the root of the file system.

#### Returns
A non-negative file handle if successful, or a negative value if the file couldn't be opened.

#### Implementation Notes
- The path will be relative to the root of your file system
- You should return a unique handle that can be used to identify the file in subsequent operations
- Return a negative value if the file doesn't exist or can't be opened

### Close

```cpp
virtual void Close(int handle) = 0;
```

Closes a previously opened file.

#### Parameters
- `handle`: The file handle returned by `Open`.

#### Implementation Notes
- Release any resources associated with the file
- Implement proper error checking to handle invalid handles

### GetSize

```cpp
virtual size_t GetSize(int handle) = 0;
```

Gets the size of a file in bytes.

#### Parameters
- `handle`: The file handle returned by `Open`.

#### Returns
The size of the file in bytes.

#### Implementation Notes
- Return 0 if the file is empty or if the handle is invalid
- Handle large files appropriately (>4GB on 64-bit systems)

### Read

```cpp
virtual size_t Read(int handle, void* buffer, size_t size) = 0;
```

Reads data from a file into a buffer.

#### Parameters
- `handle`: The file handle returned by `Open`.
- `buffer`: The buffer to read data into.
- `size`: The number of bytes to read.

#### Returns
The number of bytes actually read.

#### Implementation Notes
- Return 0 if no data could be read or if the file is at the end
- Handle partial reads (returning less than `size` bytes)
- Advance the file pointer after reading

### Seek

```cpp
virtual bool Seek(int handle, size_t offset, FileSeekOrigin origin) = 0;
```

Moves the file pointer to a specified position.

#### Parameters
- `handle`: The file handle returned by `Open`.
- `offset`: The offset from the origin.
- `origin`: The origin from which to seek (Beginning, Current, or End).

#### Returns
`true` if the seek operation was successful, `false` otherwise.

#### Implementation Notes
- Update the file pointer position according to the origin and offset
- Return `false` if the operation would place the pointer outside the file boundaries

### Tell

```cpp
virtual size_t Tell(int handle) = 0;
```

Gets the current position of the file pointer.

#### Parameters
- `handle`: The file handle returned by `Open`.

#### Returns
The current position of the file pointer, in bytes from the beginning of the file.

#### Implementation Notes
- Return 0 if the file pointer is at the beginning
- Return the current offset from the beginning of the file

### Exists

```cpp
virtual bool Exists(const char* path) = 0;
```

Checks if a file exists.

#### Parameters
- `path`: The path to the file.

#### Returns
`true` if the file exists, `false` otherwise.

#### Implementation Notes
- Check if the file exists without actually opening it
- Return `true` only if the file is accessible and readable

## Example Implementation

```cpp
class MyFileHandler : public Coherent::UI::FileHandler {
public:
	MyFileHandler() {
		// Initialize your file system
	}
	
	~MyFileHandler() {
		// Clean up any resources
		for (auto& pair : m_OpenFiles) {
			fclose(pair.second);
		}
	}
	
	int Open(const char* path) override {
		// Convert the path to a platform-specific path
		std::string fullPath = ResolvePath(path);
		
		// Open the file
		FILE* file = fopen(fullPath.c_str(), "rb");
		if (!file) {
			return -1;  // Failed to open
		}
		
		// Assign a unique handle
		int handle = m_NextHandle++;
		m_OpenFiles[handle] = file;
		
		return handle;
	}
	
	void Close(int handle) override {
		auto it = m_OpenFiles.find(handle);
		if (it != m_OpenFiles.end()) {
			fclose(it->second);
			m_OpenFiles.erase(it);
		}
	}
	
	size_t GetSize(int handle) override {
		auto it = m_OpenFiles.find(handle);
		if (it == m_OpenFiles.end()) {
			return 0;
		}
		
		FILE* file = it->second;
		
		// Save current position
		long currentPos = ftell(file);
		
		// Seek to end and get position
		fseek(file, 0, SEEK_END);
		long size = ftell(file);
		
		// Restore original position
		fseek(file, currentPos, SEEK_SET);
		
		return static_cast<size_t>(size);
	}
	
	size_t Read(int handle, void* buffer, size_t size) override {
		auto it = m_OpenFiles.find(handle);
		if (it == m_OpenFiles.end()) {
			return 0;
		}
		
		return fread(buffer, 1, size, it->second);
	}
	
	bool Seek(int handle, size_t offset, Coherent::UI::FileSeekOrigin origin) override {
		auto it = m_OpenFiles.find(handle);
		if (it == m_OpenFiles.end()) {
			return false;
		}
		
		int whence;
		switch (origin) {
			case Coherent::UI::FileSeekOrigin::Beginning:
				whence = SEEK_SET;
				break;
			case Coherent::UI::FileSeekOrigin::Current:
				whence = SEEK_CUR;
				break;
			case Coherent::UI::FileSeekOrigin::End:
				whence = SEEK_END;
				break;
			default:
				return false;
		}
		
		return fseek(it->second, static_cast<long>(offset), whence) == 0;
	}
	
	size_t Tell(int handle) override {
		auto it = m_OpenFiles.find(handle);
		if (it == m_OpenFiles.end()) {
			return 0;
		}
		
		return static_cast<size_t>(ftell(it->second));
	}
	
	bool Exists(const char* path) override {
		std::string fullPath = ResolvePath(path);
		
		FILE* file = fopen(fullPath.c_str(), "rb");
		if (file) {
			fclose(file);
			return true;
		}
		
		return false;
	}
	
private:
	std::string ResolvePath(const char* path) {
		// Convert coui:// path to a real file system path
		// Example: coui://html/index.html -> C:/MyGame/UI/html/index.html
		std::string relativePath = path;
		
		// Remove protocol prefix if present
		const char* couiPrefix = "coui://";
		if (relativePath.substr(0, strlen(couiPrefix)) == couiPrefix) {
			relativePath = relativePath.substr(strlen(couiPrefix));
		}
		
		// Combine with base path
		return m_BasePath + "/" + relativePath;
	}
	
	int m_NextHandle = 1;
	std::map<int, FILE*> m_OpenFiles;
	std::string m_BasePath = "C:/MyGame/UI";  // Base directory for UI files
};
```

## Registering a Custom File Handler

To use your custom `FileHandler`, register it with the `ViewContext`:

```cpp
// Create your file handler
MyFileHandler* fileHandler = new MyFileHandler();

// Set context settings
Coherent::UI::ContextSettings settings;
settings.FileHandler = fileHandler;

// Create view context with the settings
Coherent::UI::ViewContext* context = factory->CreateViewContext(settings, listener, nullptr);
```

## The coui:// Protocol

The `coui://` protocol is the default protocol used by Coherent UI to load resources. When you implement a custom `FileHandler`, you're essentially providing a custom implementation of this protocol.

For example, when a view loads a URL like `coui://html/main.html`, the following process occurs:

1. Coherent UI removes the `coui://` prefix to get the relative path (`html/main.html`)
2. It calls your `FileHandler::Open` method with this relative path
3. Your `FileHandler` resolves the path to an actual resource and returns a handle
4. Coherent UI reads the file content using `FileHandler::Read`
5. The content is processed and displayed in the view

## Multiple Custom Protocols

If you need to support multiple custom protocols, you can implement a more sophisticated `FileHandler` that handles different protocols:

```cpp
int Open(const char* path) override {
	std::string pathStr = path;
	
	if (pathStr.substr(0, 7) == "coui://") {
		// Handle coui:// protocol
		return OpenCouiFile(pathStr.substr(7));
	}
	else if (pathStr.substr(0, 7) == "pack://") {
		// Handle pack:// protocol (e.g., for packed archives)
		return OpenPackedFile(pathStr.substr(7));
	}
	else if (pathStr.substr(0, 9) == "memory://") {
		// Handle memory:// protocol (e.g., for files stored in memory)
		return OpenMemoryFile(pathStr.substr(9));
	}
	
	// Default to coui:// behavior
	return OpenCouiFile(pathStr);
}
```

## Best Practices

1. **Optimize for Performance**: File I/O can be a bottleneck, so implement efficient caching and preloading when appropriate.

2. **Handle Errors Gracefully**: Return appropriate error codes and handle failure cases to avoid crashes.

3. **Implement Thread Safety**: If your game uses multiple threads, ensure your `FileHandler` is thread-safe.

4. **Use Platform-Specific Optimizations**: Take advantage of platform-specific file APIs for better performance.

5. **Support Relative Paths**: Handle relative paths correctly, especially when resources reference other resources.

6. **Consider Resource Compression**: Implement decompression on-the-fly for loading compressed resources.

## See Also

- [ViewContext](ViewContext.md)
- [ContextSettings](ContextSettings.md)
- [Custom File Handler Tutorial](../Samples/Custom_File_Handler.md)
- [Custom IO Handling Guide](../Guides/Custom_IO_Handling.md) 