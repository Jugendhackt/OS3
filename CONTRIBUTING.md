# Introduction

### Willkommen in der Conribution Guideline File

&gt; Erstmal vielen Dank für das Interesse an einem Beitrag. Auf dieser Seite werden alle wichtigen Informationen zum Beitragen am Projekt genannt.

&gt; Wie im [Code of Conduct](https://github.com/Jugendhackt/OS3/blob/master/CODE_OF_CONDUCT.md) beschrieben wollen wir einen freundlichen und gewinnbringenden Umgang miteinander fördern. Zudem möchte keiner undokumentierten und nicht funktionierenden Code. Deswegen wäre es wichtig für jeden, der etwas zum Projekt beitragen möchte die Contribution Guidelines gründlich zu lesen.

### Wie kann man zum Projekt beitragen?

&gt; Im Grunde ist fast jeder Beitrag eine Hilfe für unser kleines Team. Mögliche Beitragsformen sind Verbesserungen der Dokumentation, Bug Tracking & Fixing oder auch das Schreiben von Tutorials.

### Was für Beiträge sind NICHT gewünscht?

&gt; Bevor ihr irgendwelche Problem meldet, schaut bitte, ob schon andere Personen diese hatten, falls nicht öffnet ein issue damit das Problem gelöst werden kann. Außerdem solltet ihr das [wiki](https://github.com/Jugendhackt/OS3/wiki) durchstöber bevor ihr irgendwelche Fragen oder Probleme bei der Installation oder Konfiguration der Software meldet.

# Grundregeln

&gt; * Falls möglich sorge für Cross-Platform-Unterstützung

&gt; * Teste deine Software bevor du sie veröffentlichst und lass nicht andere deine Bugs suchen

&gt; * Erstelle ein issue für größere Änderungen, bespreche diese transparent und hol dir Community Feedback.

&gt; * Füge Code zum Kerncode nur hinzu, falls unbedingt nötig und wenn du welchen hinzufügst, dokumentiere deine Erweiterung/Änderung, sodass man weiß was passiert und wer dafür Verantwortlich ist.

&gt; * Sei freundlich gegenüber allen Leuten auch Neulingen. Siehe für Details in den [Code of Conduct](https://github.com/Jugendhackt/OS3/blob/master/CODE_OF_CONDUCT.md).

# Dein erster Beitrag?
Um dich mit dem Projekt und den Funktionen vertraut zu machen, solltest du erstmal das [wiki](https://github.com/Jugendhackt/OS3/wiki) lesen hier werden sämtliche Funktionen und Funktionsweisen des Projektes (einigermaßen) übersichtlich aufgelistet und erklärt.

Falls du das schon getan hast schau mal in die [Issues](https://github.com/Jugendhackt/OS3/issues) dort findet sich sicher etwas wozu du beitragen kannst. Alternativ kannst du ein eigenes öffnen falls du irgendeine Funktion vermisst.

### Neu bei Open Source Projekten?
Hier sind ein paar einfache Tutorials: http://makeapullrequest.com/, http://www.firsttimersonly.com/

Verzweifelst du an deiner ersten Pull Request? Dann schaue dir [diese](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github) kostenlose Videoreihe an.

# Loslegen
### Wie läuft ein Beitrag ab?

Erstelle am besten ein Issue mit den Änderungen, die du haben möchtest. Auf diesem postest du die Codeänderung und wie sehr du den Code getestet hast (Niemand möchte fehlerhaften Code also tut allen diesen Gefallen).

Bei größeren Änderung erstelle deine eigene Fork und beachte, dass weiterhin die LGPLv3 oder die GPLv3 verwendet werden. Falls dein Projekt jedoch nur mit diesem Projekt interagiert jedoch nicht auf dessen Quellcode basiert kann auch jede andere Lizenz verwendet werden.
Wenn du der Meinung bist, dass deine Änderung essenziell ist, öffne einfach ein issue und jemand wird sich (hoffentlich in absehbarer Zeit) darum kümmern.

### Was ist mit kleinen Verbesserungen?

&gt; Änderungen sind offensichtliche Verbesserungen, wenn weder neue Funktionen hinzufügen werden noch Kreatives Denken benötigt wird. Wenn das der Fall ist, ist der Beitrag zu klein um als intellektueller Besitz bezeichnet zu werden und kann durch einen Contributor einfach als Patch veröffentlicht werden. Jedoch sollte dieser den Namen der Person, die den Hinweis gab, im Commit nennen. Beispiele für die das der Fall ist können folgende sein:

&gt;* Rechtschreibungs- und Grammatikkorrekturen

&gt;* Formatierungsänderungen

&gt;* Aufräumen der Kommentare

&gt;* Bug Fixes die einen Standartrückgabewert ändern oder Fehler die in Konstanten gespeichert werden

&gt;* Hinzufügen von Logging Nachrichten oder Debug Ausgaben

&gt;* Änderungen an Meta-Dateien wie .gitignore, build scripts, etc.

&gt;* Verschieben von Quelldateien in ein anderes Verzeichnis oder Package

# Ich hab einen Bug gefunden was soll ich tun?
### Betrifft dein Bug eine Sicherheitsproblem?
&gt; All Sicherheitsprobleme sollten an 14131388+noah1510@users.noreply.github.com gemeldet werden bevor die Lücke allen in einem issue preisgegeben wird.

&gt; Falls du dir nicht sicher bist, ob du mit einem Sicherheitsproblem konfrontiert stelle dir die folgenen Fragen:

&gt; * Kann ich auf etwas, dass nicht mir gehört bzw. auf, dass ich keinen Zugriff haben sollte, zugreifen?

&gt; * Kann ich irgendetwas etwas für andere außer Stand setzen oder blockieren?

&gt; Falls die Antwort auf eine der Fragen "Ja" ist, handelt es sich höchstwahrscheinlich um ein Sicherheitsproblem. 
Beachte, dass es sich auch um ein Sicherheitsproblem handeln kann, selbst wenn die Antwort auf beide Fragen "nein" ist. Falls du dir unsicher bist, schreibe eine E-Mail an 14131388+noah1510@users.noreply.github.com du solltest dann zeitnah weitere Informationen bekommen.

### Was wenn es sich nicht um ein Sicherheitsproblem handelt.

&gt; Wenn du ein Issue erstellst stelle sicher, dass du die folgenden Sachen beachtest:

&gt; 1. Hatte jemand anderes schon das gleiche Problem?

&gt; 2. Welche Version(Commit Nummer) der Software nutzt du?

&gt; 3. Welches Beriebssystem und Prozessorarchitektur nutzt du?

&gt; 4. Was hast du getan/versucht zu tun?

&gt; 5. Was hast du erwartet zu sehen?

&gt; 6. Was hast du stattdessen gesehen?

# Wie kann ich eine neue Funktion vorschlagen?
### Was ist das Ziel des Projektes?

&gt; OS3 versucht ein System zu schaffen mit dem Schulen oder andere Organisationen möglichst leicht ihre Daten verwalten können. Dazu muss das System flexibel und übersichtlich sein und ganz viele optionale Module anbieten die alle mit dem Hauptprogramm arbeiten. Dabei sind wir auf Vorschläge der Community angewiesen.

### Was muss ich bei einem Vorschlag beachten?

&gt; Falls du eine neue Funktion willst, die bisher in der Software fehlt, dann bist du wahrscheinlich nicht allein. Bevor du ein neues issue erstellst, schaue ob nicht eine andere Person genau diese Idee hatte. Wenn nicht, erstelle einfach ein issue in dem du beschreibst was für eine Funktion du sehen möchtest, warum du/man diese braucht und wie sie funktionieren soll. Die Community wird sicher dabei helfen die Funktion umzusetzen.

# Was passiert bei einer Pull Request?

&gt; Das Kernteam schaut regelmäßig nach Pull Reqests. Ob eine Pull request angenommen wird, wird gegebenenfalls auf dem [Discord Server](https://discord.gg/7EvAB6f) besprochen und Updates vom Kernteam im update-notes channel veröffentlicht. Leute, deren Pull Request angenommen wurde erhalten den Contributor Status auf dem Discord Server.

# Community

&gt; Für interessierte Leute besteht die Möglichkeit unserem [Discord Server](https://discord.gg/7EvAB6f) beizutreten um mit dem Kernteam und Beitragenden Kontakt aufnehmen zu können.
