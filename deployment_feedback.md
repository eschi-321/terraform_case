# Wie wuerde ich ein binary auf AWS EC2 deployen?

- Ich benoetige einen Ort, wo ich mein binary ablegen kann, sodass es von EC2 erreicht werden kann.
  - zb. ECR (fuer Container-Images) oder S3 (nachfolgend gehe ich von S3 aus)
- Auf der EC2-Instanz erstelle ich ein Skript, welches sich das Binary von S3 laedt und installiert
  - das Skript kann zb. auch ueber User-data auf der Instanz erzeugt werden, um bei einer neuen Instanz direkt verfuegbar zu sein
  - alternativ: kann man das Skript einmal erstellen und anschliessend ein AMI von der Instanz erzeugen und dies fuer zukuenftige Instanzen verwenden
- Ich wuerde immer ein Tool zur Automatisierung (Pipelines) verwenden: hier Gitlab
- Meine Deploymentumgebung benoetigt Zugriff auf AWS
  - AWS Access-key und Secret Access-key waeren moeglich aber nicht empfohlen
  - Es sollten in jedem Fall Rollen verwendet werden
  - Ggf. bietet Gitlab selbst bereits einen empfohlenen Weg zur integration mit AWS an (zb. runners)
  - Ansonsten habe ich auch gute Erfahrungen mit IAM-Roles-Anywhere gemacht, hierbei erfolgt die Authentifizierung mittels Zertifikat
  - Es gilt darauf zu achten, dass die Rolle nur die Rechte bekommt, die fuer das Deployment zwingend erforderlich sind (least-privilige)
- Nachdem ich sichergestellt habe, dass ich auf AWS zugreifen kann, muss ich die Umgebung meiner Pipeline vorbereiten
  - Ich erstelle alle benoetigten Variablen und Secrets (zb. Instanz-ID, S3-Bucket, ...)
- Ich erstelle meine Pipeline:
  - (falls noch nicht geschehen) baue ich mein binary
  - hochladen des binarys in S3
  - Ueber SSM lasse ich das Skript ausfuehren, um das Binary zu installieren

# Feedback und ergaenzende Worte

<p> Die Aufgabe mit dem erstellen des Moduls und der Implementierung im Projekt war gar nicht so trivial.<br>
Aufgrund der unterschiedlichen Regionen der Services musste ich oefters umdenken und initiale Gedankengaenge verwerfen (zb. vpc-endpoints fuer S3). <br>
Leider konnte ich auch nicht testen ob mein Code sich tatsaechlich so deployen laesst, wie ich ihn geschrieben habe. <br>
Es kann daher durchaus sein, dass der Zugriff von EC2 auf S3 insbesondere noch beim Netzwerk oder an IAM haengen bleibt. <br>
In das ganze Thema mit den Netzwerk-Komponenten musste ich mich erstmal wieder einlesen, da ich zuletzt immer das offizielle TF-VPC-Modul genutzt habe. <br>
Dies nimmt einem die ganzen Verbindungen zwischen den Resourcen ab. <br>
Es haette mir geholfen, wenn ich mehr Infos zur Konfiguration gehabt haette (zb. Verschluesselung, versionierung, Festplatte, ...) - Ich hoffe meine Annahmen sind ausreichend. <p>

<p> Die Aufgabe mit dem EC2 Deployment hat mich auch zum Nachdenken angeregt. <br>
Aktuell arbeite ich ausschliesslich mit Containern als Applikationen, diese werden dann zumeist auf ECS deployed, wo der Prozess ein etwas anderer ist. <br>
Ein Deployment auf EC2 direkt habe ich schon lange nicht mehr gemacht und ich bin mir auch nicht Sicher, ob der oben genannte Ansatz wirklich die beste Loesung darstellt. <p>
