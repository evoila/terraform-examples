# Permission Order

Dieses Beispiel soll zeigen, dass es bei manchen Terraform Ressourcen wichtig ist sogar auf die Reihenfolge von einzelnen "inneren" Objekten zu achten, da sonst beim Apply mehr Änderungen gemacht werden als eigentlich notwendig!

Als Beispiel dienen hier die vSphere Permissions. Diese müssen alphabetisch sortiert sein!
(Beispiel semi gut - Früher wurden die Änderungen bei jedem Plan angezeigt :/ . Vielleicht aber trotzdem gut, um zu zeigen, dass manchmal komische Pläne das richtige bewirken)

## Setup

1. Überprüfen, dass der Resource Pool terraform-permission-order-demo nicht existiert.

## Durchführung

1. terraform init
2. terraform plan
    - Hier sollte angezeigt werden, dass ein RP erstellt und die Rechte darauf vergeben werden.
3. terraform apply
4. Im vCenter schauen, dass der RP angelegt wurden und die entsprechenden Rechte darauf erteilt wurden (This object and its children).
5. Neue Permission im entity permission object hinzufügen (ganz ans Ende des Objekts)

```hcl
permissions {
    user_or_group = "vsphere.local\\mdima"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.administrator.id
}
```

5. terraform plan
    - Hier wird nun angezeigt, dass eine neue Permission hinzugefügt wird. ABER: Es wird auch angezeigt, dass an anderen Permissions was geändert wird (weil die User nicht alphabetisch sortiert sind)
6. Permissions sortieren (mdima -> nfeldhausen -> sbaier -> terraform-demo)
7. terraform plan
    - Zeigt einen ähnlichen Output wie Schritt 5 an, aber wenn beim nächsten Mal am ein User mit beispielsweise mit z eingefügt, wird nur dieser User erstellt und die anderen Änderungen werden nicht angezeigt.

## Aufräumen

1. terraform destroy