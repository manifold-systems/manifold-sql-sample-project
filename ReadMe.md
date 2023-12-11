
## Manifold SQL Sample Project (Maven, IntelliJ)

Utilize a sampling of manifold-sql features to demonstrate the
structure of a basic project using Manifold. Use the `pom.xml` file as a
template for your own project.

If you simply want to experiment with Manifold, this project will help get you started.

* `git clone https://github.com/manifold-systems/manifold-sql-sample-project.git`
* Build: `mvn clean compile`
* For the optimal experience, use [IntelliJ IDEA](https://www.jetbrains.com/idea/download)
* Install the **Manifold plugin** from within IntelliJ: `Settings | Plugins | Marketplace`
* Restart IntelliJ to use the plugin
* Open the project you just cloned (open the root directory or the pom.xml file)
* Add the [Java 17 JDK](https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=hotspot): `File | Project Structure | SDKs | + | path-to-your-Jdk17`
* Set the project JDK and language level: `File | Project Structure | Project` select `17` for both `Project JDK` and `Project language level`
* Build the project
* Examine the `RunMe.java` file