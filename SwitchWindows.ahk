; Initialize global variables to keep track of current window index
global edgeIndex := 1
global terminalIndex := 1
global vscodeIndex := 1
global neovideIndex := 1
global teamsIndex := 1
global lastWindowType := ""

; Function to cycle through windows with a check for the current active window
cycleWindows(exeName, indexRef, windowType) {
  global lastWindowType
  windows := WinGetList("ahk_exe " exeName)
  filteredWindows := []

  ; Filter windows to exclude those without a title or not visible
  for _, window in windows {
    if (WinGetTitle(window) != "") {
      filteredWindows.Push(window)
    }
  }

  ; Manually sort the filtered windows by their HWND to ensure consistent order
  for i, win1 in filteredWindows {
    for j, win2 in filteredWindows {
      if (i < j && win1 > win2) {
        temp := filteredWindows[i]
        filteredWindows[i] := filteredWindows[j]
        filteredWindows[j] := temp
      }
    }
  }

  if (filteredWindows.Length > 0) {
    ; Check if the last window type matches the current type
    if (lastWindowType = windowType) {
      ; Cycle to the next window if the type is the same
      indexRef := Mod(indexRef, filteredWindows.Length) + 1

    } else {
      ; Use the current index if switching to a different type
      indexRef := Mod(indexRef - 1, filteredWindows.Length) + 1
    }

    ; Activate the next window in the filtered list
    WinActivate(filteredWindows[indexRef])

    ; Update the last window type
    lastWindowType := windowType
  } else {
    MsgBox("No valid windows found for " exeName)
  }
  return indexRef
}

; Switch to MS Edge and cycle through windows
!1:: {
  global edgeIndex, lastWindowType
  edgeIndex := cycleWindows("msedge.exe", edgeIndex, "edge")
}

; Switch to Windows Terminal and cycle through windows
!2:: {
  global terminalIndex, lastWindowType
  terminalIndex := cycleWindows("WindowsTerminal.exe", terminalIndex, "terminal")
}

; Switch to Neovide and cycle through windows
!3:: {
  global neovideIndex, lastWindowType
  neovideIndex := cycleWindows("neovide.exe", neovideIndex, "neovide")
}

; Switch to Microsoft Teams and cycle through windows
!4:: {
  global teamsIndex, lastWindowType
  teamsIndex := cycleWindows("ms-teams.exe", teamsIndex, "teams")
}

; Switch to Visual Studio Code and cycle through windows
!5:: {
  global vscodeIndex, lastWindowType
  vscodeIndex := cycleWindows("Code.exe", vscodeIndex, "vscode")
}
