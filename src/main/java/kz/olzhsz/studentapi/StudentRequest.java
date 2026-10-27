package kz.olzhsz.studentapi;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record StudentRequest(
        @NotBlank @Size(max = 100) String fullName,
        @NotBlank @Size(max = 30) String groupName,
        @NotBlank @Email @Size(max = 254) String email) {
}
