package io.genuit.mavendemo

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Disabled
import org.springframework.boot.test.context.SpringBootTest

class MavenDemoApplicationTests {

	@Disabled
    @Test
	fun contextLoads1() {
        assert(true)
	}

	@Test
	fun contextLoads2() {
       throw Exception()
	}

	@Test
	fun contextLoads() {
        assert(false)
	}

    fun thisIsNoTest(){
    }

}
