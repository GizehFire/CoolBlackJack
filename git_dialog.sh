#!/bin/bash
# Prüfe, ob sich das Skript in einem Git-Repository befindet
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    dialog --msgbox "Dieses Skript muss in einem Git-Repository ausgeführt werden." 10 40
    exit 1
fi

show_changes() {
    # Überprüfen, ob es Änderungen gibt
    if [ -z "$(git diff --name-only --diff-filter=M)" ]; then
        dialog --msgbox "Keine Änderungen vorhanden." 10 40
        return
    fi

    # Sammle alle Änderungen und zeige sie in einer scrollbaren Dialogbox an
    git diff --name-only --diff-filter=M | while read -r file; do
        git diff "$file" > /tmp/diff_output.txt  # Schreibe die Diff-Ausgabe in eine temporäre Datei
        dialog --clear --title "Änderungen in $file" --textbox "/tmp/diff_output.txt" 20 60
    done
}

# Funktion zum Hinzufügen von Dateien
add_files() {
    # Überprüfe, ob relevante Änderungen vorhanden sind, ohne .godot/ und .gitignore Dateien
    if [ -z "$(git status --short | grep -v '\.godot$' | grep -v '^[?][?] \.godot/$' | grep -v '\.gitignore$')" ]; then
        dialog --msgbox "Keine relevanten Änderungen vorhanden." 10 40
        return  # Zurück zum Hauptmenü
    fi

    # Filtere geänderte Dateien, um .gitignore und .godot-Dateien auszuschließen
    local files=$(git status --short | awk '{print $2}' | grep -v '\.godot' | grep -v '^\.godot/$' | grep -v '\.gitignore$')
    local IFS=$'\n'
    local options=()

    # Füge gefilterte Dateien zur Auswahl hinzu
    for file in $files; do
        options+=("$file" "" "on")
    done
    
    # Zeige die Checkliste mit den gefilterten Dateien an
    selected_files=$(dialog --stdout --checklist "Wähle Dateien zum Hinzufügen aus:" 20 60 15 "${options[@]}")

    # Füge die ausgewählten Dateien hinzu, wenn welche gewählt wurden
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
        5 "Letzte Änderungen anzeigen" \
        6 "Beenden")  # Stelle sicher, dass hier die richtige Anzahl angegeben ist

    # Überprüfe den Exit-Status des Dialogs
    exit_status=$?
    if [ $exit_status -eq 1 ] || [ $exit_status -eq 255 ]; then
        clear
        exit 0  # Skript beenden ohne Meldung
    fi

    case $action in
        1) add_files ;;
        2) commit_changes ;;
        3) push_changes ;;
        4) dialog --stdout --prgbox "git log --oneline" 20 60 ;;
        5) show_changes ;;  # Neue Funktion aufrufen
        6) break ;;
        *) dialog --msgbox "Ungültige Auswahl." 10 40 ;;  # Dieser Teil tritt auf, wenn keine der oben genannten Optionen passt
    esac
done

clear
