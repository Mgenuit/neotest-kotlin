package io.genuit.mavendemo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class MavenDemoApplication

fun main(args: Array<String>) {
	runApplication<MavenDemoApplication>(*args)
}
