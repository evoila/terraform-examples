# Permissions

Dieses Beispiel soll zeigen, wieso man bei den vCenter Permissions direkt mit der Automatisierung anfangen sollte.
Fängt man nicht direkt mit der Automatisierung an und fängt erst per Hand an, können unerwartete Dinge passieren (Verlust von Rechten)!

# Setup

1. Erstelle einen Resource Pool im vCenter mit dem Namen terraform-permission-demo
2. Gehe beim Resource Pool auf den Permissions Tab und weise einem beliebigen (nicht der Terraform Demo User!) irgendwelche Berechtigungen auf dem Ordner.

# Durchführung

1. terraform init
2. terraform plan
    - Hier sollte Terraform nur die Entity Permission anlegen, die im Terraform File angegeben sind.
3. terraform apply
4. Im vCenter schauen, dass noch BEIDE Rechte vorhanden sind
5. terraform plan
    - Hier will Terraform dann plötzlich eine der beiden Permissions (die die mit Hand angelegt wurde) löschen
6. terraform apply
7. Im vCenter schauen und feststellen, dass die zuvor mit Hand angelegte Permission nun nicht mehr da ist
    -> Wenn man nicht aufpasst, können unvorhergesehene Nebeneffekte (Permission Verlust) auftreten

# Aufräumen

1. Erstellten Resource Pool im vCenter wieder löschen