# 404 Option not found

In bestimmten Fällen kann es vorkommen, dass der Terraform Provider nicht alle Konfigurationsparameter einer Ressource unterstützt. In diesen Fällen muss man sich was besonderes überlegen...

## Setup

1. Überprüfen, dass das HTTP Application Profile terraform-demo-application-profile nicht existiert

## Durchführung

1. terraform init
2. terraform plan
    - Hier sollte angezeigt werden, dass das Application Profile erstellt wurde.
3. terraform apply
4. Überprüfen über die API, dass das HTTP Profile erstellt wurde.
    - `cat terraform.tfstate | jq -r '.resources[].instances[0].attributes.id' | xargs -I % curl -u "$NSXT_USERNAME:$NSXT_PASSWORD" -k https://$NSXT_MANAGER_HOST/api/v1/loadbalancer/application-profiles/% | jq .`
    - Hier ist dann auch zu sehen, dass das API Objekt auch Konfigurations Parameter besitzt, die Terraform nicht kennt. Beispielsweise: Respons Body Size. Bei manchen Applikationen muss diese hochgesetzt werden. Somit hat man über nur Terraform ein Problem.

5. Nun hat man zwei Optionen. Entweder man baut das Objekt außerhalb von Terraform (und importiert es über eine Data Ressource (Oft nicht möglich, weil bestimmte Attribute fehlen oder es keine Data Ressource dazu gibt)) oder man baut das Objekt über Terraform und passt dieses nachgelagert über ein Skript in einer Pipeline an.
6. Hier haben wir uns für die Variante mit dem Skript entschieden. Das Script passt die Response Header Size entsprechend an und updatet die NSX-T Ressource über die API.
    - Ausführen des Skiprt ./update-object.sh
7. Mit Befehl aus Schritt 4 prüfen, dass die Response Header Size angepasst wurde.
8. terraform plan
    - Zeigt keine Änderungen, weil es diesen Parameter garnicht kennt
9. Anpassen der Terraform konfiguration (bspw. Request Header Size auf 2048)
10. terraform plan
    - Zeigt nur die entsprechende Änderung an
11. terraform apply
12. Befehl aus Schritt 4 ausführen
    - Hier sieht man wieder, dass das Property vom Script wieder zurückgesetzt wurde
    -> NACH JEDEM TERRAFORM APPLY (welches die entsprechende Ressource anpasst) MUSS DAS SCRIPT AUSGEFÜHRT WERDEN! Deswegen in einem Pipeline Schritt nach terraform apply

## Aufräumen

1. terraform destroy

## Was haben wir hieraus gelernt?

Terraform unterstützt nicht immer alle Objekte bzw dessen Properties. Deswegen ist es notwendig Workarounds zu finden und GLEICHZEITIG ein Herstellerticket zu eröffnen, sodass das Property vielleicht nachgepflegt werden kann.
Die Workarounds sind entweder:
- Komplette Erstellung des Objekts außerhalb von Terraform über die API
    - Nachträglich durch terraform import importieren, wenn der Provider die entsprechende Property kennt
    - Nachteil: Nicht alle Ressourcen haben in Terraform eine DATA Ressource und können somit nicht richtig in Terraform genutzt werden
- Anpassung über nachgelagertes Script
    - Entsprechende Property wird über Script angepasst
    - Nachteil: Muss nach jedem terraform apply ausgeführt werden, welches das entsprechende Objekt anpasst
    - Nachteil: Die gewünschte Konfiguration kann kurzzeitig nicht gesetzt sein (Zeit zwischen terraform apply und Ausführung des Skripts)

Auf das manuelle Anlegen der Ressource sollte weiterhin verzichtet werden, da dies bei einem Wiederaufbau zu erhöhtem Aufwand führen kann.