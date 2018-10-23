# Disks

File storage abstraction layer for Vapor 3. Simple interface to interact and manipulate with files without caring about tha backing storage - local or cloud.
For tests, you can simply use local filesystem and for staging or production AWS S3 with different buckets. In both cases, you will leverage the same API and chaging the location is only a matter of configuration.

## Features

- [x] Pluggable adapters anyone can develop
- [x] Generic API for handling common file operations
- [x] Local filesystem integration
- [ ] Cloud services integrations (AWS S3)
- [x] Mutiple file storage systems in single application, mixed adapters
- [x] Non-blocking
- [ ] Link generation
- [x] Vapor 3 compatible
- [ ] Works as Vapor caching driver
- [ ] Streams support for big files
- [ ] 100% test coverage

## Adapters

### Core
- Local filesystem
- Null

### Officially supported
- AWS S3 (coming soon)

### Community supported
Create PR and add yours!

## License
The MIT License (MIT)
