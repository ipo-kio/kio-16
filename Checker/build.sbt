name := "Kio checkers"

version := "0.1"

resolvers += "Typesafe repository" at "http://repo.typesafe.com/typesafe/releases/"

libraryDependencies ++= Seq(
  "com.fastexml.jackson.core" % "jackson-databind" % "2.5.1"
)