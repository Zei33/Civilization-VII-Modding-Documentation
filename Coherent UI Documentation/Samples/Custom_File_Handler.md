# Custom File Handler Sample

This guide walks through the "Custom File Handler" sample included with Coherent UI, which demonstrates how to implement a custom file loading system for your UI resources.

## Overview

The Custom File Handler sample shows how to:

1. Implement a custom `FileHandler` class
2. Register it with Coherent UI
3. Load UI resources from custom locations
4. Handle multiple file sources (filesystem, embedded, virtual)

This is particularly useful for games that need to:
- Load UI resources from packed archives
- Implement virtual file systems
- Modify resources at runtime
- Control access to files and resources

## Sample Files

The sample includes the following key files:

- `CustomFileHandlerSample.cpp` - The main sample implementation
- `CustomFileHandlerSample.h` - Sample header file
- `CustomFileHandler.h` - Custom file handler implementation
- `CustomFileHandler.cpp` - Implementation details
- `html/` - Directory containing sample HTML files

## Implementation Details

### The Custom File Handler Class

The sample implements a custom file handler that can load files from multiple sources:

```cpp
class CustomFileHandler : public Coherent::UI::FileHandler {
public:
	CustomFileHandler(const std::string& basePath);
	~CustomFileHandler();
	
	// FileHandler interface implementation
	int Open(const char* path) override;
	void Close(int handle) override;
	size_t GetSize(int handle) override;
	size_t Read(int handle, void* buffer, size_t size) override;
	bool Seek(int handle, size_t offset, Coherent::UI::FileSeekOrigin origin) override;
	size_t Tell(int handle) override;
	bool Exists(const char* path) override;
	
	// Additional methods for the sample
	void AddVirtualFile(const std::string& path, const std::string& content);
	void RegisterEmbeddedFile(const std::string& path, const void* data, size_t size);
	
private:
	struct FileHandle {
		enum class Type { Regular, Virtual, Embedded };
		
		Type type;
		FILE* regularFile;
		std::string virtualContent;
		const void* embeddedData;
		size_t embeddedSize;
		size_t position;
	};
	
	std::string m_BasePath;
	int m_NextHandle;
	std::map<int, FileHandle> m_OpenFiles;
	std::map<std::string, std::string> m_VirtualFiles;
	std::map<std::string, std::pair<const void*, size_t>> m_EmbeddedFiles;
	
	std::string ResolvePath(const char* path);
};
```

### Opening Files

The `Open` method demonstrates how to handle different file sources:

```cpp
int CustomFileHandler::Open(const char* path) {
	std::string normalizedPath = ResolvePath(path);
	
	// Check if it's a virtual file
	auto virtualIt = m_VirtualFiles.find(normalizedPath);
	if (virtualIt != m_VirtualFiles.end()) {
		int handle = m_NextHandle++;
		
		FileHandle fileHandle;
		fileHandle.type = FileHandle::Type::Virtual;
		fileHandle.regularFile = nullptr;
		fileHandle.virtualContent = virtualIt->second;
		fileHandle.embeddedData = nullptr;
		fileHandle.embeddedSize = 0;
		fileHandle.position = 0;
		
		m_OpenFiles[handle] = fileHandle;
		return handle;
	}
	
	// Check if it's an embedded file
	auto embeddedIt = m_EmbeddedFiles.find(normalizedPath);
	if (embeddedIt != m_EmbeddedFiles.end()) {
		int handle = m_NextHandle++;
		
		FileHandle fileHandle;
		fileHandle.type = FileHandle::Type::Embedded;
		fileHandle.regularFile = nullptr;
		fileHandle.virtualContent.clear();
		fileHandle.embeddedData = embeddedIt->second.first;
		fileHandle.embeddedSize = embeddedIt->second.second;
		fileHandle.position = 0;
		
		m_OpenFiles[handle] = fileHandle;
		return handle;
	}
	
	// Try to open as a regular file
	std::string fullPath = m_BasePath + "/" + normalizedPath;
	FILE* file = fopen(fullPath.c_str(), "rb");
	if (!file) {
		return -1;  // Failed to open
	}
	
	int handle = m_NextHandle++;
	
	FileHandle fileHandle;
	fileHandle.type = FileHandle::Type::Regular;
	fileHandle.regularFile = file;
	fileHandle.virtualContent.clear();
	fileHandle.embeddedData = nullptr;
	fileHandle.embeddedSize = 0;
	fileHandle.position = 0;
	
	m_OpenFiles[handle] = fileHandle;
	return handle;
}
```

### Reading Files

The `Read` method shows how to handle reading from different sources:

```cpp
size_t CustomFileHandler::Read(int handle, void* buffer, size_t size) {
	auto it = m_OpenFiles.find(handle);
	if (it == m_OpenFiles.end()) {
		return 0;
	}
	
	FileHandle& fileHandle = it->second;
	
	switch (fileHandle.type) {
		case FileHandle::Type::Regular:
			return fread(buffer, 1, size, fileHandle.regularFile);
			
		case FileHandle::Type::Virtual: {
			size_t available = fileHandle.virtualContent.size() - fileHandle.position;
			size_t toRead = std::min(size, available);
			
			if (toRead > 0) {
				memcpy(buffer, fileHandle.virtualContent.data() + fileHandle.position, toRead);
				fileHandle.position += toRead;
			}
			
			return toRead;
		}
		
		case FileHandle::Type::Embedded: {
			size_t available = fileHandle.embeddedSize - fileHandle.position;
			size_t toRead = std::min(size, available);
			
			if (toRead > 0) {
				memcpy(buffer, static_cast<const char*>(fileHandle.embeddedData) + fileHandle.position, toRead);
				fileHandle.position += toRead;
			}
			
			return toRead;
		}
		
		default:
			return 0;
	}
}
```

### Registering the File Handler

The sample shows how to register the custom file handler with Coherent UI:

```cpp
void CustomFileHandlerSample::Initialize() {
	// Create the custom file handler
	m_FileHandler = new CustomFileHandler("html");
	
	// Add a virtual file
	m_FileHandler->AddVirtualFile("virtual.html", 
		"<!DOCTYPE html>"
		"<html>"
		"<head>"
		"    <title>Virtual File</title>"
		"</head>"
		"<body>"
		"    <h1>This file doesn't exist on disk!</h1>"
		"    <p>It was created dynamically in memory.</p>"
		"</body>"
		"</html>"
	);
	
	// Register an embedded file
	static const char* embeddedContent = 
		"<!DOCTYPE html>"
		"<html>"
		"<head>"
		"    <title>Embedded File</title>"
		"</head>"
		"<body>"
		"    <h1>This file is embedded in the executable!</h1>"
		"    <p>It was compiled directly into the application.</p>"
		"</body>"
		"</html>";
	
	m_FileHandler->RegisterEmbeddedFile("embedded.html", embeddedContent, strlen(embeddedContent));
	
	// Initialize Coherent UI with the custom file handler
	Coherent::UI::ContextSettings settings;
	settings.FileHandler = m_FileHandler;
	
	m_ViewContext = m_Factory->CreateViewContext(settings, this, nullptr);
}
```

### Sample UI Files

The sample includes several HTML files that demonstrate different loading scenarios:

1. **regular.html** - A normal file loaded from the filesystem
2. **virtual.html** - A file created dynamically in memory
3. **embedded.html** - A file embedded directly in the application code

The sample UI provides buttons to switch between these files, showing how each type is loaded through the custom file handler.

## Running the Sample

To run the sample:

1. Build and run the CustomFileHandler sample application
2. The sample will create a window showing the initial UI
3. Click the buttons to load different file types
4. Observe how each file is loaded through the custom file handler

## Key Takeaways

1. **Custom Resource Loading**: Implement custom loading logic for your UI resources.

2. **Multiple Sources**: Load files from different sources (filesystem, memory, embedded).

3. **Virtual Files**: Create files that don't exist on disk but can be used by the UI.

4. **Embedded Resources**: Package resources directly into your executable.

5. **Custom Protocols**: Implement virtual protocols beyond the standard `coui://`.

## Extending the Sample

You can extend this sample in several ways:

1. **Implement File Caching**: Add caching to improve performance for frequently accessed files.

2. **Add Resource Packing**: Load resources from a packed archive format.

3. **Implement Encryption/Decryption**: Add security by encrypting sensitive resources.

4. **Add Hot Reloading**: Implement detection of file changes for development workflows.

5. **Support Async Loading**: Add asynchronous file loading for large resources.

## See Also

- [FileHandler API](../API%20Reference/FileHandler.md)
- [ViewContext API](../API%20Reference/ViewContext.md)
- [ContextSettings API](../API%20Reference/ContextSettings.md)
- [Custom IO Handling Guide](../Guides/Custom_IO_Handling.md) 