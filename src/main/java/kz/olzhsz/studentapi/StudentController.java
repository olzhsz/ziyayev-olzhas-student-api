package kz.olzhsz.studentapi;

import java.net.URI;
import java.util.List;
import java.util.Map;

import jakarta.validation.Valid;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ziyayev-olzhas")
public class StudentController {
    private final StudentRepository repository;

    public StudentController(StudentRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public Map<String, String> info() {
        return Map.of("student", "Ziyayev Olzhas", "group", "IT2-2302",
                "github", "https://github.com/olzhsz", "application", "ziyayev-olzhas-student-api");
    }

    @GetMapping("/students")
    public List<Student> list() {
        return repository.findAll(Sort.by("id"));
    }

    @GetMapping("/students/{id}")
    public Student get(@PathVariable Long id) {
        return find(id);
    }

    @PostMapping("/students")
    public ResponseEntity<Student> create(@Valid @RequestBody StudentRequest request) {
        Student saved = repository.save(new Student(request));
        return ResponseEntity.created(URI.create("/api/ziyayev-olzhas/students/" + saved.getId())).body(saved);
    }

    @PutMapping("/students/{id}")
    @Transactional
    public Student update(@PathVariable Long id, @Valid @RequestBody StudentRequest request) {
        Student student = find(id);
        student.updateFrom(request);
        return repository.save(student);
    }

    @DeleteMapping("/students/{id}")
    @Transactional
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        repository.delete(find(id));
        return ResponseEntity.noContent().build();
    }

    private Student find(Long id) {
        return repository.findById(id).orElseThrow(() -> new StudentNotFoundException(id));
    }
}
