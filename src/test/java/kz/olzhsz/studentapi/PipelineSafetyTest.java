package kz.olzhsz.studentapi;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertFalse;

class PipelineSafetyTest {
    @Test
    void controlledFailureIsDisabledForNormalBuilds() {
        assertFalse(Boolean.getBoolean("midterm.controlledFailure"),
                "Controlled failure for Ziyayev Olzhas: fix the demo branch and run the pipeline again.");
    }
}
