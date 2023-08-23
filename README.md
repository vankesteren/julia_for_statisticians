# Julia for statisticians
Short live-coding intro to Julia for statisticians

![image](https://user-images.githubusercontent.com/11596858/226922795-8d29f8af-1adb-4316-9cf3-a1fb07b4b5d4.png)


## Setup

- Download and install visual studio code (https://code.visualstudio.com/)
- From within vs code, install the julia extension for visual studio code
- install `juliaup` (https://github.com/JuliaLang/juliaup)
- Install the latest release version with `juliaup` by typing the following in your command line
	```
  juliaup add release
  juliaup default release
  ```
- You can check that this went well with `juliaup status`
- Download the code repository https://github.com/vankesteren/julia_for_statisticians
- open this folder in vs code (or `cd` to it using your terminal)
- open a new julia repl within vs code: (or in your terminal by typing `julia`)
    - press ctrl+shift+p
    - search for Julia: start repl
    - run the command 
- within the repl:
    - press `]` (this opens the julia package manager, your cursor should say `pkg>`
    - type `activate .`
		- type `instantiate`
		- wait a while for all the packages to install :)
    - type `precompile`
    - wait a while for all the packages to precompile :)
    - press backspace to go back to the repl (cursor should now say `julia>`)
    - type `using DataFrames`
    - type `DataFrame()`
    - there should be a `0x0 dataframe` object
	
Now you are ready!
