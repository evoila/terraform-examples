# Allow Modifications

Dieses Beispiel soll zeigen, wie man Terraform sagt, dass es bestimmte Änderungen ignorieren soll. Dies ist beispielsweise nötig, wenn andere System ein Objekt verändern müssen (beispielsweise Bosh Director und NSGroups).

## Setup

1. Überprüfen, dass die NSGroup terraform-nsgroup-demo im NSX-T nicht existiert.

## Durchführung

1. terraform init
2. terraform plan
    - Hier sollte angezeigt werden, dass eine neue NSGROUP erstellt wird
3. terraform apply
4. Im NSX-T zeigen, dass NSGroup erstellt wurde.
5. Manuell ein Member hinzufügen (bspw. irgendein LogicalPort)
6. terraform plan
    - Hier wird angezeigt, dass der Manuell hinzugefügte Member wieder gelöscht wird.
7. terraform apply
8. Zeigen, dass NSGroup wieder leer ist.
9. NSGroup mit folgendem Code erweitern:

```hcl
lifecycle {
    ignore_changes = [
      member
    ]
}
```

10. Nochmals Member zur NSGroup hinzufügen
11. terraform plan
    - Hier werden nun keine Änderungen mehr angezeigt "No changes."
12. Modifikation der NSGroup über Terraform weiterhin möglich. (bspw. Name ändern)
13. terraform plan
    - Es wird angezeigt, dass nur der Name geändert wird
14. terraform apply
15. Zeigen, dass Namen sich im NSX-T geändert hat, aber das Member immernoch in der NSGroup ist.


## Aufräumen

1. terraform destroy