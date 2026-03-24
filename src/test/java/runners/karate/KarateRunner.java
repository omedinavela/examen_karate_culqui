package runners.karate;

import com.intuit.karate.junit5.Karate;

public class KarateRunner {
//

    @Karate.Test
    Karate runAllUsersTests() {
        return Karate.run(
                "classpath:features/auth/create-token.feature",
                "classpath:features/booking/get-booking.feature",
                "classpath:features/booking/update-booking.feature"
        ).relativeTo(getClass());
    }
}