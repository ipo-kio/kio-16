name := "Kio checkers"

version := "0.1"

resolvers += "Typesafe repository" at "http://repo.typesafe.com/typesafe/releases/"

libraryDependencies ++= Seq(
  "com.fasterxml.jackson.core" % "jackson-databind" % "2.5.1",
  "org.jopendocument" % "jOpenDocument" % "1.3",
  "com.itextpdf" % "itext-xtra" % "5.4.4",
  "com.opencsv" % "opencsv" % "3.4"
)