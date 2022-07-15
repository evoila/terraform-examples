# The glory of variables

Terraform ist ein gutes Tool um mit dem selben Code und unterschiedlicher Variablisierung Objekte des selben Typs aber unterschiedlicher Konfiguration zu erstellen.
Dies ist ein Beispiel, wie aus EINER Konfigurationsdatei die Infrastruktur (hier T1, LS...) von unterschiedlichen Umgebungen (DEV / TEST / PROD) entstehen kann.
(Hier wichtig: eine Konfigurationsdatei mehrere Umgebungen. Natürlich könnte das hier auch über unterschiedliche Pipelines passieren. Dann mehrere Konfigurationsdateien mehrere Umgebungen getrennt durch unterschiedliche Pipelines) 

## Setup

1. Überprüfen, dass T1 Router t1-terraform-demo-dev, t1-terraform-demo-prod und die Switche ls-terraform-demo-dev-sw1, ls-terraform-demo-dev-sw2 sowie ls-terraform-demo-prod-sw1 nicht existieren.

## Durchführung

1. terraform init
2. Umwandelung der YAML Konfiguration in JSON (In einer Pipeline würde das in einem Task stattfinden)
    - yq . variables.yaml -o json > variables.json
3. terraform plan -var-file variables.json
    - Hier werden einige Ressourcen angezeigt (~15 Stück)
4. terraform apply -var-file variables.json
5. Erstellten Switche / T1 in NSX-T zeigen
6. Want another environment? Hinzufügen der notwendigen Konfiguration

```yaml
test:
    switches:
    - name: ls-terraform-demo-test-sw1
      cidr: 4.4.4.1/24
```

7. Wiederholung von Schritt 2
8. terraform plan -var-file variables.json
    - Es werden nur die Ressourcen für das neu angelegte Environment angezeigt.
9. terraform apply -var-file variables.json
10. In NSX-T wurden neue Switche angelegt

## Aufräumen

1. terraform destroy -var-file variables.json

## Was haben wir hieraus gelernt?

Terraform ist ein mächtiges Werkzeug, wenn Variablen genutzt werden. Write Code once - Use it in different environments!