#!/bin/bash

# Prüfe, ob sich das Skript in einem Git-Repository befindet
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    dialog --msgbox "Dieses Skript muss in einem Git-Repository ausgeführt werden." 10 40
    exit 1
fi

# Funktion zum Hinzufügen von Dateien
add_files() {
#    	local files=$(git status --short | awk '{print $2}')
    local files=$(git status --short | awk '{print $2}' | grep -v '\.godot$' | grep -v '^\.godot/$')
    local IFS=$'\n'
    local options=()
    
    for file in $files; do
        options+=("$file" "" "on")
    done
    
    selected_files=$(dialog --stdout --checklist "Wähle Dateien zum Hinzufügen aus:" 20 60 15 "${options[@]}")
    
    if [ -n "$selected_files" ]; then
        git add $selected_files
        dialog --msgbox "Dateien hinzugefügt:\n$selected_files" 10 40
    else
        dialog --msgbox "Keine Dateien hinzugefügt." 10 40
    fi
}

# Funktion zum Erstellen eines Commits
commit_changes() {
    commit_message=$(dialog --stdout --inputbox "Gib eine Commit-Nachricht ein:" 10 40)
    
    if [ -n "$commit_message" ]; then
        git commit -m "$commit_message"
        dialog --msgbox "Commit erstellt mit Nachricht:\n$commit_message" 10 40
    else
        dialog --msgbox "Commit abgebrochen. Keine Nachricht eingegeben." 10 40
    fi
}

# Funktion zum Pushen der Änderungen
push_changes() {
    git push
    dialog --msgbox "Änderungen wurden erfolgreich gepusht." 10 40
}

# Hauptmenü
while true; do
    action=$(dialog --stdout --menu "Wähle eine Aktion:" 15 50 6 \
        1 "Dateien hinzufügen" \
        2 "Commit erstellen" \
        3 "Änderungen pushen" \
        4 "Änderungen auflisten" \
        5 "Beenden")
    
    case $action in
        1) add_files ;;
        2) commit_changes ;;
        3) push_changes ;;
        4) dialog --stdout --prgbox "git log --oneline" 20 60 ;;
        5) break ;;
        *) dialog --msgbox "Ungültige Auswahl." 10 40 ;;
    esac
done

clear
