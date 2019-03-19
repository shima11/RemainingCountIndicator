# RemainingCountIndicator

# Overview

RemainingCountIndicator is twitter like remaining count indicator.

<img src="demo.gif" width="300">

# Usage

```
let remaingCountIndicator = RemainigCountIndicator(
  maximumNumber: 20,
  config: RemainigCountIndicator.Config.init(threshold1: 5, threshold2: -5),
  style: RemainigCountIndicator.Style.init()
)

remaingCountIndicator.currentNumber = 10
```

# Installation

## CocoaPods

```
pod 'RemainingCountIndicator'

```

## Carthage

```
github "shima11/RemainingCountIndicator"
```

# Licence

Licence MIT
