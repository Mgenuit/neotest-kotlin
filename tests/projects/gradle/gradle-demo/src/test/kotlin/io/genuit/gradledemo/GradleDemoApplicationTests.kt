package io.genuit.gradledemo

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Disabled
import org.springframework.boot.test.context.SpringBootTest

class GradleDemoApplicationTests {
	@Disabled
    @Test
	fun simpleDisabledTest() {
        assert(true)
	}

	@Test
	fun simpleExceptionTest() {
       throw Exception()
	}

	@Test
	fun simpleFailedTest() {
        assert(false)
	}

	@Test
	fun simpleFaildTest() {
        assert(true)
	}

    fun thisIsNoTest(){
    }


}
