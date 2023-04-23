package io.genuit.gradledemo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class GradleDemoApplication

fun main(args: Array<String>) {
	runApplication<GradleDemoApplication>(*args)
}
