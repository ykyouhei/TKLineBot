# TKLineBot

[![macOS](https://img.shields.io/badge/os-Mac%20OS%20X-green.svg?style=flat)](http://www.apple.com/macos/) [![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)](http://releases.ubuntu.com/14.04/) [![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0) ![Swift version](https://img.shields.io/badge/swift-3.0.2-orange.svg)

* LineBot用Projectです
* Bluemix上で動作します


## Setup

1) ビルド（Package.swift更新時にも実行する必要があります）
```
$ swift build
```

2) XcodeProjectを生成（Package.swift更新時にも実行する必要があり？）
```
$ swift package generate-xcodeproj
```

3) 実行（コマンドライン）
Once the application is compiled, you can start the server (note that the executable file is located in the `.build/debug` directory: `./.build/debug/Kitura-Starter`):

```
$ ./.build/debug/Kitura-Starter
 INFO: Kitura_Starter main.swift line 29 - Server will be started on 'http://localhost:8090'. 
 INFO: listen(on:) HTTPServer.swift line 73 - Listening on port 8090 
```

4) 実行（Xcode）
XcodeでRun

