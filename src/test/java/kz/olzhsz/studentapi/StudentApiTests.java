package kz.olzhsz.studentapi;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class StudentApiTests {
    private static final String BASE = "/api/ziyayev-olzhas/students";
    private static final String BODY = """
            {"fullName":"Ziyayev Olzhas","groupName":"IT2-2302","email":"olzhas@example.com"}
            """;

    @Autowired MockMvc mvc;
    @Autowired StudentRepository repository;

    @BeforeEach
    void resetDatabase() { repository.deleteAll(); }

    @Test
    void displaysPersonalIdentity() throws Exception {
        mvc.perform(get("/api/ziyayev-olzhas"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.student").value("Ziyayev Olzhas"))
                .andExpect(jsonPath("$.group").value("IT2-2302"));
    }

    @Test
    void createsStudentWithLocationAndListsIt() throws Exception {
        mvc.perform(post(BASE).contentType(MediaType.APPLICATION_JSON).content(BODY))
                .andExpect(status().isCreated()).andExpect(header().exists("Location"))
                .andExpect(jsonPath("$.fullName").value("Ziyayev Olzhas"));
        mvc.perform(get(BASE)).andExpect(status().isOk()).andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    void retrievesStudentById() throws Exception {
        Student student = saveStudent();
        mvc.perform(get(BASE + "/" + student.getId())).andExpect(status().isOk())
                .andExpect(jsonPath("$.groupName").value("IT2-2302"));
    }

    @Test
    void updatesStudentAndPersistsTheChange() throws Exception {
        Student student = saveStudent();
        String updated = """
                {"fullName":"Ziyayev Olzhas Updated","groupName":"IT2-2302","email":"updated@example.com"}
                """;
        mvc.perform(put(BASE + "/" + student.getId()).contentType(MediaType.APPLICATION_JSON).content(updated))
                .andExpect(status().isOk()).andExpect(jsonPath("$.id").value(student.getId()))
                .andExpect(jsonPath("$.fullName").value("Ziyayev Olzhas Updated"));
        mvc.perform(get(BASE + "/" + student.getId())).andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("updated@example.com"));
    }

    @Test
    void updateMissingStudentReturns404AndDoesNotInsert() throws Exception {
        mvc.perform(put(BASE + "/9223372036854775807").contentType(MediaType.APPLICATION_JSON).content(BODY))
                .andExpect(status().isNotFound());
        mvc.perform(get(BASE)).andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    void invalidUpdateDoesNotChangeStoredRecord() throws Exception {
        Student student = saveStudent();
        mvc.perform(put(BASE + "/" + student.getId()).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"fullName\":\"\",\"groupName\":\"IT2-2302\",\"email\":\"bad\"}"))
                .andExpect(status().isBadRequest());
        mvc.perform(get(BASE + "/" + student.getId()))
                .andExpect(jsonPath("$.fullName").value("Ziyayev Olzhas"));
    }

    @Test
    void deletesStudentAndReturns404Afterwards() throws Exception {
        Student student = saveStudent();
        mvc.perform(delete(BASE + "/" + student.getId())).andExpect(status().isNoContent());
        mvc.perform(get(BASE + "/" + student.getId())).andExpect(status().isNotFound());
    }

    @Test
    void missingStudentReturns404() throws Exception {
        mvc.perform(get(BASE + "/9223372036854775807")).andExpect(status().isNotFound())
                .andExpect(jsonPath("$.detail").value("Student with id 9223372036854775807 was not found"));
        mvc.perform(delete(BASE + "/9223372036854775807")).andExpect(status().isNotFound());
    }

    @Test
    void rejectsInvalidFields() throws Exception {
        mvc.perform(post(BASE).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"fullName\":\" \",\"groupName\":\"\",\"email\":\"bad\"}"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.errors.fullName").exists())
                .andExpect(jsonPath("$.errors.email").exists());
        mvc.perform(get(BASE)).andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    void rejectsMalformedJsonAndId() throws Exception {
        mvc.perform(post(BASE).contentType(MediaType.APPLICATION_JSON).content("{"))
                .andExpect(status().isBadRequest());
        mvc.perform(get(BASE + "/not-a-number")).andExpect(status().isBadRequest());
    }

    private Student saveStudent() {
        return repository.save(new Student(new StudentRequest("Ziyayev Olzhas", "IT2-2302", "olzhas@example.com")));
    }
}
