tasks.create("compile") {
  group = "compile"
  description = "compile task"
  println("[phase:configuration] compile")
  doFirst {
    println("[phase:execution] compile :doFirst()")
  }
}

tasks.create("test") {
  group = "test"
  description = "test task"
  println("[phase:configuration] test")
  doLast {
    println("[phase:execution] test:doLast()")
  }
}.dependsOn("compile")

tasks.create("packaging") {
  group = "packaging"
  description = "packaging task"
  enabled =  true
  println("[phase:configuration] packaging")
  doLast {
    println("[phase:execution] packaging:doLast()")
  }
}.dependsOn("test")

open class Install: DefaultTask() {
  lateinit var installObjectName: String

  @TaskAction
  fun checkObject() {
    println("[phase:execution] install:checkObject   (${installObjectName})")
  }

  @TaskAction
  fun installObject() {
    println("[phase:execution] install:installObject (${installObjectName})")
  }
}

tasks.create<Install>("install") {
  group = "install"
  description = "install task"
  installObjectName = "test.jar"
  var isSkip = false

  println("[phase:configuration] install")
  doFirst {
    println("[phase:execution] install:doFirst()")
  }
  doLast {
    println("[phase:execution] install:doLast()")
  }
  onlyIf { !isSkip }
}.dependsOn("packaging")
