# terraform-examples

Dieses Repository beinhaltet einige Terraform Beispiele, welche zeigen sollen, wieso man mit der Automatisierung bei Tag 0 anfangen sollte und wieso es schlecht ist, Dinge per Hand anzufassen

## Globales Setup

Für den Gebrauch der beispiele wird Terraform Version v1.2.5 benötigt.

Für den Gebrauch der entsprechenden Provider müssen folgende Umgebungsvariablen gesetzt werden:

- `NSXT_MANAGER_HOST`(Ohne HTTP/S)
- `NSXT_USERNAME`
- `NSXT_PASSWORD`
- `VSPHERE_SERVER` (Ohne HTTP/S)
- `VSPHERE_USER`
- `VSPHERE_PASSWORD`

Es wurden alle Beispiele in der Sandbox vcsasdbx01 / nsxsdbx01 auf Funktionalität überprüft