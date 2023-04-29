# Neotest Kotlin

Neotest adapter for Kotlin tests

# BEFORE YOU READ ANY FURTHER :warning:

## Lets manage expectations

This is a very early WIP project, basically a mvp. Many very reasonable features are not yet supported like:

- Using mvnw or gradlew to build the project
- Using anything other than `pom.xml` or `build.gradle.kt` as indicators of the projects root files
- Using DAP to debug your test
- Using anything other than a basic JUnit `@Test` annotation
- Comprehensive logging
- Adding extra configuration thought the setup method

Look at this project less as a implementation of a neotest adapter and more as a experiment to see if I could implement it,
while distracted from more pressing issues with the Kotlin tooling for neovim.

I will continue to tinker on it.

- _Please feel free to open an issue, or contribute if you are missing a key feature_

## Lets say thanks

Many thanks to the guys and girls contributing to the [neotest-dotnet][1] project guiding me thought the process by me stealing much of their project and butchering it.
All the good bits are probably theirs.

# Pre-requisites

neotest-kotlin requires makes a number of assumptions about your environment:

1. Your project is using Maven or Gradle with a `pom.xml` or `build.gradle.kt` file in the root of the directory
2. The user is running tests using one of the supported test runners / frameworks (see support grid)
3. Requires [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) and the parser for Kotlin

# Installation

## Lazy

```
   return {
    "nvim-neotest/neotest",
    dependencies = {
      {
        "Mgenuit/neotest-kotlin",
      },
    }
  }
```

## [vim-plug](https://github.com/junegunn/vim-plug)

```vim
    Plug 'https://github.com/nvim-neotest/neotest'
    Plug 'https://github.com/Mgenuit/neotest-kotlin'
```

# Usage

```lua
require("neotest").setup({
  adapters = {
    require("neotest-kotlin").Adapter
  }
})
```

# Build Tool Support

Currently I aim to support both Maven and Gradle.

## Running Tests

To run the plenary tests from CLI, in the root folder, run

```
make test
`
[1]: https://github.com/Issafalcon/neotest-dotnet
```
